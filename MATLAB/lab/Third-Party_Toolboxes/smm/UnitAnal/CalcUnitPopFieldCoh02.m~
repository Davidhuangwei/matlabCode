function CalcUnitPopSpectrum02(fileBaseCell,varargin)
%function CalcUnitSpectrum01(fileBaseCell)
%spectAnalDir = 'CalcRunningSpectra12_noExp_MidPoints_MinSpeed0Win626wavParam8.eeg/';
%winLen = 626;
%[winLen,spectAnalDir] = DefaultArgs(varargin,{winLen,spectAnalDir});
fileExt = '.eeg';
spectAnalDir = 'CalcRunningSpectra12_noExp_MidPoints_MinSpeed0Win626wavParam8';
winLen = 626;
[winLen,fileExt,spectAnalDir,NW] = DefaultArgs(varargin,{winLen,fileExt,spectAnalDir,5});
spectAnalDir = [spectAnalDir fileExt '/'];

eegSamp = 1250;
datSamp = 20000;
%newSamp = eegSamp;
timeWin = winLen/eegSamp;
%newWinLen = round(winLen/eegSamp*newSamp);
cellTypeLabels = {'w' 'n' 'x'}
cellLayerNames = {...
    'or',...
    'ca1Pyr',...
    'rad',...
    'lm',...
    'mol',...
    'gran',...
    'hil',...
    'ca3Pyr',...
    'noLayer',...
    }
    
bps = 2;
nChan = load(['ChanInfo/NChan' fileExt '.txt']);
selChan = LoadVar(['ChanInfo/SelChan' fileExt '.mat']);
selChanNames = fieldnames(selChan);

paramb = [];
paramb.Fs = eegSamp;
paramb.pad = 0;
paramb.tapers = [NW 2*NW-1];
infoStruct.paramb = paramb;
infoStruct.eegSamp = eegSamp;
infoStruct.datSamp = datSamp;
infoStruct.timeWin = timeWin;
infoStruct.cellTypeLabels = cellTypeLabels;
infoStruct.cellLayerNames = cellLayerNames;
infoStruct.winLen = winLen;
infoStruct.spectAnalDir = spectAnalDir;
infoStruct.bps = bps;
infoStruct.nChan = nChan;
infoStruct.mfilename = mfilename;

