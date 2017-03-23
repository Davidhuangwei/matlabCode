
%% combine data
%AA = CatStruct(ALL(1:4)); 
AA = CatStruct(ALL(7:10));

AA.type=AA.type(1:end-1);

for n=1:length(AA.type)
  SHH(:,n) = smooth(AA.PhH.phhist(:,n),5,'lowess');
end

%% select good and cells
GC = AA.PhH.pval<0.1;
PC = AA.type==2 & GC';
IN = AA.type==1 & GC';

%% bins for histograms
Bin = [-360+5:10:360-5];

%% max phase of each cell
[mm mi] = max(SHH(1:36,:));
[ss si] = sort(Bin(mi));

%% mean phase
mPC = mod(circmean(Bin(mi(PC))*pi/180),2*pi)*180/pi
mIN = mod(circmean(Bin(mi(IN))*pi/180),2*pi)*180/pi

%% Eeg phase
ThPhase = InternThetaPh(FileBase);
AvEegPh = MakeAvF(mod(ThPhase.deg,2*pi)*180/pi,Eeg,36);

figure(323);clf
subplot(531)
plot([AvEegPh;AvEegPh],'k','LineWidth',2)
axis tight
box off
axis off
text(-15,0,'LFP','FontSize',16)
%
subplot(5,3,[4:3:12])
imagesc(Bin,[],unity(SHH(:,(PC)))')
axis xy
Lines(mPC,[],'k','--',2);
Lines(mPC-360,[],'k','--',2);
set(gca,'FontSize',16,'TickDir','out','XTick',[-360:180:360])
xlabel('phase','FontSize',16)
ylabel('cell #','FontSize',16)
box off
%
subplot(132)
r=rose(AA.PhH.th0(PC));
set(r,'color',[0 0 0],'LineWidth',2)
%set(r,'FontSize',16)
xlabel('pyramidal cells','FontSize',16)
%
subplot(133)
r=rose(AA.PhH.th0(IN))
set(r,'color',[0 0 0],'LineWidth',2)
xlabel('Interneurons','FontSize',16)



%% PRINT FIGURE
PrintFig('SfN08PhaseHist',0)
