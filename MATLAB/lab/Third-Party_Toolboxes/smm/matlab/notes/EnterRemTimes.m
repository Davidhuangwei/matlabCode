save('RemFiles','remFiles')
for i=1:size(remFiles,1)
    remTimes(i).fileName = remFiles(i,:)
end

remTimes(1).times = [1*60+4 2*60+41]

for i=1:length(remTimes)
remTimes(i).fileName
remTimes(i).times
end

nchan = 97
chan = 38
eegSamp = 1250
for i=1:length(remTimes)
    inName = [remTimes(i).fileName '.eeg'];
    fprintf('%s ',inName);
    eeg = readmulti(inName,nchan,chan);
    plot(eeg(round(remTimes(i).times(1)*eegSamp+1):round(remTimes(i).times(2)*eegSamp+1)))
    zoom on
    pause
end
in = [];
while ~strcmp(in,'yes') & ~strcmp(in,'no')
    in = input('Save these times? (yes/no) ','s');
    if strcmp(in,'yes')
        save('RemTimes','remTimes')
    end
end
