function FigureForGyuri1(varargin)
[COMPUTE,PRINTFIG] = DefaultArgs(varargin,{0,0});

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

cc1 = [[0 0 1]*0.8;[1 0 0]*0.6;[0 1 0]*0.5];
%cc1 = [[0 0 1]*0.8;[1 0.5 0];[0 1 0]*0.5];
cells1 = [36 47 71 46 60];
cells2 = [47 71];
%
colormap('default');
cc2 = colormap;
%cc1 = [cc2([1 1 15],:); cc1([2 3],:)];
%cc1 = [cc2([1 43 1],:); cc1([2 3],:)];
cc1 = [cc1(1,:); cc1(2,:); cc1(1,:); cc2(43,:); cc1(3,:)];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%PLOT
%figure(123);clf
%%set(gcf,'position',[1853 80 704 870]);
%set(gcf,'position',[1853 80 650 800]);


%%% TRACE
%subplot('position',[0.55 0.7 0.38 0.25])
figure(124);clf
set(gcf,'position',[1817         721         373         248]);
run = round(trial.itv/WhlRate*EegRate);
n=3;%n=24;
eee = Eeg(run(n,1):run(n,2));
t = [run(n,1):run(n,2)]/EegRate;
plot(t-t(1),eee/max(eee),'k','LineWidth',2)
hold on
%ind1 = find(spike.ind==cells1(4) & spike.lpos(:,1)>0);
ind1 = find(spike.ind==cells1(3) & spike.lpos(:,1)>0);
ix = find(WithinRanges(round(spike.t(ind1)/SampleRate*WhlRate),run(n,:)));
spt = spike.t(ind1(ix))/SampleRate-t(1);
Lines(spt,[0.75 1.25],cc1(3,:),[],1);
Lines(spt+(rand(size(spt))-0.5)*0.005+0.37,[0.75 1.25]+0.55,cc1(5,:),[],1);
Lines([3.4 3.5],-0.8,'k','-',2)
text(3.35,-1,'100 ms','FontSize',16)

Lines([2.85]',[0.74 1.9]','k','-');
Lines([2.91]',[0.74 1.9]','k','-');
Lines([2.85 2.91]',[1.85]','k','-');
text(2.93,2.15,'\tau','FontSize',24)

Lines([2.75]',[0.74 2.5]','k','-');
Lines([3.12]',[0.74 2.5]','k','-');
%text(2.92,2.6,'T','FontSize',24)
text(2.91,2.67,'T','FontSize',24)

a1=annotation('doublearrow',[0.41 0.635],[0.81 0.81]);
a2=annotation('arrow',[0.52 0.485],[0.73 0.7]);
set(a1,'Head1Style','vback1','Head2Style','vback1','Head1Length',5,'Head1Width',5,'Head2Length',5,'Head2Width',5)
set(a2,'HeadStyle','vback1','HeadLength',5,'HeadWidth',5)

axis tight
xlim([2.3 3.3+0.25]) 
%xlim([min(spt) max(spt)])
ylim([-1 3])
box off 
axis off

PrintFig('FigGyuri1',PRINTFIG);

%%%%%% compression factor
figure(125);clf
set(gcf,'position',[1817         373         373         259]);
X=load('KamranCompFact.mat','-MAT');
%subplot('position', [0.58 0.1 0.32 0.23])
subplot('position', [0.25 0.2 0.55 0.65])
%subplot('position', [0.61 0.1 0.28 0.18])
plot(X.PairDistance,X.PairTimeLag,'o','markersize',1,'markeredgecolor',[1 1 1]*0.15,'markerfacecolor',[1 1 1]*0.15)
hold on
plot(X.SigX,X.SigY,'r','LineWidth',2)
gx = find(X.SigX>-20 & X.SigX<20);
b = robustfit(X.SigX(gx),X.SigY(gx))
plot([-100 100],b(1)+b(2)*[-100 100],'--r','LineWidth',2)
axis tight
xlim([-100 100])
ylim([-200 200])
xlabel('\Delta distance [cm]','FontSize',16)
a = get(gca,'XLim'); b = get(gca,'YLim');
ylabel('\Delta time [ms]','FontSize',16,'position',[a(1)-diff(a)*0.18 mean(b)])
set(gca,'FontSize',16,'TickDir','out','YTick',[-200 0 200])
box off
n=length(X.PairDistance);
fprintf(['number of pairs: ' num2str(n) '\n']);

%keyboard

