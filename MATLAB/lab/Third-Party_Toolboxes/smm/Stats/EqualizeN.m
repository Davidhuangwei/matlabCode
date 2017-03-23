% function outputStruct = EqualizeN(inputData,varargin)
% [sameIndexesDepth] = DefaultArgs(varargin,{0});
function outputStruct = EqualizeN(inputData,varargin)
[sameIndexesDepth] = DefaultArgs(varargin,{0});

cellConvertBool = 0;
if ~iscell(inputData)
    inputData = {inputData};
    cellConvertBool = 1;
end
fields = fieldnames(inputData{1});
depCell = Struct2CellArray(inputData{1},[],1);
for j=1:size(depCell,1)
    nTrials(j) = size(depCell{j,end},1);
end
shortestLen = min(nTrials);
    
[rmIndStruct counter] = CalcIndexes(inputData{1},shortestLen,sameIndexesDepth);

for i=1:length(inputData)
    outputStruct{i} = DeleteOutliers(inputData{i},rmIndStruct);
end
if cellConvertBool
   outputStruct = cell2mat(outputStruct);
end
return

%%%%% calc indexes %%%%%%
function [rmIndStruct counter] = CalcIndexes(dataMatStruct,shortestLen,varargin)
[sameIndexesDepth] = DefaultArgs(varargin,{0});

if ~isstruct(dataMatStruct)
    rmIndStruct = logical(ones(size(dataMatStruct,1),1));
    rmIndStruct(randsample(size(dataMatStruct,1),shortestLen)) = 0;
    counter = 1;
else
    fields = fieldnames(dataMatStruct);
    for i=1:length(fields)
        inDataMatStruct = dataMatStruct.(fields{i});
        [tempIndexes counter] = CalcIndexes(inDataMatStruct,shortestLen,sameIndexesDepth);
        if counter > sameIndexesDepth
            rmIndStruct.(fields{i}) = tempIndexes;
        else 
            if ~exist('rmIndStruct','var')
                rmIndStruct = tempIndexes;
            else
                if length(rmIndStruct) ~= length(tempIndexes)
                    ERROR_MATRICES_DIFFERENT_SIZES
                end
            end
        end
    end
    counter = counter + 1;
end
return
