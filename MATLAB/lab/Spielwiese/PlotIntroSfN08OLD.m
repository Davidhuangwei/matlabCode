function PlotIntroSfN08OLD(varargin)
[COMPUTE] = DefaultArgs(varargin,{0});

list = LoadStringArray('listWheel.txt');
f = 2;
FileBase = [list{f} '/' list{f}];
PrintBase = [list{f} '/Figs/' list{f}];

if COMPUTE
  
  SampleRate = 20000;
  EegRate = 1250;
  WhlRate = 1250;
  
  whl = GetWhl(FileBase); 
  WhlCtr = whl.ctr;
  
  trial = GetTrials(FileBase,whl);
  whl = GetWhlLin(whl,trial);
  
  elc = InternElc(FileBase,0);
  
  [spike.t, spike.ind, spike.pos, numclus, xspikeph, spike.clu] = SpikePos(FileBase,WhlCtr,WhlRate,1,SampleRate);
  spike = FindGoodTheta(FileBase,spike);
  goodsp = find(spike.pos(:,1)>0 | spike.pos(:,2)>0 & spike.good);
  [spike.ph spike.uph] = SpikePhase(FileBase,spike.t,SampleRate,EegRate);
  spike.dir = zeros(length(spike.t),1);
  for nn=unique(trial.dir)'
    spike.dir(find(WithinRanges(spike.t/20000*whl.rate,trial.itv(find(trial.dir==nn),:))),:)=nn;
  end
  spike = SpikeLinPos(spike,trial,WhlRate);
  
  Eeg = GetEEG(FileBase);
  
  HCcells = find(ismember(spike.clu(:,1),find(elc.region==1)));

  xcorrlM = SVMUccg(FileBase,Eeg,spike,trial.itv,0,0,'.xcorrM');
  GoodPC = xcorrlM.goodPC(ismember(xcorrlM.goodPC,HCcells));
  GoodIN = xcorrlM.goodIN(ismember(xcorrlM.goodIN,HCcells));
  
  SpectM = SVMUspect(FileBase,Eeg,spike,trial.itv,PrintBase,GoodPC,GoodIN,0,1,0,'.spectM');
  
  save([FileBase '.DataPlotIntroSfN08'])
else
  load([FileBase '.DataPlotIntroSfN08'],'-MAT')
end


%%PLOT
figure(123);clf
s=subplot(221);
set(s,'position',[0.1 0.5 0.38 0.4])
plot(whl.plot(:,1),whl.plot(:,2),'color',[1 1 1]*0.7)
hold on
cc = colormap;
ind1 = find(spike.ind==36 & spike.pos(:,1)>0);
plot(spike.pos(ind1,1),spike.pos(ind1,2),'o','markersize',5,'markerfacecolor',cc(1,:),'markeredgecolor',cc(1,:))
ind2 = find(spike.ind==46 & spike.pos(:,1)>0);
plot(spike.pos(ind2,1),spike.pos(ind2,2),'o','markersize',5,'markerfacecolor',cc(64,:),'markeredgecolor',cc(64,:))
ind3 = find(spike.ind==60 & spike.pos(:,1)>0);
plot(spike.pos(ind3,1),spike.pos(ind3,2),'o','markersize',5,'markerfacecolor',[0 0.5 0],'markeredgecolor',[0 0.5 0])
axis tight
box off
axis off

