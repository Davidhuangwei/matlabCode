function CalcUnitPopACG01(fileBaseCell,varargin)
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


bps = 2;
nChan = load('ChanInfo/NChan.eeg.txt');

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
    chanLoc = LoadVar('ChanInfo/ChanLoc_Full.eeg.mat');
    elNum = 0;
    chanLocNames = fieldnames(chanLoc);
    for m=1:length(chanLocNames)
        unitPopACG.(chanLocNames{m}).yo = [];
        unitPopACG.(chanLocNames{m}).to = [];
        unitPopACG.(chanLocNames{m}).rate = [];

        catRes = [];
        for k=1:size(cluLoc,1)
            if elNum ~= cluLoc(k,1)
                clu = load([fileBase '/' fileBase '.clu.' num2str(cluLoc(k,1))]);
                res = load([fileBase '/' fileBase '.res.' num2str(cluLoc(k,1))]);
                eegFiles = dir([fileBase '/' fileBase '.eeg']);
                numNewSamp = ceil(eegFiles(1).bytes/bps/nChan/eegSamp*newSamp);
            end
            elNum = cluLoc(k,1);
            if sum(cluLoc(k,3)==[chanLoc.(chanLocNames{m}){:}])>0
                selRes = clu(2:end)==cluLoc(k,2);
                catRes = cat(1,catRes,res(selRes));
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
        if ~isempty(unitPopACG.(chanLocNames{m}).to) & unitPopACG.(chanLocNames{m}).to ~= toTemp
            problem
        else
            unitPopACG.(chanLocNames{m}).to = toTemp;
        end
        unitPopACG.(chanLocNames{m}).rate = cat(2,unitPopACG.(chanLocNames{m}).rate,rateTemp);
        unitPopACG.(chanLocNames{m}).yo = cat(2,unitPopACG.(chanLocNames{m}).yo,permute(ccgTemp2,[1,3,2]));
    end
    save([fileBase '/' spectAnalDir 'unitPopACG.mat'],SaveAsV6,'unitPopACG');
end
catch
    junk = lasterror
    %junk.stack
    keyboard
end
