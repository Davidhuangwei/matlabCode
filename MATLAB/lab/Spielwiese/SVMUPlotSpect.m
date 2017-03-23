function SVMUPlotSpect(CatAll,ALL,varargin)
[printfig] = DefaultArgs(varargin,{0});

mp=0; mi=0;
figure(3874);clf;


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
PC1 = find(CatAll.type.num==2 & CatAll.cells.region<3 & CatAll.spect.good')';
IN1 = find(CatAll.type.num==1 & CatAll.cells.region<3 & CatAll.spect.good')';
%PC1 = find(CatAll.type.num==2 & CatAll.cells.region==2 & CatAll.spect.good')';
%IN1 = find(CatAll.type.num==1 & CatAll.cells.region==2 & CatAll.spect.good')';

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SPECTRUM
figure(3874);clf;
subplot('position',[0.15 0.15 0.2 0.6])
[sa si] = sort(MXF(PC1));
for n=1:length(PC1)
  imagesc(F(:,PC1(si(n))),n,unity(SP(:,PC1(si(n))))')
  hold on
  axis xy
  ylim([1 length(PC1)])
  xlim([4 12])
  xlabel('frequency [Hz]','FontSize',16)
  ylabel('pyramidal cells','FontSize',16)
  set(gca,'TickDir','out','FontSize',16,'XTick',[4:2:12])
  box off;
end
plot(sa,[1:length(PC1)],'.k')
Lines(mean(sa),[],'k','--',2);
%%%%%%%%%%%%%%%%
subplot('position',[0.15 0.75 0.2 0.2])
b = [floor(min(MXF)):0.2:ceil(max(MXF))];
bp = b(1:end-1)+0.1;
hp = histcI(MXF(PC1),b);
b1=bar(bp,hp);
set(b1,'FaceColor',[0.6 0 0],'EdgeColor',[0.5 0 0])
axis tight
ylabel('count','FontSize',16)
Lines(mean(MXF(PC1)),[],[0 0 0],'--',2);
fprintf(['Spect: mean PC=' num2str(mean(MXF(PC1))) 'Hz  ; mean IN=' num2str(mean(MXF(IN1))) 'Hz\n' ]);
set(gca,'TickDir','out','FontSize',16,'XTick',[],'YTick',300)
box off; axis off;
xlim([4 12])
%%%%%%%%%%%%%%%%%
subplot('position',[0.45 0.15 0.2 0.6])
[sa si] = sort(MXF(IN1));
for n=1:length(IN1)
  imagesc(F(:,IN1(si(n))),n,unity(SP(:,IN1(si(n))))')
  hold on
  axis xy
  ylim([1 length(IN1)])
  xlim([4 12])
  xlabel('frequency [Hz]','FontSize',16)
  ylabel('interneurons','FontSize',16)
  set(gca,'TickDir','out','FontSize',16,'XTick',[4:2:12])
  box off;
end
plot(sa,[1:length(IN1)],'.k')
Lines(mean(sa),[],'k','--',2);
%%%%%%%%%%%%%%%%
subplot('position',[0.45 0.75 0.2 0.2])
b = [floor(min(MXF)):0.2:ceil(max(MXF))];
bp = b(1:end-1)+0.1;
hp = histcI(MXF(IN1),b);
b2=bar(bp,hp);
set(b2,'FaceColor',[0 0.6 0],'EdgeColor',[0 0.5 0])
axis tight
Lines(mean(MXF(IN1)),[],[0 0 0],'--',2);
set(gca,'TickDir','out','FontSize',16)
box off; axis off;
xlim([4 12])
%%%%%%%%%%%%%%%
subplot('position',[0.75 0.55 0.2 0.3])
Acc = Accumulate([round((EF(PC1)+rand(size(PC1))*0.1)*10)' round((MXF(PC1)+rand(size(PC1))'*0.1)*10)],1,[100 110]);
sAcc = reshape(smooth(reshape(smooth(Acc,5,'lowess'),100,110)',5,'lowess'),110,100)';
imagesc([1:100]/10,[1:110]/10,sAcc')
axis xy
hold on
%plot([4 11],[4 11],'--','color',[1 1 1],'LineWidth',2)
plot([4 11],[4 11],'w--','LineWidth',2)
xlim([6 10])
ylim([6 10])
ylabel('unit frequency [Hz]','FontSize',16,'position',[5.3 5.3])
title('pyramidal cells','FontSize',16,'position',[8 10])
set(gca,'TickDir','out','FontSize',16,'XTick',[])
box off
%%%%%%%%%%%%%%%%%%
subplot('position',[0.75 0.15 0.2 0.3])
Acci = Accumulate([round((EF(IN1)+rand(size(IN1))*0.1)*10)' round((MXF(IN1)+rand(size(IN1))'*0.1)*10)],1,[100 110]);
sAcci = reshape(smooth(reshape(smooth(Acci,5,'lowess'),100,110)',5,'lowess'),110,100)';
imagesc([1:100]/10,[1:110]/10,sAcci')
axis xy
hold on
plot([4 11],[4 11],'--','color',[1 1 1],'LineWidth',2)
xlim([6 10])
ylim([6 10])
xlabel('LFP frequency [Hz]','FontSize',16)
%ylabel('unit  frequency [Hz]','FontSize',16)
title('interneurons','FontSize',16,'position',[8 10])
set(gca,'TickDir','out','FontSize',16)
box off

PrintFig('SVMUPlotSpect_1',printfig)
%PrintFig('SVMUPlotSpectCA3_1',printfig)


%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% XCORR SP
figure(3875);clf;
subplot('position',[0.15 0.15 0.2 0.6])
[sxa sxi] = sort(MCXT(PC1));
for n=1:length(PC1)
  imagesc(CXT(:,PC1(sxi(n))),n,unity(CX(:,PC1(sxi(n))))')
  hold on
  axis xy
  ylim([1 length(PC1)])
  xlim([-3 3])
  xlabel('\Delta frequency [Hz]','FontSize',16)
  ylabel('pyramidal cells','FontSize',16)
  set(gca,'TickDir','out','FontSize',16)
  box off;
end
plot(sxa,[1:length(PC1)],'.k')
Lines(0,[],'k','--',2);
Lines(mean(sxa),[],[1 1 1]*0.7,'--',2);
%%%%%%%%%%%%%%%%
subplot('position',[0.15 0.75 0.2 0.2])
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
set(gca,'TickDir','out','FontSize',16)
box off; axis off
%%%%%%%%%%%%%%%
subplot('position',[0.45 0.15 0.2 0.6])
[sxa sxi] = sort(MCXT(IN1));
for n=1:length(IN1)
  imagesc(CXT(:,IN1(sxi(n))),n,unity(CX(:,IN1(sxi(n))))')
  hold on
  axis xy
  ylim([1 length(IN1)])
  xlim([-3 3])
  xlabel('\Delta frequency [Hz]','FontSize',16)
  ylabel('interneurons','FontSize',16)
  set(gca,'TickDir','out','FontSize',16)
  box off;
end
plot(sxa,[1:length(IN1)],'.k')
Lines(0,[],'k','--',2);
Lines(mean(sxa),[],[1 1 1]*0.7,'--',2);
%%%%%%%%%%%%%
subplot('position',[0.45 0.75 0.2 0.2])
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
subplot('position',[0.75 0.55 0.2 0.3])
b1=bar([-1 0 1],[length(find(MCXT(PC1)<0)) length(find(MCXT(PC1)==0)) length(find(MCXT(PC1)>0))]);
set(b1,'FaceColor',[1 0 0]*0.6,'EdgeColor',[1 0 0]*0.5);
ylabel('count','FontSize',16)
title('pyramidal cells','FontSize',16,'position',[0 max(get(b1,'YData'))])
set(gca,'TickDir','out','FontSize',16,'XTick',[])
axis tight
xlim([-2 2])
box off
%%%%%%%%%%%%%%%%
subplot('position',[0.75 0.15 0.2 0.3])
b2=bar([-1 0 1],[length(find(MCXT(IN1)<0)) length(find(MCXT(IN1)==0)) length(find(MCXT(IN1)>0))]);
set(b2,'FaceColor',[0 1 0]*0.6,'EdgeColor',[0 1 0]*0.5);
%xlabel('','FontSize',16)
ylabel('count','FontSize',16)
xlabel('\Delta frequency [Hz]','FontSize',16)
title('interneurons','FontSize',16,'position',[0 max(get(b2,'YData'))])
set(gca,'TickDir','out','FontSize',16,'XTick',[-1 0 1],'XTickLabel',[{'<0'}; {'0'}; {'>0'}])
axis tight
xlim([-2 2])
box off
%%
y1 = get(b1,'YData'); y2 = get(b2,'YData');
py1 = round(y1/sum(y1)*100); py2 = round(y2/sum(y2)*100);
fprintf(['CX PC (<1 | 1 | >1): ' num2str(y1(1)) ' | ' num2str(y1(2)) ' | ' num2str(y1(3)) '\n'])  
fprintf(['          (percentage): ' num2str(py1(1)) ' | ' num2str(py1(2)) ' | ' num2str(py1(3)) '\n'])  
fprintf(['CX IN (<1 | 1 | >1): ' num2str(y2(1)) ' | ' num2str(y2(2)) ' | ' num2str(y2(3)) '\n'])  
fprintf(['          (percentage): ' num2str(py2(1)) ' | ' num2str(py2(2)) ' | ' num2str(py2(3)) '\n'])  

PrintFig('SVMUPlotSpect_2',printfig)
%PrintFig('SVMUPlotSpectCA3_2',printfig)

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Phase Sp
figure(3876);clf;
subplot('Position',[0.15 0.15 0.2 0.6])
[sa si] = sort(MXP(PC1));
imagesc(P,[1:length(PC1)],unity(PH(:,PC1(si)))')
hold on
axis xy
ylim([1 length(PC1)])
xlim([0.7 1.3])
xlabel('frequency [1/deg]','FontSize',16)
ylabel('pyramidal cells','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off;
plot(sa,[1:length(PC1)],'.k')
Lines(1,[],'k','--',2);
Lines(mean(sa),[],[1 1 1]*0.7,'--',2);
%%%%%%%%%%%%
subplot('Position',[0.15 0.75 0.2 0.2])
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
set(gca,'TickDir','out','FontSize',16)
box off; axis off;
%%%%%%%%%%%%%%%%%
subplot('Position',[0.45 0.15 0.2 0.6])
[sa si] = sort(MXP(IN1));
imagesc(P,[1:length(IN1)],unity(PH(:,IN1(si)))')
hold on
axis xy
ylim([1 length(IN1)])
xlim([0.7 1.3])
xlabel('frequency [1/deg]','FontSize',16)
ylabel('interneurons','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off;
plot(sa,[1:length(IN1)],'.k')
Lines(1,[],'k','--',2);
Lines(mean(sa),[],[1 1 1]*0.7,'--',2);
%%%%%%%%%%%%%%%%%
subplot('Position',[0.45 0.75 0.2 0.2])
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
subplot('position',[0.75 0.55 0.2 0.3])
co = 1.02; co2 = 0.98;
b1=bar([-1 0 1],[length(find(MXP(PC1)<co2)) length(find(MXP(PC1)>co2 & MXP(PC1)<co)) length(find(MXP(PC1)>co))]);
set(b1,'FaceColor',[1 0 0]*0.6,'EdgeColor',[1 0 0]*0.5);
ylabel('count','FontSize',16)
title('pyramidal cells','FontSize',16,'position',[0 max(get(b1,'YData'))])
set(gca,'TickDir','out','FontSize',16,'XTick',[])
axis tight
xlim([-2 2])
box off
%%%%%%%%%%%%%%%%%
subplot('position',[0.75 0.15 0.2 0.3])
b2=bar([-1 0 1],[length(find(MXP(IN1)<co2)) length(find(MXP(IN1)>co2 & MXP(IN1)<co)) length(find(MXP(IN1)>co))]);
set(b2,'FaceColor',[0 1 0]*0.6,'EdgeColor',[0 1 0]*0.5);
xlabel('frequency [1/deg]','FontSize',16)
ylabel('count','FontSize',16)
title('interneurons','FontSize',16,'position',[0 max(get(b2,'YData'))])
set(gca,'TickDir','out','FontSize',16,'XTick',[-1 0 1],'XTickLabel',[{'<1'}; {'1'}; {'>1'}])
axis tight
xlim([-2 2])
box off
%%
%%
y1 = get(b1,'YData'); y2 = get(b2,'YData');
py1 = round(y1/sum(y1)*100); py2 = round(y2/sum(y2)*100);
fprintf(['Phase PC (<1 | 1 | >1): ' num2str(y1(1)) ' | ' num2str(y1(2)) ' | ' num2str(y1(3)) '\n'])  
fprintf(['          (percentage): ' num2str(py1(1)) ' | ' num2str(py1(2)) ' | ' num2str(py1(3)) '\n'])  
fprintf(['Phase IN (<1 | 1 | >1): ' num2str(y2(1)) ' | ' num2str(y2(2)) ' | ' num2str(y2(3)) '\n'])  
fprintf(['          (percentage): ' num2str(py2(1)) ' | ' num2str(py2(2)) ' | ' num2str(py2(3)) '\n'])  

PrintFig('SVMUPlotSpect_3',printfig)
%PrintFig('SVMUPlotSpectCA3_3',printfig)


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


for n=unique(CatAll.file)'
  
  figure(3874);
  subplot(221);
  imagesc(F,[mp+1:mp+length(PC1)],unity(SP(:,PC1))');
  hold on
  ylim([1 mp+length(PC1)]);
  axis xy
  xlabel('frequency [Hz]','FontSize',16)
  ylabel('pyramidal cells','FontSize',16)
  set(gca,'TickDir','out','FontSize',16)
  box off;
  %
  subplot(223);
  imagesc(CXT(GCXT),[mp+1:mp+length(PC1)],unity(CX(GCXT,PC1))');
  hold on
  ylim([1 mp+length(PC1)]);
  xlim([-4 4])
  axis xy
  xlabel('\Delta frequency [Hz]','FontSize',16)
  ylabel('pyramidal cells','FontSize',16)
  set(gca,'TickDir','out','XTick',[-5:5],'FontSize',16)
  Lines(0,[],'k','--',2);
  box off;
  mp = mp+length(PC1);

  subplot(222);
  imagesc(F,[mi+1:mi+length(IN1)],unity(SP(:,IN1))');
  hold on
  ylim([1 mi+length(IN1)]);
  axis xy
  xlabel('frequency [Hz]','FontSize',16)
  ylabel('interneurons','FontSize',16)
  set(gca,'TickDir','out','FontSize',16)
  box off;
  %
  subplot(224);
  imagesc(CXT(GCXT),[mi+1:mi+length(IN1)],unity(CX(GCXT,IN1))');
  hold on
  ylim([1 mi+length(IN1)]);
  xlim([-5 5])
  axis xy
  xlabel('\Delta frequency [Hz]','FontSize',16)
  ylabel('interneurons','FontSize',16)
  set(gca,'TickDir','out','FontSize',16)
  Lines(0,[],'k','--',2);
  box off;
  mi = mi+length(IN1);
  
  
  %figure(876)
  
  
  %go = input('go\n');
  
end  


return;


%% x-corr between eeg and units
XC = CatAll.spect.xcorr;
flag = [-floor(size(XC,1)/2):floor(size(XC,1)/2)]*mean(diff(F));
xi = find(flag>-5 & flag<5);
[mf mi] = max(XC(xi,:));
MXC = flag(xi(mi));
GMXC = MXC>-4 & MXC<4;


%% max of spect
[mf mi] = max(SP(fg,:));
MF = F(fg(mi));

RMF = MF - Spect.feega;


%%%%%%%%%%%%%%%%%%%%%%%

dx = 0.35;
dy = 0.35;
x1 = 0.15;
x2 = 0.56;
y1 = 0.15;
y2 = 0.55;

figure(543);clf;
%subplot(2,2,1)
subplot('position',[x1 y2 dx dy])
imagesc(F,[],unity(SP(:,PC1))')
hold on
axis xy
plot(Spect.feega(PC1),[1:length(find(PC1))],'k+')
ylabel('pyramidal cells #','FontSize',16)
title('dorsal','FontSize',16)
set(gca,'TickDir','out','FontSize',16,'XTickLabel',[])
box off
%
%subplot(2,2,2)
subplot('position',[x2 y2 dx dy])
imagesc(F,[],unity(SP(:,PC5))')
hold on
axis xy
plot(Spect.feega(PC5),[1:length(find(PC5))],'k+')
title('ventral','FontSize',16)
set(gca,'TickDir','out','FontSize',16,'XTickLabel',[])
box off
%
%subplot(2,2,3)
subplot('position',[x1 y1 dx dy])
imagesc(F,[],unity(SP(:,IN1))')
hold on
axis xy
plot(Spect.feega(IN1),[1:length(find(IN1))],'k+')
xlabel('frequency [Hz]','FontSize',16)
ylabel('interneurons #','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off
%
%subplot(2,2,4)
subplot('position',[x2 y1 dx dy])
imagesc(F,[],unity(SP(:,IN5))')
hold on
axis xy
plot(Spect.feega(IN5),[1:length(find(IN5))],'k+')
xlabel('frequency [Hz]','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off

PrintFig('SVMUPlotSpect_1',printfig)




%%%%
pbin = [-30:1:30]*mean(diff(flag));
bin = [pbin pbin(end)+mean(diff(flag))]-mean(diff(flag))/2;
p = 0.2;
p2 = 0.1;
pbin2 = [1:ceil(length(pbin)/2)];

figure(544);clf;
subplot(2,2,1)
k = RMF(PC1);
h(:,1) = histcI(k,bin);
bar(pbin,h(:,1))
hold on
Lines(mean(k),[],[],'--',2);
plot(pbin,cumsum(h(:,1))/sum(h(:,1))*max(h(:,1)),'--','color',[1 1 1]*0.5,'LineWidth',2)
s = sum(h(pbin2,1))/sum(h(:,1))
if s<p
  plot(0,max(h(:,1))*1.1,'*','color',[0 0 0])
end
axis tight
xlim([-2 2])
ylabel('pyramidal cells #','FontSize',16)
title('dorsal','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off
%
subplot(2,2,2)
k = RMF(PC5);
h(:,2) = histcI(k,bin);
bar(pbin,h(:,2))
hold on
Lines(mean(k),[],[],'--',2);
plot(pbin,cumsum(h(:,2))/sum(h(:,2))*max(h(:,2)),'--','color',[1 1 1]*0.5,'LineWidth',2)
s = sum(h(pbin2,2))/sum(h(:,2))
if s<p
  plot(0,max(h(:,2))*1.1,'*','color',[0 0 0])
end
axis tight
xlim([-2 2])
ylabel('pyramidal cells #','FontSize',16)
title('ventral','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off
%
subplot(2,2,3)
k = RMF(IN1);
h(:,3) = histcI(k,bin);
bar(pbin,h(:,3))
hold on
Lines(mean(k),[],[],'--',2);
plot(pbin,cumsum(h(:,3))/sum(h(:,3))*max(h(:,3)),'--','color',[1 1 1]*0.5,'LineWidth',2)
s = sum(h(pbin2,3))/sum(h(:,3))
if s<p
  plot(0,max(h(:,3))*1.1,'*','color',[0 0 0])
end
axis tight
xlim([-2 2])
ylabel('interneurons #','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off
%
subplot(2,2,4)
k = RMF(IN5);
h(:,4) = histcI(k,bin);
bar(pbin,h(:,4))
hold on
Lines(mean(k),[],[],'--',2);
plot(pbin,cumsum(h(:,4))/sum(h(:,4))*max(h(:,4)),'--','color',[1 1 1]*0.5,'LineWidth',2)
s = sum(h(pbin2,4))/sum(h(:,4))
if s<p
  plot(0,max(h(:,4))*1.1,'*','color',[0 0 0])
end
axis tight
xlim([-2 2])
ylabel('interneurons #','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off

PrintFig('SVMUPlotSpect_2',printfig)





%%%%%%%
dx = 0.35;
dy = 0.25;
x1 = 0.15;
x2 = 0.56;
y1 = 0.15;
y2 = 0.55;

figure(545);clf;
%subplot(2,2,1)
subplot('position',[x1 y2+dy dx 0.1])
k = MXC(GMXC&PC1);
h(:,1) = histcI(k,bin);
bar(pbin,h(:,1))
axis tight
xlim([-4 4])
title('dorsal','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off;axis off;
%%
subplot('position',[x1 y2 dx dy])
imagesc(flag(xi),[],unity(XC(xi,PC1))')
hold on
axis xy
plot(MXC(PC1),[1:length(find(PC1))],'k+')
Lines(0,[],'k','--',2);
set(gca,'TickDir','out','FontSize',16,'XTick',[])
xlim([-4 4])
box off
%
%subplot(2,2,2)
subplot('position',[x2 y2+dy dx 0.1])
k = MXC(GMXC&PC5);
h(:,2) = histcI(k,bin);
bar(pbin,h(:,2))
axis tight
xlim([-4 4])
title('ventral','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off;axis off
%%
subplot('position',[x2 y2 dx dy])
imagesc(flag(xi),[],unity(XC(xi,PC5))')
hold on
axis xy
plot(MXC(PC5),[1:length(find(PC5))],'k+')
Lines(0,[],'k','--',2);
set(gca,'TickDir','out','FontSize',16,'XTickLabel',[])
xlim([-4 4])
box off
%
%subplot(2,2,3)
subplot('position',[x1 y1+dy dx 0.1])
k = MXC(GMXC&IN1);
h(:,3) = histcI(k,bin);
bar(pbin,h(:,3))
axis tight
xlim([-4 4])
ylabel('interneurons #','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off;axis off
%%
subplot('position',[x1 y1 dx dy])
imagesc(flag(xi),[],unity(XC(xi,IN1))')
hold on
axis xy
plot(MXC(IN1),[1:length(find(IN1))],'k+')
Lines(0,[],'k','--',2);
ylabel('interneurons #','FontSize',16)
xlabel('frequency [Hz]','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
xlim([-4 4])
box off
%
%subplot(2,2,4)
subplot('position',[x2 y1+dy dx 0.1])
k = MXC(GMXC&IN5);
h(:,4) = histcI(k,bin);
bar(pbin,h(:,4))
axis tight
xlim([-4 4])
set(gca,'TickDir','out','FontSize',16)
box off, axis off;
%%
subplot('position',[x2 y1 dx dy])
imagesc(flag(xi),[],unity(XC(xi,IN5))')
hold on
axis xy
plot(MXC(IN5),[1:length(find(IN5))],'k+')
Lines(0,[],'k','--',2);
%ylabel('interneurons #','FontSize',16)
xlabel('frequency [Hz]','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off
xlim([-4 4])
%

PrintFig('DVPlotSpect_3',printfig)





%%%%%%%%%%%%%%%%%%%

figure(546);clf;
subplot(2,2,1)
k = MXC(GMXC&PC1);
h(:,1) = histcI(k,bin);
bar(pbin,h(:,1))
hold on
Lines(mean(k),[],[],'--',2);
Lines([],max(h(:,1))*p,'k','--',1);
plot(pbin,cumsum(h(:,1))/sum(h(:,1))*max(h(:,1)),'-','color',[1 1 1]*0.5,'LineWidth',2)
s = sum(h(pbin2,1))/sum(h(:,1))
if s<p2
  %plot(-0.1,max(h(:,1))*1.1,'*','color',[0 0 0])
  plot(0,max(h(:,1))*1.1,'*','color',[0 0 0])
end
axis tight
xlim([-2 2])
ylabel('pyramidal cells #','FontSize',16)
title('dorsal','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off
%
subplot(2,2,2)
k = MXC(GMXC&PC5);
h(:,2) = histcI(k,bin);
bar(pbin,h(:,2))
hold on
Lines(mean(k),[],[],'--',2);
Lines([],max(h(:,2))*p2,'k','--',1);
plot(pbin,cumsum(h(:,2))/sum(h(:,2))*max(h(:,2)),'-','color',[1 1 1]*0.5,'LineWidth',2)
s = sum(h(pbin2,2))/sum(h(:,2))
if s<p2
  %plot(-0.1,max(h(:,2))*1.1,'*','color',[0 0 0])
  plot(0,max(h(:,2))*1.1,'*','color',[0 0 0])
end
axis tight
xlim([-2 2])
title('ventral','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off
%
subplot(2,2,3)
k = MXC(GMXC&IN1);
h(:,3) = histcI(k,bin);
bar(pbin,h(:,3))
hold on
Lines(mean(k),[],[],'--',2);
Lines([],max(h(:,3))*p2,'k','--',1);
plot(pbin,cumsum(h(:,3))/sum(h(:,3))*max(h(:,3)),'-','color',[1 1 1]*0.5,'LineWidth',2)
s = sum(h(pbin2,3))/sum(h(:,3))
if s<p2
  %plot(-0.1,max(h(:,3))*1.1,'*','color',[0 0 0])
  plot(0,max(h(:,3))*1.1,'*','color',[0 0 0])
end
axis tight
xlim([-2 2])
xlabel('frequency [Hz]','FontSize',16)
ylabel('interneurons #','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off
%
subplot(2,2,4)
k = MXC(GMXC&IN5);
h(:,4) = histcI(k,bin);
bar(pbin,h(:,4))
hold on
Lines(mean(k),[],[],'--',2);
Lines([],max(h(:,4))*p2,'k','--',1);
plot(pbin,cumsum(h(:,4))/sum(h(:,4))*max(h(:,4)),'-','color',[1 1 1]*0.5,'LineWidth',2)
s = sum(h(pbin2,4))/sum(h(:,4))
if s<p2
  %plot(-0.1,max(h(:,4))*1.1,'*','color',[0 0 0])
  plot(0,max(h(:,4))*1.1,'*','color',[0 0 0])
end
axis tight
xlim([-2 2])
xlabel('frequency [Hz]','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off


PrintFig('SVMUPlotSpect_4',printfig)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% NUMBERS


tdp = length(find(CatAll.type.num==2 & CatAll.cells.region==1));
sdp = length(find(CatAll.type.num==2 & CatAll.cells.region==1 & CatAll.spect.good));
tdi = length(find(CatAll.type.num==1 & CatAll.cells.region==1));
sdi = length(find(CatAll.type.num==1 & CatAll.cells.region==1 & CatAll.spect.good));

tvp = length(find(CatAll.type.num==2 & CatAll.cells.region==2));
svp = length(find(CatAll.type.num==2 & CatAll.cells.region==2 & CatAll.spect.good));
tvi = length(find(CatAll.type.num==1 & CatAll.cells.region==2));
svi = length(find(CatAll.type.num==1 & CatAll.cells.region==2 & CatAll.spect.good));

st = sdp+sdi+svp+svi;
at = tdp+tdi+tvp+tvi;

fprintf(['\n\n'])
fprintf(['sig/tot dorsal PC ' num2str(sdp) '/' num2str(tdp) '=' num2str(sdp/tdp) '\n'])
fprintf(['sig/tot dorsal IN ' num2str(sdi) '/' num2str(tdi) '=' num2str(sdi/tdi)  '\n'])
fprintf(['sig/tot ventral PC ' num2str(svp) '/' num2str(tvp) '=' num2str(svp/tvp)  '\n'])
fprintf(['sig/tot ventral IN ' num2str(svi) '/' num2str(tvi) '=' num2str(svi/tvi)  '\n'])
fprintf(['sum sig/tot ' num2str(sdp+sdi+svp+svi) '/' num2str(tdp+tdi+tvp+tvi) '=' num2str(st/at) '\n'])


keyboard

return


for m=1:13
  for n=1:size(ALL(m).spect.spunit,2)
    [ALL(m).spect.xcorr(:,n),lags] = xcorr(ALL(m).spect.spunit(:,n),ALL(m).spect.speeg);
  end
end
