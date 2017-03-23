function SVMUPlotPhase(FileBase,CatAll)

%% smooth all histograms
for n=1:size(CatAll.PhH.phhist,2);
  SHH(:,n) = smooth(CatAll.PhH.phhist(:,n),10,'lowess');
end
%SHH = CatAll.PhH.sphhist;


%% bins for histograms
Bin = [-360+5:10:360-5];

%% max phase of each cell
[mm mi] = max(SHH(1:36,:));
[ss si] = sort(Bin(mi));

%% select good and cells
GC = (CatAll.PhH.pval<0.01)';% & CatAll.spect.good';

%% select all CA1
RS(:,1) = CatAll.cells.region==1;% | CatAll.cells.region==2;
%% select all CA3
RS(:,2) = CatAll.cells.region==2;

%% Eeg phase
FileBase = '2006-6-07_16-40-19/2006-6-07_16-40-19';
run = load([FileBase '.sts.RUN']);
Eeg = GetEEG(FileBase);
pEeg =  SelectPeriods(Eeg,run,'c',1,1);
ThPhase = InternThetaPh(FileBase);
pPhase = SelectPeriods(ThPhase.deg,run,'c',1,1);
AvEegPh = MakeAvF(mod(pPhase,2*pi)*180/pi,pEeg,36);
%AvEegPh = cos([1:36]'*2*pi/36);

for n=1%:2
  %% select interneurons and pyramidal cells
  PC = CatAll.type.num==2 & GC & RS(:,n);
  IN = CatAll.type.num==1 & GC & RS(:,n);

  %% mean phase of each sorted
  %[mphs maxph] = MeanPhaseFromHist(CatAll.PhH.phhist(1:36,PC));
  [ths thi] = sort(CatAll.PhH.th0(PC));
  %[ths thi] = sort(mphs);
  dPC = find(PC);
  
  %% mean phase
  %mPC = mod(circmean(Bin(mi(PC))*pi/180),2*pi)*180/pi;
  %mIN = mod(circmean(Bin(mi(IN))*pi/180),2*pi)*180/pi;
  [rmPC rPC] = circmean(CatAll.PhH.th0(PC));
  [rmIN rIN] = circmean(CatAll.PhH.th0(IN));
  mPC = mod(rmPC*180/pi,360);
  mIN = mod(rmIN*180/pi,360);
  
  %% Figure
  f = 323+n;
  figure(f);clf
  set(gcf,'position',[1853 604 855 346]);
  %subplot(531)
  subplot('position',[0.15 0.82 0.21 0.10])
  plot([AvEegPh;AvEegPh],'k','LineWidth',2)
  axis tight
  box off
  axis off
  text(-15,0,'LFP','FontSize',16)
  %
  %subplot(5,3,[4:3:12])
  subplot('position',[0.15 0.28 0.21 0.46])
  %imagesc(Bin,[],unity(SHH(:,(PC(thi))))')
  imagesc(Bin,[],unity(SHH(:,(dPC(thi))))');
  hold on
  plot(ths*180/pi,[1:length(ths)],'k.');
  plot(ths*180/pi-360,[1:length(ths)],'k.');
  axis xy
  %Lines(mPC,[],'r','--',2);
  %Lines(mPC-360,[],'r','--',2);
  %Lines(180,[],'k','--',2);
  %Lines(180-360,[],'k','--',2);
  set(gca,'FontSize',16,'TickDir','out','XTick',[-360:180:360]);
  xlabel('phase','FontSize',16);
  ylabel('pyramidal cell #','FontSize',16);
  box off
  %text(-700,1700,'G','FontSize',16)
  %text(450,1700,'H','FontSize',16)  
  text(-700,1700,'A','FontSize',16)
  text(450,1700,'B','FontSize',16)
  %
  %
  %subplot(132)
  subplot('position',[0.4108    0.1100    0.2134    0.8150])
  r=rose(CatAll.PhH.th0(PC));
  axis tight
  hold on
  set(r,'color',[0 0 0],'LineWidth',2);
  p=polar([rmPC rmPC],[0 200],'--r');
  set(p,'LineWidth',2);
  xlabel('pyramidal cells','FontSize',16);
  %
  %subplot(133)
  subplot('position',[0.6916    0.1100    0.2134    0.8150])
  r=rose(CatAll.PhH.th0(IN));
  axis tight
  hold on
  set(r,'color',[0 0 0],'LineWidth',2)
  p=polar([rmIN rmIN],[0 40],'--r');
  set(p,'LineWidth',2);
  xlabel('interneurons','FontSize',16)

  fprintf(['mean phase PC ' num2str(round(mPC)) '\n'])
  fprintf(['mean phase IN ' num2str(round(mIN)) '\n'])
  
  %length(find(PC))
  %length(find(IN))
  
  %% PRINT FIGURE
  PrintFig(['SVMUPlotPhase' num2str(n)],0)
end



PrintFig(['SVMUPlotPhase1'],0)




return