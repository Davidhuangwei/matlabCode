function CalcUnitCCG01(fileBaseCell,varargin)
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
normalization = 'count';


bps = 2;
nChan = load('ChanInfo/NChan.eeg.txt');

paramb = [];
paramb.Fs = newSamp;
paramb.pad = 1;
paramb.tapers = [5 7];
unitCCG.paramb = paramb;

try
for j=1:length(fileBaseCell)
    fileBase = fileBaseCell{j}
    time = LoadVar([fileBase '/' spectAnalDir 'time.mat']);
    unitCCG.yo = [];
    unitCCG.to = [];
    unitCCG.rate = [];
    unitCCG.elClu = [];

    cluLoc = load([fileBase '/' fileBase '.cluloc']);
    elNum = 0;
    for k=1:size(cluLoc,1)
        if elNum ~= cluLoc(k,1)
            clu = load([fileBase '/' fileBase '.clu.' num2str(cluLoc(k,1))]);
            res = load([fileBase '/' fileBase '.res.' num2str(cluLoc(k,1))]);
            eegFiles = dir([fileBase '/' fileBase '.eeg']);
            numNewSamp = ceil(eegFiles(1).bytes/bps/nChan/eegSamp*newSamp);
        end
        elNum = cluLoc(k,1);
        selRes = clu(2:end)==cluLoc(k,2);
        ccgTemp = [];
        ccgTemp2 = [];
        rateTemp = [];
        for n=1:length(time)
            selInd = find(selRes & res>=(time(n)-timeWin/2)*datSamp & res<(time(n)+timeWin/2)*datSamp);
            if ~isempty(selInd)
                [ccgTemp toTemp] = CCG(res(selInd),ones(size(selInd,1),1),round(binSize*datSamp/1000),round(timeWin/2*1000/binSize),datSamp,1,normalization);
            else
                toTemp = [-round(timeWin/2*1000/binSize):round(timeWin/2*1000/binSize)]*round(binSize*datSamp/1000)/datSamp*1000;
                ccgTemp =  zeros(round(timeWin/2*1000/binSize)*2+1,1);
            end
            rateTemp(n,1) = length(selInd)/timeWin;
            ccgTemp2 = cat(1,ccgTemp2,ccgTemp');
        end
        if ~isempty(unitCCG.to) & unitCCG.to ~= toTemp
            problem
        else
            unitCCG.to = toTemp;
        end
%         figure
%         plot(mean(ccgTemp2));
        %plot(mean(ccgTemp2));
        %plot(sum(ccgTemp2));
        unitCCG.rate = cat(2,unitCCG.rate,rateTemp);
        unitCCG.yo = cat(2,unitCCG.yo,permute(ccgTemp2,[1,3,2]));
        unitCCG.elClu = cat(1,unitCCG.elClu,[cluLoc(k,1) cluLoc(k,2)]);
    end
    save([fileBase '/' spectAnalDir 'unitCCG.mat'],SaveAsV6,'unitCCG');
end
catch
    junk = lasterror
    %junk.stack
    keyboard
end
