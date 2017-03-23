function PlotAveActiv_Kamran(varargin)
[FileBase,Eeg,whl,overwriteSP] = DefaultArgs(varargin,{'2006-6-08_14-26-15/2006-6-08_14-26-15',[],[],0});

%% FileBase = '2006-6-08_14-26-15/2006-6-08_14-26-15'; Eeg = GetEEG(FileBase); whl = GetWhl(FileBase,0,[1 length(Eeg)]);
%% PlotAveActiv_Kamran(FileBase,Eeg,whl)

%if isempty(Eeg)
%  Eeg = GetEEG(FileBase); 
%end
if isempty(whl)
  whl = GetWhl(FileBase,0,[1 length(Eeg)]);
end

load([FileBase '.INspike.mat']);

SampleRate = 32552;
EegRate = 1252;

region = [1:8];  %% CA3
%region = [9:12]; %% CA1

%% Find Good Theta
elc = InternElc(FileBase);
spike=FindGoodTheta(FileBase,spike);


%% Load Eeg og Theta-Periods
if isempty(Eeg)
  Periods = load([FileBase '.sts.RUN']);
  Eeg = GetEEG(FileBase,Periods); 
end


%% CA1 PS and interneurons
PC = find(ismember(spike.qclu, [1 2 4 6 7 8 9]) & ismember(spike.shank,region) & spike.good);
%PC = find(ismember(spike.qclu, [1 2]) & ismember(spike.shank,region) & spike.good);
IN = find(spike.qclu == 5 & ismember(spike.shank,region) & spike.good);

STP = spike.t(PC);
SIP = spike.aclu(PC);

STI = spike.t(IN);
SII = spike.aclu(IN);


% ==============================================================
if 0
  %% CCGs
  [ccgPC, t] = CCG(spike.t(PC),spike.aclu(PC),200,50,SampleRate);
  for n=1:size(ccgPC,2);
    ccgM(:,n) = ccgPC(:,n,n);
  end
  [ccgPCA, t] = CCG(spike.t(PC),1,200,50,SampleRate);
  
  %% USE CCG TO DEREMINE THE SIGNIFICANCE OF THE THETA MODULATION
  %%      ====>> HOW TO DETERMINE THE SIGNIFICANCE OF THE THETA PEAK????
end
% ==============================================================


%% Spectra
Res = round(spike.t(PC)/SampleRate*EegRate); %% in Eeg rate!!!!!
Clu = spike.aclu(PC);
ResI = round(spike.t(IN)/SampleRate*EegRate); %% in Eeg rate!!!!!
CluI = spike.aclu(IN);
nFFT = 2^12;
Fs = EegRate;
nOverlap = [];
NW = 1;  %% ~5 for gamma
Detrend = 'linear';
nTapers = [];
FreqRange = [1 100];
CluSubset = [];
pval = []; 
WinLength = 2^10;%512;

NN = unique(Clu)';
if ~FileExists([FileBase '.spectra']) | overwriteSP
  m=0;
  for n=NN
    m=m+1
    n
    xRes = Res(find(Clu==n));
    xClu = Clu(find(Clu==n));
    if length(xRes)<50
      m=m-1;
      continue;
    end
    [SP,f]=mtptcsd(Eeg,xRes,xClu,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,FreqRange);
    xSp(:,m) = SP(:,2,2);
  end
  save([FileBase '.spectra'],'f','xSp')
else
  load([FileBase '.spectra'],'-MAT')
end
[SPA,f]=mtptcsd(Eeg,Res,ones(size(Res)),nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,FreqRange);

NN = unique(CluI)';
if ~FileExists([FileBase '.spectraIN']) | overwriteSP
  m=0;
  for n=NN
    m=m+1
    n
    xRes = ResI(find(CluI==n));
    xClu = CluI(find(CluI==n));
    if length(xRes)<50
      m=m-1;
      continue;
    end
    [SP,f]=mtptcsd(Eeg,xRes,xClu,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,FreqRange);
    xSpI(:,m) = SP(:,2,2);
  end
  save([FileBase '.spectraIN'],'f','xSpI')
else
  load([FileBase '.spectraIN'],'-MAT')
end
[SPAI,f]=mtptcsd(Eeg,ResI,ones(size(ResI)),nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,FreqRange);

%ResSp = Res+round(rand(length(Res),1)*0.01*EegRate);
%[SPAsp,f]=mtptcsd(Eeg,ResSp,ones(size(Res)),nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,FreqRange);

