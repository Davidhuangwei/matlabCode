function SVMUPlotMua6(ALL)
%% function SVMUPlotMua(ALL(23))
%%
%% SVMUPlotMua6(ALL([2 23]))



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2 %% 

MUA = ALL(1).mua; 
SP = ALL(1).spect;
GSP = ALL(1).type.num==2 & ALL(1).spect.good';
EegRate = ALL(1).info.EegRate;


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
  
  %% spikes
  ispk = find(MUA.spkt/EegRate>t1(n) & MUA.spkt/EegRate<t2(n)); %3
  
  %% cells
  ind = MUA.spki(ispk);
  h = hist(ind,[min(ind):max(ind)]);
  gcel = find(h>numspikes);
  ngc1(n) = length(gcel)/b0;     %% find cells with more than 'numspikes' spikes
  %ngcmean(n) = mean(h(gcel))/b0;%% mean of number of spikes/cell/epoch
  %ngcstd(n) = std(h(gcel))./mean(h(gcel));  %% standard deviation of number of spikes/cell/epoch
  
  %% calculate mean spect for the 3 sec episode and take max of that
    
  MUf(n) = mean(MUA.mxunitF(gtSP));
  MEf(n) = mean(MUA.mxeegF(gtSP));
  %DF(n) = (mean(MUA.mxunitF(gtSP))-mean(MUA.mxeegF(gtSP)))./mean(MUA.mxeegF(gtSP));  
  DF1(n) = (mean(MUA.mxunitF(gtSP))-mean(MUA.mxeegF(gtSP)));  
  
  %% quality of spectra
  [gspS(n) gspSa1(n)] = GoodSpect(mean(MUA.spectgrunit(gtSP,:))',MUA.spF,[6 12]);
  [gspE(n) gspEa1(n)] = GoodSpect(mean(MUA.spectgreeg(gtSP,:))',MUA.spF,[6 12]);
  
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 23 %% 

MUA = ALL(2).mua; 
SP = ALL(2).spect;
GSP = ALL(2).type.num==2 & ALL(2).spect.good';
EegRate = ALL(2).info.EegRate;


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
  
  %% spikes
  ispk = find(MUA.spkt/EegRate>t1(n) & MUA.spkt/EegRate<t2(n)); %3
  
  %% cells
  ind = MUA.spki(ispk);
  h = hist(ind,[min(ind):max(ind)]);
  gcel = find(h>numspikes);
  ngc2(n) = length(gcel)/b0;     %% find cells with more than 'numspikes' spikes
  %ngcmean(n) = mean(h(gcel))/b0;%% mean of number of spikes/cell/epoch
  %ngcstd(n) = std(h(gcel))./mean(h(gcel));  %% standard deviation of number of spikes/cell/epoch
  
  %% calculate mean spect for the 3 sec episode and take max of that
    
  MUf(n) = mean(MUA.mxunitF(gtSP));
  MEf(n) = mean(MUA.mxeegF(gtSP));
  %DF(n) = (mean(MUA.mxunitF(gtSP))-mean(MUA.mxeegF(gtSP)))./mean(MUA.mxeegF(gtSP));  
  DF2(n) = (mean(MUA.mxunitF(gtSP))-mean(MUA.mxeegF(gtSP)));  
  
  %% quality of spectra
  [gspS(n) gspSa2(n)] = GoodSpect(mean(MUA.spectgrunit(gtSP,:))',MUA.spF,[6 12]);
  [gspE(n) gspEa2(n)] = GoodSpect(mean(MUA.spectgreeg(gtSP,:))',MUA.spF,[6 12]);
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


DF = [DF1 DF2];
gspSa = [gspSa1 gspSa2];
gspEa = [gspEa1 gspEa2];
ngc = [ngc1 ngc2];


%% find good episodes
yep = find(gspSa>1 & gspEa>1); 



%gi = yep;%find(ngc>numgcells & gspSa>1.2 & gspEa>1.2); %% find episodes with more than 'numgcells' cells
%lgi= length(gi)
%fprintf(['number of good episodes: ' num2str(lgi) '\n']);
%RangT =  NoOverlapRanges([t1(gi)' t2(gi)']);
%RangI =  NoOverlapRanges([gi' gi'+(length(MUA.spT)-n)]);%
%[gtSP gtSPi] = SelectPeriods(MUA.spT,RangI,'d',1,1); %0
%gtSP = [1:length(gtSPi)]*MUA.spT(end)/length(MUA.spT);
%gtSPA = gtSP;
%[gtR gtRi]=    SelectPeriods(MUA.rate,round(RangI/length(MUA.spT)*length(MUA.rate)),'c',1,1); %2
%[SpkT ispk]=   SelectPeriods(MUA.spkt,round(RangI/length(MUA.spT)*length(MUA.rate)),'d',1,1); %3
%gf = find(MUA.spF>4 & MUA.spF<12);



figure(984);clf
set(gcf,'position',[1829         115         696         854])


subplot('position',[0.12 0.12 0.665 0.2])
plot(ngc(yep)+(rand(size(yep))-0.5)*0.3,DF(yep),'o','markersize',5,'markeredgecolor',[0.5 0.5 1],'markerfacecolor',[0.5 0.5 1])
set(gca,'TickDir','out','FontSize',16)
box off
xlim([0 10])
ylim([-2 3])
xlabel('place field density [cell/sec]','FontSize',16)
ylabel('\Delta frequency [Hz]','FontSize',16)
Lines([],0,[0.6 0 0],'--',2);

text(-1.4,4.5,'E','FontSize',16)


subplot('position',[0.12 0.32 0.665 0.08])
bin = [0:0.3:10];
pbin = bin(2:end)-0.15;
h = histcI(ngc(yep)+(rand(size(yep))-0.5)*0.3,bin);
b=bar(pbin,h);
set(b,'BarWidth',1,'FaceColor',[0.5 0.5 1])
box off
axis off

subplot('position',[0.785 0.12 0.08 0.2])
bin = [-2:0.3:3];
pbin = bin(2:end)-0.15;
h = histcI(DF(yep),bin);
b=barh(pbin,h);
set(b,'BarWidth',1,'FaceColor',[0.5 0.5 1])
box off
axis off




%keyboard

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% make figures



PrintFig(['SVMUPlotMUAhistgrp'],0)




return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

