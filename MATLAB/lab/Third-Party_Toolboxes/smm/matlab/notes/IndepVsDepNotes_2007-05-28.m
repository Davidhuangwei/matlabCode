
for j=1:length(alterFiles)
    junk = LoadVar([forceFiles{j} '/' spectAnalDir{1} fileExtCell{1} '/' 'taskType'])
end

temp = LoadVar('../../7-15-04/analysis/FileInfo/AlterFiles')
alterFiles = temp
temp = LoadVar('../../7-16-04/analysis/FileInfo/AlterFiles')
alterFiles = cat(1,alterFiles,temp)
save('FileInfo/AlterFiles.mat',SaveAsV6,'alterFiles')

temp = LoadVar('../../7-15-04/analysis/FileInfo/ForceFiles')
forceFiles = temp
temp = LoadVar('../../7-16-04/analysis/FileInfo/ForceFiles')
forceFiles = cat(1,forceFiles,temp)
save('FileInfo/ForceFiles.mat',SaveAsV6,'forceFiles')

for k=1:length(analDirs)
for j=1:length(alterFiles)
    if exist([analDirs{k} alterFiles{j}],'dir')
        eval(['!ln -s ' analDirs{k} alterFiles{j} ' .'])
    end
end
end


for k=1:length(analDirs)
for j=1:length(forceFiles)
    if exist([analDirs{k} forceFiles{j}],'dir')
        eval(['!ln -s ' analDirs{k} forceFiles{j} ' .'])
    end
end
end

alterFiles = LoadVar('FileInfo/AlterFiles')
forceFiles = LoadVar('FileInfo/ForceFiles')

for j=1:length(alterFiles)
any(~strcmp(LoadVar([alterFiles{j} '/' spectAnalDir{1} fileExtCell{1} '/' 'taskType']),'alter'))
end


for j=1:length(forceFiles)
any(~strcmp(LoadVar([forceFiles{j} '/' spectAnalDir{1} fileExtCell{1} '/' 'taskType']),'force'))
end


glmVersion = 'GlmWholeModel08'
load(['TrialDesig/' glmVersion '/' analRoutine{1} '.mat'])
dirName = [spectAnalDir{1} fileExtCell{1}];


indepCell = Struct2CellArray(LoadDesigVar(mazeFiles,dirName,'speed.p0',trialDesig),[],1);
indepCell = Struct2CellArray(LoadDesigVar(mazeFiles,dirName,'accel.p0',trialDesig),[],1);
depCell = Struct2CellArray(LoadDesigVar(mazeFiles,dirName,[depVarCell{1} '.ca3Pyr'],trialDesig),[],1);

% depCell = Struct2CellArray(LoadDesigVar(intersect(fileBaseCell,files.name),dirName,[depVar '.yo.ca3Pyr'],trialDesig),[],1);

chanMat = LoadVar(['ChanInfo/ChanMat' fileExtCell{1} '.mat'])
badChan = load(['ChanInfo/BadChan'  fileExtCell{1} '.txt'])
plotColors = 'rgbk'
for j=1:size(chanMat,1)
    for k=1:size(chanMat,2)
        subplot(size(chanMat,1),size(chanMat,2),(j-1)*size(chanMat,2)+k)
        hold on
        for m=1:size(depCell,1)
            if ~ismember(chanMat(j,k),badChan)
                plot(indepCell{m,end},UnATanCoh(depCell{m,end}(chanMat(j,k))),[plotColors(m) '.'])
            end
            set(gca,'ylim',[0 1])
            if j==m & k==1
                xmax = get(gca,'xlim');
                text(xmax(2),mean(get(gca,'ylim')),[depCell{m,1:end-1}],'color',plotColors(m))
            end
        end
    end
end
