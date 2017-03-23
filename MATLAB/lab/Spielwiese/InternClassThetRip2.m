function ThRpPh=InternClassThetRip2(FileBase,PlaceCell,spike,whl,varargin)
[overwrite,plotting] = DefaultArgs(varargin,{0,1});
%% classify interneurons depending on 
%% -prefered theta phase
%% -firing during ripples 

IN = unique(PlaceCell.ind(find(PlaceCell.ind(:,5)==2),1));

if ~FileExists([FileBase '.intThRp']) | overwrite
  
  RateFactor = 1250/20000;
  
  [Rspike.t, Rspike.ind, Rspike.pos] = SpikeAll(FileBase,whl.ctr,whl.rate);
  
  for n=1:length(IN)
    for d=[2 3]
      %% THETA
      gspikeTh = spike.ind==IN(n) & spike.good & spike.dir==d;
      
      %% spikes in and outside of theta
      %placecells = 
      %ranges = NoOverlapRanges(PlaceCell.trial(find(ismember(PlaceCell.trial(:,1),placecells)),2:3));
      %gspikesThIN = gspikeTh & WithinRanges(round(spike.t/20000*whl.rate,ranges);
      %gspikesThOUT = gspikeTh & ~WithinRanges(round(spike.t/20000*whl.rate,ranges);
      HistTh = histcI(spike.ph(gspikeTh)*180/pi,[0:10:360]);
      [MeanPhase R] = circmean(spike.ph(gspikeTh));
      MeanPhase = mod(MeanPhase,2*pi);
      
      %% RIPPLES
      Rips = InternRips(FileBase);
      
      gspikeRip = find(Rspike.ind==IN(n));
      [ccg, t] = CCG([Rspike.t(gspikeRip)*RateFactor; Rips.t],[ones(size(gspikeRip));2*ones(size(Rips.t))],20,20,1250);
      smccg = smooth(ccg(:,1,2),5,'lowess');
      
      %keyboard
      
      %% save
      ThRpPh.histTh(n,d,:) = HistTh;
      ThRpPh.binTh(n,d,:) = [5:10:355];
      ThRpPh.mph(n,d,:) = [MeanPhase R];
      
      ThRpPh.histRp(n,d,:) = ccg(:,1,2);
      ThRpPh.histRpsm(n,d,:) = smccg;
      ThRpPh.binRp(n,d,:) = t;
      ThRpPh.statRp(n,d,:) = [mean(smccg(1:10)) smccg((length(t)+1)/2) mean(smccg(end-9:end))];
      ThRpPh.ind(n,d) = IN(n)
    end
  end
  save([FileBase '.intThRp'],'ThRpPh')
    
else
  load([FileBase '.intThRp'],'-MAT')
end
  
if plotting
   figure(3847);clf
   figure(3848);clf
  for n=1:length(IN)
     figure(3847)
     subplot(length(IN),2,2*(n-1)+1)
     bar(squeeze(ThRpPh.binTh(n,2,:)),squeeze(ThRpPh.histTh(n,2,:))/10)
     Lines(mod(ThRpPh.mph(n,2,1)*180/pi,360));
     xlabel('phase [deg]','FontSize',16)
     ylabel('count','FontSize',16)
     set(gca,'FontSize',16)
     subplot(length(IN),2,n*2)
     bar(squeeze(ThRpPh.binRp(n,2,:)),squeeze(ThRpPh.histRp(n,2,:)));
     %hold on;
     %plot(ThRpPh.binRp(n,:),ThRpPh.histRpsm(n,:),'r')
     xlabel('time [ms]','FontSize',16)
     ylabel('rate [hz]','FontSize',16)
     set(gca,'FontSize',16)
     ForAllSubplots('axis tight; box off')
     
     figure(3848)
     subplot(length(IN),2,2*(n-1)+1)
     bar(squeeze(ThRpPh.binTh(n,3,:)),squeeze(ThRpPh.histTh(n,3,:))/10)
     Lines(mod(ThRpPh.mph(n,3,1)*180/pi,360));
     xlabel('phase [deg]','FontSize',16)
     ylabel('count','FontSize',16)
     set(gca,'FontSize',16)
     subplot(length(IN),2,n*2)
     bar(squeeze(ThRpPh.binRp(n,3,:)),squeeze(ThRpPh.histRp(n,3,:)));
     %hold on;
     %plot(ThRpPh.binRp(n,:),ThRpPh.histRpsm(n,:),'r')
     xlabel('time [ms]','FontSize',16)
     ylabel('rate [hz]','FontSize',16)
     set(gca,'FontSize',16)
     
     ForAllSubplots('axis tight; box off')
    end
end
return


%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%

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
