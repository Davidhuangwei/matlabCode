function DVPlotSpectPh(CatAll,varargin)
[printfig] = DefaultArgs(varargin,{0});

F = CatAll.spectPh.f(:,1);
fg = find(F>0.6 & F<1.4);

SP = CatAll.spectPh.spunit;
Spect = CatAll.spectPh;

newpc = CheckPCIN(CatAll,0,'DorsalVentral_NewPC.mat');
CatAll.type.num = newpc+1;

PC1 = (CatAll.type.num==2 & CatAll.cells.region==1 & CatAll.spect.good)';
IN1 = (CatAll.type.num==1 & CatAll.cells.region==1 & CatAll.spect.good)';

PC5 = (CatAll.type.num==2 & CatAll.cells.region==5 & CatAll.spect.good)';
IN5 = (CatAll.type.num==1 & CatAll.cells.region==5 & CatAll.spect.good)';


%% max of spect
[mf mi] = max(SP(fg,:));
MF = F(fg(mi));


%%%%%%%%%%%%%%%%%%%%%%%
pbin = F';%[1:40]*mean(diff(F));
bin = [pbin pbin(end)+mean(diff(F))]-mean(diff(F))/2;
p = 0.2;

dx = 0.35;
dy = 0.25;
x1 = 0.15;
x2 = 0.56;
y1 = 0.15;
y2 = 0.55;


