function ThRpPh=InternClassThetRip(FileBase,PlaceCell,spike,whl,Eeg,varargin)
[overwrite,plotting] = DefaultArgs(varargin,{0,0});
%% classify interneurons depending on 
%% -prefered theta phase
%% -firing during ripples 

IN = unique(PlaceCell.ind(find(PlaceCell.ind(:,5)==2),1));

if ~FileExists([FileBase '.intThRp']) | overwrite
  
  RateFactor = 1250/20000;
  
  [Rspike.t, Rspike.ind, Rspike.pos] = SpikeAll(FileBase,whl.ctr,whl.rate);
  
  for n=1:length(IN)
    %% THETA
    gspikeTh = spike.ind==IN(n) & spike.good;% & spike.dir==d;
    
    HistTh = histcI(spike.ph(gspikeTh)*180/pi,[0:10:360]);
    [MeanPhase R] = circmean(spike.ph(gspikeTh));
    MeanPhase = mod(MeanPhase,2*pi);
    ThPhase = InternThetaPh(FileBase);
    newstats = load([FileBase '.sts.RUN']);
    ThOcc = histcI(ThPhase.deg(find(WithinRanges([1:length(Eeg)],newstats)))*180/pi+180,[0:10:360]);
    
    %% RIPPLES
    gspikeRip = find(Rspike.ind==IN(n));
    overwriteripp = input('overwriting ripples, too [1/0]? ');
    Rips = InternRips(FileBase);%,overwriteripp,[],overwriteripp);
    %Rips = InternRipsPeaks(FileBase);
    RipItv = [Rips.t-Rips.len/2 Rips.t+Rips.len/2];
    Peaks = RipplesPeaks(Eeg,Rips.t,RipItv)

    
    %% take Ripples NOT during running
    goodRips = find(~WithinRanges(Peaks.ctr,[min(find(whl.ctr(:,1)>0)) max(find(whl.ctr(:,2)>0))]*32));
    if isempty(goodRips)
      Ript = Peaks.ctr';
      Ripat = Peaks.min;
    else
      Ript = Peaks.ctr(goodRips)';
      Ripat = Peaks.min(find(ismember(Peaks.bursts,goodRips)));
    end
    
    [ccg, t] = CCG([Rspike.t(gspikeRip)*RateFactor; Ripat],[ones(size(gspikeRip));2*ones(size(Ripat))],1,200,1250);
    smccg = smooth(ccg(:,1,2),5,'lowess');
    [ccg2, t2] = CCG([Rspike.t(gspikeRip)],[ones(size(gspikeRip))],40,50,20000);
    
    [ccgEeg] = TriggeredAv(Eeg,500,500,Ript,1);
    etS = [-500:500]/1.250;
    
    %% save
    ThRpPh.histCorr(n,:) = ccg2(:,1,1);
    ThRpPh.binCorr(1,:) = t2;
    
    ThRpPh.histTh(n,:) = HistTh./ThOcc;
    ThRpPh.binTh(1,:) = [5:10:355];
    ThRpPh.mph(n,:) = [MeanPhase R];
    
    ThRpPh.histRp(n,:) = ccg(:,1,2);
    ThRpPh.binRp(1,:) = t;
    ThRpPh.histRpsm(n,:) = ccgEeg;
    ThRpPh.binRpsm(1,:) = etS;
    %ThRpPh.statRp(n,:) = [mean(smccg(1:10)) smccg((length(t)+1)/2) mean(smccg(end-9:end))];
    ThRpPh.ind(n) = IN(n)
  end
  save([FileBase '.intThRp'],'ThRpPh')
    
else
  load([FileBase '.intThRp'],'-MAT')
end
  
if plotting
   figure(3847);clf
   subplot(length(IN)+1,2,1)
   plot([1:360],cos([1:360]/180*pi))
   subplot(length(IN)+1,2,2)
   plot(etS,ccgEeg)
  
   for n=1:length(IN)
     subplot(length(IN)+1,2,2*(n-1)+3)
     bar(squeeze(ThRpPh.binTh(n,:)),squeeze(ThRpPh.histTh(n,:))/10)
     axis tight
     Lines(mod(ThRpPh.mph(n,1)*180/pi,360));
     xlabel('phase [deg]','FontSize',16)
     ylabel('count','FontSize',16)
     set(gca,'FontSize',16)
     
     subplot(length(IN)+1,2,n*2+2)
     bar(squeeze(ThRpPh.binRp(n,:)),squeeze(ThRpPh.histRp(n,:)));
     %hold on;
     %plot(ThRpPh.binRp(n,:),ThRpPh.histRpsm(n,:),'r')
     xlabel('time [ms]','FontSize',16)
     ylabel('rate [hz]','FontSize',16)
     set(gca,'FontSize',16)
     ForAllSubplots('axis tight; box off')
  end
end

return;

%% THIS EXAMPLE WORKS!! 
%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EXAMPLE
figure(3847);clf

n=1
subplot(4,3,[1 4 7 10])
bar(ThRpPh.binCorr,ThRpPh.histCorr(n,:))
axis tight
xlim([-50 50])
xlabel('time [ms]','FontSize',16)
ylabel('rate [Hz]','FontSize',16)
set(gca,'FontSize',16)

subplot(4,3,[5 8 11])
bar(ThRpPh.binTh,ThRpPh.histTh(n,:))
axis tight
Lines(mod(ThRpPh.mph(n,1)*180/pi,360));
xlabel('phase [deg]','FontSize',16)
ylabel('count','FontSize',16)
set(gca,'FontSize',16,'XTick',[0:90:360])

subplot(4,3,[6 9 12])
smRip = smooth(ThRpPh.histRp(n,:),5,'lowess');
%bar(ThRpPh.binRp,ThRpPh.histRp(n,:));
bar(ThRpPh.binRp,smRip);
%hold on;
%plot(ThRpPh.binRp(n,:),ThRpPh.histRpsm(n,:),'r')
xlabel('time [ms]','FontSize',16)
ylabel('rate [Hz]','FontSize',16)
set(gca,'FontSize',16)
axis tight
xlim([-100 100])

subplot(432)
plot([1:360],cos([1:360]/180*pi))
axis tight; axis off; 
subplot(433)
plot(ThRpPh.binRpsm,ThRpPh.histRpsm(n,:))
axis tight; axis off
xlim([-100 100])

ForAllSubplots('box off')

%%%%%%%%%%%%%%%%%%%%%%%%%%

return;

CatAll = CatStruct(ALL);
xx=(CatAll.ThRpPh.statRp(:,3)+CatAll.ThRpPh.statRp(:,3))/2;
yy=CatAll.ThRpPh.statRp(:,2);
mm=mod(CatAll.ThRpPh.mph(:,1),2*pi)*180/pi;
Thetas=[];
for n=1:16
  if isempty(ALL(n).intph)
    continue
  end
  ind=ALL(n).intph;
  good = unique(ind(find(ind(:,3)==1),1));
  
  Thetas = [Thetas; [ALL(n).ThRpPh.ind' ismember(ALL(n).ThRpPh.ind',good)]]
  %ALL(n).ThRpPh.ind = [ALL(n).ThRpPh.ind(:,1)];% ismember(ALL(n).ThRpPh.ind',good)]'
end

Precess = find(Thetas(:,2))
