function SVMUPlotSpectExpl(ALL,varargin)
[arg] = DefaultArgs(varargin,{[]});

GoPrint = 0;

%%% maze and wheel
CatMW = CatStruct(ALL(1:5));
cmw = 4;
cmw = 4;
%cmw = arg;

ExW = ALL(cmw).spectW;
ExM = ALL(cmw).spectM;

%%% CA1/CA3
CatCA = CatStruct(ALL(17:28));
%if isempty(arg)
  cca = 22; %%??
  %cca = [19:28];
%else
%  cca = arg;
%end
CA = ALL(cca).spectM;

%% Place Field Size Factor
LF = 2*sqrt(-log(0.1));

%%%%%%%%%%%%%%%%%%%%%%%
figure(654);clf

%% Maze
%good = find(ExM.good'&ALL(cmw).type.num==2);
good = find(ExM.good'&ALL(cmw).type.num==2 & ALL(cmw).xcorrlM.std'& abs(ALL(cmw).xcorrlM.goodness)'<0.05);

subplot('position',[0.1 0.85 0.15 0.1])
f = ExM.f;
fg = find(f>=5 & f<=10);
[mmh mih] = max(ExM.spunit(fg,good));
[smh sih] = sort(mih);
bb = f(1:2:end);
hh = histcI(f(fg(mih)),bb);
b1 = bar(bb(1:end-1)+mean(diff(bb))/2,hh);
%set(bi,'width',1)
axis tight
xlim([4 12])
axis off
%%
subplot('position',[0.1 0.6 0.15 0.25])
imagesc(ExM.f,[],unity(ExM.spunit(:,good(sih)))')
hold on
plot(ExM.f,ExM.speeg/max(ExM.speeg)*length(good),'color',[1 1 1]*0,'LineWidth',2)
axis xy
xlim([4 12])
[mm mi] = max(ExM.speeg(:,1));
Lines(ExM.f(mi),[],[1 1 1]*0.5,'--',2);
Lines(mean(f(fg(mih))),[],[1 1 1]*0,'--',2);
fprintf(['\n mean f_0 ' num2str(mean(f(fg(mih)))) '\n'])
fprintf([' mean f_e ' num2str(ExM.feeg) '\n'])
xlabel('frequency [Hz]','FontSize',16)
ylabel('cells #','FontSize',16)
%set(gca,'TickDir','out','XTickLabel',[],'FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off

%% rel. freqeuncy
subplot('position',[0.3 0.6 0.15 0.25])
fph = ALL(cmw).spectPhM.f;
fgph = find(fph>=0.5 & fph<=1.5);
%imagesc(ALL(cmw).spectPhM.f,[],unity(ALL(cmw).spectPhM.spunit(:,good(sih)))')
%hold on
[mph iph] = max(ALL(cmw).spectPhM.spunit(fgph,good(sih)));
%plot(fph(fgph(iph)),[1:length(mph)],'.k')
bbph = fph(1:1:end);
hhph = histcI(fph(fgph(iph)),bbph);
bph1 = bar(bbph(1:end-1)+mean(diff(bbph))/2,hhph);
mrph = mean(fph(fgph(iph)));
mrphM = fph(fgph(iph));
axis tight
xlim([0.5 1.5])
Lines(1,[],[1 1 1]*0.5,'--',2);
Lines(mrph,[],[1 1 1]*0,'--',2);
xlabel('rel. frequency','FontSize',16)
ylabel('count','FontSize',16)
ax = get(gca,'YLim');
rmrph = round(mrph*100)/100;
title(['f_0/f_{\Theta}=' num2str(rmrph) ],'FontSize',16,'position',[1 ax(2)*0.95])
set(gca,'TickDir','out','FontSize',16)
box off

%% Sequence Compression
subplot('position',[0.525 0.6 0.15 0.25])
CMP = ALL(cmw).compr;
gg = find(CMP.Mrunt>-500 & CMP.Mrunt<500);
plot(CMP.Mrunt(gg),CMP.Mtheta(gg),'o','markersize',5,'markeredgecolor',[1 1 1]*0.5,'markerfacecolor',[1 1 1]*0.5) 
axis tight
rob = robustfit(CMP.Mrunt(gg),CMP.Mtheta(gg));
Mcmf = [CMP.Mrunt(gg)',CMP.Mtheta(gg)'];
[rRC pRC] = RankCorrelation(CMP.Mrunt,CMP.Mtheta);
x = [-1000 1000];
hold on
plot(x,rob(1)+rob(2)*x,'r--')
a = round(rob(2)*1000)/1000;
ax = get(gca,'YLim');
bx = get(gca,'XLim');
title(['slope=' num2str(a)],'FontSize',16,'position',[mean(bx) ax(2)])
xlabel('distance [cm]','FontSize',16)
ylabel('\tau_{\Theta} [ms]','FontSize',16,'position',[bx(1)-diff(bx)*0.2 mean(ax)])
set(gca,'TickDir','out','FontSize',16)
box off


%% Place Field Size
subplot('position',[0.75 0.6 0.15 0.25])
gg = ExM.good'&ALL(cmw).type.num==2 & ALL(cmw).xcorrlM.std'& abs(ALL(cmw).xcorrlM.goodness)'<0.05;
binlf = [0:0.2:3];
hlf = histcI(ALL(cmw).xcorrlM.std(gg)*LF/1000,binlf);
bar(binlf(1:end-1)+mean(diff(binlf))/2,hlf);
axis tight
box off
ml = median(ALL(cmw).xcorrlM.std(gg)*LF)/1000;
Lines(ml);
ml = round(ml*100)/100;
ax = get(gca,'YLim');
bx = get(gca,'XLim');
title(['L=' num2str(ml) 's'],'FontSize',16,'position',[mean(bx) ax(2)])
xlabel('time [sec]','FontSize',16)
ylabel('count','FontSize',16)
set(gca,'TickDir','out','FontSize',16,'XTick',[0:1:3])

f0=LF/(sqrt(2)*pi*a*ml)
f0fe=1./(1-a) 

%%%%%%%%%%%%%%%%%
%% Wheel
%good = find(ExW.good'&ALL(cmw).type.num==2);
good = find(ExW.good'&ALL(cmw).type.num==2 & ALL(cmw).xcorrlW.std'& abs(ALL(cmw).xcorrlW.goodness)'<0.1 & ALL(cmw).xcorrlW.std'*LF<=2500);

subplot('position',[0.1 0.4 0.15 0.1])
f = ExW.f;
fg = find(f>=5 & f<=10);
[mmh mih] = max(ExW.spunit(fg,good));
[smh sih] = sort(mih);
hh = histcI(f(fg(mih)),bb);
b1 = bar(bb(1:end-1)+mean(diff(bb))/2,hh);
axis tight
xlim([4 12])
axis off

subplot('position',[0.1 0.15 0.15 0.25])
imagesc(ExW.f,[],unity(ExW.spunit(:,good(sih)))')
hold on
plot(ExW.f,ExW.speeg/max(ExW.speeg)*length(good),'color',[1 1 1]*0,'LineWidth',2)
axis xy
xlim([4 12])
[mm mi] = max(ExW.speeg(:,1));
Lines(ExW.f(mi),[],[1 1 1]*0.5,'--',2);
Lines(mean(f(fg(mih))),[],[1 1 1]*0,'--',2);
fprintf(['\n mean f_0 ' num2str(mean(f(fg(mih)))) '\n'])
fprintf([' mean f_e ' num2str(ExW.feeg) '\n'])
xlabel('frequency [Hz]','FontSize',16)
ylabel('cells #','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off

%% rel. freqeuncy
subplot('position',[0.3 0.15 0.15 0.25])
fph = ALL(cmw).spectPhW.f;
fgph = find(fph>=0.5 & fph<=1.5);
%imagesc(ALL(cmw).spectPhW.f,[],unity(ALL(cmw).spectPhW.spunit(:,good(sih)))')
%hold on
[mph iph] = max(ALL(cmw).spectPhW.spunit(fgph,good(sih)));
%plot(fph(fgph(iph)),[1:length(mph)],'.k')
bbph = fph(1:1:end);
hhph = histcI(fph(fgph(iph)),bbph);
bph1 = bar(bbph(1:end-1)+mean(diff(bbph))/2,hhph);
mrph = mean(fph(fgph(iph)));
mrphW = fph(fgph(iph));
axis tight
xlim([0.5 1.5])
Lines(1,[],[1 1 1]*0.5,'--',2);
Lines(mrph,[],[1 1 1]*0,'--',2);
xlabel('rel. frequency','FontSize',16)
ylabel('count','FontSize',16)
ax = get(gca,'YLim');
rmrph = round(mrph*100)/100;
title(['f_0/f_{\Theta}=' num2str(rmrph) ],'FontSize',16,'position',[1 ax(2)*0.95])
set(gca,'TickDir','out','FontSize',16)
box off

%% Sequence Compression
subplot('position',[0.525 0.15 0.15 0.25])
CMP = ALL(cmw).compr;
plot(CMP.Trunt,CMP.Ttheta,'o','markersize',5,'markeredgecolor',[1 1 1]*0.5,'markerfacecolor',[1 1 1]*0.5) 
axis tight
rob = robustfit(CMP.Trunt,CMP.Ttheta);
[rRC pRC] = RankCorrelation(CMP.Trunt,CMP.Ttheta);
Wcmf = [CMP.Trunt,CMP.Ttheta];
x = [-1000 1000];
hold on
plot(x,rob(1)+rob(2)*x,'r--')
a = round(rob(2)*1000)/1000;
ax = get(gca,'YLim');
bx = get(gca,'XLim');
title(['slope=' num2str(a)],'FontSize',16,'position',[mean(bx) ax(2)])
xlabel('distance [cm]','FontSize',16)
ylabel('\tau_{\Theta} [ms]','FontSize',16,'position',[bx(1)-diff(bx)*0.2 mean(ax)])
set(gca,'TickDir','out','FontSize',16)
box off


%% Place Field Size
subplot('position',[0.75 0.15 0.15 0.25])
gg = ExW.good'&ALL(cmw).type.num==2 & ALL(cmw).xcorrlW.std'& abs(ALL(cmw).xcorrlW.goodness)'<0.05 & ALL(cmw).xcorrlW.std'*LF<=2500;
binlf = [0:0.2:3];
hlf = histcI(ALL(cmw).xcorrlW.std(gg)*LF/1000,binlf);
bar(binlf(1:end-1)+mean(diff(binlf))/2,hlf);
axis tight
box off
%ml = median(ALL(cmw).xcorrlW.std(gg)*LF)/1000;
ml = median(ALL(cmw).xcorrlW.std(gg)*LF)/1000;
Lines(ml);
ml = round(ml*100)/100;
ax = get(gca,'YLim');
bx = get(gca,'XLim');
title(['L=' num2str(ml) 's'],'FontSize',16,'position',[mean(bx) ax(2)])
xlabel('time [sec]','FontSize',16)
ylabel('count','FontSize',16)
set(gca,'TickDir','out','FontSize',16,'XTick',[0:1:3])

f0=LF/(sqrt(2)*pi*a*ml)
f0fe=1./(1-a) 

%text(-14,ax(2)*2.9,'C','FontSize',16)
text(-14,ax(2)*3.1,'C','FontSize',16)
text(-14,ax(2)*1.3,'D','FontSize',16)


PrintFig([ALL(cmw).info.FileBase '.cmp1'],GoPrint)


%%%%%%%%%%%%%%%%%%%%%%%
%%% CA1 -- CA3
%%%%%%%%%%%%%%%%%%%%%%%
figure(653);clf

%% CA1
good = find(CA.good' & ALL(cca).type.num==2 & ALL(cca).cells.region==1 & ALL(cca).xcorrlM.std'& abs(ALL(cca).xcorrlM.goodness)'<0.05);

subplot('position',[0.1 0.85 0.15 0.1])
f = CA.f;
fg = find(f>=5 & f<=10);
[mmh mih] = max(CA.spunit(fg,good));
[smh sih] = sort(mih);
bb = f(1:2:end);
hh = histcI(f(fg(mih)),bb);
b1 = bar(bb(1:end-1)+mean(diff(bb))/2,hh);
%set(bi,'width',1)
axis tight
xlim([4 12])
axis off

subplot('position',[0.1 0.6 0.15 0.25])
imagesc(CA.f,[],unity(CA.spunit(:,good(sih)))')
hold on
plot(CA.f,CA.speeg/max(CA.speeg)*length(good),'color',[1 1 1]*0,'LineWidth',2)
axis xy
xlim([4 12])
[mm mi] = max(CA.speeg(:,1));
Lines(CA.f(mi),[],[1 1 1]*0.5,'--',2);
Feeg = CA.f(mi);
Lines(mean(f(fg(mih))),[],[1 1 1]*0,'--',2);
fprintf(['\n mean f_0 ' num2str(mean(f(fg(mih)))) '\n'])
fprintf([' mean f_e ' num2str(CA.feeg) '\n'])
xlabel('frequency [Hz]','FontSize',16)
ylabel('cells #','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off

%% rel. freqeuncy
subplot('position',[0.3 0.6 0.15 0.25])
fph = ALL(cca).spectPhM.f;
fgph = find(fph>=0.5 & fph<=1.5);
%imagesc(ALL(cca).spectPhM.f,[],unity(ALL(cca).spectPhM.spunit(:,good(sih)))')
%hold on
[mph iph] = max(ALL(cca).spectPhM.spunit(fgph,good(sih)));
%plot(fph(fgph(iph)),[1:length(mph)],'.k')
bbph = fph(1:1:end);
hhph = histcI(fph(fgph(iph)),bbph);
bph1 = bar(bbph(1:end-1)+mean(diff(bbph))/2,hhph);
mrph = round(mean(fph(fgph(iph)))*1000)/1000;
axis tight
xlim([0.5 1.5])
Lines(1,[],[1 1 1]*0.5,'--',2);
Lines(mrph,[],[1 1 1]*0,'--',2);
xlabel('rel. frequency','FontSize',16)
ylabel('count','FontSize',16)
ax = get(gca,'YLim');
rmrph = round(mrph*100)/100;
title(['f_0/f_{\Theta}=' num2str(rmrph) ],'FontSize',16,'position',[1 ax(2)*0.95])
set(gca,'TickDir','out','FontSize',16)
box off


%% Sequence Compression
subplot('position',[0.525 0.6 0.15 0.25])
CMP = ALL(cca).compr;
idx = find(CMP.region1==1 & CMP.region2==1 & ismember(CMP.cellids(1,:),find(CA.good)) & ismember(CMP.cellids(2,:),find(CA.good)));
plot(CMP.runt(idx),CMP.theta(idx),'o','markersize',5,'markeredgecolor',[1 1 1]*0.5,'markerfacecolor',[1 1 1]*0.5) 
axis tight
rob = robustfit(CMP.runt(idx),CMP.theta(idx));
[rRC pRC] = RankCorrelation(CMP.runt(idx),CMP.theta(idx));
x = [-1000 1000];
hold on
plot(x,rob(1)+rob(2)*x,'r--')
a = round(rob(2)*1000)/1000;
ax = get(gca,'YLim');
bx = get(gca,'XLim');
title(['slope=' num2str(a)],'FontSize',16,'position',[mean(bx) ax(2)])
xlabel('time [ms]','FontSize',16)
ylabel('\tau_{\Theta} [ms]','FontSize',16,'position',[bx(1)-diff(bx)*0.2 mean(ax)])
set(gca,'TickDir','out','FontSize',16)
box off


%% Place Field Size
subplot('position',[0.75 0.6 0.15 0.25])
gg = find(CA.good' & ALL(cca).type.num==2 & ALL(cca).cells.region==1 & ALL(cca).xcorrlM.std'& abs(ALL(cca).xcorrlM.goodness)'<0.05);
binlf = [0:0.2:3];
hlf = histcI(ALL(cca).xcorrlM.std(gg)*LF/1000,binlf);
bar(binlf(1:end-1)+mean(diff(binlf))/2,hlf);
axis tight
box off
ml = median(ALL(cca).xcorrlM.std(gg)*LF)/1000;
Lines(median(ALL(cca).xcorrlM.std(gg)*LF)/1000);
ml = round(ml*100)/100;
ax = get(gca,'YLim');
bx = get(gca,'XLim');
title(['L=' num2str(ml) 's'],'FontSize',16,'position',[mean(bx) ax(2)])
xlabel('time [sec]','FontSize',16)
ylabel('count','FontSize',16)
set(gca,'TickDir','out','FontSize',16,'XTick',[0:1:3])


f0=LF/(sqrt(2)*pi*a*ml)
f0fe=1./(1-a) 


%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%
%% CA3
good = find(CA.good' & ALL(cca).type.num==2 & ALL(cca).cells.region==2 & ALL(cca).xcorrlM.std'& abs(ALL(cca).xcorrlM.goodness)'<0.05);

subplot('position',[0.1 0.4 0.15 0.1])
f = CA.f;
fg = find(f>=5 & f<=10);
[mmh mih] = max(CA.spunit(fg,good));
[smh sih] = sort(mih);
hh = histcI(f(fg(mih)),bb);
b1 = bar(bb(1:end-1)+mean(diff(bb))/2,hh);
axis tight
xlim([4 12])
axis off

subplot('position',[0.1 0.15 0.15 0.25])
imagesc(CA.f,[],unity(CA.spunit(:,good(sih)))')
hold on
plot(CA.f,CA.speeg/max(CA.speeg)*length(good),'color',[1 1 1]*0,'LineWidth',2)
axis xy
xlim([4 12])
Lines(Feeg,[],[1 1 1]*0.5,'--',2);
Lines(mean(f(fg(mih))),[],[1 1 1]*0,'--',2);
fprintf(['\n mean f_0 ' num2str(mean(f(fg(mih)))) '\n'])
fprintf([' mean f_e ' num2str(CA.feeg) '\n'])
xlabel('frequency [Hz]','FontSize',16)
ylabel('cells #','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off


%% rel. freqeuncy
subplot('position',[0.3 0.15 0.15 0.25])
fph = ALL(cca).spectPhM.f;
fgph = find(fph>=0.5 & fph<=1.5);
imagesc(ALL(cca).spectPhM.f,[],unity(ALL(cca).spectPhM.spunit(:,good(sih)))')
%hold on
[mph iph] = max(ALL(cca).spectPhM.spunit(fgph,good(sih)));
%plot(fph(fgph(iph)),[1:length(mph)],'.k')
bbph = fph(1:1:end);
hhph = histcI(fph(fgph(iph)),bbph);
bph1 = bar(bbph(1:end-1)+mean(diff(bbph))/2,hhph);
mrph = round(mean(fph(fgph(iph)))*1000)/1000;
axis tight
xlim([0.5 1.5])
Lines(1,[],[1 1 1]*0.5,'--',2);
Lines(mrph,[],[1 1 1]*0,'--',2);
xlabel('rel. frequency','FontSize',16)
ylabel('count','FontSize',16)
ax = get(gca,'YLim');
rmrph = round(mrph*100)/100;
title(['f_0/f_{\Theta}=' num2str(rmrph) ],'FontSize',16,'position',[1 ax(2)*0.95])
set(gca,'TickDir','out','FontSize',16)
box off


%% Sequence Compression
subplot('position',[0.525 0.15 0.15 0.25])
idx = find(CMP.region1==3 & CMP.region2==3 & ismember(CMP.cellids(1,:),find(CA.good)) & ismember(CMP.cellids(2,:),find(CA.good)));
%plot(CMP.dist(idx),CMP.theta(idx),'o','markersize',5,'markeredgecolor',[1 1 1]*0.5,'markerfacecolor',[1 1 1]*0.5) 
plot(CMP.runt(idx),CMP.theta(idx),'o','markersize',5,'markeredgecolor',[1 1 1]*0.5,'markerfacecolor',[1 1 1]*0.5) 
axis tight
%rob = robustfit(CMP.dist(idx),CMP.theta(idx));
rob = robustfit(CMP.runt(idx),CMP.theta(idx));
[rRC pRC] = RankCorrelation(CMP.runt(idx),CMP.theta(idx));
%keyboard
%x = [-200 200];
x = [-1000 1000];
hold on
plot(x,rob(1)+rob(2)*x,'r--')
a = round(rob(2)*1000)/1000;
ax = get(gca,'YLim');
bx = get(gca,'XLim');
title(['slope=' num2str(a)],'FontSize',16,'position',[mean(bx) ax(2)])
xlabel('time [ms]','FontSize',16)
ylabel('\tau_{\Theta} [ms]','FontSize',16,'position',[bx(1)-diff(bx)*0.2 mean(ax)])
set(gca,'TickDir','out','FontSize',16)
box off

%% Place Field Size
subplot('position',[0.75 0.15 0.15 0.25])
gg = find(CA.good' & ALL(cca).type.num==2 & ALL(cca).cells.region==2 & ALL(cca).xcorrlM.std'& abs(ALL(cca).xcorrlM.goodness)'<0.05);
%keyboard
binlf = [0:0.2:3];
hlf = histcI(ALL(cca).xcorrlM.std(gg)*LF/1000,binlf);
bar(binlf(1:end-1)+mean(diff(binlf))/2,hlf);
axis tight
box off
ml = median(ALL(cca).xcorrlM.std(gg)*LF)/1000;
Lines(median(ALL(cca).xcorrlM.std(gg)*LF)/1000);
ml = round(ml*100)/100;
ax = get(gca,'YLim');
bx = get(gca,'XLim');
title(['L=' num2str(ml) 's'],'FontSize',16,'position',[mean(bx) ax(2)])
xlabel('time [sec]','FontSize',16)
ylabel('count','FontSize',16)
set(gca,'TickDir','out','FontSize',16,'XTick',[0:1:3])

f0=LF/(sqrt(2)*pi*a*ml)
f0fe=1./(1-a) 


text(-14,ax(2)*3.1,'A','FontSize',16)
text(-14,ax(2)*1.3,'B','FontSize',16)


PrintFig([ALL(cca).info.FileBase '.cmp2'],GoPrint)


return;

%%%%%%%%%%%%%
%%%%%%%%%%%%%
%%%%%%%%%%%%%
%%%%%%%%%%%%%
%%% GROUP
%%%%%%%%%%%%%
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
CatAll = CatStruct(ALL(1:28));

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




figure(745);clf;
m=0;
filen =  [17:28];
rn = [1 3];
for r=[1 2]
  for n=filen
    m=m+1;
    %subplotfit(m,length(filen))
    CMPG = ALL(n).compr;
    CAG = ALL(n).spectM;
    idx = find(CMPG.region1==rn(r) & CMPG.region2==rn(r) & ismember(CMPG.cellids(1,:),find(CAG.good)) & ismember(CMPG.cellids(2,:),find(CAG.good)));
    if length(idx)<=3
      G(m,[1:4]) = 1;
      continue
    end
    plot(CMPG.runt(idx),CMPG.theta(idx),'o','markersize',5,'markeredgecolor',[1 1 1]*0.5,'markerfacecolor',[1 1 1]*0.5) 
    axis tight
    rob = robustfit(CMPG.runt(idx),CMPG.theta(idx));
    for k=1:length(idx)
      fidx = setdiff(idx,idx(k));
      frob(k,:) = robustfit(CMPG.runt(fidx),CMPG.theta(fidx));
    end
    [rRC pRC] = RankCorrelation(CMPG.runt(idx),CMPG.theta(idx));
    x = [-1000 1000];
    hold on
    plot(x,rob(1)+rob(2)*x,'r--')
    title(['slope=' num2str(rob(2))],'FontSize',16)
    xlabel('time [ms]','FontSize',16)
    ylabel('\tau_{\Theta} [ms]','FontSize',16)
    set(gca,'TickDir','out','FontSize',16)
    box off
    %% 
    %% freqeuncy:
    fph = ALL(n).spectPhM.f;
    fgph = find(fph>=0.5 & fph<=1.5);
    good = find(CAG.good' & ALL(n).type.num==2 & ALL(n).cells.region==r);%%
    [mph iph] = max(ALL(n).spectPhM.spunit(fgph,good));
    bbph = fph(1:1:end);
    hhph = histcI(fph(fgph(iph)),bbph);
    bph1 = bar(bbph(1:end-1)+mean(diff(bbph))/2,hhph);
    mrph = mean(fph(fgph(iph)));
    for k=1:length(iph)
      fiph = setdiff(iph,iph(k));
      ffr(k) = mean(fph(fgph(fiph)));
    end
    G(m,:) = [rob(2) rRC pRC mrph];
    FG(m,:) = [mean(1-frob(:,2)) std(1-frob(:,2)) mean(1./ffr) std(1./ffr)];
  end
end

%%%%%%%%%%%%%%
%% Maze/Wheel
%whos Mcmf Wcmf mrphM mrphW
%keyboard
for n=1:length(mrphW)
  ix = setdiff([1:length(mrphW)],n);
  mfW(n) = mean(mrphW(ix));
end
for n=1:length(mrphM)
  ix = setdiff([1:length(mrphM)],n);
  mfM(n) = mean(mrphM(ix));
end
for n=1:length(Wcmf)
  ix = setdiff([1:size(Wcmf,1)],n);
  cfW(n,:) = robustfit(Wcmf(ix,1),Wcmf(ix,2));
end
for n=1:length(Mcmf)
  ix = setdiff([1:size(Mcmf,1)],n);
  cfM(n,:) = robustfit(Mcmf(ix,1),Mcmf(ix,2));
end


%%%%%%%%%%%%%%%%
%% Group Figure

figure(45898);clf
subplot(121)
hold on
ix1 = find(G(:,3)<0.05 & [repmat(1,1,length(filen)) repmat(0,1,length(filen))]' & FG(:,3)<1.1);
ix2 = find(G(:,3)<0.05 & [repmat(0,1,length(filen)) repmat(1,1,length(filen))]' & FG(:,3)<1.1);
%
plot(FG(ix1,1),FG(ix1,3),'o','markersize',10,'markeredgecolor',[1 0 0],'markerfacecolor',[1 0 0])
plot(FG(ix2,1),FG(ix2,3),'o','markersize',10,'markeredgecolor',[0 1 0],'markerfacecolor',[0 1 0])
%
errorbar(FG(ix1,1),FG(ix1,3),FG(ix1,4),'.','color',[1 0 0])
herrorbar(FG(ix1,1),FG(ix1,3),FG(ix1,2),'.r')
errorbar(FG(ix2,1),FG(ix2,3),FG(ix2,4),'.','color',[0 1 0])
herrorbar(FG(ix2,1),FG(ix2,3),FG(ix2,2),'.g')
%
plot([0.8 1.1],[0.8 1.1],'k--')
l=legend('CA1','CA3','Location','SouthEast');
%set(l,'boxoff')
axis tight
xlim([0.85 1.05])
ylim([0.85 1.05])
xlabel('(1-c)','FontSize',16)
ylabel('f_{\Theta}/f_{0}','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off
%%%%%%%
subplot(122)
hold on
EF(1,:) = [mean(1-cfM(:,2)) std(1-cfM(:,2)) mean(1./mfM) std(1./mfM)];
EF(2,:) = [mean(1-cfW(:,2)) std(1-cfW(:,2)) mean(1./mfW) std(1./mfW)];
plot(EF(1,1),EF(1,3),'o','markersize',10,'markeredgecolor',[1 0 0],'markerfacecolor',[1 0 0])
plot(EF(2,1),EF(2,3),'o','markersize',10,'markeredgecolor',[0 1 0],'markerfacecolor',[0 1 0])
%%
%errorbar(EF(:,1),EF(:,3),EF(:,4),'.r')
%herrorbar(EF(:,1),EF(:,3),EF(:,2),'.g')
%
plot([0.8 1.1],[0.8 1.1],'k--')
l=legend('track','wheel','Location','SouthEast');
%set(l,'boxoff')
axis tight
xlim([0.85 1.05])
ylim([0.85 1.05])
xlabel('(1-c)','FontSize',16)
ylabel('f_{\Theta}/f_{0}','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off


PrintFig([ALL(cca).info.FileBase '.cmpgr'],GoPrint)


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

%% model: example of wheel/maze
% get single cell rel.firing rates for each  
m=0;
ff = -ones(30,2);
ffr = zeros(30,2);
cc = -ones(30,2);
pp = -ones(30,2);
filen =  [1:16];
for n=filen
  m=m+1;
  if isempty(ALL(n).info)
    continue;
  end
  if ALL(n).info.BehNum~=2 | ~ALL(n).info.Wheel
    continue;
  end
  CMP = ALL(n).compr;
  SPM = ALL(n).spectPhM;
  SPW = ALL(n).spectPhW;
  if ismember(n,[2 3 10])
    %% 1-maze 2-wheel
    gg = find(CMP.Ldt>-500 & CMP.Ldt<500);
    pp(n,1) = 1-ranksum(CMP.Ldt(gg),CMP.Sdt(gg));
    [b stat] = robustfit(CMP.Ldt(gg),CMP.Sdt(gg));
    cc(n,1) = 1-b(2);
    [maxx maxt] = MaxPeak(SPM.f,SPM.spunit,[0.5 1.5]);
    ff(n,1) = mean(1./maxt);
  else
    figure(4378);clf
    %%%% MAZE
    subplot(121)
    plot(CMP.Mrunt,CMP.Mtheta,'.')    
    gg = find(CMP.Mrunt>-500 & CMP.Mrunt<500);
    pp(n,1) = 1-ranksum(CMP.Mrunt(gg),CMP.Mtheta(gg));
    title(num2str(pp(n,1)))
    
    [b stat] = robustfit(CMP.Mrunt(gg),CMP.Mtheta(gg));
    hold on
    plot([-500 500],b(1)+b(2)*[-500 500],'r--')
    cc(n,1) = 1-b(2);
    %% 
    gsp = find(ALL(n).spectM.good);
    [maxx maxt] = MaxPeak(SPM.f,SPM.spunit(:,gsp),[0.5 1.5]);
    for l=1:length(maxt)
      ix = setdiff([1:length(maxt)],l);
      lf(l) = mean(1./maxt(ix));
    end
    ff(n,1) = mean(lf);
    ffr(n,1) = std(lf);
    %ff(n,1) = median(1./maxt);
    %%%% WHEEL
    subplot(122)
    plot(CMP.Trunt,CMP.Ttheta,'.')
    gg = find(CMP.Trunt>-500 & CMP.Trunt<500);
    pp(n,2) = 1-ranksum(CMP.Trunt(gg),CMP.Ttheta(gg));
    title(num2str(pp(n,2)))
    [b stat] = robustfit(CMP.Trunt(gg),CMP.Ttheta(gg));
    hold on
    plot([-500 500],b(1)+b(2)*[-500 500],'r--')
    cc(n,2) = 1-b(2);
    %%
    gsp = find(ALL(n).spectW.good);
    [maxx maxt] = MaxPeak(SPW.f,SPW.spunit(:,gsp),[0.5 1.5]);
    for l=1:length(maxt)
      ix = setdiff([1:length(maxt)],l);
      lf(l) = mean(1./maxt(ix));
    end
    ff(n,2) = mean(lf);
    ffr(n,2) = std(lf);
    %ff(n,2) = median(1./maxt);
    
    WaitForButtonpress
   end

  %keyboard
  
  %% maze
  %for m=1:length(CMP.Mrunt)
  %  b(m,:) = robustfit(CMP.Mrunt,CMP.Mtheta);
  %end
  
  %% What is it here? How do I get 
  %% 
  
end


figure(4);clf
gp = pp>0.6;
plot([0.85 1.05],[0.85 1.05],'k--')
hold on
plot(cc(gp(:,1),1),ff(gp(:,1),1),'ro')
%errorbar(cc(:,1),ff(:,1),ffr(:,1),'.','color',[1 0 0])
plot(cc(gp(:,2),2),ff(gp(:,2),2),'go')
%errorbar(cc(:,2),ff(:,2),ffr(:,2),'.','color',[0 1 0])
xlim([0.85 1.05])
ylim([0.85 1.05])



keyboard

return;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


  idx = find(CMPG.region1==rn(r) & CMPG.region2==rn(r) & ismember(CMPG.cellids(1,:),find(CAG.good)) & ismember(CMPG.cellids(2,:),find(CAG.good)));
  if length(idx)<=3
    G(m,[1:4]) = 1;
    %continue
  end
  plot(CMPG.runt(idx),CMPG.theta(idx),'o','markersize',5,'markeredgecolor',[1 1 1]*0.5,'markerfacecolor',[1 1 1]*0.5)
  axis tight
  rob = robustfit(CMPG.runt(idx),CMPG.theta(idx));
  for k=1:length(idx)
    fidx = setdiff(idx,idx(k));
    frob(k,:) = robustfit(CMPG.runt(fidx),CMPG.theta(fidx));
  end
  [rRC pRC] = RankCorrelation(CMPG.runt(idx),CMPG.theta(idx));
  x = [-1000 1000];
  hold on
  plot(x,rob(1)+rob(2)*x,'r--')
  title(['slope=' num2str(rob(2))],'FontSize',16)
  xlabel('time [ms]','FontSize',16)
  ylabel('\tau_{\Theta} [ms]','FontSize',16)
  set(gca,'TickDir','out','FontSize',16)
  box off
  %% 
  %% freqeuncy:
  fph = ALL(n).spectPhM.f;
  fgph = find(fph>=0.5 & fph<=1.5);
  good = find(CAG.good' & ALL(n).type.num==2 & ALL(n).cells.region==r);%%
  [mph iph] = max(ALL(n).spectPhM.spunit(fgph,good));
  bbph = fph(1:1:end);
  hhph = histcI(fph(fgph(iph)),bbph);
  bph1 = bar(bbph(1:end-1)+mean(diff(bbph))/2,hhph);
  mrph = mean(fph(fgph(iph)));
  for k=1:length(iph)
    fiph = setdiff(iph,iph(k));
    ffr(k) = mean(fph(fgph(fiph)));
  end
  G(m,:) = [rob(2) rRC pRC mrph];
  FG(m,:) = [mean(1-frob(:,2)) std(1-frob(:,2)) mean(1./ffr) std(1./ffr)];



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(4873);clf
%ca1
idx = find(CMP.region1==1 & CMP.region2==1);
%A1 = 1./CMP.fccg(idx)*Feeg;
A1 = 1./CMP.fpair(idx)*Feeg;
A2 = 1 - CMP.theta(idx)./CMP.runt(idx);
plot(A1 + rand(size(A1))*0.1,A2,'o','markersize',5,'markeredgecolor',[1 1 1]*0.5,'markerfacecolor',[1 1 1]*0.5) 
hold on
%ca3
idx = find(CMP.region1==3 & CMP.region2==3);
%A1 = 1./CMP.fccg(idx)*Feeg;
A1 = 1./CMP.fpair(idx)*Feeg;
A2 = 1 - CMP.theta(idx)./CMP.runt(idx);
plot(A1 + rand(size(A1))*0.1,A2,'o','markersize',5,'markeredgecolor',[1 1 1]*0,'markerfacecolor',[1 1 1]*0) 
%
%rob = robustfit(A1,A2);
x = [min(A1) max(A1)];
%%plot(x,rob(1)+rob(2)*x,'r--')
plot(x,x,'k--')
%title(['slope=' num2str(round(rob(2)*100)/100)],'FontSize',16)
title(['slope=' num2str(rob(2))],'FontSize',16)
xlabel('1-c','FontSize',16)
ylabel('f_\theta/f_0','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
axis tight
box off


%%%%%%%%%%%%%
figure(48765);clf
%ca1
CMP = CatCA.compr; 
idx = find(CMP.region1==1 & CMP.region2==1);
%A1 = 1./CMP.fccg(idx)*Feeg;
A1 = 1./CMP.fpair(idx)'.*CMP.feeg(idx);
A2 = 1 - CMP.theta(idx)./CMP.runt(idx);
plot(A1 + rand(size(A1))*0.1,A2,'o','markersize',5,'markeredgecolor',[1 1 1]*0.5,'markerfacecolor',[1 1 1]*0.5) 
hold on
%ca2
idx = find(CMP.region1==3 & CMP.region2==3);
%A1 = 1./CMP.fccg(idx)*Feeg;
A1 = 1./CMP.fpair(idx)'.*CMP.feeg(idx);
A2 = 1 - CMP.theta(idx)./CMP.runt(idx);
plot(A1 + rand(size(A1))*0.1,A2,'o','markersize',5,'markeredgecolor',[1 1 1]*0,'markerfacecolor',[1 1 1]*0) 
%
%rob = robustfit(A1,A2);
x = [min(A1) max(A1)];
%%plot(x,rob(1)+rob(2)*x,'r--')
plot(x,x,'k--')
%title(['slope=' num2str(round(rob(2)*100)/100)],'FontSize',16)
title(['slope=' num2str(rob(2))],'FontSize',16)
xlabel('1-c','FontSize',16)
ylabel('f_\theta/f_0','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
axis tight
box off


%% M-group
good = find(CatMW.spectM.good'& CatMW.type.num==2);
[mma mia] = max(CatMW.spectM.spunit(fg,good));
subplot('position',[0.7 0.55 0.2 0.25])
hh = histcI(f(fg(mia)),bb);
b2 = bar(bb(1:end-1)+mean(diff(bb))/2,hh);
axis tight
Lines(mean(CatMW.spectM.feeg),[],[1 1 1]*0,'--',2);
xlim([4 12])
ylabel('count','FontSize',16)
%xlabel('frequency [Hz]','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off
length(mia)
%keyboard


%% W-group
good = find(CatMW.spectW.good'& CatMW.type.num==2);
[mma mia] = max(CatMW.spectW.spunit(fg,good));
subplot('position',[0.7 0.15 0.2 0.25])
hh = histcI(f(fg(mia)),bb);
b2 = bar(bb(1:end-1)+mean(diff(bb))/2,hh);
axis tight
Lines(mean(CatMW.spectW.feeg),[],[1 1 1]*0,'--',2);
xlim([4 12])
ylabel('count','FontSize',16)
%xlabel('frequency [Hz]','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off
length(mia)
%% 


%% CA1-group
good = find(CatCA.spectM.good'& CatCA.type.num==2 & CatCA.cells.region==1);
[mma mia] = max(CatCA.spectM.spunit(fg,good));
subplot('position',[0.7 0.55 0.2 0.25])
hh = histcI(f(fg(mia)),bb);
b2 = bar(bb(1:end-1)+mean(diff(bb))/2,hh);
axis tight
Lines(mean(CatCA.spectM.feeg),[],[1 1 1]*0,'--',2);
xlim([4 12])
ylabel('count','FontSize',16)
%xlabel('frequency [Hz]','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off
length(mia)
%keyboard

%return;


%% CA3-group
good = find(CatCA.spectM.good'& CatCA.type.num==2 & CatCA.cells.region==2);
[mma mia] = max(CatCA.spectM.spunit(fg,good));
subplot('position',[0.7 0.15 0.2 0.25])
hh = histcI(f(fg(mia)),bb);
b2 = bar(bb(1:end-1)+mean(diff(bb))/2,hh);
axis tight
Lines(mean(CatCA.spectM.feeg),[],[1 1 1]*0,'--',2);
xlim([4 12])
ylabel('count','FontSize',16)
%xlabel('frequency [Hz]','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off
length(mia)
%% 

