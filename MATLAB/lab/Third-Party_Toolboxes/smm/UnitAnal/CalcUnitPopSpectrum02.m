function CalcUnitPopSpectrum02(fileBaseCell,varargin)
%function CalcUnitSpectrum01(fileBaseCell)
%spectAnalDir = 'CalcRunningSpectra12_noExp_MidPoints_MinSpeed0Win626wavParam8.eeg/';
%winLen = 626;
%[winLen,spectAnalDir] = DefaultArgs(varargin,{winLen,spectAnalDir});

spectAnalDir = 'CalcRunningSpectra12_noExp_MidPoints_MinSpeed0Win626wavParam8.eeg/';
winLen = 626;
[winLen,spectAnalDir,NW] = DefaultArgs(varargin,{winLen,spectAnalDir,5});

eegSamp = 1250;
datSamp = 20000;
newSamp = 1250;
timeWin = winLen/eegSamp;
newWinLen = round(winLen/eegSamp*newSamp);
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

paramb = [];
paramb.Fs = newSamp;
paramb.pad = 0;
paramb.tapers = [NW 2*NW-1];
unitPopPowSpec.infoStruct.paramb = paramb;
unitPopPowSpec.infoStruct.eegSamp = eegSamp;
unitPopPowSpec.infoStruct.datSamp = datSamp;
unitPopPowSpec.infoStruct.newSamp = newSamp;
unitPopPowSpec.infoStruct.timeWin = timeWin;
unitPopPowSpec.infoStruct.newWinLen = newWinLen;
unitPopPowSpec.infoStruct.cellTypeLabels = cellTypeLabels;
unitPopPowSpec.infoStruct.cellLayerNames = cellLayerNames;
unitPopPowSpec.infoStruct.winLen = winLen;
unitPopPowSpec.infoStruct.spectAnalDir = spectAnalDir;
unitPopPowSpec.infoStruct.bps = bps;
unitPopPowSpec.infoStruct.nChan = nChan;
unitPopPowSpec.infoStruct.mfilename = mfilename;

try
for j=1:length(fileBaseCell)
    fileBase = fileBaseCell{j}
    time = LoadVar([fileBase '/' spectAnalDir 'time.mat']);
    eegSegTime = LoadVar([fileBase '/' spectAnalDir 'eegSegTime.mat']);
    cellLayer = LoadCellLayers([fileBase '/' fileBase '.cellLayer']);
    cellType = LoadCellTypes([fileBaseCell{1} '/' fileBaseCell{1} '.type']);

    elNum = 0;
    eegFiles = dir([fileBase '/' fileBase '.eeg']);
    numNewSamp = ceil(eegFiles(1).bytes/bps/nChan/eegSamp*newSamp);
    
    %cellLayerNames = unique(cellLayer(:,3));
    for m=1:length(cellLayerNames)
        for p=1:length(cellTypeLabels)
            unitPopPowSpec.(cellLayerNames{m}).(cellTypeLabels{p}).yo = [];
            unitPopPowSpec.(cellLayerNames{m}).(cellTypeLabels{p}).fo = [];
            unitPopPowSpec.(cellLayerNames{m}).(cellTypeLabels{p}).rate = [];
            unitPopPowSpec.(cellLayerNames{m}).(cellTypeLabels{p}).nCells = 0;

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
                    unitPopPowSpec.(cellLayerNames{m}).(cellTypeLabels{p}).nCells = ...
                        unitPopPowSpec.(cellLayerNames{m}).(cellTypeLabels{p}).nCells + 1;
                end
            end
            if ~isempty(catRes)
                spikeBin = Accumulate(round(catRes/datSamp*newSamp),1,numNewSamp);
            else
                spikeBin = zeros(numNewSamp,1);
            end
            trialBin = [];
            for n=1:length(time)
                spikeBinStartInd = max(1,round((time(n)-timeWin/2)*newSamp));
                trialBin(n,:) = spikeBin(spikeBinStartInd:min(spikeBinStartInd+newWinLen,numNewSamp));
            end
            [specTemp,foTemp,rateTemp]=mtspectrumpb(trialBin',paramb);
            if ~isempty(unitPopPowSpec.(cellLayerNames{m}).(cellTypeLabels{p}).fo) ...
                    & unitPopPowSpec.(cellLayerNames{m}).(cellTypeLabels{p}).fo ~= foTemp
                problem
            else
                unitPopPowSpec.(cellLayerNames{m}).(cellTypeLabels{p}).fo = foTemp;
            end

            unitPopPowSpec.(cellLayerNames{m}).(cellTypeLabels{p}).yo = cat(2,unitPopPowSpec.(cellLayerNames{m}).(cellTypeLabels{p}).yo,permute(specTemp,[2,3,1]));
            unitPopPowSpec.(cellLayerNames{m}).(cellTypeLabels{p}).rate = cat(2,unitPopPowSpec.(cellLayerNames{m}).(cellTypeLabels{p}).rate,rateTemp);
               
%             keyboard
%             plot(trialBin(n,:))
%             plot(foTemp,specTemp(:,n))
            
        end
    end
    save([fileBase '/' spectAnalDir 'unitPopPowSpecNW' num2str(NW) '.mat'],SaveAsV6,'unitPopPowSpec');
end
catch
    junk = lasterror
    junk.stack
    keyboard
end
