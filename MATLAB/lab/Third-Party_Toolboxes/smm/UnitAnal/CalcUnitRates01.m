function CalcUnitRates01(fileBaseCell)
spectAnalDir = 'CalcRunningSpectra12_noExp_MidPoints_MinSpeed0Win626wavParam8.eeg/';
winLen = 626;
eegSamp = 1250;
datSamp = 20000;
for j=1:length(fileBaseCell)
    fileBase = fileBaseCell{j}
    time = LoadVar([fileBase '/' spectAnalDir 'time.mat']);
    firingRate = [];
    nEl = length(dir([fileBase '/*.fet.*']));
    for k=1:nEl
        clu = load([fileBase '/' fileBase '.clu.' num2str(k)]);
        res = load([fileBase '/' fileBase '.res.' num2str(k)]);
        for m=2:clu(1)-1
            selRes = res(clu(2:end)==m);
            for n=1:length(time)
                firingRate.(['elec' num2str(k)]).(['clu' num2str(m)])(n,1) = ...
                    sum(selRes>=(time(n)-winLen/eegSamp/2)*datSamp & selRes<=(time(n)+winLen/eegSamp/2)*datSamp) ...
                    /(winLen/eegSamp);
            end
        end
    end
    save([fileBase '/' spectAnalDir 'firingRate.mat'],SaveAsV6,'firingRate');
end