subplot(223)
ind1 = find(spike.ind==36 & spike.lpos(:,1)>0);
ind3 = find(spike.ind==60 & spike.lpos(:,1)>0);
plot(spike.lpos(ind1),spike.ph(ind1)*180/pi,'o','markersize',5,'markerfacecolor',cc(1,:),'markeredgecolor',cc(1,:))
hold on
plot(spike.lpos(ind1),spike.ph(ind1)*180/pi+360,'o','markersize',5,'markerfacecolor',cc(1,:),'markeredgecolor',cc(1,:))
ind2 = find(spike.ind==46 & spike.lpos(:,1)>0);
plot(spike.lpos(ind2),spike.ph(ind2)*180/pi,'o','markersize',5,'markerfacecolor',cc(64,:),'markeredgecolor',cc(64,:))
plot(spike.lpos(ind2),spike.ph(ind2)*180/pi+360,'o','markersize',5,'markerfacecolor',cc(64,:),'markeredgecolor',cc(64,:))
axis tight
xlim([0 300])
ylim([0 720])
xlabel('distance','FontSize',16)
ylabel('phase','FontSize',16)
set(gca,'FontSize',16,'TickDir','out','YTick',[0:360:720],'XTick',[0:100:300])
box off

subplot(224)
cell = 36;
plot(SpectM.f,SpectM.speeg/max(SpectM.speeg),'--','color',[1 1 1]*0.5,'LineWidth',2)
hold on
plot(SpectM.f,SpectM.spunit(:,cell)/max(SpectM.spunit(:,cell)),'color',cc(1,:),'LineWidth',2)
axis tight
xlim([5 12])
xlabel('frequency','FontSize',16)
ylabel('power','FontSize',16)
set(gca,'FontSize',16,'TickDir','out')
l=legend('LFP','unit','Location','NorthEast');
set(l,'box','off')
box off

s = subplot(222)
set(s,'position',[0.5 0.5 0.4 0.4])
run = round(trial.itv/WhlRate*EegRate);
n=24;
eee = Eeg(run(n,1):run(n,2));
t = [run(n,1):run(n,2)]/EegRate;
plot(t-t(1),eee/max(eee),'k','LineWidth',2)
hold on
ix = find(WithinRanges(round(spike.t(ind2)/SampleRate*WhlRate),run(n,:)));
Lines(spike.t(ind2(ix))/SampleRate-t(1),[0.75 1.25],cc(64,:),[],2);
text(1.8,-1.2,'1 sec','FontSize',16)
axis tight
xlim([1 2]) 
ylim([-1.5 2.5])
box off 
axis off

PrintFig([PrintBase 'IntroSfn08'],0)


%% plot cartoon
figure(432);clf
t = [1:2000];
lfp = cos(2*pi*t*7.8/1000)+1;
dt = -30;
unit = [cos(2*pi*(t+dt)*8.5/1000)+1].*exp(-(t-1060+dt).^2/(300)^2);
plot(t,lfp,'--','color',[1 1 1]*0.5,'LineWidth',2)
hold 
plot(t,unit,'color',cc(1,:),'LineWidth',2)
text(1800,-0.3,'2 sec','FontSize',16)
box off
axis off
ylim([-0.2 2])

PrintFig([PrintBase 'IntroSfn08-2'],0)

%% plot phase histograms of multi and single units



return;

%% Find good place cells
figure
for n=1:length(GoodPC)
  clf
  plot(whl.plot(:,1),whl.plot(:,2),'color',[1 1 1]*0.8)
  hold on
  ind = find(spike.ind==GoodPC(n));
  plot(spike.pos(ind,1),spike.pos(ind,2),'.')
  title(['n= ' num2str(GoodPC(n))])
  WaitForButtonpress
end

%% Find Trial with good spikes
run = round(trial.itv/WhlRate*EegRate);
figure
for n=1:length(run)
  clf
  n
  eee = Eeg(run(n,1):run(n,2));
  t = [run(n,1):run(n,2)]/EegRate;
  plot(t,eee/max(eee),'k')
  hold on
  ix = find(WithinRanges(round(spike.t(ind2)/SampleRate*WhlRate),run(n,:)));
  axis tight
  Lines(spike.t(ind2(ix))/SampleRate);
  xlim([spike.t(ind2(ix(1)))-0.2 spike.t(ind2(ix(end)))+0.2]/SampleRate) 
  
  WaitForButtonpress
end













