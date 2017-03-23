function CheckSpectAnalSize01(outputFile,analDirs,fileExts,numChans,varargin)
[SpectAnalBases] = DefaultArgs(varargin,{{'CalcRunningSpectra11_noExp_MinSpeed0Win1250',...
    'CalcRemSpectra03_allTimes_Win1250'}});

fid = fopen(outputFile,'a');
if ~fid
    ERROR_OPENING_FILE
else
    cwd = pwd;
    for j=1:length(analDirs)
        cd(analDirs{j});
        allFiles = LoadVar('FileInfo/AllFiles.mat');
        for k=1:length(allFiles)
            for m=1:length(SpectAnalBases)
                for n=1:length(fileExts)
                    if exist([allFiles{k} '/' SpectAnalBases{m} fileExts{n}],'dir')
                        eeg = LoadVar([allFiles{k} '/' SpectAnalBases{m} fileExts{n} '/rawTrace.mat']);
                        if size(eeg,2) == numChans{n}
                            %fprintf('GOOD: %s%i\n',[analDirs{j} allFiles{k} '/' SpectAnalBases{m} fileExts{n} '/rawTrace.mat == '],numChans{n})
                        else
                            fprintf(fid,'BADNCHAN: %s%i\n',[analDirs{j} allFiles{k} '/' SpectAnalBases{m} fileExts{n} '/rawTrace.mat == '],size(eeg,2));
                        end
                    end
                end
            end
        end
    end
    cd(cwd);
    fclose(fid);
end
return

