function CalcUnitFieldCoh01(fileBaseCell,winLen,spectAnalDir,varargin)
eegSamp = 1250;
datSamp = 20000;
timeWin = winLen/eegSamp;
selChanCell = Struct2CellArray(LoadVar('ChanInfo/SelChan.eeg.mat'));
[selChan,fpass,tapers,newSamp,padBool] = DefaultArgs(varargin,{[selChanCell{:,end}],[0 250],[2,3],eegSamp,0});

newWinLen = round(winLen/eegSamp*newSamp);

bps = 2;
nChan = load('ChanInfo/NChan.eeg.txt');

paramb = [];
paramb.fpass = fpass;
paramb.Fs = newSamp;
paramb.pad = padBool;
paramb.tapers = tapers;
unitFieldCoh.paramb = paramb;
unitFieldPhase.paramb = paramb;
unitFieldCrossSpec.paramb = paramb;

% try
for j=1:length(fileBaseCell)
    fileBase = fileBaseCell{j}
    time = LoadVar([fileBase '/' spectAnalDir 'time.mat']);
    cellLayer = LoadCellLayers([fileBase '/' fileBase '.cellLayer']);
    cellType = LoadCellTypes([fileBaseCell{1} '/' fileBaseCell{1} '.type']);
    
    unitFieldCoh.cellLayer = cellLayer;
    unitFieldCoh.cellType = cellType;
    unitFieldCoh.yo = [];
    unitFieldCoh.fo = [];
    unitFieldPhase.cellLayer = cellLayer;
    unitFieldPhase.cellType = cellType;
    unitFieldCrossSpec.cellLayer = cellLayer;
    unitFieldCrossSpec.cellType = cellType;
    
    eegTrials = zeros(length(time),length(selChan),winLen);
    for n=1:length(time)
        tempEEG = bload([fileBase '/' fileBase '.eeg'],[nChan winLen],...
            round((time(n)-timeWin/2)*eegSamp*nChan*bps));
        eegTrials(n,:,:) = tempEEG(selChan,:);
    end
    eegFiles = dir([fileBase '/' fileBase '.eeg']);
    numNewSamp = ceil(eegFiles(1).bytes/bps/nChan/eegSamp*newSamp);
    elNum = 0;
    for k=1:size(cellLayer,1)
        if elNum ~= cellLayer{k,1}
            clu = load([fileBase '/' fileBase '.clu.' num2str(cellLayer{k,1})]);
            res = load([fileBase '/' fileBase '.res.' num2str(cellLayer{k,1})]);
        end
        elNum = cellLayer{k,1};
        selRes = res(clu(2:end)==cellLayer{k,2});
        if ~isempty(selRes)
            spikeBin = Accumulate(round(selRes/datSamp*newSamp),1,numNewSamp);
        else
            spikeBin = zeros(numNewSamp,1);
        end
        trialBin = [];
        for n=1:length(time)
            spikeBinStartInd = max(1,round((time(n)-timeWin/2)*newSamp));
            trialBin(n,:) = spikeBin(spikeBinStartInd:min(spikeBinStartInd+newWinLen-1,numNewSamp));
            %spikeBinStartInd = find(spikeBinTime>=time(n)-round(timeWin/2),1);
            %trialBin(n,:) = spikeBin(spikeBinStartInd:spikeBinStartInd+newWinLen);
        end
        for m=1:length(selChan)
            [cohTemp phiTemp csdTemp spec1Junk spec2Junk foTemp zerospTemp] = ...
                coherencycpb(squeeze(eegTrials(:,m,:))',trialBin',paramb);
            %         [specTemp,foTemp,rateTemp]=mtspectrumpb(trialBin',paramb);
            if ~isempty(unitFieldCoh.fo) & unitFieldCoh.fo ~= foTemp
                problem
            else
                unitFieldCoh.fo = foTemp;
            end
            if isempty(unitFieldCoh.yo)
                unitFieldCoh.yo = zeros([length(time) size(cellLayer,1) ...
                    length(selChan) size(cohTemp,1)]);
                unitFieldCoh.zerosp = zeros([length(time) size(cellLayer,1)]);
                
                unitFieldPhase.yo = zeros([length(time) size(cellLayer,1) ...
                    length(selChan) size(cohTemp,1)]);
                unitFieldPhase.zerosp = zeros([length(time) size(cellLayer,1)]);
                  
                unitFieldCrossSpec.yo = zeros([length(time) size(cellLayer,1) ...
                    length(selChan) size(cohTemp,1)]);
                unitFieldCrossSpec.zerosp = zeros([length(time) size(cellLayer,1)]);
            end
            unitFieldCoh.yo(:,k,m,:) = permute(cohTemp,[2,3,1]);
            unitFieldCoh.fo = foTemp;
            unitFieldCoh.zerosp(:,k) = zerospTemp;

            unitFieldPhase.yo(:,k,m,:) = permute(phiTemp,[2,3,1]);;
            unitFieldPhase.fo = foTemp;
            unitFieldPhase.zerosp(:,k) = zerospTemp;

            unitFieldCrossSpec.yo(:,k,m,:) = permute(csdTemp,[2,3,1]);;
            unitFieldCrossSpec.fo = foTemp;
            unitFieldCrossSpec.zerosp(:,k) = zerospTemp;
        end
    end
    save([fileBase '/' spectAnalDir 'unitFieldCoh.mat'],SaveAsV6,'unitFieldCoh');
    save([fileBase '/' spectAnalDir 'unitFieldPhase.mat'],SaveAsV6,'unitFieldPhase');
    save([fileBase '/' spectAnalDir 'unitFieldCrossSpec.mat'],SaveAsV6,'unitFieldCrossSpec');
    %unitPowSpec
%firingRate.elClu
end
% catch
%     junk = lasterror
%     junk.stack
%     keyboard
% end
