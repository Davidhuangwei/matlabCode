fileBase = 'sm9603m2_206_s1_249'
remTimes = LoadVar([fileBase '/RemTimes'])
load([fileBase '/spectrograms/' fileBase '.eegWin1250Ovrlp938NW1.5_mtpsg_39.mat'])

remInd = find(to>=remTimes(1,1),1):find(to<=remTimes(1,2),1,'last');
%ImageScInterp({to(remInd),fo,10*log10(yo(:,remInd)./repmat(mean(yo(:,remInd),2),1,size(yo(:,remInd),2)))},1) 
%ImageScInterp({to(remInd),fo,10*log10(yo(:,remInd))},1) 

clf
%subplot(7,1,1:2)
hold on
yo = Conv2Trim(gaussWin(8),gaussWin(8),yo);
ImageScInterp({to(remInd),flipdim(fo,1),10*log10(flipdim(yo(:,remInd),1))},0) 
%imagesc(to(remInd),fo,10*log10(yo(:,remInd))) 
 thetaPeak = FindSpectPeak01(permute(yo,[2 3 1]),fo,[4 12]);
 smoothWinSize = 10;
 smoothWin = [gausswin(smoothWinSize)/sum(gausswin(smoothWinSize))];
 %smoothWin = [hanning(smoothWinSize)/sum(hanning(smoothWinSize))];
 %smoothWin = ones(1,smoothWinSize)/smoothWinSize;
 freq = ConvTrim(thetaPeak,smoothWin);
 hold on
 plot(to(remInd),freq(remInd),'k')
set(gca,'ylim',[0 150])
 set(gca,'xlim',to(remInd([1 end])))
 grid on
    
 
 mother = 'MORLET';
wavParam=6;
N = winLength;
 DJ = 1/18;
 S0 = 4;
 J1 = round(log2(N/S0)/(DJ)-1.3/DJ);
 dt = 1;
 pad = 1;

 winLen =1250;
eegSamp = 1250;
fileBase ='sm9603m2_211_s1_254';
 eeg = readmulti([fileBase '/' fileBase '.eeg'],97,37);
 %eeg = eeg(remTimes(1)*eegSamp:remTimes(2)*eegSamp);
statThetaJs = [5 49 61 123 167];
 j=0
 while j<length(eeg)+winLen
     [wave period scale,coi] = wavelet(eeg(j+1:j+winLen),dt,pad,DJ,S0,J1,mother,wavParam);
     clf
     fo = 1./period.*eegSamp;
     wave = wave.*conj(wave);
     thetaPeak = FindSpectPeak01(permute(wave,[2,3,1]),fo,[4 12]);
     %pcolor(1:winLength,fo,10*log10(wave))
     pcolor(1:winLength,fo,abs(10*log10(wave./repmat(mean(wave,2),1,size(wave,2)))))
     shading interp
     hold on
     plot(1:winLength,1./coi.*eegSamp,'k')
     plot(thetaPeak,'r','linewidth',3)
     set(gca,'ylim',[0 100])
     %set(gca,'clim',[0 80])
     set(gca,'clim',[0 5])
     colorbar
     time = j/winLen
     j=j+winLen;
     pause
 end
 
 
winLen =1250;

widthRange = [1/10:1/5:10];
heightRange = [0:0.1:4];
offSetRange = [-winLen:winLen/25:winLen];

width = 1;
height = 4;
offset = -winLen*9/10;
hanWinSize = winLen*width;
hannWin = hann(hanWinSize)*height+1;
pad = ones(winLen*100,1);
pad(floor((length(pad)-hanWinSize)/2+1):ceil((length(pad)+hanWinSize)/2)) = ...    
    hann(hanWinSize)*4+1;

hannWin = pad(round((length(pad)-winLen)/2)+1+offset:round((length(pad)+winLen)/2)+offset);
plot(hannWin)
set(gca,'xlim',[0 1250],'ylim',[0 6])


hanWinSize = winLen*1;
hannWin = hann(hanWinSize)*4+1;
if hanWinSize < winLen
    hannWin = [ones(floor((winLen-hanWinSize))/2+1,1); hannWin; ones(ceil((winLen-hanWinSize))/2,1)];
    hanWinSize = length(hannWin);
end
hannWin = hannWin(round((hanWinSize-winLen)/2)+1:round((hanWinSize+winLen)/2));
plot(hannWin)
set(gca,'xlim',[0 1250],'ylim',[0 6])

