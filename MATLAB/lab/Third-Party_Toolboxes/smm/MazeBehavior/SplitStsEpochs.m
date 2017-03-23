% function SplitStsEpochs(fileBaseCell,mergeBase,fileExtCell,varargin)
% [nChan stsFs eegFs outFs bps] = DefaultArgs(varargin,{load('ChanInfo/NChan.eeg.txt'),1250,1250,1,2});
% Splits the sts epochs generated from Anton's ~CheckEegStates.m calculated
% on a merged eeg file and distributes the appropriate epochs back to the
% original eeg file directories.  
function SplitStsEpochs(fileBaseCell,mergeBase,fileExtCell,varargin)
[nChan stsFs eegFs outFs bps] = DefaultArgs(varargin,{load('ChanInfo/NChan.eeg.txt'),1250,1250,1250,2});

for j=1:length(fileBaseCell)
    junk = dir([fileBaseCell{j} '/' fileBaseCell{j} '.eeg']);
    fileSizes(j) = junk.bytes/bps/nChan*stsFs/eegFs;
end
fileCum = [0; cumsum(fileSizes)'];

for k=1:length(fileExtCell)
    epochs = load([mergeBase '/' mergeBase fileExtCell{k}]);
    allEpochs = {};
    for j=2:length(fileCum)
        col1 = find(epochs(:,1)>fileCum(j-1) & epochs(:,1)<fileCum(j));
        col2 = find(epochs(:,2)>fileCum(j-1) & epochs(:,2)<fileCum(j));
        if length(col1) == length(col2)
            allEpochs{j-1} = cat(2,epochs(col1,1),epochs(col2,2));
        else
            if length(col2) > length(col1)
                allEpochs{j-1} = cat(2,cat(1,fileCum(j-1)+1,epochs(col1,1)),epochs(col2,2));
            else
                allEpochs{j-1} = cat(2,epochs(col1,1),cat(1,epochs(col2,2),fileCum(j)));
            end
        end
    end
    
    for j=1:length(fileBaseCell)
        outVar = (allEpochs{j}-fileCum(j))*outFs/stsFs;
        save([fileBaseCell{j} '/' fileBaseCell{j} fileExtCell{k}],'-ascii','outVar');
    end
end

return

%%%%%%%
mazeFiles = {};
remFiles = {};
for j=1:length(allFiles)
    temp = load([allFiles{j} '/' allFiles{j} '.sts.REM']);
    if ~isempty(temp)
        remFiles = cat(1,remFiles,allFiles(j));
    end
    temp = load([allFiles{j} '/' allFiles{j} '.sts.RUN']);
    if ~isempty(temp)
        mazeFiles = cat(1,mazeFiles,allFiles(j));
    end
end
save('FileInfo/MazeFiles.mat',SaveAsV6,'mazeFiles')
save('FileInfo/RemFiles.mat',SaveAsV6,'remFiles')
    
    

