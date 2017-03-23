function CalcUnitPopSpectrum01(fileBaseCell,varargin)
%function CalcUnitSpectrum01(fileBaseCell)
%spectAnalDir = 'CalcRunningSpectra12_noExp_MidPoints_MinSpeed0Win626wavParam8.eeg/';
%winLen = 626;
%[winLen,spectAnalDir] = DefaultArgs(varargin,{winLen,spectAnalDir});

spectAnalDir = 'CalcRunningSpectra12_noExp_MidPoints_MinSpeed0Win626wavParam8.eeg/';
winLen = 626;
[winLen,spectAnalDir] = DefaultArgs(varargin,{winLen,spectAnalDir});

eegSamp = 1250;
datSamp = 20000;
newSamp = 1250;
timeWin = winLen/eegSamp;
newWinLen = round(winLen/eegSamp*newSamp);
binSize = 2;
cellTypeLabels = {'w' 'n' 'x'};

bps = 2;
nChan = load('ChanInfo/NChan.eeg.txt');
chanLoc = LoadVar('ChanInfo/ChanLoc_Full.eeg.mat');

paramb = [];
paramb.Fs = newSamp;
paramb.pad = 1;
paramb.tapers = [5 9];
unitPopPowSpec.paramb = paramb;

try
for j=1:length(fileBaseCell)
    fileBase = fileBaseCell{j}
    time = LoadVar([fileBase '/' spectAnalDir 'time.mat']);
    cluLoc = load([fileBase '/' fileBase '.cluloc']);
    cellType = LoadCellTypes([fileBaseCell{1} '/' fileBaseCell{1} '.type']);

    elNum = 0;
    chanLocNames = fieldnames(chanLoc);
    for m=1:length(chanLocNames)
        for p=1:length(cellTypeLabels)
            unitPopPowSpec.(chanLocNames{m}).(cellTypeLabels{p}).yo = [];
            unitPopPowSpec.(chanLocNames{m}).(cellTypeLabels{p}).fo = [];
            unitPopPowSpec.(chanLocNames{m}).(cellTypeLabels{p}).rate = [];
            unitPopPowSpec.(chanLocNames{m}).(cellTypeLabels{p}).nCells = 0;

            catRes = [];
            for k=1:size(cluLoc,1)
                if elNum ~= cluLoc(k,1)
                    clu = load([fileBase '/' fileBase '.clu.' num2str(cluLoc(k,1))]);
                    res = load([fileBase '/' fileBase '.res.' num2str(cluLoc(k,1))]);
                    eegFiles = dir([fileBase '/' fileBase '.eeg']);
                    numNewSamp = ceil(eegFiles(1).bytes/bps/nChan/eegSamp*newSamp);
                end
                elNum = cluLoc(k,1);
                if sum(cluLoc(k,3)==[chanLoc.(chanLocNames{m}){:}])>0 & strcmp(cellTypeLabels{p},cellType{k,3})
                    selRes = clu(2:end)==cluLoc(k,2);
                    catRes = cat(1,catRes,res(selRes));
                    unitPopPowSpec.(chanLocNames{m}).(cellTypeLabels{p}).nCells = ...
                        unitPopPowSpec.(chanLocNames{m}).(cellTypeLabels{p}).nCells + 1;
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
            if ~isempty(unitPopPowSpec.(chanLocNames{m}).(cellTypeLabels{p}).fo) ...
                    & unitPopPowSpec.(chanLocNames{m}).(cellTypeLabels{p}).fo ~= foTemp
                problem
            else
                unitPopPowSpec.(chanLocNames{m}).(cellTypeLabels{p}).fo = foTemp;
            end

            unitPopPowSpec.(chanLocNames{m}).(cellTypeLabels{p}).yo = cat(2,unitPopPowSpec.(chanLocNames{m}).(cellTypeLabels{p}).yo,permute(specTemp,[2,3,1]));
            unitPopPowSpec.(chanLocNames{m}).(cellTypeLabels{p}).rate = cat(2,unitPopPowSpec.(chanLocNames{m}).(cellTypeLabels{p}).rate,rateTemp);
        end
    end
    save([fileBase '/' spectAnalDir 'unitPopPowSpec.mat'],SaveAsV6,'unitPopPowSpec');
end
catch
    junk = lasterror
    junk.stack
    keyboard
end