warning('off','MATLAB:divideByZero')
fo = [];
try
for j=1:length(fileBaseCell)
    fileBase = fileBaseCell{j}
    eegSegTime = LoadVar([fileBase '/' spectAnalDir 'eegSegTime.mat']);
    cellLayer = LoadCellLayers([fileBase '/' fileBase '.cellLayer']);
    cellType = LoadCellTypes([fileBaseCell{1} '/' fileBaseCell{1} '.type']);

    elNum = 0;
    eegFiles = dir([fileBase '/' fileBase fileExt]);
    numEegSamp = ceil(eegFiles(1).bytes/bps/nChan);
    rawTrace = LoadVar([fileBase '/' spectAnalDir 'rawTrace.mat']);
    
    for r=1:length(selChanNames)
        for m=1:length(cellLayerNames)
            for p=1:length(cellTypeLabels)
                unitPopCohSpec.(selChanNames{r}).(cellLayerNames{m}).(cellTypeLabels{p}).yo = [];
                unitPopPhaseSpec.(selChanNames{r}).(cellLayerNames{m}).(cellTypeLabels{p}).yo = [];
                unitPopCrossSpec.(selChanNames{r}).(cellLayerNames{m}).(cellTypeLabels{p}).yo = [];
                unitPopEegPowSpec.(selChanNames{r}).(cellLayerNames{m}).(cellTypeLabels{p}).yo = [];
                unitPopUnitPowSpec.(selChanNames{r}).(cellLayerNames{m}).(cellTypeLabels{p}).yo = [];
                unitPopRate.(selChanNames{r}).(cellLayerNames{m}).(cellTypeLabels{p}).rate = [];
                unitPopNCells.(selChanNames{r}).(cellLayerNames{m}).(cellTypeLabels{p}).nCells = 0;

                catRes = [];
                for k=1:size(cellLayer,1)
                    if elNum ~= cellLayer{k,1} % saves a little time
                        clu = load([fileBase '/' fileBase '.clu.' num2str(cellLayer{k,1})]);
                        res = load([fileBase '/' fileBase '.res.' num2str(cellLayer{k,1})]);
                    end
                    elNum = cellLayer{k,1};
                    if sum(strcmp(cellLayerNames{m},cellLayer{k,3}) & strcmp(cellTypeLabels{p},cellType{k,3}))>0
                        selRes = clu(2:end)==cellLayer{k,2};
                        catRes = cat(1,catRes,res(selRes));
                        unitPopNCells.(selChanNames{r}).(cellLayerNames{m}).(cellTypeLabels{p}).nCells = ...
                            unitPopNCells.(selChanNames{r}).(cellLayerNames{m}).(cellTypeLabels{p}).nCells + 1;
                    end
                end
                if ~isempty(catRes)
                    spikeBin = Accumulate(ceil(catRes/datSamp*eegSamp),1,numEegSamp);
                else
                    spikeBin = zeros(numEegSamp,1);
                end
                trialSpikeBin = [];
                for n=1:length(eegSegTime)
                    trialSpikeBin(n,:) = spikeBin(eegSegTime(n)+1:eegSegTime(n)+winLen);
                end
                rateTemp = sum(trialSpikeBin,2)./timeWin;
                
                [cohTemp phaseTemp crossTemp EegPowTemp UnitPowTemp foTemp]=...
                    coherencycpb(squeeze(rawTrace(:,selChan.(selChanNames{r}),:))',trialSpikeBin',paramb);
                
                if ~isempty(fo) & fo ~= foTemp % sanity check
                    problem
                else
                    fo = foTemp;
                end
                
                unitPopCohSpec.(selChanNames{r}).(cellLayerNames{m}).(cellTypeLabels{p}).yo = ...
                    cat(2,unitPopCohSpec.(selChanNames{r}).(cellLayerNames{m}).(cellTypeLabels{p}).yo,permute(cohTemp,[2,3,1]));
                unitPopPhaseSpec.(selChanNames{r}).(cellLayerNames{m}).(cellTypeLabels{p}).yo = ...
                    cat(2,unitPopPhaseSpec.(selChanNames{r}).(cellLayerNames{m}).(cellTypeLabels{p}).yo,permute(phaseTemp,[2,3,1]));
                unitPopCrossSpec.(selChanNames{r}).(cellLayerNames{m}).(cellTypeLabels{p}).yo = ...
                   cat(2,unitPopCrossSpec.(selChanNames{r}).(cellLayerNames{m}).(cellTypeLabels{p}).yo,permute(crossTemp,[2,3,1]));
                unitPopEegPowSpec.(selChanNames{r}).(cellLayerNames{m}).(cellTypeLabels{p}).yo = ...
                   cat(2,unitPopEegPowSpec.(selChanNames{r}).(cellLayerNames{m}).(cellTypeLabels{p}).yo,permute(EegPowTemp,[2,3,1]));
                unitPopUnitPowSpec.(selChanNames{r}).(cellLayerNames{m}).(cellTypeLabels{p}).yo = ...
                   cat(2,unitPopUnitPowSpec.(selChanNames{r}).(cellLayerNames{m}).(cellTypeLabels{p}).yo,permute(UnitPowTemp,[2,3,1]));
                unitPopRate.(selChanNames{r}).(cellLayerNames{m}).(cellTypeLabels{p}).rate = ...
                   cat(2,unitPopRate.(selChanNames{r}).(cellLayerNames{m}).(cellTypeLabels{p}).rate,rateTemp);
            end
        end
    end
    unitPopCohSpec.fo = fo;
    unitPopPhaseSpec.fo = fo;
    unitPopCrossSpec.fo = fo;
    unitPopEegPowSpec.fo = fo;
    unitPopUnitPowSpec.fo = fo;
    
    unitPopCohSpec.infoStruct = infoStruct;
    unitPopPhaseSpec.infoStruct = infoStruct;
    unitPopCrossSpec.infoStruct = infoStruct;
    unitPopEegPowSpec.infoStruct = infoStruct;
    unitPopUnitPowSpec.infoStruct = infoStruct;
    
    save([fileBase '/' spectAnalDir 'unitPopCohSpecNW' num2str(NW) '.mat'],SaveAsV6,'unitPopCohSpec');
    save([fileBase '/' spectAnalDir 'unitPopPhaseSpecNW' num2str(NW) '.mat'],SaveAsV6,'unitPopPhaseSpec');
    save([fileBase '/' spectAnalDir 'unitPopCrossSpecNW' num2str(NW) '.mat'],SaveAsV6,'unitPopCrossSpec');
    save([fileBase '/' spectAnalDir 'unitPopEegPowSpecNW' num2str(NW) '.mat'],SaveAsV6,'unitPopEegPowSpec');
    save([fileBase '/' spectAnalDir 'unitPopUnitPowSpecNW' num2str(NW) '.mat'],SaveAsV6,'unitPopUnitPowSpec');
    save([fileBase '/' spectAnalDir 'unitPopRate.mat'],SaveAsV6,'unitPopRate');
    save([fileBase '/' spectAnalDir 'unitPopNCells.mat'],SaveAsV6,'unitPopNCells');
end
catch
    junk = lasterror
    junk.stack
    keyboard
end
warning('off','MATLAB:divideByZero')
