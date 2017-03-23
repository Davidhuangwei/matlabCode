function SVMUPlotMua5(ALL)
%% function SVMUPlotMua(ALL(23))
%ALL = ALL(20);
%ALL = ALL(23);
MUA = ALL.mua; 
SP = ALL.spect;

GSP = ALL.type.num==2 & ALL.spect.good';

EegRate = ALL.info.EegRate;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% find good episode
FileBase = '2006-6-09_22-24-40/2006-6-09_22-24-40';

a0 = 52; b0 = 57;
a1 = 53; b1 = 55.5;
a2 = 53; b2 = 56;
a3 = 52; b3 = 56;

a0 = 51; b0 = 55;
a1 = 52; b1 = 55;
a2 = 52; b2 = 55;
a3 = 52; b3 = 55;

a0 = 52; b0 = 57;
a1 = 53; b1 = 56;
a2 = 53; b2 = 56;
a3 = 53; b3 = 56;




%a0 = 305; b0 = 320;
%a1 = a0+1; b1 = b0;
%a1 = 200; b1 = b0;
%a2 = a0+1; b2 = b0;
%a3 = a0+1; b3 = b0;
%%a3 = 200; b3 = 320;



gtSP = find(MUA.spT>a0 & MUA.spT<b0); %0
gtSPA = find(MUA.spT>a1 & MUA.spT<b1); %1
gtR = find([1:length(MUA.rate)]/EegRate>a2 & [1:length(MUA.rate)]/EegRate<b2); %2
gf = find(MUA.spF>4 & MUA.spF<12);
ispk = find(MUA.spkt/EegRate>a3 & MUA.spkt/EegRate<b3); %3


%% number of spikes
ind = MUA.spki(ispk);

h = hist(ind,[min(ind):max(ind)]);
sdf=length(find(h>3));
dfg=length(find(h>3))/(b3-a3);
nh = length(unique(ind));

fprintf(['tot num of cells: ' num2str(nh) '\n']);
fprintf(['num of cells with more than 3 spikes:' num2str(sdf) ' || num of good cells/sec ' num2str(dfg) '\n']);
fprintf(['num of good cells/sec ' num2str(dfg) '\n']);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% make figures

cc1 = [0.94 0 0];
cc2 = [0 0.6 0];

figure(3278463);clf;
%set(gcf,'position',[2200 297 672 627])
set(gcf,'position',[1711  188  600  597])


%% jitter spikes:
isp = unique(ind);
INDSP = MUA.spki;%(ispk);
TSP = MUA.spkt;%(ispk);
JittS = round(EegRate/10);


%% loop over several realizations of the 
NN = 10;
for m=1:NN
  m
  if m>1
    for n=isp'
      id = find(INDSP==n);
      jtt = randi([-JittS JittS],1);
      %TSP(id) = TSP(id) + randi([-JittS JittS],size(id));
      TSP(id) = TSP(id) + jtt;
    end
    TSP(find(TSP>length(MUA.rate))) = length(MUA.rate);
    TSP(find(TSP<1)) = 1;
  end
  
  % compute POP rate
  [Rate RBin] = InstantRate(ALL.info.FileBase,sort(TSP),ones(size(TSP)),1);
  
  if length(Rate)<length(MUA.rate)
    Rate = [Rate; zeros(length(MUA.rate)-length(Rate),1)];
  elseif length(Rate)>length(MUA.rate)
    nRate = Rate(1:length(MUA.rate)); clear Rate;
    Rate = nRate;
  end
  MRate = ButFilter(Rate,1,4/(EegRate/2),'high');
  
  %% coherence
  wstep = 1/4;
  WinLength = 2^11;%512;
  
  nFFT = 2^12;
  Fs = EegRate;
  NW = 2;  %% ~5 for gamma
  Detrend = 'linear';
  nTapers = [];
  FreqRange = [1 20];
  CluSubset = [];
  pval = []; 
  nOverlap = WinLength*(1-wstep);
  
  [yo,fo,to] = mtptchglong(MUA.eeg,sort(TSP),ones(size(TSP)),nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,FreqRange,CluSubset);
  
  JSP(:,:,m) = sq(yo(:,:,2,2));
end

%keyboard

%% Good Spect and max of average spect
DD = sq(mean(JSP(gtSPA,:,:),1));
[GSP GSPA] = GoodSpect(DD,fo,[6 12],[],[],[],ones(NN,1));
[dummy maxfo] = MaxPeak(fo,DD,[6 12]);


%% average spectra
noJSP = sq(mean(JSP(gtSPA,gf,1),1));

mJSP = sq(mean(JSP(gtSPA,gf,2:end),1));

