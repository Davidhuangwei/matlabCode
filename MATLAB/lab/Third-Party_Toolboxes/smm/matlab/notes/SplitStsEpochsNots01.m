% function SplitStsEpochs(fileBaseCell,mergeBase,fileExtCell,varargin)
% [stsFs eegFs outFs bps] = DefaultArgs(varargin,{1250,1250,1,2});
% Splits the sts epochs generated from Anton's ~CheckEegStates.m calculated
% on a merged eeg file and distributes the appropriate epochs back to the
% original eeg file directories.  
function SplitStsEpochs(fileBaseCell,mergeBase,fileExtCell,varargin)
[stsFs eegFs outFs bps] = DefaultArgs(varargin,{1250,1250,1,2});

for j=1:length(fileBaseCell)
    junk = dir([fileBaseCell{j} '/' fileBaseCell{j} '.eeg']);
    fileSizes(j) = junk.bytes/bps/nChan*stsFs/eegFs;
end
fileCum = cumsum(fileSizes)';

for k=1:fileExtCell
    epochs = load([mergeBase '/' mergeBase fileExtCell{k}]);

    fileCum = [0; fileCum]
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
        save([fileBaseCell{j} '/' fileBaseCell{j} fileExtCell{k}],'-ascii',allEpochs{j}*outFs/stsFs);
    end
end