gf = find(f>4 & f<15);
[PowP PowI] = max(xSp(gf,:),[],1); %% PC unit
[APowP APowI] = max(SPA(gf,2,2),[],1); %% PC multiunit
[PowPI PowII] = max(xSpI(gf,:),[],1); %% IN unit
[APowPI APowII] = max(SPAI(gf,2,2),[],1); %% IN multiunit
[EPowP EPowI] = max(SPA(gf,1,1),[],1); %% LFP


%% Figures - Spectra 
[MEeg IEeg] = max(SPA(gf,1,1));
figure(442);clf;
subplot(511)
plot(f(gf),log(xSp(gf,1)),'color',[0 0 0],'LineWidth',2)
axis tight
[M I] = max(xSp(gf,1));
fm = mean(f(gf(PowI)));
Lines(f(gf(I)),[],[1 1 1]*0,'--',1);
Lines(fm,[],[0 0 1],'--',2)
Lines(f(gf(IEeg)),[],[],'--',2);
ll = (3*max(log(xSp(gf,1)))+min(log(xSp(gf,1))))/4;
text(11,ll,['f=' sprintf('%1.2f',f(gf(I))) '; f_m=' sprintf('%1.2f',fm)],'FontSize',16)
ylabel('power','FontSize',16)
title('pyramidal cell','FontSize',16)
set(gca,'TickDir','out','FontSize',16)

subplot(512)
plot(f(gf),log(SPA(gf,2,2)),'color',[0 0 0],'LineWidth',2)
axis tight
[M I] = max(SPA(gf,2,2));
Lines(f(gf(I)),[],[1 1 1]*0,'--',1);
Lines(f(gf(IEeg)),[],[],'--',2);
ll = (3*max(log(SPA(gf,2,2)))+min(log(SPA(gf,2,2))))/4;
text(11,ll,['f=' sprintf('%1.2f',f(gf(I)))],'FontSize',16)
ylabel('power','FontSize',16)
title('multi unit','FontSize',16)
set(gca,'TickDir','out','FontSize',16)

subplot(513)
plot(f(gf),log(xSpI(gf,1)),'color',[0 0 0],'LineWidth',2)
axis tight
[M I] = max(xSpI(gf,1));
fm = mean(f(gf(PowII)));
Lines(f(gf(I)),[],[1 1 1]*0,'--',1);
Lines(fm,[],[0 0 1],'--',2)
Lines(f(gf(IEeg)),[],[],'--',2);
ll = (3*max(log(xSpI(gf,1)))+min(log(xSpI(gf,1))))/4;
text(11,ll,['f=' sprintf('%1.2f',f(gf(I))) '; f_m=' sprintf('%1.2f',fm)],'FontSize',16)
ylabel('power','FontSize',16)
title('interneuron','FontSize',16)
set(gca,'TickDir','out','FontSize',16)

subplot(514)
plot(f(gf),log(SPAI(gf,2,2)),'color',[0 0 0],'LineWidth',2)
axis tight
[M I] = max(SPAI(gf,2,2));
Lines(f(gf(I)),[],[1 1 1]*0,'--',1);
Lines(f(gf(IEeg)),[],[],'--',2);
ll = (3*max(log(SPAI(gf,2,2)))+min(log(SPAI(gf,2,2))))/4;
text(11,ll,['f=' sprintf('%1.2f',f(gf(I)))],'FontSize',16)
ylabel('power','FontSize',16)
title('multi unit','FontSize',16)
set(gca,'TickDir','out','FontSize',16)

subplot(515)
plot(f(gf),log(SPA(gf,1,1)),'color',[0 0 0],'LineWidth',2)
axis tight
Lines(f(gf(IEeg)),[],[],'--',2);
ll = (3*max(log(SPA(gf,1,1)))+min(log(SPA(gf,1,1))))/4;
text(11,ll,['f=' sprintf('%1.2f',f(gf(IEeg)))],'FontSize',16)
set(gca,'TickDir','out','FontSize',16)
xlabel('frequency [Hz]')
ylabel('power','FontSize',16)
title('LFP','FontSize',16)

ForAllSubplots('axis tight')  
ForAllSubplots('box off')  


