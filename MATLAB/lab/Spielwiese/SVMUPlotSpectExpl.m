function SVMUPlotSpectExpl(ALL,varargin)
[arg] = DefaultArgs(varargin,{[]});

GoPrint = 1;

%%% maze and wheel
CatMW = CatStruct(ALL(1:5));
cmw = 4;
%cmw = arg;

ExW = ALL(cmw).spectW;
ExM = ALL(cmw).spectM;

%%% CA1/CA3
CatCA = CatStruct(ALL(17:28));
%if isempty(arg)
  %cca = arg; %%??
  %cca = 22; %%??
  cca = [19];
%else
%  cca = arg;
%end
CA = ALL(cca).spectM;

%% Place Field Size Factor :: 1% !!!!!!!!
LF = 2*sqrt(-log(0.01));

cL = 4000; % field size cut off
cL2 = 4000; % field size cut off

%%%%%%%%%%%%%%%%%%%%%%%
figure(654);clf
set(gcf,'position',[1796         458         878         420])
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
ylabel('CA1 place cell #','FontSize',16)
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
%mrph = mean(fph(fgph(iph)));
mrph = Jackknife(fph(fgph(iph)));
mrphM = fph(fgph(iph));
axis tight
xlim([0.5 1.5])
Lines(1,[],[1 1 1]*0.5,'--',2);
Lines(mrph,[],'r','--',2);
xlabel('rel. frequency','FontSize',16)
ay = get(gca,'ylim');
ylabel('count','FontSize',16,'position',[0.35 mean(ay)])
ax = get(gca,'YLim');
rmrph = round(mrph*100)/100;
title(['f_0/f_{\theta}=' num2str(rmrph) ],'FontSize',16,'position',[1 ax(2)*0.95])
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
plot(x,rob(1)+rob(2)*x,'r--','LineWidth',2)
a = round(rob(2)*1000)/1000;
ax = get(gca,'YLim');
bx = get(gca,'XLim');
title(['c=' num2str(a)],'FontSize',16,'position',[mean(bx) ax(2)])
xlabel('time [ms]','FontSize',16)
ylabel('\tau_{\theta} [ms]','FontSize',16,'position',[bx(1)-diff(bx)*0.2 mean(ax)])
set(gca,'TickDir','out','FontSize',16)
box off


%% Place Field Size
subplot('position',[0.725 0.6 0.15 0.25])
gg = ExM.good'&ALL(cmw).type.num==2 & ALL(cmw).xcorrlM.std'& abs(ALL(cmw).xcorrlM.goodness)'<0.05;
binlf = [0:0.2:3];
hlf = histcI(ALL(cmw).xcorrlM.std(gg)*LF/1000,binlf);
bar(binlf(1:end-1)+mean(diff(binlf))/2,hlf);
axis tight
box off
ml = median(ALL(cmw).xcorrlM.std(gg)*LF)/1000;
%ml = Jackknife(ALL(cmw).xcorrlM.std(gg)*LF/1000);
Lines(ml,[],'r','--',2);
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
good = find(ExW.good'&ALL(cmw).type.num==2 & ALL(cmw).xcorrlW.std'& abs(ALL(cmw).xcorrlW.goodness)'<0.1 & ALL(cmw).xcorrlW.std'*LF<=cL);

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
ylabel('CA1 wheel cell #','FontSize',16)
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
%mrph = Jackknife(fph(fgph(iph)));
mrphW = fph(fgph(iph));
axis tight
xlim([0.5 1.5])
Lines(1,[],[1 1 1]*0.5,'--',2);
Lines(mrph,[],'r','--',2);
xlabel('rel. frequency','FontSize',16)
ay = get(gca,'ylim');
ylabel('count','FontSize',16,'position',[0.35 mean(ay)])
ax = get(gca,'YLim');
rmrph = round(mrph*100)/100;
title(['f_0/f_{\theta}=' num2str(rmrph) ],'FontSize',16,'position',[1 ax(2)*0.95])
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
plot(x,rob(1)+rob(2)*x,'r--','LineWidth',2)
a = round(rob(2)*1000)/1000;
ax = get(gca,'YLim');
bx = get(gca,'XLim');
title(['c=' num2str(a)],'FontSize',16,'position',[mean(bx) ax(2)])
xlabel('time [ms]','FontSize',16)
ylabel('\tau_{\theta} [ms]','FontSize',16,'position',[bx(1)-diff(bx)*0.2 mean(ax)])
set(gca,'TickDir','out','FontSize',16,'XTick',[-400:400:400])
box off


%% Place Field Size
subplot('position',[0.725 0.15 0.15 0.25])
gg = ExW.good'&ALL(cmw).type.num==2 & ALL(cmw).xcorrlW.std'& abs(ALL(cmw).xcorrlW.goodness)'<0.05 & ALL(cmw).xcorrlW.std'*LF<=cL;
binlf = [0:0.2:3];
hlf = histcI(ALL(cmw).xcorrlW.std(gg)*LF/1000,binlf);
bar(binlf(1:end-1)+mean(diff(binlf))/2,hlf);
axis tight
box off
%ml = median(ALL(cmw).xcorrlW.std(gg)*LF)/1000;
ml = median(ALL(cmw).xcorrlW.std(gg)*LF)/1000;
Lines(ml,[],'r','--',2);
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
text(-14,ax(2)*3.1,'A','FontSize',16)
text(-14,ax(2)*1.3,'B','FontSize',16)


