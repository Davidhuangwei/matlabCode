function [outCell] = GetAllFields(categIndepStruct)
% given a struct returns the data from all branches of the struct and a cell
% array deliniating the branch matrix

outCell = {};
if isstruct(categIndepStruct)
    names = fieldnames(categIndepStruct);
    for i=1:length(names)
        [tempOutCell] = GetAllFields(getfield(categIndepStruct,names{i}));
        %size(tempData,1)
        outCell = cat(1,outCell,cat(2,repmat(names(i),size(tempOutCell,1),1),tempOutCell));
        %data = cat(1,data,tempData);
    end
else
    if iscell(categIndepStruct)
        outCell = categIndepStruct;
    else
    outCell =  mat2cell(categIndepStruct,ones(size(categIndepStruct,1),1),...
			size(categIndepStruct,2));
    end
end
return