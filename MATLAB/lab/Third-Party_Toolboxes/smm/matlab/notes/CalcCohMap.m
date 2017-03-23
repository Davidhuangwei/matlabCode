function CalcCoh(fileBaseMat,fileExt,nChan,refChan,freqRange,winLength)


% fileBase = 'sm9603m2_237_s1_281';
% fileExt = '_LinNearCSD121.csd';
%badChan = load(['ChanInfo/BadChan' fileExt '.txt']);
%chanMat = LoadVar(['ChanInfo/ChanMat' fileExt '.mat']);
%eegChanMat = LoadVar(['ChanInfo/ChanMat.eeg.mat']);
% nChan = load(['ChanInfo/NChan' fileExt '.txt']);
% plotSize = size(eegChanMat);
% plotOffset = load(['ChanInfo/Offset' fileExt '.txt']);
% 
% refChan = 48;
% winLength = 0.25;
%freqRange = [40 120];
 plotChan = 27;

whlSamp = 39.065;
eegSamp = 1250;
bps = 2;


params.tapers = [0.5 1]
params.Fs = eegSamp;
params.fpass = freqRange;

avgfilorder = round(winLength*whlSamp/2);
avgfiltb = ones(avgfilorder,1)/avgfilorder; 

for k=1:length(fileBaseMat)
    fileBase = fileBaseMat{k};

    whl = load([fileBase '/' fileBase '.whl']);
gammaCoh = [];
cohSave = [];
n=0;
for j=1:size(whl,1)
    time = j/whlSamp;
    eegTime = round(time*eegSamp);
    eeg = bload([fileBase '/' fileBase fileExt],[nChan round(eegSamp*winLength)],eegTime*nChan*bps);
    [coh junk1 junk2 junk3 junk4 fo] = coherencyc(repmat(eeg(refChan,:)',1,size(eeg,1)),eeg',params);
    coh = ATanCoh(coh);
    if ~isempty(cohSave)
        cohSave = cohSave+coh;
    else cohSave = coh;
    end
    n = n+1;
    gammaCoh(j,:) = mean(coh);
%     clf
%     subplot(1,2,1)
%     imagesc(Make2DPlotMat(gammaCoh(j,:)',chanMat,badChan,'linear'));
%     PlotAnatCurves('../ChanInfo/AnatCurves.mat',plotSize,0.5-plotOffset);
%     set(gca,'clim',[0.5 1])
%     colorbar
%     subplot(1,2,2)
%     hold on
%      plot(fo,coh(:,plotChan));
%     plot([fo(1) fo(end)],[gammaCoh(j,plotChan) gammaCoh(j,plotChan)],'r')
%     set(gca,'ylim',[0 1]);
%     pause
end
figure
plot(fo,UnATanCoh(cohSave(plotChan)/n))
set(gca,'ylim',[0 1]);

smoothGammaCoh = UnATanCoh(Filter0(avgfiltb,gammaCoh));

outCohFileName = [fileBase '/' fileBase '_' num2str(freqRange(1)) '-' num2str(freqRange(2)) 'Hz' fileext '.10000coh'];
fprintf('\nSaving %s\n', outCohFileName);
bsave(outCohFileName,10000*smoothGammaCoh','int16');



