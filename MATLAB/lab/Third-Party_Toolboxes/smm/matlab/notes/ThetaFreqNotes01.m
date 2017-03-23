
spectAnalBase = 'RemVsRun01_noExp_MinSpeed0Win1250';
fileExts = {'.eeg','_LinNearCSD121.csd'};
allFiles = LoadVar('FileInfo/AllFiles');
for j=1:length(allFiles)
    for k=1:length(fileExts)
        selChan = LoadVar(['ChanInfo/SelChan' fileExts{k}]);
        chanMat = LoadVar(['ChanInfo/ChanMat' fileExts{k}]);
        badChan = load(['ChanInfo/BadChan' fileExts{k} '.txt']);
        goodChan = setdiff(chanMat(:),badChan);
        powChan = selChan.ca1Pyr;
        freqChan = selChan.lm;
        thetaFreq = LoadVar([allFiles{j} '/' spectAnalBase fileExts{k} '/' 'thetaFreq4-12Hz']);
        powSpec = LoadField([allFiles{j} '/' spectAnalBase fileExts{k} '/' 'powSpec.yo']);
        fo = LoadField([allFiles{j} '/' spectAnalBase fileExts{k} '/' 'powSpec.fo']);
        figure(1)
        clf
        selChanNames = fieldnames(selChan);
        for m=1:length(selChanNames)-2
            powChan = selChan.(selChanNames{m+1});
            subplot(length(selChanNames)-2,1,m)
            hold on
            title(SaveTheUnderscores([allFiles{j} '/' spectAnalBase fileExts{k} '/']));
            pcolor(1:size(powSpec,1),fo,squeeze(powSpec(:,powChan,:))');
            shading flat
            plot(0.5+[1:size(powSpec,1)],median(thetaFreq(:,goodChan),2),'w');
            plot(0.5+[1:size(powSpec,1)],thetaFreq(:,freqChan),'k');
            set(gca,'ylim',[0 20])
            colorbar
        end
        in  = input('anything breaks: ','s');
        if ~isempty(in)
            return
        end
    end
end
return
lmChan = [5,6,22,40,57,58]
ca1PyrChan = [17,18,34,35,52,53,70,71]
plotChan = [17];
selChan = 3;

thetaFreq = LoadVar('thetaFreq4-12Hz');
medAllThetaFreq = median(thetaFreq,2);
medLmThetaFreq = median(thetaFreq(:,lmChan),2);
medPyrThetaFreq = median(thetaFreq(:,ca1PyrChan),2);

powSpec = LoadField('powSpec.yo');
fo = LoadField('powSpec.fo');
figure(1)
clf
hold on
pcolor(1:size(powSpec,1),fo,squeeze(powSpec(:,plotChan,:))');
shading flat
plot([1:size(powSpec,1)],thetaFreq(:,selChan),'k');
set(gca,'ylim',[0 20])

plot([1:size(powSpec,1)],medAllThetaFreq,'.k');
plot([1:size(powSpec,1)],medLmThetaFreq,'.b');
plot([1:size(powSpec,1)],medPyrThetaFreq,'.w');

