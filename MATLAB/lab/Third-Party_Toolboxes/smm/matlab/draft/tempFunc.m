function tempFunc(taskType,fileBaseMat,nChan,channels)

win = 1250*2;
eegSamp = 1250;
eeg = [];
for i=1:size(fileBaseMat,1)
    inName = [fileBaseMat(i,:) '.eeg'];
    fprintf('Loading: %s\n',inName);
    eeg = [eeg; readmulti(inName,nChan,channels)];
end

for i=1:length(channels)
 %   [p f] = spectrum(eeg(:,i),win*2,win/2,win,eegSamp);
    [p f] = pwelch(eeg(:,i),win,win/2,win*2,eegSamp);
    
    b(:,i,:) = 10.*log10(p);
end

outName = [taskType '_PSpectrum_Win_' num2str(win) 'DB.mat'];
fprintf('Saving: %s\n',outName);
save(outName, 'b','f','channels');