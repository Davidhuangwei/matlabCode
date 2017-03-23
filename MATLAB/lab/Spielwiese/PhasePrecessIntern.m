function PhasePrecessIntern(PlaceCell,whl,trial,Corr,spike,Tune)

CellPC = 13;
CellIN = 14;
%CellIN = 4;
%CellPC = 9;
%CellIN = 6;
%CellPC = 9;
%CellIN = 2;
%CellPC = 16;

ColRed = [216 41 0]/255;
ColBlue = [0 0 1];
ColGreen = [0 127 0]/255;
ColGray1 = [1 1 1]*0.7;
ColGray2 = [1 1 1]*0.9;


indxI = spike.ind==PlaceCell.ind(CellIN,1) & spike.dir==PlaceCell.ind(CellIN,4) & ...
	WithinRanges(round(spike.t/20000*whl.rate),trial.itv(find(trial.dir==PlaceCell.ind(CellIN,4)),:)) & spike.good; 
indxP = spike.ind==PlaceCell.ind(CellPC,1) & spike.dir==PlaceCell.ind(CellPC,4) & ...
	WithinRanges(round(spike.t/20000*whl.rate),trial.itv(find(trial.dir==PlaceCell.ind(CellIN,4)),:)) & spike.good;

AindxI = spike.ind==PlaceCell.ind(CellIN,1) & spike.good;
AindxP = spike.ind==PlaceCell.ind(CellPC,1) & spike.good;

Res = [spike.t(find(AindxI));spike.t(find(AindxP))];
Clu = [spike.ind(find(AindxI));spike.ind(find(AindxP))];
Allclu = unique(Clu);
Ph = [spike.ph(find(AindxI));spike.ph(find(AindxP))];
Lpos = [spike.lpos(find(AindxI));spike.lpos(find(AindxP))];
[ccg,t,pairs] = CCG(Res,Clu,30,30,20000);
for n=1:100
  Res1=Res+rand(size(Res))*2000;
  shccg =  CCG(Res1,Clu,30,30,20000);
  mccg(:,n) = shccg(:,1,2);
end
xpairs = pairs(Clu(pairs(:,1))==Allclu(1) & Clu(pairs(:,2))==Allclu(2),:);
pairbin = round(diff(Res(xpairs),1,2)/40) + 100 + 1;
goodpair = find(pairbin==102);

gpos = find(WithinRanges([1:size(whl.itv,1)],trial.itv(find(trial.dir==PlaceCell.ind(CellIN,4)),:)));

