% function ExtractThetaFreqLM(fileBaseCell,spectAnalBase,fileExtCell,thetaFreqRange)
% tag:theta
% tag:freq
% tag:lm
% tag:extract

function ExtractThetaFreqLM(fileBaseCell,spectAnalBase,fileExtCell,thetaFreqRange)

for j=1:length(fileBaseCell)
    for k=1:length(fileExtCell)
        selChan = LoadVar(['ChanInfo/SelChan' fileExtCell{k}]);
        %         chanMat = LoadVar(['ChanInfo/ChanMat' fileExtCell{k}]);
        %         badChan = load(['ChanInfo/BadChan' fileExtCell{k} '.txt']);
        %         goodChan = setdiff(chanMat(:),badChan);
        %         powChan = selChan.ca1Pyr;
        lmChan = selChan.lm;
        thetaFreq = LoadVar([fileBaseCell{j} '/' spectAnalBase fileExtCell{k} '/' ...
            'thetaFreq' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz']);
        fo = LoadField([fileBaseCell{j} '/' spectAnalBase fileExtCell{k} '/' 'powSpec.fo']);
        minFo = min(fo(fo>=thetaFreqRange(1)));
        maxFo = max(fo(fo<=thetaFreqRange(2)));
        thetaFreqLM = thetaFreq(:,lmChan);
        thetaFreqLM(thetaFreqLM==minFo | thetaFreqLM==maxFo) = NaN;
        if ~isempty(find(isnan(thetaFreqLM)))
            fprintf('%i NaNs; %s\n',length(find(isnan(thetaFreqLM))),...
                [fileBaseCell{j} '/' spectAnalBase fileExtCell{k}]);
        end
       outFile = [fileBaseCell{j} '/' spectAnalBase fileExtCell{k} '/' ,...
            'thetaFreqLM' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.mat'];
        if exist(outFile,'file')
            eval(['!rm ' outFile]);
        end

        fprintf('SAVING: %s\n',outFile);
        save(outFile,...
            SaveAsV6,'thetaFreqLM');

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

