function SVMUPlotSpectExplGrp(ALL,varargin)
[arg] = DefaultArgs(varargin,{[]});

GoPrint = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% GROUP
%LF = 2*sqrt(-log(0.01));
LF = 3*sqrt(2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% from L

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Maze/Wheel

%% find good sessions
m=0;
for n=1:16
  if isempty(ALL(n).info)
    continue
  end
  if ALL(n).info.BehNum~=2
    continue;
  end
  m=m+1;
  gsess(m) = n;
end

CatMW = CatStruct(ALL(gsess));

CCM = CatMW.spectM.good' & CatMW.type.num==2 & CatMW.cells.region==1 & CatMW.xcorrlM.std'& abs(CatMW.xcorrlM.goodness)'<0.05;
CCW = CatMW.spectW.good' & CatMW.type.num==2 & CatMW.cells.region==1 & CatMW.xcorrlW.std'& abs(CatMW.xcorrlW.goodness)'<0.05;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Maze
figure(222);clf;
ix = CCM & CatMW.xcorrlM.std'*LF<2500;
xL = CatMW.xcorrlM.std(ix)';
xP = CatMW.spectPhM.maxfu(ix);
xS = CatMW.spectM.maxfu(ix);
%
subplot(241)
hist(xS)
ml = mean(xS);
Lines(ml);
ylabel('Maze')
title(num2str(ml));
%
subplot(242)
hist(xP)
ml = mean(xP);
Lines(ml);
title(num2str(ml));
%
subplot(243)
hist(xL*LF)
ml = mean(xL);
Lines(ml*LF);
title(num2str(ml*LF));
%
subplot(244)
xF = 1-1./(sqrt(2)*pi*xL.*xS/1000);
[h, hx, hy] = hist2([xF 1./xP]);
sh = reshape(smooth(h,10,'lowess'),50,50);
sh = reshape(smooth(sh',10,'lowess'),50,50);
imagesc(hx,hy,sh);
axis xy
hold on
plot([0.5 1.5],[0.5 1.5],'--k','linewidth',2)
%m1 = 1-1/(sqrt(2)*pi*mean(xL)*mean(xS)/1000); m2 = 1./mean(xP);
%m1 = 1-1/(sqrt(2)*pi*median(xL)*median(xS)/1000); m2 = 1./median(xP);
%m1 = mean(xF); m2 = mean(1./xP);
m1 = median(xF); m2 = median(1./xP);
plot(m1,m2,'+k','markersize',10,'linewidth',2)
title([num2str(m1) ' , ' num2str(m2)])
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% wheel
figure(222);
ix = CCW & CatMW.xcorrlW.std'*LF<4000;
xL = CatMW.xcorrlW.std(ix)';
xP = CatMW.spectPhW.maxfu(ix);
xS = CatMW.spectW.maxfu(ix);
%
subplot(245)
hist(xS)
ml = mean(xS);
Lines(ml);
title(num2str(ml));
ylabel('Wheel')
%
subplot(246)
hist(xP)
ml = mean(xP);
Lines(ml);
title(num2str(ml));
%
subplot(247)
hist(xL*LF)
ml = mean(xL);
Lines(ml*LF);
title(num2str(ml*LF));
%
subplot(248)
xF = 1-1./(sqrt(2)*pi*xL.*xS/1000);
[h, hx, hy] = hist2([xF 1./xP]);
sh = reshape(smooth(h,10,'lowess'),50,50);
sh = reshape(smooth(sh',10,'lowess'),50,50);
imagesc(hx,hy,sh);
axis xy
hold on
plot([0.5 1.5],[0.5 1.5],'--k','linewidth',2)
%m1 = 1-1/(sqrt(2)*pi*mean(xL)*mean(xS)/1000); m2 = 1./mean(xP);
%m1 = 1-1/(sqrt(2)*pi*median(xL)*median(xS)/1000); m2 = 1./median(xP);
%m1 = mean(xF); m2 = mean(1./xP);
m1 = median(xF); m2 = median(1./xP);
plot(m1,m2,'+k','markersize',10,'linewidth',2)
title([num2str(m1) ' , ' num2str(m2)])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CA1/CA3
%% find good sessions
m=0;
for n=17:28
  if isempty(ALL(n).info)
    continue
  end
  if ALL(n).info.BehNum~=2
    continue;
  end
  m=m+1;
  gsess(m) = n;
end

CatMW = CatStruct(ALL(gsess));

CC1 = CatMW.spectM.good' & CatMW.type.num==2 & CatMW.cells.region==1 & CatMW.xcorrlM.std'& abs(CatMW.xcorrlM.goodness)'<0.05;
CC3 = CatMW.spectM.good' & CatMW.type.num==2 & CatMW.cells.region==2 & CatMW.xcorrlM.std'& abs(CatMW.xcorrlM.goodness)'<0.05;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Ca1
figure(224);clf;
ix = CC1 & CatMW.xcorrlM.std'*LF<2500;
xL = CatMW.xcorrlM.std(ix)';
xP = CatMW.spectPhM.maxfu(ix);
xS = CatMW.spectM.maxfu(ix);
%
subplot(241)
hist(xS)
ml = mean(xS);
Lines(ml);
ylabel('CA1')
title(num2str(ml));
%
subplot(242)
hist(xP)
ml = mean(xP);
Lines(ml);
title(num2str(ml));
%
subplot(243)
hist(xL*LF)
ml = mean(xL);
Lines(ml*LF);
title(num2str(ml*LF));
%
subplot(244)
xF = 1-1./(sqrt(2)*pi*xL.*xS/1000);
[h, hx, hy] = hist2([xF 1./xP]);
sh = reshape(smooth(h,10,'lowess'),50,50);
sh = reshape(smooth(sh',10,'lowess'),50,50);
imagesc(hx,hy,sh);
axis xy
hold on
plot([0.5 1.5],[0.5 1.5],'--k','linewidth',2)
%m1 = 1-1/(sqrt(2)*pi*mean(xL)*mean(xS)/1000); m2 = 1./mean(xP);
%m1 = 1-1/(sqrt(2)*pi*median(xL)*median(xS)/1000); m2 = 1./median(xP);
%m1 = mean(xF); m2 = mean(1./xP);
m1 = median(xF); m2 = median(1./xP);
plot(m1,m2,'+k','markersize',10,'linewidth',2)
title([num2str(m1) ' , ' num2str(m2)])
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Ca3
figure(224);
ix = CC3 & CatMW.xcorrlM.std'*LF<2500;
xL = CatMW.xcorrlM.std(ix)';
xP = CatMW.spectPhM.maxfu(ix);
xS = CatMW.spectM.maxfu(ix);
%
subplot(245)
hist(xS)
ml = mean(xS);
Lines(ml);
ylabel('CA3')
title(num2str(ml));
%
subplot(246)
hist(xP)
ml = mean(xP);
Lines(ml);
title(num2str(ml));
%
subplot(247)
hist(xL*LF)
ml = mean(xL);
Lines(ml*LF);
title(num2str(ml*LF));
%
subplot(248)
xF = 1-1./(sqrt(2)*pi*xL.*xS/1000);
[h, hx, hy] = hist2([xF 1./xP]);
sh = reshape(smooth(h,10,'lowess'),50,50);
sh = reshape(smooth(sh',10,'lowess'),50,50);
imagesc(hx,hy,sh);
axis xy
hold on
plot([0.5 1.5],[0.5 1.5],'--k','linewidth',2)
%m1 = 1-1/(sqrt(2)*pi*mean(xL)*mean(xS)/1000); m2 = 1./mean(xP);
%m1 = 1-1/(sqrt(2)*pi*median(xL)*median(xS)/1000); m2 = 1./median(xP);
%m1 = mean(xF); m2 = mean(1./xP);
m1 = median(xF); m2 = median(1./xP);
plot(m1,m2,'+k','markersize',10,'linewidth',2)
title([num2str(m1) ' , ' num2str(m2)])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% overall M
m=0;
for n=1:60
  if isempty(ALL(n).info) | isempty(ALL(n).xcorrlM)
    continue
  end
  if ALL(n).info.BehNum~=2
    continue;
  end
  m=m+1;
  gsess(m) = n;
end

CatMW = CatStruct(ALL(gsess));
CatMWw = CatStruct(ALL(gsess(find(gsess<=16))));

CCA = CatMW.spectM.good' & CatMW.type.num==2 & CatMW.cells.region>=1 & CatMW.xcorrlM.std'& abs(CatMW.xcorrlM.goodness)'<0.05;
CCAW = CatMWw.spectW.good' & CatMWw.type.num==2 & CatMWw.cells.region>=1 & CatMWw.xcorrlW.std'& abs(CatMWw.xcorrlW.goodness)'<0.05;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ALL

figure(226);clf;
set(gcf,'position',[1829 364 590 493])
ix = CCA & CatMW.xcorrlM.std'*LF<2500 & CatMW.spectPhM.maxfu>1.0107;
ixw = CCAW & CatMW.xcorrlW.std'*LF<2500 & CatMW.spectPhW.maxfu>1.0107;

%xL = [CatMW.xcorrlM.std(ix)'; CatMWw.xcorrlW.std(ixw)']/1000;
%xP = [CatMW.spectPhM.maxfu(ix); CatMW.spectPhW.maxfu(ixw)];
%xS = [CatMW.spectM.maxfu(ix); CatMW.spectW.maxfu(ixw)];
xL = [CatMW.xcorrlM.std(ix)']/1000;
xP = [CatMW.spectPhM.maxfu(ix)];
xS = [CatMW.spectM.maxfu(ix)];
%
%subplot('position',[0.13 0.58 0.33 0.33])
%subplot(321)
subplot('position',[0.65 0.73 0.28 0.18])
b = [4:0.5:12];
pb = b(1:end-1)+mean(diff(b))/2;
h = histcI(xS,b);
br = bar(pb,h);
set(br,'BarWidth',1);
ml = median(xS);
mean_f_0 = ml
axis tight;
Lines(ml,[],[],'--');
%title(num2str(ml));
ax = get(gca,'XLim');
ay = get(gca,'YLim');
xlabel('frequency f_0 [Hz]','FontSize',16,'position',[mean(ax) ay-diff(ay)*0.42])
ylabel('# of cells','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off
%
%subplot('position',[0.58 0.58 0.33 0.33])
%subplot(323)
subplot('position',[0.65 0.43 0.28 0.18])
b = [0.6:0.05:1.4];
pb = b(1:end-1)+mean(diff(b))/2;
h = histcI(xP,b);
br = bar(pb,h);
set(br,'BarWidth',1);
ml = median(xP);
mean_rel_f_0 = ml
axis tight
Lines(ml,[],[],'--');
%title(num2str(ml));
ax = get(gca,'XLim');
ay = get(gca,'YLim');
xlabel('rel. frequency f_0/f_\theta','FontSize',16,'position',[mean(ax) ay-diff(ay)*0.42])
ylabel('# of cells','FontSize',16)
set(gca,'TickDir','out','FontSize',16,'XTick',[0.4:0.2:1.4])
box off
%
%subplot('position',[0.13 0.11 0.33 0.33])
%subplot(325)
subplot('position',[0.65 0.13 0.28 0.18])
b = [0:200:2500]/1000;
pb = b(1:end-1)+mean(diff(b))/2;
h = histcI(xL*LF,b);
br = bar(pb,h);
set(br,'BarWidth',1);
ml = median(xL);
mean_L = ml*LF
axis tight
Lines(ml*LF,[],[],'--');
%title(num2str(ml*LF));
ax = get(gca,'XLim');
ay = get(gca,'YLim');
xlabel('place field size L [sec]','FontSize',16,'position',[mean(ax) ay-diff(ay)*0.42])
ylabel('# of cells','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off
%
%%%%%%%

%xF = 1-1./(sqrt(2)*pi*xL.*xS);
%xF = 1-1./(LF*xL.*xS)*314/360;
xF = 1-1./(LF*xL.*xS);
hx = [0.75:0.01:1.1];
hy = [0.75:0.01:1.1];
%subplot('position',[0.58 0.11 0.23 0.23])
%subplot('position',[0.58 0.11 0.33 0.33])
%subplot(222)
subplot('position',[0.13 0.13 0.35 0.33])
%[h, hx, hy] = hist2([xF 1./xP]);
hx = [0.75:0.01:1.1];
hy = [0.75:0.01:1.1];
[h] = hist2d([xF 1./xP],hx,hy,[min(hx),max(hx),min(hy),max(hy)]);
sh = reshape(smooth(h,10,'lowess'),length(hy),length(hx));
sh = reshape(smooth(sh',10,'lowess'),length(hx),length(hy));
imagesc(hx,hy,sh');
axis xy
hold on
%plot([0.5 1.5],[0.5 1.5],'--k','linewidth',2)
plot([0.5 1.5],[0.5 1.5],'--','linewidth',2,'Color',[1 1 1]*0.9)
%m1 = 1-1/(sqrt(2)*pi*mean(xL)*mean(xS)/1000); m2 = 1./mean(xP);
%m1 = 1-1/(sqrt(2)*pi*median(xL)*median(xS)/1000); m2 = 1./median(xP);
%m1 = mean(xF); m2 = mean(1./xP);
m1 = median(xF); 
m2 = median(1./xP);
plot(m1,m2,'+k','markersize',10,'linewidth',2)
%title([num2str(m1) ' , ' num2str(m2)])
a=get(gca,'Ylim');
b=get(gca,'Xlim');
xlabel('F(L,f_0)','FontSize',16,'position',[mean(b) a(1)-diff(a)*0.17 mean(a)])
ylabel('f_\theta/f_0','FontSize',16,'position',[b(1)-diff(b)*0.13 mean(a)])
set(gca,'TickDir','out','FontSize',16)
box off
hold off

subplot('position',[0.13 0.13 0.35 0.33])
XX = xP.*(1-1./(LF*xS.*xL))-1;
b = [-0.2:0.02:0.2];
pb = b(1:end-1)+mean(diff(b))/2;
h = histcI(XX,b);
br = bar(pb,h);
axis tight
set(br,'BarWidth',1);
ml = median(XX);
mean_XX = ml
axis tight
Lines(ml,[],[],'--');
a=get(gca,'Ylim');
b=get(gca,'Xlim');
xlabel('f_0/f_\theta(1-1/Lf_0)-1','FontSize',16,'position',[mean(b) a(1)-diff(a)*0.25])
ylabel('# of cells','FontSize',16,'position',[b(1)-diff(b)*0.16 mean(a)])
set(gca,'TickDir','out','FontSize',16,'XTick',[-0.2:0.1:0.2])
box off



%keyboard

%subplot('position',[0.58 0.11 0.33 0.33])
%subplot(224)
subplot('position',[0.13 0.58 0.35 0.33])
%XX = (1-1./xP)*LF.*xL.*xS*360;
XX = (1-1./xP)*LF.*xL.*xS*360;
%keyboard
b = [0:60:720];
pb = b(1:end-1)+mean(diff(b))/2;
h = histcI(XX,b);
br = bar(pb,h);
axis tight
set(br,'BarWidth',1);
ml = median(XX);
mean_XX = ml
axis tight
Lines(ml,[],[],'--');
%title(num2str(ml*LF));
a=get(gca,'Ylim');
b=get(gca,'Xlim');
xlabel('\Delta \Phi [deg]','FontSize',16,'position',[mean(b) a(1)-diff(a)*0.25])
ylabel('count','FontSize',16)
set(gca,'TickDir','out','FontSize',16,'XTick',[0:180:720])
box off

%subplot(224)
%subplot('position',[0.55 0.13 0.35 0.33])
subplot('position',[0.13 0.58 0.35 0.33])

%keyboard

SVMUPlotSpectGrp(ALL)
xlim([-0.2 0.2])
a=get(gca,'Ylim');
b=get(gca,'Xlim');
ylabel('# of sessions','FontSize',16,'position',[b(1)-diff(b)*0.16 mean(a)])
xlabel('f_0/f_\theta(1-c)-1','FontSize',16,'position',[mean(b) a(1)-diff(a)*0.25])


%text(-0.385,19,'A','FontSize',16);
%text(-0.385,11.8,'B','FontSize',16);
%text(-0.385,4.5,'C','FontSize',16);
%text(-0.15,19,'D','FontSize',16);
%text(-0.15,8.1,'E','FontSize',16);

text(-0.15*2.2,8,'A','FontSize',16);
text(-0.15*2.2,-3,'B','FontSize',16);

text(0.12*2,8,'C','FontSize',16);
text(0.12*2,0.6,'D','FontSize',16);
text(0.12*2,-6.5,'E','FontSize',16);

%keyboard

PrintFig(['SpectExplGrp'],0)

PrintFig(['SpectExplGrp2'],GoPrint)


%keyboard
return;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%









idx1=[];
idx3=[];
for n=1:28
  
  idx = [];
  idx = ALL(n)
  idx = idx & ismember(ALL(n).compr.cellids(1,:),find(ALL(n).spectM.good)) & ismember(ALL(n).compr.cellids(2,:),find(ALL(n).spectM.good)); 
  idx1 = [idx1; find(idx & abs(ALL(n).compr.runt)<1000 & abs(ALL(n).compr.theta)<100)']; 
  
  idx = [];
  idx = ALL(n).compr.region1==3 & ALL(n).compr.region2==3;
  idx = idx & ismember(ALL(n).compr.cellids(1,:),find(ALL(n).spectM.good)) & ismember(ALL(n).compr.cellids(2,:),find(ALL(n).spectM.good)); 
  idx3 = [idx3; find(idx & abs(ALL(n).compr.runt)<1000 & abs(ALL(n).compr.theta)<100)'];
end



figure(766);clf
%
subplot(241)
hist(CatAll.spect.maxfu(gCA1))
Lines(mean(CatAll.spect.maxfu(gCA1)));
title(num2str(mean(CatAll.spect.maxfu(gCA1))))
axis tight
%
subplot(243)
plot(CatAll.compr.runt(idx1),CatAll.compr.theta(idx1),'.')
[b1] = robustfit(CatAll.compr.runt(idx1),CatAll.compr.theta(idx1));
hold on
plot([-1000 1000],b1(1)+b1(2)*[-1000 1000],'r')
title(num2str(b1(2)))
axis tight
%
subplot(244)
hist(CatAll.xcorrlM.std(gCA1)*LF)
Lines(median(CatAll.xcorrlM.std(gCA1)*LF));
title(num2str(median(CatAll.xcorrlM.std(gCA1)*LF)))
axis tight
%
subplot(242)
mf0=1000/(sqrt(2)*pi*b(2)*mean(CatAll.xcorrlM.std(gCA1)))
f0 = 1000./(sqrt(2)*pi*b(2)*(CatAll.xcorrlM.std(gCA1)));
hist(f0,20);
Lines(mf0);
title(num2str(mf0))
axis tight
%%%
%%%
subplot(245)
hist(CatAll.spect.maxfu(gCA3))
Lines(mean(CatAll.spect.maxfu(gCA3)));
title(num2str(mean(CatAll.spect.maxfu(gCA3))))
axis tight
%
subplot(247)
plot(CatAll.compr.runt(idx3),CatAll.compr.theta(idx3),'.')
[b] = robustfit(CatAll.compr.runt(idx3),CatAll.compr.theta(idx3));
hold on
plot([-1000 1000],b(1)+b(2)*[-1000 1000],'r')
title(num2str(b(2)))
axis tight
%
subplot(248)
hist(CatAll.xcorrlM.std(gCA3)*LF)
Lines(median(CatAll.xcorrlM.std(gCA3)*LF));
title(num2str(median(CatAll.xcorrlM.std(gCA3)*LF)))
axis tight
%
subplot(246)
mf0=1000/(sqrt(2)*pi*b(2)*mean(CatAll.xcorrlM.std(gCA3)))
f0 = 1000./(sqrt(2)*pi*b(2)*(CatAll.xcorrlM.std(gCA3)));
hist(f0,20);
Lines(mf0);
title(num2str(mf0))
axis tight




return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CA1/CA3

CatAll = CatStruct(ALL(19:28));

gCA1 = CatAll.spectM.good' & CatAll.type.num==2 & CatAll.cells.region==1 & CatAll.xcorrlM.std'& abs(CatAll.xcorrlM.goodness)'<0.1;
gCA3 = CatAll.spectM.good' & CatAll.type.num==2 & CatAll.cells.region==2 & CatAll.xcorrlM.std'& abs(CatAll.xcorrlM.goodness)'<0.1;

idx1=[];
idx3=[];
for n=19:28
  idx = [];
  idx = ALL(n).compr.region1==1 & ALL(n).compr.region2==1;
  idx = idx & ismember(ALL(n).compr.cellids(1,:),find(ALL(n).spectM.good)) & ismember(ALL(n).compr.cellids(2,:),find(ALL(n).spectM.good)); 
  idx1 = [idx1; find(idx & abs(ALL(n).compr.runt)<1000 & abs(ALL(n).compr.theta)<100)']; 
  
  idx = [];
  idx = ALL(n).compr.region1==3 & ALL(n).compr.region2==3;
  idx = idx & ismember(ALL(n).compr.cellids(1,:),find(ALL(n).spectM.good)) & ismember(ALL(n).compr.cellids(2,:),find(ALL(n).spectM.good)); 
  idx3 = [idx3; find(idx & abs(ALL(n).compr.runt)<1000 & abs(ALL(n).compr.theta)<100)'];
end

figure(765);clf;
%
subplot(241)
hist(CatAll.spect.maxfu(gCA1))
Lines(mean(CatAll.spect.maxfu(gCA1)));
title(num2str(mean(CatAll.spect.maxfu(gCA1))))
axis tight
%
subplot(243)
plot(CatAll.compr.runt(idx1),CatAll.compr.theta(idx1),'.')
[b1] = robustfit(CatAll.compr.runt(idx1),CatAll.compr.theta(idx1));
hold on
plot([-1000 1000],b1(1)+b1(2)*[-1000 1000],'r')
title(num2str(b1(2)))
axis tight
%
subplot(244)
hist(CatAll.xcorrlM.std(gCA1)*LF)
Lines(mean(CatAll.xcorrlM.std(gCA1)*LF));
title(num2str(median(CatAll.xcorrlM.std(gCA1)*LF)))
axis tight
%
subplot(242)
mf0=1000/(sqrt(2)*pi*b1(2)*mean(CatAll.xcorrlM.std(gCA1)))
f0 = 1000./(sqrt(2)*pi*b1(2)*(CatAll.xcorrlM.std(gCA1)));
hist(f0,20);
Lines(mf0);
title(num2str(mf0))
axis tight
%%%
%%%
subplot(245)
hist(CatAll.spect.maxfu(gCA3))
Lines(mean(CatAll.spect.maxfu(gCA3)));
title(num2str(mean(CatAll.spect.maxfu(gCA3))))
axis tight
%
subplot(247)
plot(CatAll.compr.runt(idx3),CatAll.compr.theta(idx3),'.')
[b3] = robustfit(CatAll.compr.runt(idx3),CatAll.compr.theta(idx3));
hold on
plot([-1000 1000],b3(1)+b3(2)*[-1000 1000],'r')
title(num2str(b3(2)))
axis tight
%
subplot(248)
hist(CatAll.xcorrlM.std(gCA3)*LF)
Lines(median(CatAll.xcorrlM.std(gCA3)*LF));
title(num2str(median(CatAll.xcorrlM.std(gCA3)*LF)))
axis tight
%
subplot(246)
mf0=1000/(sqrt(2)*pi*b3(2)*mean(CatAll.xcorrlM.std(gCA3)))
f0 = 1000./(sqrt(2)*pi*b3(2)*(CatAll.xcorrlM.std(gCA3)));
hist(f0,20);
Lines(mf0);
title(num2str(mf0))
axis tight

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
return

