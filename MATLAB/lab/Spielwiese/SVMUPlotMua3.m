function SVMUPlotMua3(ALL)
%% function SVMUPlotMua(ALL(23))
%ALL = ALL(20);
%ALL = ALL(23);
MUA = ALL.mua; 
SP = ALL.spect;

GSP = ALL.type.num==2 & ALL.spect.good';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% find good episode
FileBase = '2006-6-09_22-24-40/2006-6-09_22-24-40';

a0 = 52; b0 = 57;
a1 = 53; b1 = 55.5;
a2 = 53; b2 = 56;
a3 = 52; b3 = 56;

a0 = 51; b0 = 55;
a1 = 52; b1 = 55;
a2 = 52; b2 = 55;
a3 = 52; b3 = 55;


%a0=-20;
%b0=0;
%while b0<=max(MUA.spT);

%a0=204; b0=209;
a0=203; b0=320;

a1=a0+1; b1=b0-1;
a2=a0+1; b2=b0-1;
a3=a0+1; b3=b0-1;
  
  
gtSP = find(MUA.spT>a0 & MUA.spT<b0); %0
gtSPA = find(MUA.spT>a1 & MUA.spT<b1); %1
gtR = find([1:length(MUA.rate)]/1252>a2 & [1:length(MUA.rate)]/1252<b2); %2
gf = find(MUA.spF>4 & MUA.spF<12);
ispk = find(MUA.spkt/1252>a3 & MUA.spkt/1252<b3); %3

%% number of spikes
ind = MUA.spki(ispk);
h = hist(ind,[min(ind):max(ind)]);
sdf=length(find(h>3));
dfg=length(find(h>3))/(b0-a0);