%% histograms
subplot('position', [0.25 0.85 0.55 0.1])
bin = [-100:6:100];
h = histcI(X.PairDistance,bin);
b1=bar(bin(2:end)-3,h);
axis tight
axis off
subplot('position', [0.8 0.2 0.1 0.65])
bin = [-200:10:200];
h = histcI(X.PairTimeLag,bin);
b2 = barh(bin(2:end)-5,h);
axis tight
axis off
set(b1,'FaceColor',[1 1 1]*0)
set(b2,'FaceColor',[1 1 1]*0)

PrintFig('FigGyuri2',PRINTFIG);

return


%% get the good cells...... 
%pos = round(whl.lin(WithinRanges([1:length(whl.lin)],trial.itv) & round(whl.lin)>0));
%ix = ismember(spike.ind,GoodPC) & WithinRanges(round(spike.t/SampleRate*EegRate),trial.itv) & spike.lpos(:,1)>0 & spike.good;
%cmpr = CompressIndx(FileBase,spike.t(ix),spike.ind(ix),spike.lpos(ix),pos,[],10,0,[-50 40]);
%subplot(326)
%plot(cmpr.posx,cmpr.thetat,'o','markersize',5,'markerfacecolor',[1 1 1]*0,'markeredgecolor',[1 1 1]*0)
%hold on
%plot([-100:100],cmpr.cmprp(1)+cmpr.cmprp(2)*[-100:100],'r--')
%axis tight
%xlim([-100 100])
%ylim([-200 200])
%xlabel('\Delta distance [cm]','FontSize',16)
%ylabel('\Delta time [ms]','FontSize',16)
%c = round(cmpr.cmprp(2)*10)/10;
%text(-70,150,['c=' num2str(c) ' [ms/cm]'],'FontSize',16);
%set(gca,'FontSize',16,'TickDir','out')
%box off

PrintFig([FileBase '.PlotIntro'],PRINTFIG)



return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% get linearizes position
whl = GetWhl(FileBase);
trial = GetTrials(FileBase,whl);
whl.dir = zeros(length(whl.ctr),1);
for n=unique(trial.dir)'
  whlindx = find(WithinRanges([1:length(whl.ctr)],trial.itv(find(trial.dir==n),:)));
  whl.dir(whlindx) = n;
end
whl.lin = -10.0*ones(size(whl.ctr,1),1);
if ~trial.OneMeanTrial
  for n=unique(trial.dir)'
    if isempty(trial.mean(n).mean)
      continue
    end
    whl.lin(find(whl.dir==n),1) = GetSpikeLinPos(whl.ctr(find(whl.dir==n),:),trial.mean(n).mean,trial.mean(n).sclin);
  end
else
  n=2;
  whl.lin(find(whl.dir>1),1) = GetSpikeLinPos(whl.ctr(find(whl.dir>1),:),trial.mean(n).mean,trial.mean(n).lin);
end

%% Rate
%Occ = histcI(whl.lin(whl.lin>0),[1:300]);
%rate = smooth(histcI(spike.lpos(ind),[1:300])./Occ,20,'lowess')*EegRate;
%hold on
%plot(rate(1:250),'color',cc(n,:),'LineWidth',2)
%axis tight
%xlim([0 250])
%xlabel('distance [cm]','FontSize',16)
%ylabel('rate','FontSize',16)
%set(gca,'FontSize',16,'TickDir','out')
%box off

%% auto-correlograms
%for n=1:2
%  subplot(4,2,5)
%  %subplot('position',[0.15+(n-2)*0.42 0.35 0.33 0.15])
%  plot(t, SAuto(:,n),'color',cc1(n+1,:),'LineWidth',2)
%  hold on
%  axis tight
%  xlim([-500 500])
%  ylim([0 30])
%  xlabel('time [ms]','FontSize',16)
%  ylabel('rate','FontSize',16)
%  set(gca,'FontSize',16,'TickDir','out')
%  box off
%end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



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




return;

%% Find good place cells
goodc1 = load([FileBase '.plotgoodcells']);

%% Auto- and Cross-Correlograms
ind = ismember(spike.ind,goodc1);
[ccg,t] = CCG(spike.t(ind),spike.ind(ind),50,1000);
Auto = GetDiagonal(ccg);
SAuto = reshape(smooth(Auto,10,'lowess'),size(Auto,1),size(Auto,2));
[Cros CrosI] = GetOffDiagonal(ccg);
SCros = reshape(smooth(Cros,10,'lowess'),size(Cros,1),size(Cros,2));

