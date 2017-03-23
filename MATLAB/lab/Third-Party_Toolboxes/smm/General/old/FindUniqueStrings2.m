function outString = FindUniqueStrings2(inputCell)
% given a cell array of text strings returns a cell array of the
% unique text strings
outString = inputCell{1};
inputCell(find(strcmp(inputCell,outString))) = [];
if ~isempty(inputCell)
    temp = FindUniqueStrings2(inputCell);
    outString = cat(1,{outString},temp);
end
return