amJSP = mean(mJSP');
asJSP = std(mJSP');
FSP = fo(gf);


%% P L O T


%%% SPIKES
subplot('position',[0.13 0.83 0.67 0.12])
xs = TSP(ispk)/EegRate-a1;
ys = INDSP(ispk)-min(MUA.spki);
line([xs';xs'],[ys'-1;ys'+1],'color',[0 0 0],'LineWidth',2);
axis tight
xlim([0 3])
set(gca,'TickDir','out','FontSize',16)
box off
axis off
ax = get(gca,'XLim');
ay = get(gca,'YLim');
%text(ax(1)-mean(ax)*0.16, mean(ay)*2/3,'cells','FontSize',16,'Rotation',90)
text(ax(1)-mean(ax)*0.2, mean(ay)*2/3,'cells','FontSize',16,'Rotation',90)

%keyboard
h=histc(ys,[min(ys):max(ys)]);
lh = length(find(h>3))/3;        %% # 


%%% POP
subplot('position',[0.13 0.7 0.67 0.12])
plot([1:length(gtR)]/EegRate,MRate(gtR),'color',cc1,'LineWidth',2)
hold on
%plot([1:length(gtR)]/EegRate,MRate(gtR),)
axis tight
xlim([0 3])
set(gca,'TickDir','out','FontSize',16)
box off
axis off
%g = get(gca,'Ylim');
%text(-0.25,-0.01,'POP','FontSize',16,'Rotation',90)
ax = get(gca,'XLim');
ay = get(gca,'YLim');
text(ax(1)-mean(ax)*0.2, ay(1)+diff(ay)*0.25,'POP','FontSize',16,'Rotation',90)


%%% SPECT POP
subplot('position',[0.13 0.5 0.67 0.2])
%imagesc(MUA.spT(gtSP)-a1,MUA.spF(gf),unity(MUA.spectgrunit(gtSP,gf)'))
imagesc(to(gtSP)-a1,fo(gf),unity(yo(gtSP,gf,2,2)'))
axis xy
hold on
plot(MUA.spT(gtSP)-a1,MUA.mxeegF(gtSP),'o','markersize',5,'markerfacecolor',[1 1 1]*0,'markeredgecolor',[1 1 1]*0)
xlim([0 3])
set(gca,'TickDir','out','XTick',[0:3],'YTick',[4:2:12],'FontSize',16)
ax = get(gca,'XLim');
ay = get(gca,'YLim');
xlabel('time [sec]','FontSize',16)
ylabel('frequency [Hz]','FontSize',16,'position',[ax(1)-mean(ax)*0.16 mean(ay)])
box off


%%% LFP VS. POP
subplot('position',[0.13 0.15 0.25 0.25])
hold on
y = mean(MUA.spectgreeg(gtSPA,gf));
plot(MUA.spF(gf),y/max(y),'color',cc2,'LineWidth',2)
[mx mt1] = MaxPeak(MUA.spF(gf),y');
%Lines(mt,[],'k','--')
%
x = noJSP;
[mx mt2] = MaxPeak(MUA.spF(gf),x');
Lines(mean([mt1 mt2]),[],'k','--');
plot(MUA.spF(gf),x/max(x),'-','color',cc1,'LineWidth',2)
hold on
fill([FSP;FSP([length(FSP):-1:1])],[amJSP+asJSP amJSP([length(FSP):-1:1])-asJSP([length(FSP):-1:1])]'/max(noJSP),[1 1 1]*0.8);
plot(MUA.spF(gf),mJSP(:,end)/max(x),'color',[0 0 1],'LineWidth',2)
%
xlabel('frequency [Hz]','FontSize',16)
ax = get(gca,'XLim');
ay = get(gca,'YLim');
ylabel('power','FontSize',16,'position',[ax(1)-mean(ax)*0.16 mean(ay)])
axis tight
ylim([0 1])
set(gca,'TickDir','out','YTick',[0 1],'FontSize',16)
box off

text(0.5,3.2,'A','FontSize',16)
text(0.5,2.6,'B','FontSize',16)
text(0.5,2.2,'C','FontSize',16)
text(0.5,1,'D','FontSize',16)
text(14,1,'E','FontSize',16)


%% how good are the spectra??
subplot('position',[0.55 0.15 0.25 0.25])
plot(maxfo,GSPA,'o','markersize',5,'markeredgecolor',[0.5 0.5 1],'markerfacecolor',[0.5 0.5 1])
hold on
plot(maxfo(1),GSPA(1),'o','markersize',10,'markeredgecolor',[1 0 0],'markerfacecolor',[1 0 0])
plot(maxfo(end),GSPA(end),'o','markersize',10,'markeredgecolor',[0 0 1],'markerfacecolor',[0 0 1])
axis tight
xlim([6 12])
ylim([0 2])
Lines(mean([mt1 mt2]),[],'k','--');
xlabel('peak frequency [Hz]','FontSize',16)
ylabel('theta/delta ratio','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off


keyboard

FileBase = '2006-6-09_22-24-40/2006-6-09_22-24-40';
PrintFig([FileBase '.SVMUPlotMUA5'],0)



return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

