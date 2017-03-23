function CalcUnitCCG04(fileBaseCell,winLen,spectAnalDir,varargin)
%function CalcUnitSpectrum01(fileBaseCell)
%spectAnalDir = 'CalcRunningSpectra12_noExp_MidPoints_MinSpeed0Win626wavParam8.eeg/';
%winLen = 626;
%[winLen,spectAnalDir] = DefaultArgs(varargin,{winLen,spectAnalDir});
eegSamp = 1250;
datSamp = 20000;
timeWin = winLen/eegSamp;
binSize = 3;
[tapers,newSamp] = DefaultArgs(varargin,{[5,7],eegSamp});

prevWarnSettings = SetWarnings({'off','MATLAB:divideByZero'});
newWinLen = round(winLen/eegSamp*newSamp);

bps = 2;
nChan = load('ChanInfo/NChan.eeg.txt');

paramb = [];
paramb.Fs = newSamp;
paramb.pad = 1;
paramb.tapers = [5 7];
unitPowSpec.paramb = paramb;
%bps = 2;
%nChan = load('ChanInfo/NChan.eeg.txt');
%chanLoc = LoadVar('ChanInfo/ChanLoc_Full.eeg.mat');

unitCCG.infoStruct.eegSamp = eegSamp;
unitCCG.infoStruct.datSamp = datSamp;
unitCCG.infoStruct.timeWin = timeWin;
unitCCG.infoStruct.binSize = binSize;
unitCCG.infoStruct.winLen = winLen;
unitCCG.infoStruct.spectAnalDir = spectAnalDir;
% unitCCG.infoStruct.bps = bps;
% unitCCG.infoStruct.nChan = nChan;
unitCCG.infoStruct.normalization = normalization;
unitCCG.infoStruct.mfilename = mfilename;


% try
for j=1:length(fileBaseCell)
    fileBase = fileBaseCell{j}
    time = LoadVar([fileBase '/' spectAnalDir 'time.mat']);
    unitCCG.cellLayer = LoadCellLayers([fileBase '/' fileBase '.cellLayer']);
    unitCCG.cellType = LoadCellTypes([fileBaseCell{1} '/' fileBaseCell{1} '.type']);
% allTimes = LoadVar([fileBase '/' spectAnalDir 'allEegSegTime.mat'])/eegSamp;
    eegFiles = dir([fileBase '/' fileBase '.eeg']);
    numNewSamp = ceil(eegFiles(1).bytes/bps/nChan/eegSamp*newSamp);
    elNum1 = 0;
    elNum2 = 0;
    catClu = [];
    catRes = [];
    for k=1:size(unitCCG.cellLayer,1)
        if elNum1 ~= unitCCG.cellLayer{k,1}% saves a little time
            clu1 = load([fileBase '/' fileBase '.clu.' num2str(unitCCG.cellLayer{k,1})]);
            res1 = load([fileBase '/' fileBase '.res.' num2str(unitCCG.cellLayer{k,1})]);
        end
        elNum1 = unitCCG.cellLayer{k,1};
        for m=1:size(unitCCG.cellLayer,1)
            if elNum2 ~= unitCCG.cellLayer{m,1}% saves a little time
                if elNum2 == elNum1
                    clu2 = clu1;
                    res2 = res1;
                else
                    clu2 = load([fileBase '/' fileBase '.clu.' num2str(unitCCG.cellLayer{m,1})]);
                    res2 = load([fileBase '/' fileBase '.res.' num2str(unitCCG.cellLayer{m,1})]);
                end
            end
            elNum2 = unitCCG.cellLayer{m,1};
            
            selRes1 = find(res1(clu1(2:end)==unitCCG.cellLayer(k,2)));
            selRes2 = find(res2(clu2(2:end)==unitCCG.cellLayer(k,2)));
            if ~isempty(selRes1)
                spikeBin1 = Accumulate(round(selRes1/datSamp*newSamp),1,numNewSamp);
            else
                spikeBin1 = zeros(numNewSamp,1);
            end
            if ~isempty(selRes2)
                spikeBin1 = Accumulate(round(selRes2/datSamp*newSamp),1,numNewSamp);
            else
                spikeBin1 = zeros(numNewSamp,1);
            end

        selInd = find(clu(2:end)==unitCCG.cellLayer{k,2});
        catRes = cat(1,catRes,res(selInd));
        catClu = cat(1,catClu,k*ones(size(selInd)));
    end
    clu = [];
    res = [];
%     keyboard
    ccgTemp = [];
    unitCCG.yo = [];
    unitRate = zeros(length(time),size(unitCCG.cellLayer,1));
    for n=1:length(time)
        % calculate ACG
        if biasCorrBool
            [ccgTemp unitCCG.to] = CCG(catRes,catClu,...
                round(binSize*datSamp/1000),halfBins,...
                datSamp,[1:size(unitCCG.cellLayer,1)],normalization,...
                [time(n)-timeWin/2 time(n)+timeWin/2]*datSamp);
        else
            tempInd = find((catRes>=(time(n)-timeWin/2)*datSamp)...
                & (catRes<=(time(n)+timeWin/2)*datSamp));
            [ccgTemp unitCCG.to] = CCG(catRes(tempInd),catClu(tempInd),...
                round(binSize*datSamp/1000),halfBins,...
                datSamp,[1:size(unitCCG.cellLayer,1)],normalization);
        end
        if isempty(unitCCG.yo) 
            unitCCG.yo = zeros([length(time) size(permute(ccgTemp,[2,3,1]))]);
        end
        unitCCG.yo(n,:,:,:) = permute(ccgTemp,[2,3,1]);
        % calculate rate
        for k=1:size(unitCCG.cellLayer,1)
            selInd = find(catClu==k & ...
                catRes>=(time(n)-timeWin/2)*datSamp & catRes<=(time(n)+timeWin/2)*datSamp);
            unitRate(n,k) = length(selInd)/timeWin;
        end
    end
    if biasCorrBool
        bcText = 'BC';
    else
        bcText = '';
    end
    save([fileBase '/' spectAnalDir 'unitCCGBin' num2str(binSize) normalization bcText '.mat'],SaveAsV6,'unitCCG');
    save([fileBase '/' spectAnalDir 'unitRate.mat'],SaveAsV6,'unitRate');
end
% catch
%     junk = lasterror
%     %junk.stack
%     keyboard
% end

SetWarnings(prevWarnSettings);