function DVPlotSpect(CatAll,varargin)
[printfig] = DefaultArgs(varargin,{0});

  
F = CatAll.spect.f(:,1);
fg = find(F>=5 & F<=10);
fg2 = find(F>=5 & F<=12);
  

SP = CatAll.spect.spunit;
Spect = CatAll.spect;

newpc = CheckPCIN(CatAll,0,'DorsalVentral_NewPC.mat');
CatAll.type.num = newpc+1;

PC1 = (CatAll.type.num==2 & CatAll.cells.region==1 & CatAll.spect.good)';
IN1 = (CatAll.type.num==1 & CatAll.cells.region==1 & CatAll.spect.good)';

PC5 = (CatAll.type.num==2 & CatAll.cells.region==5 & CatAll.spect.good)';
IN5 = (CatAll.type.num==1 & CatAll.cells.region==5 & CatAll.spect.good)';



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

PrintFig('DVPlotSpect_1',printfig)




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

PrintFig('DVPlotSpect_2',printfig)





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


PrintFig('DVPlotSpect_4',printfig)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% NUMBERS


tdp = length(find(CatAll.type.num==2 & CatAll.cells.region==1));
sdp = length(find(CatAll.type.num==2 & CatAll.cells.region==1 & CatAll.spect.good));
tdi = length(find(CatAll.type.num==1 & CatAll.cells.region==1));
sdi = length(find(CatAll.type.num==1 & CatAll.cells.region==1 & CatAll.spect.good));

tvp = length(find(CatAll.type.num==2 & CatAll.cells.region==5));
svp = length(find(CatAll.type.num==2 & CatAll.cells.region==5 & CatAll.spect.good));
tvi = length(find(CatAll.type.num==1 & CatAll.cells.region==5));
svi = length(find(CatAll.type.num==1 & CatAll.cells.region==5 & CatAll.spect.good));

st = sdp+sdi+svp+svi;
at = tdp+tdi+tvp+tvi;

fprintf(['\n\n'])
fprintf(['sig/tot dorsal PC ' num2str(sdp) '/' num2str(tdp) '=' num2str(sdp/tdp) '\n'])
fprintf(['sig/tot dorsal IN ' num2str(sdi) '/' num2str(tdi) '=' num2str(sdi/tdi)  '\n'])
fprintf(['sig/tot ventral PC ' num2str(svp) '/' num2str(tvp) '=' num2str(svp/tvp)  '\n'])
fprintf(['sig/tot ventral IN ' num2str(svi) '/' num2str(tvi) '=' num2str(svi/tvi)  '\n'])
fprintf(['sum sig/tot ' num2str(sdp+sdi+svp+svi) '/' num2str(tdp+tdi+tvp+tvi) '=' num2str(st/at) '\n'])


return


for m=1:13
  for n=1:size(ALL(m).spect.spunit,2)
    [ALL(m).spect.xcorr(:,n),lags] = xcorr(ALL(m).spect.spunit(:,n),ALL(m).spect.speeg);
  end
end
