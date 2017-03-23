% function AllEegSegTimes2StsRun(fileBaseCell,spectAnalDir,winLen)
function AllEegSegTimes2StsRun(fileBaseCell,spectAnalDir,winLen)


for j=1:length(fileBaseCell)
    allTimes = LoadVar([fileBaseCell{j} '/' spectAnalDir '/allEegSegTime.mat']);
    epochs = Times2Epochs(allTimes,winLen);
    msave([fileBaseCell{j} '/' fileBaseCell{j} '.sts.RUN'],epochs)
end