%% good pairs:
%% CrosI(28,:) = [4 8] -> goodc1([4 8])' = [47 71];
%a = [7 13 14 28 34 45 2 6 21];
a = [3 7 28];
%% CrosI(a,:) = 
%b = [1 8; 2 6; 2 7; 4 8; 5 9; 9 10; 1 3; 1 7; 3 7];
b = [1 4; 1 8; 4 8];
%% goodc1(b) = 
%GG = [36 71; 44 55; 44 60; 47 71; 51 81; 81 109; 36 46; 36 60; 46 60];
GG = [36 47; 36 71; 47 71];


%% loop through pair

for m=1:size(GG,1)
  goodc = GG(m,:);

  figure(434);clf;
  for n=1:length(goodc)
    ind = find(spike.ind==goodc(n) & spike.pos(:,1)>0);
    %
    subplot(321)
    if n==1
      plot(whl.plot(:,1),whl.plot(:,2),'color',[1 1 1]*0.7)
      hold on
    end
    plot(spike.pos(ind,1),spike.pos(ind,2),'o','markersize',5,'markerfacecolor',cm(n*6,:),'markeredgecolor',cm(n*6,:))
    title(['n= ' num2str(goodc(n))])
    axis tight
    box off
    axis off
    %
    subplot(323)
    plot(spike.lpos(ind),spike.ph(ind)*180/pi,'o','markersize',5,'markerfacecolor',cm(n*6,:),'markeredgecolor',cm(n*6,:))
    hold on
    plot(spike.lpos(ind),spike.ph(ind)*180/pi+360,'o','markersize',5,'markerfacecolor',cm(n*6,:),'markeredgecolor',cm(n*6,:))
    axis tight
    xlim([0 300])
    ylim([0 720])
    xlabel('distance','FontSize',16)
    ylabel('phase','FontSize',16)
    set(gca,'FontSize',16,'TickDir','out','YTick',[0:360:720],'XTick',[0:100:300])
    box off
    %
    subplot(325)
    plot(SpectM.f,SpectM.speeg/max(SpectM.speeg),'--','color',[1 1 1]*0.5,'LineWidth',2)
    hold on
    plot(SpectM.f,SpectM.spunit(:,goodc(n))/max(SpectM.spunit(:,goodc(n))),'color',cm(n*6,:),'LineWidth',2)
    axis tight
    xlim([5 12])
    xlabel('frequency','FontSize',16)
    ylabel('power','FontSize',16)
    set(gca,'FontSize',16,'TickDir','out')
    l=legend('LFP','unit','Location','NorthEast');
    set(l,'box','off')
    box off
    %
    subplot(322)
    plot(t,SCros(:,a(m)),'-','color',[1 1 1]*0.5,'LineWidth',2)
    axis tight
    %xlim([5 12])
    xlabel('frequency','FontSize',16)
    ylabel('power','FontSize',16)
    set(gca,'FontSize',16,'TickDir','out')
    box off
    %
    subplot(3,2,4+(n-1)*2)
    plot(t,SAuto(:,b(m,n)),'-','color',cm(n*6,:),'LineWidth',2)
    axis tight
    xlabel('time','FontSize',16)
    ylabel('frequency [Hz]','FontSize',16)
    title(['n = ' num2str(goodc(n))])
    set(gca,'FontSize',16,'TickDir','out')
    box off
    %
  end
  go = input('go');
end

keyboard


return;



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







  %% phase
  %subplot(413)
  %%subplot('position',[0.15 0.78 0.75 0.15])
  %hold on
  %plot(spike.lpos(ind),spike.ph(ind)*180/pi,'o','markersize',5,'markerfacecolor',cc(n,:),'markeredgecolor',cc(n,:))
  %plot(spike.lpos(ind),spike.ph(ind)*180/pi+360,'o','markersize',5,'markerfacecolor',cc(n,:),'markeredgecolor',cc(n,:))
  %axis tight
  %xlim([0 250])
  %ylim([0 720])
  %%xlabel('distance [cm]','FontSize',16)
  %ylabel('phase','FontSize',16)
  %set(gca,'FontSize',16,'TickDir','out','YTick',[0:360:720],'XTick',[])
  %box off
  
  %% rate
  %subplot(412)
  %subplot('position',[0.15 0.6 0.75 0.15])
  %rate = smooth(histcI(spike.lpos(ind),[1:300])./Occ,20,'lowess')*EegRate;
  %hold on
  %plot(rate(1:250),'color',cc(n,:),'LineWidth',2)
  %axis tight
  %xlim([0 250])
  %xlabel('distance [cm]','FontSize',16)
  %ylabel('rate','FontSize',16)
  %set(gca,'FontSize',16,'TickDir','out')
  %box off
 





