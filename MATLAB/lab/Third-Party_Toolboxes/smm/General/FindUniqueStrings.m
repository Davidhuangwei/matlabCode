function outString = FindUniqueStrings(inputCell)
% given a cell array of text strings returns a cell array of the
% unique text strings
outString = inputCell{1};
inputCell(find(strcmp(inputCell,outString))) = [];
if ~isempty(inputCell)
    temp = FindUniqueStrings(inputCell);
    outString = cat(1,{outString},temp);
end
return