PrintFig([ALL(cmw).info.FileBase '.cmp1'],GoPrint)


%%%%%%%%%%%%%%%%%%%%%%%
%%% CA1 -- CA3
%%%%%%%%%%%%%%%%%%%%%%%
figure(653);clf

%% CA1
good = find(CA.good' & ALL(cca).type.num==2 & ALL(cca).cells.region==1 & ALL(cca).xcorrlM.std'& abs(ALL(cca).xcorrlM.goodness)'<0.05 & ALL(cca).xcorrlM.std'*LF<=cL2);

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
ylabel('CA1 place cell #','FontSize',16)
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
%mrph = round(mean(fph(fgph(iph)))*1000)/1000;
%mrph = Jackknife(fph(fgph(iph)));
mrph = median(fph(fgph(iph)));
axis tight
xlim([0.5 1.5])
Lines(1,[],[1 1 1]*0.5,'--',2);
Lines(mrph,[],'r','--',2);
xlabel('rel. frequency','FontSize',16)
ylabel('count','FontSize',16)
ax = get(gca,'YLim');
rmrph = round(mrph*100)/100;
title(['f_0/f_{\theta}=' num2str(rmrph) ],'FontSize',16,'position',[1 ax(2)*0.95])
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
plot(x,rob(1)+rob(2)*x,'r--','lineWidth',2)
a = round(rob(2)*1000)/1000;
ax = get(gca,'YLim');
bx = get(gca,'XLim');
title(['c=' num2str(a)],'FontSize',16,'position',[mean(bx) ax(2)])
xlabel('time [ms]','FontSize',16)
ylabel('\tau_{\theta} [ms]','FontSize',16,'position',[bx(1)-diff(bx)*0.2 mean(ax)])
set(gca,'TickDir','out','FontSize',16)
box off


%% Place Field Size
subplot('position',[0.75 0.6 0.15 0.25])
gg = find(CA.good' & ALL(cca).type.num==2 & ALL(cca).cells.region==1 & ALL(cca).xcorrlM.std'& abs(ALL(cca).xcorrlM.goodness)'<0.05 & ALL(cca).xcorrlM.std'*LF<=cL2);
binlf = [0:0.2:3];
hlf = histcI(ALL(cca).xcorrlM.std(gg)*LF/1000,binlf);
bar(binlf(1:end-1)+mean(diff(binlf))/2,hlf);
axis tight
box off
ml = median(ALL(cca).xcorrlM.std(gg)*LF)/1000;
%ml = Jackknife(ALL(cca).xcorrlM.std(gg)*LF/1000);
Lines(ml,[],'r','--',2);
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
good = find(CA.good' & ALL(cca).type.num==2 & ALL(cca).cells.region==2 & ALL(cca).xcorrlM.std'& abs(ALL(cca).xcorrlM.goodness)'<0.05 & ALL(cca).xcorrlM.std'*LF<=cL2);

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
ylabel('CA3 place cell #','FontSize',16)
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
%mrph = round(mean(fph(fgph(iph)))*1000)/1000;
%mrph = Jackknife(fph(fgph(iph)));
mrph = median(fph(fgph(iph)));
axis tight
xlim([0.5 1.5])
Lines(1,[],[1 1 1]*0.5,'--',2);
Lines(mrph,[],'r','--',2);
xlabel('rel. frequency','FontSize',16)
ylabel('count','FontSize',16)
ax = get(gca,'YLim');
rmrph = round(mrph*100)/100;
title(['f_0/f_{\theta}=' num2str(rmrph) ],'FontSize',16,'position',[1 ax(2)*0.95])
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
plot(x,rob(1)+rob(2)*x,'r--','LineWidth',2)
a = round(rob(2)*1000)/1000;
ax = get(gca,'YLim');
bx = get(gca,'XLim');
title(['c=' num2str(a)],'FontSize',16,'position',[mean(bx) ax(2)])
xlabel('time [ms]','FontSize',16)
ylabel('\tau_{\theta} [ms]','FontSize',16,'position',[bx(1)-diff(bx)*0.2 mean(ax)])
set(gca,'TickDir','out','FontSize',16)
box off

%% Place Field Size
subplot('position',[0.75 0.15 0.15 0.25])
gg = find(CA.good' & ALL(cca).type.num==2 & ALL(cca).cells.region==2 & ALL(cca).xcorrlM.std'& abs(ALL(cca).xcorrlM.goodness)'<0.05 & ALL(cca).xcorrlM.std'*LF<=cL2);
%keyboard
binlf = [0:0.2:3];
hlf = histcI(ALL(cca).xcorrlM.std(gg)*LF/1000,binlf);
bar(binlf(1:end-1)+mean(diff(binlf))/2,hlf);
axis tight
box off
ml = median(ALL(cca).xcorrlM.std(gg)*LF)/1000;
ml = Jackknife(ALL(cca).xcorrlM.std(gg)*LF)/1000;
Lines(ml,[],'r','--',2);
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

