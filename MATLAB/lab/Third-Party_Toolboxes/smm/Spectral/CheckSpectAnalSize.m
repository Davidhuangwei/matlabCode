function CheckSpectAnalSize01(analDirs,fileExts,numChans,varargin)
[SpectAnalBases] = DefaultArgs(varargin,{'CalcRunningSpectra11_noExp_MinSpeed0Win1250',...
    'CalcRemSpectra03_allTimes_Win1250'});

cwd = pwd;
for j=1:length(analDirs)
    cd(analDirs(j);
    allFiles = LoadVar('FileInfo/AllFiles.mat');
    for k=1:length(allFiles)
        for m=1:length(SpectAnalBases)
            for n=1:length(fileExts)
                if exist([allFiles{k} '/' SpectAnalBases{m} fileExts{n}],'dir')
                    eeg = LoadVar([allFiles{k} '/' SpectAnalBases{m} fileExts{n} '/rawTrace.mat']);
                    if size(eeg,2) == numChans{n}
                        fprintf('GOOD: %s\n',)
                    else
                        fprintf('BAD: %s\n',)
                    end
                end
            end
        end
    end
end
cd(cwd);
return

            

[fileExtCell runningSpectAnalBase remSpectAnalBase] = ...
    DefaultArgs(varargin,{{'.eeg','_LinNearCSD121.csd'},...
    'CalcRunningSpectra11_noExp_MinSpeed0Win1250',...
    'CalcRemSpectra03_allTimes_Win1250'})

eval(['!echo "' date '" >> ' outputFile]);

CheckRunningSpectraFiles01(outputFile,analDirs,fileExtCell,runningSpectAnalBase);
eval(['!echo "running scan complete" >> ' outputFile]);

CheckRemSpectraFiles01(outputFile,analDirs,fileExtCell,remSpectAnalBase);
eval(['!echo "rem scan complete" >> ' outputFile]);