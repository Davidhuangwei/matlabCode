function CalcUnitSpectrum01(fileBaseCell,varargin)
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

bps = 2;
nChan = load('ChanInfo/NChan.eeg.txt');

paramb = [];
paramb.Fs = newSamp;
paramb.pad = 1;
paramb.tapers = [5 7];
unitPowSpec.paramb = paramb;

try
for j=1:length(fileBaseCell)
    fileBase = fileBaseCell{j}
    time = LoadVar([fileBase '/' spectAnalDir 'time.mat']);
    unitPowSpec.yo = [];
    unitPowSpec.rate = [];
    unitPowSpec.elClu = [];
    unitPowSpec.fo = [];
    %unitPowSpec.OlSkuRate = [];
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
        selRes = res(clu(2:end)==cluLoc(k,2));
        if ~isempty(selRes)
            %[spikeBin spikeBinTime] = hist(selRes,max(selRes)/datSamp*newSamp);
            spikeBin = Accumulate(round(selRes/datSamp*newSamp),1,numNewSamp);
            %spikeBinTime = (1:numNewSamp)/newSamp;
        else
            spikeBin = zeros(numNewSamp,1);
            %spikeBinTime = (1:numNewSamp)/newSamp;
        end
        trialBin = [];
        for n=1:length(time)
            spikeBinStartInd = max(1,round((time(n)-timeWin/2)*newSamp));
            trialBin(n,:) = spikeBin(spikeBinStartInd:min(spikeBinStartInd+newWinLen,numNewSamp));
            %spikeBinStartInd = find(spikeBinTime>=time(n)-round(timeWin/2),1);
            %trialBin(n,:) = spikeBin(spikeBinStartInd:spikeBinStartInd+newWinLen);
        end
        [specTemp,foTemp,rateTemp]=mtspectrumpb(trialBin',paramb);
        if ~isempty(unitPowSpec.fo) & unitPowSpec.fo ~= foTemp
            problem
        else
            unitPowSpec.fo = foTemp;
        end
        %         elsehelp 
        %             specTemp = zeros(size(unitPowSpec.yo,3),length(time));
        %             rateTemp = zeros(length(time),1);
        %         end
        
%         if sum(rateTemp>0)
%             keyboard
%         end
        unitPowSpec.yo = cat(2,unitPowSpec.yo,permute(specTemp,[2,3,1]));
        unitPowSpec.rate = cat(2,unitPowSpec.rate,rateTemp);
        %unitPowSpec.OlSkuRate = cat(2,unitPowSpec.OlSkuRate,sum(trialBin,2));
        unitPowSpec.elClu = cat(1,unitPowSpec.elClu,[cluLoc(k,1) cluLoc(k,2)]);
    end
    save([fileBase '/' spectAnalDir 'unitPowSpec.mat'],SaveAsV6,'unitPowSpec');
    %unitPowSpec
%firingRate.elClu
end
catch
    junk = lasterror
    junk.stack
    keyboard
end
