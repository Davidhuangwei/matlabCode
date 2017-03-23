function CheckSpectraFiles01(outputFile,analDirs,varargin)
% function CheckSpectraFiles01(outputFile,analDirs,varargin)
% [fileExtCell runningSpectAnalBase remSpectAnalBase] = ...
%     DefaultArgs(varargin,{{'.eeg','_LinNearCSD121.csd'},...
%     'CalcRunningSpectra11_noExp_MinSpeed0Win1250',...
%     'CalcRemSpectra03_allTimes_Win1250'})

[fileExtCell runningSpectAnalBase remSpectAnalBase] = ...
    DefaultArgs(varargin,{{'.eeg','_LinNearCSD121.csd'},...
    'CalcRunningSpectra11_noExp_MinSpeed0Win1250',...
    'CalcRemSpectra03_allTimes_Win1250'})

eval(['!echo "' date '" >> ' outputFile]);

CheckRunningSpectraFiles01(outputFile,analDirs,fileExtCell,runningSpectAnalBase);
eval(['!echo "running scan complete" >> ' outputFile]);

CheckRemSpectraFiles01(outputFile,analDirs,fileExtCell,remSpectAnalBase);
eval(['!echo "rem scan complete" >> ' outputFile]);

temp = strfind(analDirs,'sm9601');
for j=1:length(temp)
    if isempty(temp{j})
        ind(j) = 0;
    else
        ind(j) = 1;
    end
end
sm9601AnalDirs = analDirs(logical(ind));
fileExts = {'.eeg';'_LinNearCSD121.csd'};
numChans = {81,72};
CheckSpectAnalSize01(outputFile,sm9601AnalDirs,fileExts,numChans,varargin)

otherAnalDirs = analDirs(~logical(ind));
fileExts = {'.eeg';'_LinNearCSD121.csd'};
numChans = {97,72};
CheckSpectAnalSize01(outputFile,otherAnalDirs,fileExts,numChans,varargin)