figure(5432);clf;
%subplot(2,2,1)
subplot('position',[x1 y2+dy dx 0.1])
k = MF(PC1);
h(:,1) = histcI(k,bin);
bar(pbin,h(:,1))
axis tight
xlim([0.4 1.8])
title('dorsal','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off;axis off;
%%
subplot('position',[x1 y2 dx dy])
[sm xm] = sort(MF(PC1)); spc = find(PC1);
%imagesc(F,[],unity(SP(:,PC1))')
imagesc(F,[],unity(SP(:,spc(xm)))')
hold on
%plot(MF(PC1),[1:length(find(PC1))],'k+')
plot(sm,[1:length(find(PC1))],'k+')
axis xy
xlim([0.4 1.8])
Lines(1,[],'k','--',2);
ylabel('pyramidal cells #','FontSize',16)
set(gca,'TickDir','out','FontSize',16,'XTickLabel',[])
box off
%%%%%%%
%subplot(2,2,2)
subplot('position',[x2 y2+dy dx 0.1])
k = MF(PC5);
h(:,1) = histcI(k,bin);
bar(pbin,h(:,1))
axis tight
xlim([0.4 1.8])
title('ventral','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off;axis off;
%%
subplot('position',[x2 y2 dx dy])
[sm xm] = sort(MF(PC5)); spc = find(PC5);
imagesc(F,[],unity(SP(:,spc(xm)))')
hold on
plot(sm,[1:length(find(PC5))],'k+')
axis xy
xlim([0.4 1.8])
Lines(1,[],'k','--',2);
set(gca,'TickDir','out','FontSize',16,'XTickLabel',[])
box off
%%%%%%%
%subplot(2,2,3)
subplot('position',[x1 y1+dy dx 0.1])
k = MF(IN1);
h(:,1) = histcI(k,bin);
bar(pbin,h(:,1))
axis tight
xlim([0.4 1.8])
set(gca,'TickDir','out','FontSize',16)
box off;axis off;
%%
subplot('position',[x1 y1 dx dy])
[sm xm] = sort(MF(IN1)); spc = find(IN1);
imagesc(F,[],unity(SP(:,spc(xm)))')
hold on
plot(sm,[1:length(find(IN1))],'k+')
axis xy
xlim([0.4 1.8])
Lines(1,[],'k','--',2);
xlabel('rel. frequency','FontSize',16)
ylabel('interneurons #','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off
%%%%%%%
%subplot(2,2,4)
subplot('position',[x2 y1+dy dx 0.1])
k = MF(IN5);
h(:,1) = histcI(k,bin);
bar(pbin,h(:,1))
axis tight
xlim([0.4 1.8])
set(gca,'TickDir','out','FontSize',16)
box off;axis off;
%%
subplot('position',[x2 y1 dx dy])
[sm xm] = sort(MF(IN5)); spc = find(IN5);
imagesc(F,[],unity(SP(:,spc(xm)))')
hold on
plot(sm,[1:length(find(IN5))],'k+')
axis xy
xlim([0.4 1.8])
Lines(1,[],'k','--',2);
xlabel('rel. frequency','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off
%%%%%%%
PrintFig('DVPlotSpectPh_1',printfig)


%%%%%%%%%%%%%%%%%%%

cf = 1.015;
gbin = find(pbin<=cf);

figure(5462);clf;
subplot(2,2,1)
k = MF(PC1);
h(:,1) = histcI(k,bin);
bar(pbin,h(:,1))
hold on
Lines(mean(k),[],[],'--',2);
Lines([],max(h(:,1))*p,'k','--',1);
plot(pbin,cumsum(h(:,1))/sum(h(:,1))*max(h(:,1)),'-','color',[1 1 1]*0.5,'LineWidth',2)
s(1) = 1-length(find(k>cf))/length(k);
if s(1)<=p
  %plot(-0.1,max(h(:,1))*1.1,'*','color',[0 0 0])
  plot(1,max(h(:,1))*1,'*','color',[0 0 0])
end
axis tight
xlim([0.5 1.5])
ylabel('pyramidal cells #','FontSize',16)
title('dorsal','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off
%%%%%%%
subplot(2,2,2)
k = MF(PC5);
h(:,2) = histcI(k,bin);
bar(pbin,h(:,2))
hold on
Lines(mean(k),[],[],'--',2);
Lines([],max(h(:,2))*p,'k','--',1);
plot(pbin,cumsum(h(:,2))/sum(h(:,2))*max(h(:,2)),'-','color',[1 1 1]*0.5,'LineWidth',2)
s(2) = 1-length(find(k>cf))/length(k);
if s(2)<=p
  %plot(-0.1,max(h(:,1))*1.1,'*','color',[0 0 0])
  plot(1,max(h(:,2))*1,'*','color',[0 0 0])
end
axis tight
xlim([0.5 1.5])
title('ventral','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off
%%%%%%%
subplot(2,2,3)
k = MF(IN1);
h(:,3) = histcI(k,bin);
bar(pbin,h(:,3))
hold on
Lines(mean(k),[],[],'--',2);
Lines([],max(h(:,3))*p,'k','--',1);
plot(pbin,cumsum(h(:,3))/sum(h(:,3))*max(h(:,3)),'-','color',[1 1 1]*0.5,'LineWidth',2)
s(3) = 1-length(find(k>cf))/length(k);
if s(3)<=p
  %plot(-0.1,max(h(:,1))*1.1,'*','color',[0 0 0])
  plot(1,max(h(:,3))*1.1,'*','color',[0 0 0])
end
axis tight
xlim([0.5 1.5])
xlabel('rel. frequency','FontSize',16)
ylabel('interneurons #','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off
%%%%%%%
subplot(2,2,4)
k = MF(IN5);
h(:,4) = histcI(k,bin);
bar(pbin,h(:,4))
hold on
Lines(mean(k),[],[],'--',2);
Lines([],max(h(:,4))*p,'k','--',1);
plot(pbin,cumsum(h(:,4))/sum(h(:,4))*max(h(:,4)),'-','color',[1 1 1]*0.5,'LineWidth',2)
s(4) = 1-length(find(k>cf))/length(k)
if s(4)<=p
  %plot(-0.1,max(h(:,1))*1.1,'*','color',[0 0 0])
  plot(1,max(h(:,4))*1.1,'*','color',[0 0 0])
end
axis tight
xlim([0.5 1.5])
xlabel('rel. frequency','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off

%%%%%%
PrintFig('DVPlotSpectPh_2',printfig)

fprintf(['\n\n'])

n1 = length(find(MF(PC1)>cf));
n2 = length(find(PC1));
fprintf(['dorsal PC ' num2str(n1) '/' num2str(n2) '=' num2str(n1/n2) '\n'])

n1 = length(find(MF(PC5)>cf));
n2 = length(find(PC5));
fprintf(['ventral PC ' num2str(n1) '/' num2str(n2) '=' num2str(n1/n2) '\n'])

n1 = length(find(MF(IN1)>cf));
n2 = length(find(IN1));
fprintf(['dorsal IN ' num2str(n1) '/' num2str(n2) '=' num2str(n1/n2) '\n'])

n1 = length(find(MF(IN5)>cf));
n2 = length(find(IN5));
fprintf(['ventral IN ' num2str(n1) '/' num2str(n2) '=' num2str(n1/n2) '\n'])




return



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
fprintf(['sig/tot ventral PC ' num2str(svi) '/' num2str(tvi) '=' num2str(svi/tvi)  '\n'])
fprintf(['sum sig/tot ' num2str(sdp+sdi+svp+svi) '/' num2str(tdp+tdi+tvp+tvi) '=' num2str(st/at) '\n'])





return


for m=1:13
  for n=1:size(ALL(m).spect.spunit,2)
    [ALL(m).spect.xcorr(:,n),lags] = xcorr(ALL(m).spect.spunit(:,n),ALL(m).spect.speeg);
  end
end
