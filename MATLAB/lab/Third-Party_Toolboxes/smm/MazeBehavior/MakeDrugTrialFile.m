function MakeDrugTrialFile(drugName,varargin)

spectAnalBase = 'CalcRunningSpectra11_noExp_MinSpeed0Win1250';
analDirs = {};
fileExtCell = {'.eeg','_LinNearCSD121.csd'};
[analDirs spectAnalBase fileExtCell] = DefaultArgs(varargin,{analDirs,spectAnalBase,fileExtCell});

cwd = pwd;
for j=1:length(analDirs)
    mazeFiles = LoadVar([analDirs{j} 'FileInfo/MazeFiles.mat']);
    if exist([analDirs{j} 'FileInfo/' drugName 'Files.mat'],'file');
        drugFiles = intersect(mazeFiles,LoadVar([analDirs{j} 'FileInfo/' drugName 'Files.mat']));
    else
        drugFiles = {};
    end
    soberFiles = setdiff(mazeFiles,drugFiles);

    for k=1:length(soberFiles)
        for m=1:length(fileExtCell)
            time = LoadVar([analDirs{j} soberFiles{k} '/' spectAnalBase fileExtCell{m} '/time']);
            drug = repmat({'none'},size(time));
            fprintf('SOBER: %s\n',[analDirs{j} soberFiles{k} '/' spectAnalBase fileExtCell{m} '/drug.mat']);
            save([analDirs{j} soberFiles{k} '/' spectAnalBase fileExtCell{m} '/drug.mat'],SaveAsV6,'drug');

        end
    end
    for k=1:length(drugFiles)
        for m=1:length(fileExtCell)
            time = LoadVar([analDirs{j} drugFiles{k} '/' spectAnalBase fileExtCell{m} '/time']);
            drug = repmat({drugName},size(time));
            fprintf('%s: %s\n',drugName,[analDirs{j} drugFiles{k} '/' spectAnalBase fileExtCell{m} '/drug.mat']);
            save([analDirs{j} drugFiles{k} '/' spectAnalBase fileExtCell{m} '/drug.mat'],SaveAsV6,'drug');
        end
    end
end
