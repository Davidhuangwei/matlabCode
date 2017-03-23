function CheckEegSizes01(analDirs)

    cwd = pwd;
    for j=1:length(analDirs)
        cd(analDirs{j});
        allFiles = LoadVar('FileInfo/AllFiles.mat');
        for k=1:length(allFiles)
            eval(['!ls -lh ../processed/' allFiles{k} '/' allFiles{k} '.eeg']);
        end
    end
    cd(cwd);
return

