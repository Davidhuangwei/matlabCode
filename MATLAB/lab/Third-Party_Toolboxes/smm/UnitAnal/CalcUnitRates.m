function CalcUnitRates(fileBaseCell)
spectAnalDir = 'CalcRunningSpectra11_noExp_MinSpeed0Win1250.eeg/';
winLen = 1250;
eegSamp = 1250;
datSamp = 20000;
for j=1:length(fileBaseCell)
    fileBase = fileBaseCell{j}
    time = LoadVar([fileBase '/' spectAnalDir 'time.mat']);
    firingRate = [];
    nEl = length(dir('*.fet.*'));
    for k=1:length(nEl)
        clu = load([fileBase '.clu.' num2str(k)]);
        res = load([fileBase '.res.' num2str(k)]);
        for m=2:clu(1)
            selRes = res(clu(2:end)==m);
            for n=1:length(time)
                [time-winLen/eegSamp/2:time+winLen/eegSamp/2]*datSamp
                firingRate.(['fet' num2str(k)]).(['clu' num2str(m)]) = ...
                    selRes(selRes>=(time-winLen/eegSamp/2)*datSamp & selRes<=(time+winLen/eegSamp/2)*datSamp);
            end
            
    