fprintf(['num of cells with more than 3 spikes:' num2str(sdf) ' || num of good cells/sec ' num2str(dfg) '\n']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% make figures

cc1 = [0.94 0 0];
cc2 = [0 0.6 0];

figure(3278467);clf;
%set(gcf,'position',[2200 297 672 627])
set(gcf,'position',[1711  188  600  597])


%%% SPIKES
subplot('position',[0.13 0.83 0.55 0.12])
xs = MUA.spkt(ispk)/1252;
ys = MUA.spki(ispk)-min(MUA.spki);
%plot(MUA.spkt(ispk)/1252-53,MUA.spki(ispk)-min(MUA.spki),'k.')
line([xs';xs'],[ys'-1;ys'+1],'color',[0 0 0],'LineWidth',2);
axis tight
xlim([a1 b1])
set(gca,'TickDir','out','FontSize',16)
box off
axis off
ax = get(gca,'XLim');
ay = get(gca,'YLim');
%text(ax(1)-mean(ax)*0.16, mean(ay)*2/3,'cells','FontSize',16,'Rotation',90)
text(ax(1)-mean(ax)*0.2, mean(ay)*2/3,'cells','FontSize',16,'Rotation',90)

%keyboard
h=histc(ys,[min(ys):max(ys)]);
lh = length(find(h>3))/3;        %% # 

%keyboard


%%% POP
subplot('position',[0.13 0.7 0.55 0.12])
plot([1:length(gtR)]/1252+a1,MUA.rate(gtR),'color',cc1,'LineWidth',2)
axis tight
%xlim([0 3])
xlim([a1 b1])
set(gca,'TickDir','out','FontSize',16)
box off
axis off
%g = get(gca,'Ylim');
%text(-0.25,-0.01,'POP','FontSize',16,'Rotation',90)
ax = get(gca,'XLim');
ay = get(gca,'YLim');
text(ax(1)-mean(ax)*0.2, ay(1)+diff(ay)*0.25,'POP','FontSize',16,'Rotation',90)


%%% SPECT POP
subplot('position',[0.13 0.5 0.55 0.2])
imagesc(MUA.spT(gtSP),MUA.spF(gf),unity(MUA.spectgrunit(gtSP,gf)'))
%imagesc(MUA.spT(gtSP)-53,MUA.spF(gf),(MUA.spectgrunit(gtSP,gf)'))
axis xy
hold on
plot(MUA.spT(gtSP),MUA.mxeegF(gtSP),'o','markersize',5,'markerfacecolor',[1 1 1]*0,'markeredgecolor',[1 1 1]*0)
%xlim([0 3])
xlim([a1 b1])
set(gca,'TickDir','out','XTick',[],'YTick',[4:2:12],'FontSize',16)
ax = get(gca,'XLim');
ay = get(gca,'YLim');
ylabel('frequency [Hz]','FontSize',16,'position',[ax(1)-mean(ax)*0.16 mean(ay)])
box off


%%% LFP
subplot('position',[0.13 0.35 0.55 0.12])
plot([1:length(gtR)]/1252+a1,MUA.eeg(gtR),'color',cc2,'LineWidth',2)
axis tight
%xlim([0 3])
xlim([a1 b1])
set(gca,'TickDir','out','FontSize',16)
box off
axis off
ax = get(gca,'XLim');
ay = get(gca,'YLim');
text(ax(1)-mean(ax)*0.2, ay(1)+diff(ay)*0.25,'LFP','FontSize',16,'Rotation',90)


%%% SPECT LFP
subplot('position',[0.13 0.15 0.55 0.2])
%imagesc(MUA.spT,MUA.spF,unity(MUA.spectgreeg'))
imagesc(MUA.spT(gtSP),MUA.spF(gf),(MUA.spectgreeg(gtSP,gf)'))
axis xy
hold on
plot(MUA.spT(gtSP),MUA.mxeegF(gtSP),'o','markersize',5,'markerfacecolor',[1 1 1]*0,'markeredgecolor',[1 1 1]*0)
%xlim([0 3])
xlim([a1 b1])
set(gca,'TickDir','out','YTick',[4:2:12],'FontSize',16)
xlabel('time [sec]','FontSize',16)
ax = get(gca,'XLim');
ay = get(gca,'YLim');
ylabel('frequency [Hz]','FontSize',16,'position',[ax(1)-mean(ax)*0.16 mean(ay)])
box off
%%


%%% LFP VS. POP
subplot('position',[0.75 0.15 0.2 0.15])
x = mean(MUA.spectgreeg(gtSPA,gf));
plot(MUA.spF(gf),x/max(x),'color',cc2,'LineWidth',2)
[mx mt] = MaxPeak(MUA.spF(gf),x');
fprintf(['eeg ' num2str(mt) '\n']);
hold on
x = mean(MUA.spectgrunit(gtSPA,gf));
plot(MUA.spF(gf),x/max(x),'color',cc1,'LineWidth',2)
[mx mt] = MaxPeak(MUA.spF(gf),x');
fprintf(['mua ' num2str(mt) '\n']);
xlabel('frequency [Hz]','FontSize',16)
ylabel('power','FontSize',16,'position',[3.2 0.5])
axis tight
%ylim([0 1])
set(gca,'TickDir','out','YTick',[0 1],'FontSize',16)
box off

%keyboard

h=histc(MUA.spki(ispk),[1:max(MUA.spki)]);  
gh = find(h>3);                            %% good cells with more than 3 spikes 
lh = length(find(h>3))/(b1-a1);            %% # of good cells


%%% EXAMPLE SPECTS
ff = find(SP.f>4 & SP.f<12);
%fGSP = find(GSP);
fGSP = gh;
[msp mi] = max(SP.spunit(ff,gh));
[ma mai] = sort(msp,'descend');
SPs = SP.spunit(ff,fGSP(mai(1:10)));
[msp mi] = max(SPs);
[ma mai] = sort(mi,'descend');
%keyboard
%imagesc(SP.spunit(gf,fGSP(mai)))
pos = [0.8 0.65 0.5];
for n=1:3
  subplot('position',[0.75 pos(n) 0.2 0.15])
  %plot(MUA.spF(gf),x/max(x),'k--','LineWidth',2)
  hold on
  plot(SP.f(ff),SPs(:,mai(n))/msp(mai(n)),'k','LineWidth',2)
  [mx mt] = MaxPeak(SP.f(ff),SPs(:,mai(n)));
  fprintf(['pc ' num2str(mt) '\n']);
  axis tight
  ylim([0 1])
  ylabel('power','FontSize',16,'position',[3.2 0.5])
  set(gca,'TickDir','out','YTick',[0 1],'FontSize',16)
  box off
  axis off
end
subplot('position',[0.75 0.35 0.2 0.15])
%plot(MUA.spF(gf),x/max(x),'k--','LineWidth',2)
hold on
%plot(MUA.spF(gf),MUA.avspunit(gf)/max(MUA.avspunit(gf)),'k','LineWidth',2)
plot(SP.f(ff),mean(SP.spunit(ff,fGSP)')/max(mean(SP.spunit(ff,fGSP)')),'k','LineWidth',2)
[mx mt] = MaxPeak(SP.f(ff),mean(SP.spunit(ff,fGSP)')');
fprintf(['apc ' num2str(mt) '\n']);
axis tight
ylim([0 1])
ylabel('power','FontSize',16,'position',[3.2 0.5])
set(gca,'TickDir','out','YTick',[0 1],'FontSize',16)
box off



%%
annotation('line',[1 1]*0.85,[0.15 0.95],'LineStyle','--');

annotation('line',[0.68 0.74],[0.9 0.86],'LineStyle','-');
annotation('line',[0.68 0.74],[0.875 0.71],'LineStyle','-');
annotation('line',[0.68 0.74],[0.84 0.56],'LineStyle','-');



%%
text(-24.5,3.9,'A','FontSize',16)
text(-24.5,2.9,'B','FontSize',16)
text(-24.5,2.25,'C','FontSize',16)
text(-24.5,0.7,'D','FontSize',16)
text(-24.5,-0.05,'E','FontSize',16)

text(2,3.9,'F','FontSize',16)
text(2,0.95,'G','FontSize',16)
text(2,-0.4,'H','FontSize',16)
%%


%WaitForButtonpress
%end


FileBase = '2006-6-09_22-24-40/2006-6-09_22-24-40';
PrintFig([FileBase '.SVMUPlotMUA'],0)



return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

