function CalcUnitRates02(fileBaseCell)
spectAnalDir = 'CalcRunningSpectra12_noExp_MidPoints_MinSpeed0Win626wavParam8.eeg/';
winLen = 626;
eegSamp = 1250;
datSamp = 20000;
newSamp = 1250;
timeWin = winLen/newSamp;

for j=1:length(fileBaseCell)
    fileBase = fileBaseCell{j}
    time = LoadVar([fileBase '/' spectAnalDir 'time.mat']);
    firingRate.ch = [];
    firingRate.elClu = [];
    cluLoc = load([fileBase '/' fileBase '.cluloc']);
    elNum = 0;
    for k=1:size(cluLoc,1)
        if elNum ~= cluLoc(k,1)
            clu = load([fileBase '/' fileBase '.clu.' num2str(cluLoc(k,1))]);
            res = load([fileBase '/' fileBase '.res.' num2str(cluLoc(k,1))]);
        end
        elNum = cluLoc(k,1);
        selRes = res(clu(2:end)==cluLoc(k,2));
        spikeBin = Accumulate(round(selRes/(datSamp/newSamp)));
        spikeBinTime = (1:max(selRes))/(datSamp/newSamp);
        for n=1:length(time)
            firingRateTemp(n,1) = ...
                sum(selRes>=(time(n)-winLen/eegSamp/2)*datSamp & selRes<=(time(n)+winLen/eegSamp/2)*datSamp) ...
                /(winLen/eegSamp);
        end
        firingRate.ch = cat(2,firingRate.ch,firingRateTemp);
        firingRate.elClu = cat(1,firingRate.elClu,[cluLoc(k,1) cluLoc(k,2)]);
    end
save([fileBase '/' spectAnalDir 'firingRate.mat'],SaveAsV6,'firingRate');
%firingRate.elClu
end