%% for single trial  
Trials = trial.itv(find(trial.dir==PlaceCell.ind(14,4)),:);
for tr=1:size(Trials,1)
  indxITR = indxI & WithinRanges(round(spike.t/20000*whl.rate),Trials(tr,:));
  indxPTR = indxP & WithinRanges(round(spike.t/20000*whl.rate),Trials(tr,:));
  
  ResTR = [spike.t(find(indxITR));spike.t(find(indxPTR))];
  CluTR = [spike.ind(find(indxITR));spike.ind(find(indxPTR))];
  AllcluTR = unique(Clu);
  PhTR = [spike.ph(find(indxITR));spike.ph(find(indxPTR))];
  LposTR = [spike.lpos(find(indxITR));spike.lpos(find(indxPTR))];
  PosTR = [spike.pos(find(indxITR),:);spike.pos(find(indxPTR),:)];
  [ccgTR,t,pairsTR] = CCG(ResTR,CluTR,30,30,20000);
  xpairsTR = pairsTR(CluTR(pairsTR(:,1))==AllcluTR(1),:);% & CluTR(pairsTR(:,2))==AllcluTR(2),:);
  pairbinTR = round(diff(ResTR(xpairsTR),1,2)/40) + 30 + 1;
  goodpairTR = find(pairbinTR==32 | pairbinTR==33);
  
  %figure(100)
  %PlotPhasegram(spike.t(find(indxI)),spike.ph(find(indxI)),spike.lpos(find(indxI)),whl.lin(gpos));

  %%%%%%%%%%%%
  figure(1);clf
  
  subplot(7,3,[1 4])
  plot(whl.plot(1:100:end,1),whl.plot(1:100:end,2),'o', ...
       'markersize',5,'markeredgecolor','none','markerfacecolor',ColGray1);
  hold on; plot(spike.pos(find(indxI),1),spike.pos(find(indxI),2),'o', ...
       'markersize',3,'markeredgecolor','none','markerfacecolor',ColGreen);
  axis off
  
  %%
  subplot(7,3,[2 5])
  plot(whl.plot(1:100:end,1),whl.plot(1:100:end,2),'o', ...
       'markersize',5,'markeredgecolor','none','markerfacecolor',ColGray1);
  hold on
  plot(spike.pos(find(indxP),1),spike.pos(find(indxP),2),'o', ...
       'markersize',3,'markeredgecolor','none','markerfacecolor',ColRed);
  axis off
  
  %%
  subplot(7,3,[7 8])
  TuneCell = find(unique(PlaceCell.ind(:,1))==PlaceCell.ind(CellIN,1));
  TuneDir = PlaceCell.ind(CellIN,4)-1;
  plot(Tune.mrate(:,TuneCell,TuneDir),'Color',ColGreen,'linewidth',2); hold on
  TuneCell = find(unique(PlaceCell.ind(:,1))==PlaceCell.ind(CellPC,1));
  TuneDir = PlaceCell.ind(CellPC,4)-1;
  plot(Tune.mrate(:,TuneCell,TuneDir)','Color',ColRed,'linewidth',2)
  set(gca,'TickDir','out','FontSize',16)
  axis tight
  xlim([0 max(spike.lpos(find(indxI)))])
  ylabel('rate [Hz]','FontSize',16)
  
  %%
  subplot(7,3,[10 11 13 14])
  plot(spike.lpos(find(indxI)),spike.ph(find(indxI))*180/pi,'o', ...
       'markersize',2,'markeredgecolor','none','markerfacecolor',ColGray1);
  hold on
  plot(spike.lpos(find(indxI)),spike.ph(find(indxI))*180/pi+360,'o', ...
       'markersize',2,'markeredgecolor','none','markerfacecolor',ColGray1);
  set(gca,'TickDir','out','FontSize',16,'YTick',[0:180:720])
  plot(LposTR(xpairsTR(goodpairTR,2)),PhTR(xpairsTR(goodpairTR,2))*180/pi,'o', ...
	   'markersize',5,'markeredgecolor','none','markerfacecolor',ColGreen);
  plot(LposTR(xpairsTR(goodpairTR,2)),PhTR(xpairsTR(goodpairTR,2))*180/pi+360,'o', ...
	   'markersize',5,'markeredgecolor','none','markerfacecolor',ColGreen);
  xlim([0 max(spike.lpos(find(indxI)))])
  ylim([0 720])
  ylabel('phase [deg]','FontSize',16)
  
  %%
  subplot(7,3,[16 17 19 20])
  plot(spike.lpos(find(indxP)),spike.ph(find(indxP))*180/pi,'o', ...
	   'markersize',2,'markeredgecolor','none','markerfacecolor',ColGray1);
  hold on
  plot(spike.lpos(find(indxP)),spike.ph(find(indxP))*180/pi+360,'o', ...
       'markersize',2,'markeredgecolor','none','markerfacecolor',ColGray1);
  plot(LposTR(find(CluTR==AllcluTR(1))),PhTR(find(CluTR==AllcluTR(1)))*180/pi,'o', ...
	   'markersize',5,'markeredgecolor','none','markerfacecolor',ColRed);
  plot(LposTR(find(CluTR==AllcluTR(1))),PhTR(find(CluTR==AllcluTR(1)))*180/pi+360,'o', ...
	   'markersize',5,'markeredgecolor','none','markerfacecolor',ColRed);
  set(gca,'TickDir','out','FontSize',16,'YTick',[0:180:720])
  xlim([0 max(spike.lpos(find(indxI)))])
  ylim([0 720])
  xlabel('space [cm]','FontSize',16)
  ylabel('phase [deg]','FontSize',16)
  
  %%%%%
  subplot(733)
  %plot([-15 15],[0.1 0.1],'Color',ColRed,'linewidth',2)
  plot(-12,0,'marker','^','markersize',40,'markeredgecolor','none','markerfacecolor',ColRed);
  H=annotation('arrow',[0.76 0.833],[0.862 0.862]);
  hold on
  plot(15,0.1,'marker','o','markersize',30,'markeredgecolor','none','markerfacecolor',ColGreen);
  set(H,'HeadStyle','rectangle','Color',ColRed,'LineWidth',2,'HeadLength',2,'HeadWidth',20);
  axis tight; xlim([-30 30]); ylim([-0.2 1]);axis off
  
  %%
  subplot(7,3,[6 9])
  H=bar(t,ccg(:,1,2),1);
  hold on;
  Lines([],mean(mean(mccg,2)),'b','--',2)
  Lines([],mean(mean(mccg,2)+3*std(mccg')'),'b','--',2)
  axis tight; xlim([-30 30])
  set(gca,'TickDir','out','FontSize',16)
  set(H,'FaceColor',[1 1 1]*0.2,'EdgeColor',[1 1 1]*0.2)
  %xlabel('time [ms]','FontSize',16)
  ylabel('rate [Hz]','FontSize',16)
  
  %%
  subplot(7,3,[12 15])
  H=bar(t,ccg(:,2,2),1);
  axis tight; xlim([-30 30])
  set(gca,'TickDir','out','FontSize',16)
  set(H,'FaceColor',ColGreen,'EdgeColor',ColGreen)
  ylabel('rate [Hz]','FontSize',16)
  
  %%
  subplot(7,3,[18 21])
  H=bar(t,ccg(:,1,1),1);
  axis tight; xlim([-30 30])
  set(gca,'TickDir','out','FontSize',16)
  set(H,'FaceColor',ColRed,'EdgeColor',ColRed)
  xlabel('time [ms]','FontSize',16)
  ylabel('rate [Hz]','FontSize',16)
  
  ForAllSubplots('box off')

  waitforbuttonpress;
end

return;








Trials = trial.itv(find(trial.dir==PlaceCell.ind(14,4)),:);
for tr=1:size(Trials,1)
  indxI = spike.ind==PlaceCell.ind(CellIN,1);
  indxP = spike.ind==PlaceCell.ind(CellPC,1);
  indxITR = indxI & WithinRanges(round(spike.t/20000*whl.rate),Trials(tr,:));
  indxPTR = indxP & WithinRanges(round(spike.t/20000*whl.rate),Trials(tr,:));

  Res = [spike.t(find(indxITR));spike.t(find(indxPTR))];
  Clu = [spike.ind(find(indxITR));spike.ind(find(indxPTR))];
  Allclu = unique(Clu);
  Ph = [spike.ph(find(indxITR));spike.ph(find(indxPTR))];
  Lpos = [spike.lpos(find(indxITR));spike.lpos(find(indxPTR))];
  Pos = [spike.pos(find(indxITR),:);spike.pos(find(indxPTR),:)];
  [ccg,t,pairs] = CCG(Res,Clu,40,100,20000);
  if length(Allclu)==1
    continue
  end
  xpairs = pairs(Clu(pairs(:,1))==Allclu(1) & Clu(pairs(:,2))==Allclu(2),:);
  pairbin = round(diff(Res(xpairs),1,2)/40) + 100 + 1;
  goodpair = find(pairbin==102);
  
  figure(3);clf
  %subplot(413)
  subplot(12,1,[6 7])
  plot(spike.lpos(find(indxPTR)),spike.ph(find(indxPTR))*180/pi,'o',...
       'markersize',5,'markeredgecolor','none','markerfacecolor',[0.7 0.7 0.7]);
  hold on
  plot(spike.lpos(find(indxPTR)),spike.ph(find(indxPTR))*180/pi+360,'o',...
       'markersize',5,'markeredgecolor','none','markerfacecolor',[0.7 0.7 0.7]);
  plot(Lpos(xpairs(goodpair,1)),Ph(xpairs(goodpair,1))*180/pi,'o',...
       'markersize',5,'markeredgecolor','none','markerfacecolor',[1 0 0]);
  plot(Lpos(xpairs(goodpair,1)),Ph(xpairs(goodpair,1))*180/pi+360,'o',...
       'markersize',5,'markeredgecolor','none','markerfacecolor',[1 0 0]);
  set(gca,'TickDir','out','FontSize',16)
  xlim([0 max(spike.lpos(find(indxITR)))])
  ylim([0 720])
  %xlabel('distance [cm]','FontSize',16)
  ylabel('phase','FontSize',16)

  %subplot(413)
  subplot(12,1,[8 9])
  plot(spike.lpos(find(indxITR)),spike.ph(find(indxITR))*180/pi,'o',...
       'markersize',5,'markeredgecolor','none','markerfacecolor',[0.7 0.7 0.7]);
  hold on
  plot(spike.lpos(find(indxITR)),spike.ph(find(indxITR))*180/pi+360,'o',...
       'markersize',5,'markeredgecolor','none','markerfacecolor',[0.7 0.7 0.7]);
  plot(Lpos(xpairs(goodpair,2)),Ph(xpairs(goodpair,2))*180/pi,'o',...
       'markersize',5,'markeredgecolor','none','markerfacecolor',[0 0 1]);
  plot(Lpos(xpairs(goodpair,2)),Ph(xpairs(goodpair,2))*180/pi+360,'o',...
       'markersize',5,'markeredgecolor','none','markerfacecolor',[0 0 1]);
  set(gca,'TickDir','out','FontSize',16)
  xlim([0 max(spike.lpos(find(indxITR)))])
  ylim([0 720])
  xlabel('distance [cm]','FontSize',16)
  ylabel('phase','FontSize',16)
  
  %subplot(411)
  subplot(12,1,1)
  Lines(spike.t(find(indxITR))/20000,[1 2],[0.7 0.7 0.7]);
  Lines(spike.t(find(indxPTR))/20000,[2 3],[0.7 0.7 0.7]);
  Lines(Res(xpairs(goodpair,1))'/20000,[2 3],'r');
  Lines(Res(xpairs(goodpair,2))'/20000,[1 2],'b');
  set(gca,'TickDir','out','FontSize',16)
  xlim([min(spike.t(find(indxITR))/20000) max(spike.t(find(indxPTR))/20000)])
  ylim([1 4])
  axis off %xlabel('Time [s]','FontSize',16)

  subplot(12,1,[2 3])
  plot(spike.t(find(indxPTR))/20000,spike.ph(find(indxPTR))*180/pi,'o',...
       'markersize',5,'markeredgecolor','none','markerfacecolor',[0.7 0.7 0.7]);
  hold on
  plot(spike.t(find(indxPTR))/20000,spike.ph(find(indxPTR))*180/pi+360,'o',...
       'markersize',5,'markeredgecolor','none','markerfacecolor',[0.7 0.7 0.7]);
  plot(Res(xpairs(goodpair,1))/20000,Ph(xpairs(goodpair,1))*180/pi,'o',...
       'markersize',5,'markeredgecolor','none','markerfacecolor',[1 0 0]);
  plot(Res(xpairs(goodpair,1))/20000,Ph(xpairs(goodpair,1))*180/pi+360,'o',...
       'markersize',5,'markeredgecolor','none','markerfacecolor',[1 0 0]);
  set(gca,'TickDir','out','FontSize',16)
  xlim([min(spike.t(find(indxITR))/20000) max(spike.t(find(indxITR))/20000)])
  ylim([0 720])
  ylabel('phase','FontSize',16)

  subplot(12,1,[4 5])
  plot(spike.t(find(indxITR))/20000,spike.ph(find(indxITR))*180/pi,'o',...
       'markersize',5,'markeredgecolor','none','markerfacecolor',[0.7 0.7 0.7]);
  hold on
  plot(spike.t(find(indxITR))/20000,spike.ph(find(indxITR))*180/pi+360,'o',...
       'markersize',5,'markeredgecolor','none','markerfacecolor',[0.7 0.7 0.7]);
  plot(Res(xpairs(goodpair,2))/20000,Ph(xpairs(goodpair,2))*180/pi,'o',...
       'markersize',5,'markeredgecolor','none','markerfacecolor',[0 0 1]);
  plot(Res(xpairs(goodpair,2))/20000,Ph(xpairs(goodpair,2))*180/pi+360,'o',...
       'markersize',5,'markeredgecolor','none','markerfacecolor',[0 0 1]);
  set(gca,'TickDir','out','FontSize',16)
  xlim([min(spike.t(find(indxITR))/20000) max(spike.t(find(indxITR))/20000)])
  ylim([0 720])
  xlabel('time [s]','FontSize',16)
  ylabel('phase','FontSize',16)

  subplot(427)
  plot(whl.plot(1:100:end,1),whl.plot(1:100:end,2),'o', ...
       'markersize',5,'markeredgecolor','none','markerfacecolor',[0.9 0.9 0.9]);
  hold on
  plot(spike.pos(find(indxITR),1),spike.pos(find(indxITR),2),'o', ...
       'markersize',5,'markeredgecolor','none','markerfacecolor',[0.7 0.7 0.7]);
  plot(Pos(xpairs(goodpair,2),1),Pos(xpairs(goodpair,2),2),'o', ...
       'markersize',5,'markeredgecolor','none','markerfacecolor',[0 0 1]);
  axis off
  
  subplot(428)
  plot(whl.plot(1:100:end,1),whl.plot(1:100:end,2),'o', ...
       'markersize',5,'markeredgecolor','none','markerfacecolor',[0.9 0.9 0.9]);
  hold on
  plot(spike.pos(find(indxPTR),1),spike.pos(find(indxPTR),2),'o', ...
       'markersize',5,'markeredgecolor','none','markerfacecolor',[0.7 0.7 0.7]);
  plot(Pos(xpairs(goodpair,2),1),Pos(xpairs(goodpair,2),2),'o', ...
       'markersize',5,'markeredgecolor','none','markerfacecolor',[1 0 0]);
  axis off

  ForAllSubplots('box off')

  waitforbuttonpress
  
end



return;

  %plot(spike.t(find(indxITR))/20000,spike.ph(find(indxITR))*180/pi,'.')
  %hold on
  %plot(spike.t(find(indxITR))/20000,spike.ph(find(indxITR))*180/pi+360,'.')
  %plot(spike.t(find(indxPTR))/20000,spike.ph(find(indxPTR))*180/pi,'r.')
  %plot(spike.t(find(indxPTR))/20000,spike.ph(find(indxPTR))*180/pi+360,'r.')



Intern = unique(find(PlaceCell.ind(:,5)==2));
Pyram = unique(find(PlaceCell.ind(:,5)==1));

for int = 1:length(Intern)
  indxI = spike.ind==Intern(int) & WithinRanges(round(spike.t/20000*whl.rate),trial.itv) & spike.good; 
  
  figure(1)
  for pyr = 1:length(Pyram)
    
    indxP = spike.ind==Pyram(pyr) & WithinRanges(round(spike.t/20000*whl.rate),trial.itv) & spike.good; 
    
    [ccg,t] = CCG([spike.t(find(indxI));spike.t(find(indxP))],[spike.ind(find(indxI));spike.ind(find(indxP))],50,20,20000);
    
    subplotfit(pyr,length(Pyram))
    bar(t,ccg(:,1,2))
    axis tight
    
  end
  
  waitforbuttonpress
  
end

for int = 1:length(Intern)
  indxI = spike.ind==Intern(int) & WithinRanges(round(spike.t/20000*whl.rate),trial.itv) & spike.good; 
  
  for pyr = 1:length(Pyram)
    
    indxP = spike.ind==Pyram(pyr) & WithinRanges(round(spike.t/20000*whl.rate),trial.itv) & spike.good; 
    
    figure(1)
    subplot(121)
    plot(spike.lpos(indxP),spike.ph(indxP),'.')

    
    
  end
  
  waitforbuttonpress
  
end
