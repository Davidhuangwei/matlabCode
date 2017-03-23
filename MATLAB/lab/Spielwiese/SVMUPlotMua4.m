function SVMUPlotMua4(ALL)
%% function SVMUPlotMua(ALL(23))
%ALL = ALL(20);
%ALL = ALL(23);
MUA = ALL.mua; 
SP = ALL.spect;

GSP = ALL.type.num==2 & ALL.spect.good';

EegRate = ALL.info.EegRate;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% find good episode
FileBase = '2006-6-09_22-24-40/2006-6-09_22-24-40';

a0=0;
b0=3;
numspikes = 3;
numgcells = 0;


n=0;
t2=0;
while t2<MUA.spT(end);
  n=n+1;
  t1(n) = MUA.spT(n);
  t2(n) = MUA.spT(n)+b0;
    
  %% time of spectra
  gtSP = find(MUA.spT>t1(n) & MUA.spT<t2(n));
  %gtSPA = find(MUA.spT>t1 & MUA.spT<t2);
  %gtR = find([1:length(MUA.rate)]/EegRate>t1 & [1:length(MUA.rate)]/EegRate<t2); %2
  
  %% spikes
  ispk = find(MUA.spkt/EegRate>t1(n) & MUA.spkt/EegRate<t2(n)); %3
  
  %% cells
  ind = MUA.spki(ispk);
  h = hist(ind,[min(ind):max(ind)]);
  gcel = find(h>numspikes);
  ngc(n) = length(gcel)/b0;     %% find cells with more than 'numspikes' spikes
  ngcmean(n) = mean(h(gcel))/b0;%% mean of number of spikes/cell/epoch
  ngcstd(n) = std(h(gcel))./mean(h(gcel));  %% standard deviation of number of spikes/cell/epoch
  
  %% calculate mean spect for the 3 sec episode and take max of that
    
  MUf(n) = mean(MUA.mxunitF(gtSP));
  MEf(n) = mean(MUA.mxeegF(gtSP));
  DF(n) = (mean(MUA.mxunitF(gtSP))-mean(MUA.mxeegF(gtSP)))./mean(MUA.mxeegF(gtSP));  
  
  %% quality of spectra
  [gspS(n) gspSa(n)] = GoodSpect(mean(MUA.spectgrunit(gtSP,:))',MUA.spF,[6 12]);
  [gspE(n) gspEa(n)] = GoodSpect(mean(MUA.spectgreeg(gtSP,:))',MUA.spF,[6 12]);
  
end


%% find good episodes
yep = find(gspSa>1 & gspEa>1 & ngc>6); 

%keyboard



figure(4343);clf


subplot(121)
[AV sAV bAV] = MakeAvF([ngc(yep)' ngcmean(yep)'],DF(yep)',10); 
imagesc(bAV{1},bAV{2},AV')
hold on
plot(ngc(yep)',ngcmean(yep)','.k')
axis xy
colorbar
xlabel('cell density')
ylabel('mean mean rate')

subplot(122)
[AV sAV bAV] = MakeAvF([ngc(yep)' ngcstd(yep)'],DF(yep)',10); 
imagesc(bAV{1},bAV{2},AV')
hold on
plot(ngc(yep)',ngcstd(yep)','.k')
axis xy
colorbar
xlabel('cell density')
ylabel('std mean rate')


%keyboard



gi = yep;%find(ngc>numgcells & gspSa>1.2 & gspEa>1.2); %% find episodes with more than 'numgcells' cells
lgi= length(gi)

fprintf(['number of good episodes: ' num2str(lgi) '\n']);


RangT =  NoOverlapRanges([t1(gi)' t2(gi)']);
RangI =  NoOverlapRanges([gi' gi'+(length(MUA.spT)-n)]);

[gtSP gtSPi] = SelectPeriods(MUA.spT,RangI,'d',1,1); %0
gtSP = [1:length(gtSPi)]*MUA.spT(end)/length(MUA.spT);
gtSPA = gtSP;
[gtR gtRi]=    SelectPeriods(MUA.rate,round(RangI/length(MUA.spT)*length(MUA.rate)),'c',1,1); %2
[SpkT ispk]=   SelectPeriods(MUA.spkt,round(RangI/length(MUA.spT)*length(MUA.rate)),'d',1,1); %3
gf = find(MUA.spF>4 & MUA.spF<12);


%gtSP =  WithinRanges(MUA.spT,Ranges); %0
%gtSPA = WithinRanges(MUA.spT,Ranges); %1
%gtR =   WithinRanges([1:length(MUA.rate)]/EegRate,Ranges); %2
%ispk =  WithinRanges(MUA.spkt/EegRate,Ranges); %3


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% make figures

cc1 = [0.94 0 0];
cc2 = [0 0.6 0];

figure(3278467);clf;
%set(gcf,'position',[2200 297 672 627])
set(gcf,'position',[1711  188  600  597])


%%% SPIKES
subplot('position',[0.13 0.83 0.55 0.12])
xs = SpkT/EegRate;
ys = MUA.spki(ispk)-min(MUA.spki);
line([xs';xs'],[ys'-1;ys'+1],'color',[0 0 0],'LineWidth',2);
axis tight
set(gca,'TickDir','out','FontSize',16)
box off
axis off
ax = get(gca,'XLim');
ay = get(gca,'YLim');
text(ax(1)-mean(ax)*0.2, mean(ay)*2/3,'cells','FontSize',16,'Rotation',90)


%%% POP
subplot('position',[0.13 0.7 0.55 0.12])
plot([1:length(gtR)]/EegRate,MUA.rate(gtRi),'color',cc1,'LineWidth',2)
axis tight
set(gca,'TickDir','out','FontSize',16)
box off
axis off
ax = get(gca,'XLim');
ay = get(gca,'YLim');
text(ax(1)-mean(ax)*0.2, ay(1)+diff(ay)*0.25,'POP','FontSize',16,'Rotation',90)


%%% SPECT POP
subplot('position',[0.13 0.5 0.55 0.2])
imagesc(gtSP,MUA.spF(gf),unity(MUA.spectgrunit(gtSPi,gf)'))
axis xy
hold on
plot(gtSP,MUA.mxeegF(gtSPi),'o','markersize',5,'markerfacecolor',[1 1 1]*0,'markeredgecolor',[1 1 1]*0)
set(gca,'TickDir','out','XTick',[],'YTick',[4:2:12],'FontSize',16)
ax = get(gca,'XLim');
ay = get(gca,'YLim');
ylabel('frequency [Hz]','FontSize',16,'position',[ax(1)-mean(ax)*0.16 mean(ay)])
box off


%%% LFP
subplot('position',[0.13 0.35 0.55 0.12])
plot([1:length(gtRi)]/EegRate,MUA.eeg(gtRi),'color',cc2,'LineWidth',2)
axis tight
%%%%xlim([0 3])
set(gca,'TickDir','out','FontSize',16)
box off
axis off
ax = get(gca,'XLim');
ay = get(gca,'YLim');
text(ax(1)-mean(ax)*0.2, ay(1)+diff(ay)*0.25,'LFP','FontSize',16,'Rotation',90)


%%% SPECT LFP
subplot('position',[0.13 0.15 0.55 0.2])
imagesc(gtSP,MUA.spF(gf),(MUA.spectgreeg(gtSPi,gf)'))
axis xy
hold on
plot(gtSP,MUA.mxeegF(gtSPi),'o','markersize',5,'markerfacecolor',[1 1 1]*0,'markeredgecolor',[1 1 1]*0)
set(gca,'TickDir','out','YTick',[4:2:12],'FontSize',16)
xlabel('time [sec]','FontSize',16)
ax = get(gca,'XLim');
ay = get(gca,'YLim');
ylabel('frequency [Hz]','FontSize',16,'position',[ax(1)-mean(ax)*0.16 mean(ay)])
box off
%%

%keyboard

%WaitForButtonpress
%end


%%% LFP VS. POP
subplot('position',[0.75 0.15 0.2 0.15])
x = mean(MUA.spectgreeg(gtSPi,gf));
plot(MUA.spF(gf),x/max(x),'color',cc2,'LineWidth',2)
[mx mt] = MaxPeak(MUA.spF(gf),x');
fprintf(['eeg ' num2str(mt) '\n']);
hold on
x = mean(MUA.spectgrunit(gtSPi,gf));
plot(MUA.spF(gf),x/max(x),'color',cc1,'LineWidth',2)
[mx mt] = MaxPeak(MUA.spF(gf),x');
fprintf(['mua ' num2str(mt) '\n']);
xlabel('frequency [Hz]','FontSize',16)
ylabel('power','FontSize',16,'position',[3.2 0.5])
axis tight
ylim([0 1])
set(gca,'TickDir','out','YTick',[0 1],'FontSize',16)
box off



%unique(MUA.spki(ispk))

h=histc(MUA.spki(ispk),[1:max(MUA.spki)]);  
gh = find(h>3);                            %% good cells with more than 3 spikes 
lh = length(find(h>3));            %% # of good cells


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

%%%% EXAMPLE SPECTS
%ff = find(MUA.spF>6 & MUA.spF<10);
%%fGSP = find();
%[msp mi] = max(MUA.spectgrunit(gtSPi,ff)');
%[ma mai] = sort(msp,'descend');
%pos = [0.8 0.65 0.5];cc = [1:3];
%for n=1:3
%  subplot('position',[0.75 pos(n) 0.2 0.15])
%  plot(MUA.spF(gf),MUA.spectgrunit(gtSPi(mai(cc(n))),gf)/msp(mai(cc(n))),'k','LineWidth',2)
%  [mx mt] = MaxPeak(MUA.spF(gf),MUA.spectgrunit(gtSPi(mai(cc(n))),gf)');
%  fprintf(['pc ' num2str(mt) '\n']);
%  axis tight
%  ylim([0 1])
%  ylabel('power','FontSize',16,'position',[3.2 0.5])
%  set(gca,'TickDir','out','YTick',[0 1],'FontSize',16)
%  box off
%  axis off
%end
%subplot('position',[0.75 0.35 0.2 0.15])
%%plot(MUA.spF(gf),mean(MUA.spectgrunit(gtSPi,gf))/max(mean(MUA.spectgrunit(gtSPi,gf))),'k','LineWidth',2)
%plot(SP.f(ff),mean(SP.spunit(ff,gtSPi)')/max(mean(SP.spunit(ff,gtSPi)')),'k','LineWidth',2)
%[mx mt] = MaxPeak(MUA.spF(gf),mean(MUA.spectgrunit(gtSPi,gf))');
%fprintf(['apc ' num2str(mt) '\n']);
%axis tight
%ylim([0 1])
%ylabel('power','FontSize',16,'position',[3.2 0.5])
%set(gca,'TickDir','out','YTick',[0 1],'FontSize',16)
%box off



%%
annotation('line',[1 1]*0.85,[0.15 0.95],'LineStyle','--');

annotation('line',[0.68 0.74],[0.9 0.86],'LineStyle','-');
annotation('line',[0.68 0.74],[0.875 0.71],'LineStyle','-');
annotation('line',[0.68 0.74],[0.84 0.56],'LineStyle','-');



%%
text(-24,3.9,'A','FontSize',16)
text(-24,2.9,'B','FontSize',16)
text(-24,2.25,'C','FontSize',16)
text(-24,0.7,'D','FontSize',16)
text(-24,-0.05,'E','FontSize',16)

text(2,3.9,'F','FontSize',16)
text(2,0.95,'G','FontSize',16)
text(2,-0.4,'H','FontSize',16)
%%



FileBase = '2006-6-09_22-24-40/2006-6-09_22-24-40';
PrintFig([FileBase '.SVMUPlotMUA'],0)

%keyboard

figure(474)
relfdiff = (MUA.mxunitF(gtSPi)-MUA.mxeegF(gtSPi))./MUA.mxeegF(gtSPi);
plot(numgcells,(MUA.mxunitF(gtSPi)-MUA.mxeegF(gtSPi))./MUA.mxeegF(gtSPi),'o','markersize',5,'markeredgecolor',[0.5 0.5 1],'markerfacecolor',[0.5 0.5 1])
hold on

mmm(mm) =  mean((MUA.mxunitF(gtSPi)-MUA.mxeegF(gtSPi))./MUA.mxeegF(gtSPi));



plot([1:length(mmm)],mmm,'o','markersize',7,'markeredgecolor',[1 1 1]*0.3,'markerfacecolor',[1 1 1]*0.3)

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

