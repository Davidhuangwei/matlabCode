function [outCell] = GetAllFieldsCell(categIndepStruct,indexMat)
% given a struct returns the data from all branches of the struct and a cell
% array deliniating the branch matrix
% optional argument indexMat is an n by 2 mat with the first column
% designating the dimension of the index in the second column

if ~exist('indexMat','var')
	indexMat = [];
end

outCell = {};
if isstruct(categIndepStruct)
    names = fieldnames(categIndepStruct);
    for i=1:length(names)
        [tempOutCell] = GetAllFieldsCell(getfield(categIndepStruct,names{i}),indexMat);
        %size(tempData,1)
        outCell = cat(1,outCell,cat(2,repmat(names(i),size(tempOutCell,1),1),tempOutCell));
        %data = cat(1,data,tempData);
    end
else
    categIndepStruct = NDimSub(categIndepStruct,indexMat);

    if iscell(categIndepStruct)
        outCell = categIndepStruct;
    else
        outCell = {categIndepStruct};
    end
end
return