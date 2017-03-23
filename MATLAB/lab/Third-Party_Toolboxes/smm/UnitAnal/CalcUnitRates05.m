% function CalcUnitFieldCoh02(fileBaseCell,fileExt,winLen,spectAnalDir,varargin)
% eegSamp = 1250;
% datSamp = 20000;
% timeWin = winLen/eegSamp;
% selChanCell = Struct2CellArray(LoadVar(['ChanInfo/SelChan' fileExt '.mat']));
% [newSamp] = DefaultArgs(varargin,{eegSamp});
function CalcUnitRates05(fileBaseCell,fileExt,winLen,spectAnalDir,varargin)
eegSamp = 1250;
datSamp = 20000;
timeWin = winLen/eegSamp;
[newSamp] = DefaultArgs(varargin,{eegSamp});

for j=1:length(fileBaseCell)
    fileBase = fileBaseCell{j}
    time = LoadVar([fileBase '/' spectAnalDir 'time.mat']);
    firingRate.ch = [];
    firingRate.elClu = [];
    cluLoc = load([fileBase '/' fileBase '.cluloc']);
    elNum = 0;
    unitRate = zeros(length(time),size(cluLoc,1));
    for k=1:size(cluLoc,1)
        if elNum ~= cluLoc(k,1)
            clu = load([fileBase '/' fileBase '.clu.' num2str(cluLoc(k,1))]);
            res = load([fileBase '/' fileBase '.res.' num2str(cluLoc(k,1))]);
        end
        elNum = cluLoc(k,1);
        selRes = res(clu(2:end)==cluLoc(k,2));
%         spikeBin = Accumulate(round(selRes/(datSamp/newSamp)));
%         spikeBinTime = (1:max(selRes))/(datSamp/newSamp);
        for n=1:length(time)
            unitRate(n,k) = ...
                sum(selRes>=(time(n)-timeWin/2)*datSamp & selRes<=(time(n)+timeWin/2)*datSamp) ...
                /(timeWin);
        end
    end
save([fileBase '/' spectAnalDir 'unitRate.mat'],SaveAsV6,'unitRate');
%firingRate.elClu
end

