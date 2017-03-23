function [data, groupCell] = LoadAllDesigVar(fileBaseMat,dirName,contIndepCell{i},categIndepStruct)
% given a struct returns the data from all branches of the struct and a cell
% array deliniating the branch matrix

data = [];
groupCell = {};

names = fieldnames(categIndepStruct);
if isstruct(getfield(categIndepStruct,names{1}))
    names = fieldnames(categIndepStruct);
    for i=1:length(names)
        [tempData, tempNameCell] = LoadAllDesigVar(getfield(categIndepStruct,names{i})); 
        groupCell = cat(1,groupCell,cat(2,repmat(names(i),size(tempData,1),1),tempNameCell));
        data = cat(1,data,tempData);
    end
else
    data = categIndepStruct;
end
return