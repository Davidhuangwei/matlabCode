function CalcUnitRates02(fileBaseCell)
spectAnalDir = 'CalcRunningSpectra12_noExp_MidPoints_MinSpeed0Win626wavParam8.eeg/';
winLen = 626;
eegSamp = 1250;
datSamp = 20000;

for j=1:length(fileBaseCell)
    fileBase = fileBaseCell{j}
    time = LoadVar([fileBase '/' spectAnalDir 'time.mat']);
    firingRate.ch = [];
    firingRate.elClu = [];
    nEl = length(dir([fileBase '/*.fet.*']));
    for k=1:nEl
        clu = load([fileBase '/' fileBase '.clu.' num2str(k)]);
        res = load([fileBase '/' fileBase '.res.' num2str(k)]);
        for m=2:max(unique(clu(2:end))) %%clu(1)-~isempty(find(clu==0))
            selRes = res(clu(2:end)==m);
            for n=1:length(time)
                firingRateTemp(n,1) = ...
                    sum(selRes>=(time(n)-winLen/eegSamp/2)*datSamp & selRes<=(time(n)+winLen/eegSamp/2)*datSamp) ...
                    /(winLen/eegSamp);
            end
            firingRate.ch = cat(2,firingRate.ch,firingRateTemp);
            firingRate.elClu = cat(1,firingRate.elClu,[k m]);
        end
    end
    save([fileBase '/' spectAnalDir 'firingRate.mat'],SaveAsV6,'firingRate');
end

