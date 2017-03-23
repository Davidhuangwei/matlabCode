function CalcUnitSpectrum03(fileBaseCell,winLen,spectAnalDir,varargin)
eegSamp = 1250;
datSamp = 20000;
timeWin = winLen/eegSamp;

[tapers,newSamp,padBool] = DefaultArgs(varargin,{[3,5],eegSamp,0});

newWinLen = round(winLen/eegSamp*newSamp);

bps = 2;
nChan = load('ChanInfo/NChan.eeg.txt');

paramb = [];
paramb.Fs = newSamp;
paramb.pad = padBool;
paramb.tapers = tapers;
unitPowSpec.paramb = paramb;

% try
for j=1:length(fileBaseCell)
    fileBase = fileBaseCell{j}
    time = LoadVar([fileBase '/' spectAnalDir 'time.mat']);
    unitPowSpec.yo = [];
    unitPowSpec.rate = [];
    unitPowSpec.fo = [];
    unitPowSpec.cellLayer = LoadCellLayers([fileBase '/' fileBase '.cellLayer']);
    unitPowSpec.cellType = LoadCellTypes([fileBaseCell{1} '/' fileBaseCell{1} '.type']);
%     cluLoc = load([fileBase '/' fileBase '.cluloc']);
    eegFiles = dir([fileBase '/' fileBase '.eeg']);
    numNewSamp = ceil(eegFiles(1).bytes/bps/nChan/eegSamp*newSamp);
    elNum = 0;
    for k=1:size(unitPowSpec.cellLayer,1)
        if elNum ~= unitPowSpec.cellLayer{k,1}
            clu = load([fileBase '/' fileBase '.clu.' num2str(unitPowSpec.cellLayer{k,1})]);
            res = load([fileBase '/' fileBase '.res.' num2str(unitPowSpec.cellLayer{k,1})]);
        end
        elNum = unitPowSpec.cellLayer{k,1};
        selRes = res(clu(2:end)==unitPowSpec.cellLayer{k,2});
        if ~isempty(selRes)
            spikeBin = Accumulate(round(selRes/datSamp*newSamp),1,numNewSamp);
        else
            spikeBin = zeros(numNewSamp,1);
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
        if isempty(unitPowSpec.yo)
            unitPowSpec.yo = zeros([length(time) size(unitPowSpec.cellLayer,1) size(specTemp,1)]);
            unitPowSpec.rate = zeros([length(time) size(unitPowSpec.cellLayer,1)]);
        end
        unitPowSpec.yo(:,k,:) = permute(specTemp,[2,3,1]);
        unitPowSpec.rate(:,k) = rateTemp;
    end
    save([fileBase '/' spectAnalDir 'unitPowSpec_tapers' num2str(paramb.tapers(2)) '.mat'],SaveAsV6,'unitPowSpec');
    %unitPowSpec
%firingRate.elClu
end
% catch
%     junk = lasterror
%     junk.stack
%     keyboard
% end
