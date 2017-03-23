function DVPlotPhase(FileBase,CatAll)

%% update cell type
newpc = CheckPCIN(CatAll,0,'DorsalVentral_NewPC.mat');
CatAll.type.num = newpc+1;

%% smooth all histograms
for n=1:size(CatAll.PhH.phhist,2)
  SHH(:,n) = smooth(CatAll.PhH.phhist(:,n),5,'lowess');
end

%% bins for histograms
Bin = [-360+5:10:360-5];

%% max phase of each cell
[mm mi] = max(SHH(1:36,:));
[ss si] = sort(Bin(mi));

%% select good and cells
%GC = CatAll.PhH.pval<0.05;
GC = CatAll.spect.good;


%% select all dorsal
RS(:,1) = CatAll.cells.region==1;
%% select all ventral
RS(:,2) = CatAll.cells.region==5;

%% Eeg phase
Eeg = GetEEG(FileBase);
ThPhase = InternThetaPh(FileBase);
AvEegPh = MakeAvF(mod(ThPhase.deg,2*pi)*180/pi,Eeg,36);

for n=1:2

  %% select interneurons and pyramidal cells
  PC = CatAll.type.num==2 & GC & RS(:,n);
  IN = CatAll.type.num==1 & GC & RS(:,n);

  %% mean phase
  mPC = mod(circmean(Bin(mi(PC))*pi/180),2*pi)*180/pi;
  mIN = mod(circmean(Bin(mi(IN))*pi/180),2*pi)*180/pi;
  
  %% Figure
  f = 323+n;
  figure(f);clf
  subplot(531)
  plot([AvEegPh;AvEegPh],'k','LineWidth',2)
  axis tight
  box off
  axis off
  text(-15,0,'LFP','FontSize',16)
  %
  subplot(5,3,[4:3:12])
  imagesc(Bin,[],unity(SHH(:,(PC)))')
  %imagesc(Bin,[],unity(SHH(:,(PC)))')
  axis xy
  Lines(mPC,[],'r','--',2);
  Lines(mPC-360,[],'r','--',2);
  Lines(180,[],'k','--',2);
  Lines(180-360,[],'k','--',2);
  set(gca,'FontSize',16,'TickDir','out','XTick',[-360:180:360])
  xlabel('phase','FontSize',16)
  ylabel('cell #','FontSize',16)
  box off
  %
  subplot(132)
  r=rose(CatAll.PhH.th0(PC));
  hold on
  
  set(r,'color',[0 0 0],'LineWidth',2)
  %set(r,'FontSize',16)
  xlabel('pyramidal cells','FontSize',16)
  %
  subplot(133)
  r=rose(CatAll.PhH.th0(IN))
  set(r,'color',[0 0 0],'LineWidth',2)
  xlabel('Interneurons','FontSize',16)

  %% PRINT FIGURE
  FileName = ['DVPlotPhase_' num2str(n)];
  PrintFig(FileName,0)
end

