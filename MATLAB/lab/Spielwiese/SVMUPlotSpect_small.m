function SVMUPlotSpect_small(CatAll,ALL,varargin)
[printfig] = DefaultArgs(varargin,{0});

mp=0; mi=0;

SP = [];
F = [];
EF = [];
MXF = [];
CX = [];
CXT = [];
MCXT = [];
for n=unique(CatAll.file)'
  %% spectra
  SizeSP = size(ALL(n).spect.spunit);
  SP = [SP ALL(n).spect.spunit(1:100,:)];
  F = [F repmat(ALL(n).spect.f(1:100),1,SizeSP(2))];
  %% max
  gf = find(ALL(n).spect.f>5 & ALL(n).spect.f<12);
  [ma mi] = max(ALL(n).spect.spunit(gf,:));
  MXF = [MXF; ALL(n).spect.f(gf(mi))];
  %% Eeg frequency
  EF = [EF repmat(ALL(n).spect.feeg,1,SizeSP(2))];
  
  %% x-corr
  SizeCX = size(ALL(n).spect.xcorr);
  DT = [(SizeCX(1)+1)/2-50:(SizeCX(1)+1)/2+50];
  CX = [CX ALL(n).spect.xcorr(DT,:)];
  CXT = [CXT repmat(ALL(n).spect.xct(DT)',1,SizeCX(2))];
  %% max
  gt = find(ALL(n).spect.xct>-4 & ALL(n).spect.xct<4);
  [mac mic] = max(ALL(n).spect.xcorr(gt,:));
  MCXT = [MCXT; ALL(n).spect.xct(gt(mic))'];
end
 
%% phase
PH = CatAll.spectPh.spunit;
P = CatAll.spectPh.f(:,1);
%% max 
gp = find(P>0.5 & P<1.5);
[map mip] = max(CatAll.spectPh.spunit(gp,:));
MXP = CatAll.spectPh.f(gp(mip));


%% good cells
%APC1 = CatAll.type.num==2 & CatAll.cells.region==1;
%AIN1 = CatAll.type.num==1 & CatAll.cells.region==1;

CT = {'CA1' 'CA3'};
LL = {'A', 'B'; 'C', 'D'};

for k=[1 2]
  APC1 = CatAll.type.num==2 & CatAll.cells.region==k;
  AIN1 = CatAll.type.num==1 & CatAll.cells.region==k;
  
  PC1 = find(APC1 & CatAll.spect.good')';
  IN1 = find(AIN1 & CatAll.spect.good')';
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% XCORR SP
  figure(3875+k);clf;
  set(gcf,'position',[1489 590 528 355])
  subplot('position',[0.15 0.15 0.3 0.6])
  [sxa sxi] = sort(MCXT(PC1));
  for n=1:length(PC1)
    gt = find(CXT(:,PC1(sxi(n)))>-3 & CXT(:,PC1(sxi(n)))<3);
    imagesc(CXT(gt,PC1(sxi(n))),n,unity(CX(gt,PC1(sxi(n))))')
    hold on
  end
  axis xy
  ylim([1 length(PC1)])
  xlim([-3 3])
  xlabel('\Delta frequency [Hz]','FontSize',16)
  ylabel([CT{k} ' pyramidal cell #'],'FontSize',16,'position',[-4.7 length(PC1)/2])
  set(gca,'TickDir','out','FontSize',16)
  box off;
  plot(sxa,[1:length(PC1)],'.k')
  Lines(0,[],'k','--',2);
  Lines(mean(sxa),[],[1 1 1]*0.7,'--',2);
  %%%%%%%%%%%%%%%%
  subplot('position',[0.15 0.75 0.3 0.2])
  b = [floor(min(MCXT)):0.2:ceil(max(MCXT))];
  bp = b(1:end-1)+0.1;
  hp = histcI(MCXT(PC1),b);
  b1=bar(bp,hp);
  set(b1,'FaceColor',[0.6 0 0],'EdgeColor',[0.5 0 0])
  axis tight
  xlim([-3 3])
  Lines(0,[],'k','--',2);
  Lines(mean(MCXT(PC1)),[],[1 1 1]*0.7,'--',2);
  fprintf(['XCorr: mean PC=' num2str(mean(MCXT(PC1))) 'Hz  ; mean IN=' num2str(mean(MCXT(IN1))) 'Hz\n' ]);
  fprintf(['XCorr: stdv PC=' num2str(std(MCXT(PC1))) 'Hz  ; stdv IN=' num2str(std(MCXT(IN1))) 'Hz\n' ]);
  set(gca,'TickDir','out','FontSize',16)
  box off; axis off
  %%%%%%%%%%%%%%%
  subplot('position',[0.6 0.15 0.3 0.6])
  [sxa sxi] = sort(MCXT(IN1));
  for n=1:length(IN1)
    gt = find(CXT(:,IN1(sxi(n)))>-3 & CXT(:,IN1(sxi(n)))<3);
    imagesc(CXT(gt,IN1(sxi(n))),n,unity(CX(gt,IN1(sxi(n))))')
    hold on
  end
  axis xy
  ylim([1 length(IN1)])
  xlim([-3 3])
  xlabel('\Delta frequency [Hz]','FontSize',16)
  ylabel([CT{k} ' interneuron #'],'FontSize',16)
  set(gca,'TickDir','out','FontSize',16)
  box off;
  plot(sxa,[1:length(IN1)],'.k')
  Lines(0,[],'k','--',2);
  Lines(mean(sxa),[],[1 1 1]*0.7,'--',2);

  text(-15,length(IN1)*1.3,LL{k,1},'FontSize',20)
    
  %%%%%%%%%%%%%
  subplot('position',[0.6 0.75 0.3 0.2])
  b = [floor(min(MCXT)):0.2:ceil(max(MCXT))];
  bp = b(1:end-1)+0.1;
  hp = histcI(MCXT(IN1),b);
  b2=bar(bp,hp);
  set(b2,'FaceColor',[0 0.6 0],'EdgeColor',[0 0.5 0])
  axis tight
  xlim([-3 3])
  xlabel('\Delta frequency [Hz]','FontSize',16)
  ylabel('count','FontSize',16)
  Lines(0,[],'k','--',2);
  Lines(mean(MCXT(IN1)),[],[1 1 1]*0.7,'--',2);
  set(gca,'TickDir','out','FontSize',16)
  box off; axis off
  
  %%%%%%%%%%%%%%%%%
  y1 = [length(find(MCXT(PC1)<0)) length(find(MCXT(PC1)==0)) length(find(MCXT(PC1)>0))];
  y2 = [length(find(MCXT(IN1)<0)) length(find(MCXT(IN1)==0)) length(find(MCXT(IN1)>0))];
  py1 = round(y1/sum(y1)*100); py2 = round(y2/sum(y2)*100);
  fprintf(['CX PC (<1 | 1 | >1): ' num2str(y1(1)) ' | ' num2str(y1(2)) ' | ' num2str(y1(3)) '\n'])  
  fprintf(['          (percentage): ' num2str(py1(1)) ' | ' num2str(py1(2)) ' | ' num2str(py1(3)) '\n'])  
  fprintf(['CX IN (<1 | 1 | >1): ' num2str(y2(1)) ' | ' num2str(y2(2)) ' | ' num2str(y2(3)) '\n'])  
  fprintf(['          (percentage): ' num2str(py2(1)) ' | ' num2str(py2(2)) ' | ' num2str(py2(3)) '\n'])  
  
  PrintFig(['SVMUPlotSpect' CT{k} '_2'],printfig)
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Phase Sp
  figure(3866+k);clf;
  set(gcf,'position',[1489 590 528 355])
  subplot('Position',[0.15 0.15 0.3 0.6])
  [sa si] = sort(MXP(PC1));
  gt = find(P>0.7 & P<1.3);
  imagesc(P(gt),[1:length(PC1)],unity(PH(gt,PC1(si)))')
  hold on
  axis xy
  ylim([1 length(PC1)])
  xlim([0.7 1.3])
  xlabel('rel. frequency','FontSize',16)
  ylabel([CT{k} ' pyramidal cell #'],'FontSize',16,'position',[0.53 length(PC1)/2])
  set(gca,'TickDir','out','FontSize',16)
  box off;
  plot(sa,[1:length(PC1)],'.k')
  Lines(1,[],'k','--',2);
  Lines(mean(sa),[],[1 1 1]*0.7,'--',2);
  %%%%%%%%%%%%
  subplot('Position',[0.15 0.75 0.3 0.2])
  b = [floor(min(MXP))-0.025:0.05:ceil(max(MXP))+0.025];
  bp = b(1:end-1)+0.025;
  hp = histcI(MXP(PC1),b);
  b1=bar(bp,hp);
  set(b1,'FaceColor',[0.6 0 0],'EdgeColor',[0.5 0 0])
  axis tight
  xlim([0.7 1.3])
  Lines(1,[],[0 0 0],'--',2);
  Lines(mean(MXP(PC1)),[],[1 1 1]*0.7,'--',2);
  fprintf(['Phase: mean PC=' num2str(mean(MXP(PC1))) 'Hz  ; mean IN=' num2str(mean(MXP(IN1))) 'Hz\n' ]);
  fprintf(['Phase: stdv PC=' num2str(std(MXP(PC1))) 'Hz  ; stdv IN=' num2str(std(MXP(IN1))) 'Hz\n' ]);
  set(gca,'TickDir','out','FontSize',16)
  box off; axis off;
  %%%%%%%%%%%%%%%%%
  subplot('Position',[0.6 0.15 0.3 0.6])
  [sa si] = sort(MXP(IN1));
  gt = find(P>0.7 & P<1.3);
  imagesc(P(gt),[1:length(IN1)],unity(PH(gt,IN1(si)))')
  hold on
  axis xy
  ylim([1 length(IN1)])
  xlim([0.7 1.3])
  xlabel('rel. frequency','FontSize',16)
  ylabel([CT{k} ' interneuron #'],'FontSize',16)
  set(gca,'TickDir','out','FontSize',16)
  box off;
  plot(sa,[1:length(IN1)],'.k')
  Lines(1,[],'k','--',2);
  Lines(mean(sa),[],[1 1 1]*0.7,'--',2);

  text(1-0.3*5,length(IN1)*1.3,LL{k,2},'FontSize',20)
  
  %%%%%%%%%%%%%%%%%
  subplot('Position',[0.6 0.75 0.3 0.2])
  b = [floor(min(MXP))-0.025:0.05:ceil(max(MXP))+0.025];
  bp = b(1:end-1)+0.025;
  hp = histcI(MXP(IN1),b);
  b2=bar(bp,hp);
  set(b2,'FaceColor',[0 0.6 0],'EdgeColor',[0 0.5 0])
  axis tight
  xlim([0.7 1.3])
  Lines(1,[],'k','--',2);
  Lines(mean(MXP(IN1)),[],[1 1 1]*0.7,'--',2);
  set(gca,'TickDir','out','FontSize',16)
  box off;axis off;
  
  
  %%%%%%%%%%%%%%%%
  co = 1.02; co2 = 0.98;
  y1=[length(find(MXP(PC1)<co2)) length(find(MXP(PC1)>co2 & MXP(PC1)<co)) length(find(MXP(PC1)>co))];
  y2=[length(find(MXP(IN1)<co2)) length(find(MXP(IN1)>co2 & MXP(IN1)<co)) length(find(MXP(IN1)>co))];
  py1 = round(y1/sum(y1)*100); py2 = round(y2/sum(y2)*100);
  fprintf(['Phase PC (<1 | 1 | >1): ' num2str(y1(1)) ' | ' num2str(y1(2)) ' | ' num2str(y1(3)) '\n'])  
  fprintf(['          (percentage): ' num2str(py1(1)) ' | ' num2str(py1(2)) ' | ' num2str(py1(3)) '\n'])  
  fprintf(['Phase IN (<1 | 1 | >1): ' num2str(y2(1)) ' | ' num2str(y2(2)) ' | ' num2str(y2(3)) '\n'])  
  fprintf(['          (percentage): ' num2str(py2(1)) ' | ' num2str(py2(2)) ' | ' num2str(py2(3)) '\n'])  
  
  fprintf(['all pc ' num2str(length(find(APC1))) '\n'])
  fprintf(['all in ' num2str(length(find(AIN1))) '\n'])
  

  %PrintFig('SVMUPlotSpect_3',printfig)
  PrintFig(['SVMUPlotSpect' CT{k} '_3'],printfig)
end

return;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