figure(47);clf
subplot(5,1,[1 2])
imagesc(f(gf),[],unity(xSp(gf,:))')
Lines(f(gf(I)),[],[0 0 0],'--',2);
axis xy
set(gca,'TickDir','out','FontSize',16)
ylabel('pyramidal cell #','FontSize',16)
%title('pyramidal cells','FontSize',16)
box off
hold on
plot(f(gf(PowI)),[1:length(PowI)],'o','markersize',5,'markerfacecolor',[1 1 1]*0,'markeredgecolor',[1 1 1]*0)

subplot(5,1,[3 4])
imagesc(f(gf),[],unity(xSpI(gf,:))')
Lines(f(gf(I)),[],[0 0 0],'--',2);
axis xy
set(gca,'TickDir','out','FontSize',16)
ylabel('interneuron #','FontSize',16)
%title('interneurons','FontSize',16)
box off
hold on
plot(f(gf(PowII)),[1:length(PowII)],'o','markersize',5,'markerfacecolor',[1 1 1]*0,'markeredgecolor',[1 1 1]*0)

subplot(515)
plot(f(gf),log(SPA(gf,1,1)),'color',[0 0 0],'LineWidth',2)
axis tight
[M I] = max(SPA(gf,1,1));
Lines(f(gf(I)),[],[0 0 0],'--',2);
text(13,9,['f=' sprintf('%1.2f',f(gf(I)))],'FontSize',16)
set(gca,'TickDir','out','FontSize',16)
xlabel('frequency [Hz]')
ylabel('LFP power','FontSize',16)
%title('LFP','FontSize',16)
box off





if 0
  
%% Figure - Illustration
%% select firing interval
ask = 0;%input('Do you want to pick the interval? [0/1] ');

if ask
  figure(666)
  subplot(311)
  %plot([1:length(whl.speed)]/whl.rate,whl.speed)
  plot([1:length(whl.speed)]/whl.rate,[whl.ctr(:,1) whl.ctr(:,2)])
  axis tight
  subplot(312)
  [H,HN] = hist(STP/SampleRate,50000);
  bar(HN,H);
  axis tight
  subplot(313)
  plot([1:length(Eeg)]/EegRate,Eeg)
  axis tight
  
  xlm = get(gca,'XLim');
  ylm = get(gca,'YLim');
  xlim(xlm)
  ylim(ylm)
  
  while 1
    xa = ginput(1)
    if xa(1)>xlm(2) | xa(1)<xlm(1)
      break
    end
    if xa(2)>ylm(2) | xa(2)<ylm(1)
      break
    end
    xb = ginput(1);
    ForAllSubplots(['xlim([' num2str(xa(1)) ' '  num2str(xb(1)) '])'])
    xlm = [xa(1) xb(1)];
  end
  
else
  
  %% identify samples for whl, spikes and eeg
  xa(1) = 943;
  xb(1) = 945;
  
end
  
BinWhl = [1:length(whl.speed)]/whl.rate;
BinEeg = [1:length(Eeg)]/EegRate;

aw = [round(xa(1)*whl.rate):round(xb(1)*whl.rate)];
asp = find(STP>xa(1)*SampleRate & STP<xb(1)*SampleRate);
asi = find(STI>xa(1)*SampleRate & STI<xb(1)*SampleRate);
ae = [round(xa(1)*EegRate):round(xb(1)*EegRate)];

%% Theta Phase
[ThetaPhase, ThetaAmp, TotPhase, Eegf] = myThetaPhase(Eeg, [],[],[],EegRate);
ThMin = LocalMinima(Eegf);
gThMin = ThMin(find(ThMin>ae(1) & ThMin<ae(end)))/EegRate;

%% Spike Rate
RateBin = [xa(1)*SampleRate:xb(1)*SampleRate];
Rate = histcI(STP(asp),[xa(1)*SampleRate:xb(1)*SampleRate]);
CG = exp(-([-1000:1000]).^2/(200)^2);
CC = Filter0(CG,Rate);
[RPhase, RAmp, RTotPhase, Ratef] = myThetaPhase(CC, [],[],[],SampleRate);

figure(666);clf
subplot(411)
%plot(BinWhl(aw),whl.speed(aw))
plot(BinWhl(aw),[whl.ctr(aw,1) whl.ctr(aw,2)])
ylabel('running speed')
axis tight

subplot(813)
plot(STP(asp)/SampleRate,SIP(asp),'.')
axis tight
box off
subplot(814)
[H,HN] = hist(STP(asp)/SampleRate,round((xb(1)-xa(1))*100));
bar(HN,H);
hold on
plot(RateBin(2:end)/SampleRate,Ratef+abs(min(Ratef)),'r')
axis tight
Lines(gThMin);

subplot(815)
plot(STI(asi)/SampleRate,SII(asi),'.')
axis tight
box off
subplot(816)
[H,HN] = hist(STI(asi)/SampleRate,round((xb(1)-xa(1))*100));
bar(HN,H);
axis tight
Lines(gThMin);

subplot(414)
plot(BinEeg(ae),Eeg(ae))
hold on
plot(BinEeg(ae),Eegf(ae),'r')
xlabel('time [sec]')
ylabel('LFP');
axis tight
Lines(gThMin);

ForAllSubplots(['xlim([' num2str(xa(1)) ' '  num2str(xb(1)) '])'])

end


return;

