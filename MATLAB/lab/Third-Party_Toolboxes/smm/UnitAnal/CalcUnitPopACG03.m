function CalcUnitPopACG03(fileBaseCell,varargin)
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
normalization = 'scale';
cellTypeLabels = {'w' 'n' 'x'};

bps = 2;
nChan = load('ChanInfo/NChan.eeg.txt');
chanLoc = LoadVar('ChanInfo/ChanLoc_Full.eeg.mat');

paramb = [];
paramb.Fs = newSamp;
paramb.pad = 1;
paramb.tapers = [5 7];
unitPopACG.paramb = paramb;

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
            unitPopACG.(chanLocNames{m}).(cellTypeLabels{p}).yo = [];
            unitPopACG.(chanLocNames{m}).(cellTypeLabels{p}).to = [];
            unitPopACG.(chanLocNames{m}).(cellTypeLabels{p}).rate = [];
            unitPopACG.(chanLocNames{m}).(cellTypeLabels{p}).nCells = 0;
            
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
                    unitPopACG.(chanLocNames{m}).(cellTypeLabels{p}).nCells = ...
                        unitPopACG.(chanLocNames{m}).(cellTypeLabels{p}).nCells + 1;
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
                selInd = find(catRes>=(time(n)-timeWin/2)*datSamp & catRes<(time(n)+timeWin/2)*datSamp);
                rateTemp(n,1) = length(selInd)/timeWin;
            end
            if ~isempty(unitPopACG.(chanLocNames{m}).(cellTypeLabels{p}).to) & unitPopACG.(chanLocNames{m}).(cellTypeLabels{p}).to ~= toTemp
                problem
            else
                unitPopACG.(chanLocNames{m}).(cellTypeLabels{p}).to = toTemp;
            end
            unitPopACG.(chanLocNames{m}).(cellTypeLabels{p}).rate = cat(2,unitPopACG.(chanLocNames{m}).(cellTypeLabels{p}).rate,rateTemp);
            unitPopACG.(chanLocNames{m}).(cellTypeLabels{p}).yo = cat(2,unitPopACG.(chanLocNames{m}).(cellTypeLabels{p}).yo,permute(ccgTemp2,[1,3,2]));
        end
    end
    save([fileBase '/' spectAnalDir 'unitPopACG.mat'],SaveAsV6,'unitPopACG');
end
catch
    junk = lasterror
    %junk.stack
    keyboard
end
