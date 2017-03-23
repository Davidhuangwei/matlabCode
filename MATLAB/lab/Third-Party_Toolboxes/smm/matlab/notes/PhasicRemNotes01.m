 
fileBase = 'sm9603m2_206_s1_249'
remTimes = LoadVar([fileBase '/RemTimes'])
load([fileBase '/spectrograms/' fileBase '.eegWin1250Ovrlp938NW1.5_mtpsg_39.mat'])

remInd = find(to>=remTimes(1,1),1):find(to<=remTimes(1,2),1,'last');
%ImageScInterp({to(remInd),fo,10*log10(yo(:,remInd)./repmat(mean(yo(:,remInd),2),1,size(yo(:,remInd),2)))},1) 
%ImageScInterp({to(remInd),fo,10*log10(yo(:,remInd))},1) 

clf
subplot(7,1,1:2)
hold on
ImageScInterp({to(remInd),flipdim(fo,1),10*log10(flipdim(yo(:,remInd),1))},0) 
%imagesc(to(remInd),fo,10*log10(yo(:,remInd))) 
 thetaPeak = FindSpectPeak01(permute(yo,[2 3 1]),fo,[4 12]);
 smoothWinSize = 24;
 smoothWin = [gausswin(smoothWinSize)/sum(gausswin(smoothWinSize))];
 %smoothWin = [hanning(smoothWinSize)/sum(hanning(smoothWinSize))];
 %smoothWin = ones(1,smoothWinSize)/smoothWinSize;
 freq = ConvTrim(thetaPeak,smoothWin);
 hold on
 plot(to(remInd),freq(remInd),'k')
set(gca,'ylim',[4 12])
 set(gca,'xlim',to(remInd([1 end])))
 set(gca,'clim',[75 90])
 grid on
 
smoothWinSize = 24;
smoothWin = [gausswin(smoothWinSize)/sum(gausswin(smoothWinSize))];
dFreq = [0; diff(freq)];
dFreq = ConvTrim(dFreq,smoothWin);
ddFreq = [0; diff(freq,2); 0];
ddFreq = ConvTrim(ddFreq,smoothWin);
subplot(7,1,3)
plot(to(remInd),dFreq(remInd))
ylabel('dFreq');
set(gca,'xlim',to(remInd([1 end])))
grid on
% set(gca,'xlim',[1 length(remInd)])
subplot(7,1,4)
plot(to(remInd),ddFreq(remInd))
ylabel('ddFreq');
set(gca,'xlim',to(remInd([1 end])))
grid on


for j=1:length(thetaPeak)
    roughPow(j) = 10*log10(yo(find(abs(fo-freq(j))==...
        min(abs(fo-freq(j))),1),j));
end
% clf
% plot(roughPow(remInd))
% hold on
smoothWinSize = 24;
smoothWin = [gausswin(smoothWinSize)/sum(gausswin(smoothWinSize))];
pow = ConvTrim(roughPow,smoothWin);
% plot(pow(remInd),'r')
smoothWinSize = 24;
smoothWin = [gausswin(smoothWinSize)/sum(gausswin(smoothWinSize))];
dpow = [0 diff(pow)];
dpow = ConvTrim(dpow,smoothWin);
ddpow = [0 diff(pow,2) 0];
ddpow = ConvTrim(ddpow,smoothWin);
subplot(7,1,5)
plot(to(remInd),pow(remInd))
ylabel('pow');
set(gca,'xlim',to(remInd([1 end])))
grid on
subplot(7,1,6)
plot(to(remInd),dpow(remInd))
ylabel('dpow');
set(gca,'xlim',to(remInd([1 end])))
grid on
subplot(7,1,7)
plot(to(remInd),ddpow(remInd))
ylabel('ddpow');
set(gca,'xlim',to(remInd([1 end])))
grid on

timeOffset = 2; %sec
toOffset = find(abs(to-timeOffset) == min(abs(to-timeOffset)),1);
xgobi([freq(remInd(toOffset+1:end)) dFreq(remInd(1:end-toOffset)) pow(remInd(toOffset+1:end))' dpow(remInd(1:end-toOffset))' ]);

glyphs = load(['PhasicRemCategSm24Off2.glyphs'],'ascii');
glyphNums = unique(glyphs)
colors = 'gbrck'
subplot(7,1,3)
hold on
for j=1:length(glyphNums)
    plot(to(remInd(find(glyphs==glyphNums(j))+toOffset)),dFreq(remInd(find(glyphs==glyphNums(j))+toOffset)),['.' colors(j)])
end
subplot(7,1,5)
hold on
for j=1:length(glyphNums)
    plot(to(remInd(find(glyphs==glyphNums(j))+toOffset)),pow(remInd(find(glyphs==glyphNums(j))+toOffset)),['.' colors(j)])
end

 
 