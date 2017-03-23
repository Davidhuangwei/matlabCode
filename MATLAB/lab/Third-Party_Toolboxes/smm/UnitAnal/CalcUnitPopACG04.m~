function CalcUnitPopACG04(fileBaseCell,varargin)
%function CalcUnitSpectrum01(fileBaseCell)
%spectAnalDir = 'CalcRunningSpectra12_noExp_MidPoints_MinSpeed0Win626wavParam8.eeg/';
%winLen = 626;
%[winLen,spectAnalDir] = DefaultArgs(varargin,{winLen,spectAnalDir});

spectAnalDir = 'CalcRunningSpectra12_noExp_MidPoints_MinSpeed0Win626wavParam8.eeg/';
winLen = 626;
[winLen,spectAnalDir,binSize] = DefaultArgs(varargin,{winLen,spectAnalDir,3});

eegSamp = 1250;
datSamp = 20000;
timeWin = winLen/eegSamp;
normalization = 'scale';
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
nChan = load('ChanInfo/NChan.eeg.txt');
%chanLoc = LoadVar('ChanInfo/ChanLoc_Full.eeg.mat');

unitPopACG.infoStruct.eegSamp = eegSamp;
unitPopACG.infoStruct.datSamp = datSamp;
unitPopACG.infoStruct.timeWin = timeWin;
unitPopACG.infoStruct.binSize = binSize;
unitPopACG.infoStruct.cellTypeLabels = cellTypeLabels;
unitPopACG.infoStruct.cellLayerNames = cellLayerNames;
unitPopACG.infoStruct.winLen = winLen;
unitPopACG.infoStruct.spectAnalDir = spectAnalDir;
unitPopACG.infoStruct.bps = bps;
unitPopACG.infoStruct.nChan = nChan;
unitPopACG.infoStruct.normalization = normalization;

try
for j=1:length(fileBaseCell)
    fileBase = fileBaseCell{j}
    time = LoadVar([fileBase '/' spectAnalDir 'time.mat']);
    cellLayer = LoadCellLayers([fileBase '/' fileBase '.cellLayer']);
    cellType = LoadCellTypes([fileBaseCell{1} '/' fileBaseCell{1} '.type']);

    elNum = 0;
    eegFiles = dir([fileBase '/' fileBase '.eeg']);
    %numNewSamp = ceil(eegFiles(1).bytes/bps/nChan/eegSamp*newSamp);
    
    %cellLayerNames = unique(cellLayer(:,3));
    for m=1:length(cellLayerNames)
        for p=1:length(cellTypeLabels)
            unitPopACG.(cellLayerNames{m}).(cellTypeLabels{p}).yo = [];
            unitPopACG.(cellLayerNames{m}).(cellTypeLabels{p}).to = [];
            unitPopACG.(cellLayerNames{m}).(cellTypeLabels{p}).rate = [];
            unitPopACG.(cellLayerNames{m}).(cellTypeLabels{p}).nCells = 0;

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
                    unitPopACG.(cellLayerNames{m}).(cellTypeLabels{p}).nCells = ...
                        unitPopACG.(cellLayerNames{m}).(cellTypeLabels{p}).nCells + 1;
                end
            end
            ccgTemp = [];
            ccgTemp2 = [];
            rateTemp = [];
            for n=1:length(time)
                % calculate ACG
                [ccgTemp toTemp] = CCG(catRes,ones(size(catRes)),...
                    round(binSize*datSamp/1000),round(timeWin/2*1000/binSize),...
                    datSamp,1,normalization,...
                    [time(n)-timeWin/2 time(n)+timeWin/2]*datSamp);
                if isempty(ccgTemp)
                    ccgTemp = zeros(size(ccgTemp,1),1);
                end
                ccgTemp2 = cat(1,ccgTemp2,ccgTemp');
                % calculate rate
                selInd = find(catRes>=(time(n)-timeWin/2)*datSamp & catRes<=(time(n)+timeWin/2)*datSamp);
                rateTemp(n,1) = length(selInd)/timeWin;
            end
            if ~isempty(unitPopACG.(cellLayerNames{m}).(cellTypeLabels{p}).to) & unitPopACG.(cellLayerNames{m}).(cellTypeLabels{p}).to ~= toTemp
                problem
            else
                unitPopACG.(cellLayerNames{m}).(cellTypeLabels{p}).to = toTemp;
            end
            unitPopACG.(cellLayerNames{m}).(cellTypeLabels{p}).rate = cat(2,unitPopACG.(cellLayerNames{m}).(cellTypeLabels{p}).rate,rateTemp);
            unitPopACG.(cellLayerNames{m}).(cellTypeLabels{p}).yo = cat(2,unitPopACG.(cellLayerNames{m}).(cellTypeLabels{p}).yo,permute(ccgTemp2,[1,3,2]));
                   
%             keyboard
%              junk = []
%              junkInd = round((catRes(catRes>(time(n)-timeWin/2)*datSamp & catRes<(time(n)+timeWin/2)*datSamp)...
%                  -(time(n)-timeWin/2)*datSamp)/datSamp*1000);
%              junk(junkInd) = 1;
%             plot(junk)
%             plot(toTemp,ccgTemp2(n,:))
        end
    end
    save([fileBase '/' spectAnalDir 'unitPopACGBin' num2str(binSize) '.mat'],SaveAsV6,'unitPopACG');
end
catch
    junk = lasterror
    junk.stack
    keyboard
end
