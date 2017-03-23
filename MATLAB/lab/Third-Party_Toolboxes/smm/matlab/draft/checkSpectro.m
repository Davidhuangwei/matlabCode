function checkSpectro(fileBaseMat)
win = 626;
newB = [];
for j=1:size(fileBaseMat,1)
    fileBase = fileBaseMat(j,:);
    inName = [fileBase '_specgram_win' num2str(win) '.mat'];
    fprintf('Loading: %s\n' ,inName)
    load(inName);
    newB = cat(2,newB,b);
end
 keyboard
 
b = squeeze(mean(10.*log10(abs(newB)),2));