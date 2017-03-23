%% Spectra
Res = round(spike.t(PC)/SampleRate*EegRate); %% in Eeg rate!!!!!
Clu = spike.aclu(PC);
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

clear xSp;

m=0;
for n=NN(1:2)
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

gf = find(f>4 & f<15);
[PowP PowI] = max(xSp(gf,:),[],1);

figure(47);clf
subplot(3,1,[1 2])
imagesc(f(gf),[],unity(xSp(gf,:))')
Lines(f(gf(I)),[],[0 0 0],'--',2);
axis xy
set(gca,'TickDir','out','FontSize',16)
xlabel('frequency [Hz]')
ylabel('cell #','FontSize',16)
title('LFP','FontSize',16)
box off

subplot(313)
plot(f(gf),xSp(gf,:),'color',[0 0 0],'LineWidth',2)
axis tight
set(gca,'TickDir','out','FontSize',16)
xlabel('frequency [Hz]')
ylabel('power','FontSize',16)
title('LFP','FontSize',16)
box off

