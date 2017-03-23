function SVMUPlotMua5b(ALL)
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

a0 = 52; b0 = 57;
a1 = 53; b1 = 55.5;
a2 = 53; b2 = 56;
a3 = 52; b3 = 56;

a0 = 51; b0 = 55;
a1 = 52; b1 = 55;
a2 = 52; b2 = 55;
a3 = 52; b3 = 55;




%a0 = 305; b0 = 320;
%a1 = a0+1; b1 = b0;
%a1 = 200; b1 = b0;
%a2 = a0+1; b2 = b0;
%a3 = a0+1; b3 = b0;
%%a3 = 200; b3 = 320;



gtSP = find(MUA.spT>a0 & MUA.spT<b0); %0
gtSPA = find(MUA.spT>a1 & MUA.spT<b1); %1
gtR = find([1:length(MUA.rate)]/EegRate>a2 & [1:length(MUA.rate)]/EegRate<b2); %2
gf = find(MUA.spF>4 & MUA.spF<12);
ispk = find(MUA.spkt/EegRate>a3 & MUA.spkt/EegRate<b3); %3


%% number of spikes
ind = MUA.spki(ispk);

h = hist(ind,[min(ind):max(ind)]);
sdf=length(find(h>3));
dfg=length(find(h>3))/(b3-a3);
nh = length(unique(ind));

fprintf(['tot num of cells: ' num2str(nh) '\n']);
fprintf(['num of cells with more than 3 spikes:' num2str(sdf) ' || num of good cells/sec ' num2str(dfg) '\n']);
fprintf(['num of good cells/sec ' num2str(dfg) '\n']);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% make figures

cc1 = [0.94 0 0];
cc2 = [0 0.6 0];

figure(3278463);

%% jitter spikes:
isp = unique(ind);
INDSP = MUA.spki;%(ispk);
TSP = MUA.spkt;%(ispk);

%% loop over several realizations of the 
NN = 20;
for m=1:NN

  JittS = round(EegRate/400*m);

  m
  if m>1
    for n=isp'
      id = find(INDSP==n);
      TSP(id) = TSP(id) + randi([-JittS JittS],size(id));
    end
    TSP(find(TSP>length(MUA.rate))) = length(MUA.rate);
    TSP(find(TSP<1)) = 1;
  end
  
  % compute POP rate
  [Rate RBin] = InstantRate(ALL.info.FileBase,sort(TSP),ones(size(TSP)),1);
  
  if length(Rate)<length(MUA.rate)
    Rate = [Rate; zeros(length(MUA.rate)-length(Rate),1)];
  elseif length(Rate)>length(MUA.rate)
    nRate = Rate(1:length(MUA.rate)); clear Rate;
    Rate = nRate;
  end
  MRate = ButFilter(Rate,1,4/(EegRate/2),'high');
  
  %% coherence
  wstep = 1/4;
  WinLength = 2^11;%512;
  
  nFFT = 2^12;
  Fs = EegRate;
  NW = 2;  %% ~5 for gamma
  Detrend = 'linear';
  nTapers = [];
  FreqRange = [1 20];
  CluSubset = [];
  pval = []; 
  nOverlap = WinLength*(1-wstep);
  
  [yo,fo,to] = mtptchglong(MUA.eeg,sort(TSP),ones(size(TSP)),nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,FreqRange,CluSubset);
  
  JSP(:,:,m) = sq(yo(:,:,2,2));
end

%keyboard

%% Good Spect and max of average spect
DD = sq(mean(JSP(gtSPA,:,:),1));
[GSP GSPA] = GoodSpect(DD,fo,[6 12],[],[],[],ones(NN,1));
[dummy maxfo] = MaxPeak(fo,DD,[6 12]);


%% average spectra
noJSP = sq(mean(JSP(gtSPA,gf,1),1));

mJSP = sq(mean(JSP(gtSPA,gf,2:end),1));

amJSP = mean(mJSP');
asJSP = std(mJSP');
FSP = fo(gf);


%% P L O T

y = mean(MUA.spectgreeg(gtSPA,gf));
[mx mt1] = MaxPeak(MUA.spF(gf),y');
x = noJSP;
[mx mt2] = MaxPeak(MUA.spF(gf),x');


%% how good are the spectra??
subplot('position',[0.55 0.15 0.25 0.25])
plot(maxfo,GSPA,'o','markersize',5,'markeredgecolor',[0.5 0.5 1],'markerfacecolor',[0.5 0.5 1])
hold on
plot(maxfo(1),GSPA(1),'o','markersize',10,'markeredgecolor',[1 0 0],'markerfacecolor',[1 0 0])
axis tight
xlim([6 12])
ylim([0 2])
Lines(mean([mt1 mt2]),[],'k','--');
xlabel('peak frequency [Hz]','FontSize',16)
ylabel('theta/delta ratio','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off


keyboard




FileBase = '2006-6-09_22-24-40/2006-6-09_22-24-40';
PrintFig([FileBase '.SVMUPlotMUA5'],0)



return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

