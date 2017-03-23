% function CalcUnitCCG04(fileBaseCell,winLen,spectAnalDir,varargin)
% eegSamp = 1250;
% datSamp = 20000;
% timeWin = winLen/eegSamp;
% binSize = 3;
% [normalization,binSize,halfBins,biasCorrBool] = DefaultArgs(varargin,{'scale',binSize,floor(timeWin*1000/2/binSize),1});
% tag:unit
% tag:ccg
function CalcUnitISIDist02(fileBaseCell,winLen,spectAnalDir,varargin)
eegSamp = 1250;
datSamp = 20000;
timeWin = winLen/eegSamp;
binSize = 1;
[binSize,maxT] = DefaultArgs(varargin,{binSize,floor(timeWin*1000/2)});

prevWarnSettings = SetWarnings({'off','MATLAB:divideByZero'});

%bps = 2;
%nChan = load('ChanInfo/NChan.eeg.txt');
%chanLoc = LoadVar('ChanInfo/ChanLoc_Full.eeg.mat');

unitISIDist.infoStruct.eegSamp = eegSamp;
unitISIDist.infoStruct.datSamp = datSamp;
unitISIDist.infoStruct.timeWin = timeWin;
unitISIDist.infoStruct.binSize = binSize;
unitISIDist.infoStruct.maxT = maxT;
unitISIDist.infoStruct.winLen = winLen;
unitISIDist.infoStruct.spectAnalDir = spectAnalDir;
unitISIDist.infoStruct.mfilename = mfilename;


% try
for j=1:length(fileBaseCell)
    fileBase = fileBaseCell{j}
    time = LoadVar([fileBase '/' spectAnalDir 'time.mat']);
    unitISIDist.cellLayer = LoadCellLayers([fileBase '/' fileBase '.cellLayer']);
    unitISIDist.cellType = LoadCellTypes([fileBaseCell{1} '/' fileBaseCell{1} '.type']);
% allTimes = LoadVar([fileBase '/' spectAnalDir 'allEegSegTime.mat'])/eegSamp;
    %eegFiles = dir([fileBase '/' fileBase '.eeg']);
    %numNewSamp = ceil(eegFiles(1).bytes/bps/nChan/eegSamp*newSamp);
    elNum = 0;
    unitISIDist.to  = [];
    unitISIDist.pd = [];
    unitISIDist.mean = [];
    unitISIDist.cv =[];
    unitISIDist.yo = [];
    for k=1:size(unitISIDist.cellLayer,1)
        if elNum ~= unitISIDist.cellLayer{k,1}% saves a little time
            clu = load([fileBase '/' fileBase '.clu.' num2str(unitISIDist.cellLayer{k,1})]);
            res = load([fileBase '/' fileBase '.res.' num2str(unitISIDist.cellLayer{k,1})]);
        end
        elNum = unitISIDist.cellLayer{k,1};
        selInd = find(clu(2:end)==unitISIDist.cellLayer{k,2});
        selRes = res(selInd);
        for n=1:length(time)
            selInd = find((selRes>(time(n)-timeWin/2)*datSamp) ...
                & (selRes<=(time(n)+timeWin/2)*datSamp));

            if ~isempty(selInd)
                try
                spikeBin = Accumulate(round(selRes(selInd)-(time(n)-timeWin/2)*datSamp),1,timeWin*datSamp);
                catch
                    keyboard
                end
            else
                spikeBin = zeros(timeWin*datSamp,1);
            end
            [unitISIDist.to unitISIDist.pd(n,k,:) unitISIDist.mean(n,k) unitISIDist.cv(n,k)] ...
                = isidist(spikeBin,binSize,maxT,1000/datSamp);
            unitISIDist.nIntervals(n,k) = sum(spikeBin)-1;
            unitISIDist.yo(n,k,:) = unitISIDist.pd(n,k,:)*unitISIDist.nIntervals(n,k);

        end

    end
    clu = [];
    res = [];
    save([fileBase '/' SC(spectAnalDir) 'unitISIDistBin' num2str(binSize) '.mat'],SaveAsV6,'unitISIDist');
end
% catch
%     junk = lasterror
%     %junk.stack
%     keyboard
% end

SetWarnings(prevWarnSettings);