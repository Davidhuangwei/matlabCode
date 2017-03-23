function CalcSpecgrams(fileBaseMat)
win = 626;
nChan = 33;
%channels = [18,19,20,21,49,50,51,66,67,68,83,85]; %sm9608
%channels = [1,2,3,17,18,33,34,50,51,68,69]; %sm9614
channels = [4,8,12,16,20,24,28,32]; %dr103
for j=1:size(fileBaseMat,1)
    fileBase = fileBaseMat(j,:);
    fprintf('Loading: %s\n', [fileBase '.eeg']);
    for i=1:length(channels)
        eeg = readmulti([fileBase '.eeg'],nChan,channels(i));
        [b(:,:,i) f t] = specgram(eeg,win*2,1250,win,win/2);
    end
    outName = [fileBase '_specgram_win' num2str(win) '.mat'];
    fprintf('Saving: %s\n',outName);
    save(outName, 'b','f','t','channels');
    clear b;
    clear f;
    clear t;
end
