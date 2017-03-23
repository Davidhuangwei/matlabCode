function [outCell] = Struct2CellArray(categIndepStruct,varargin)
%function [outCell] = Struct2CellArray(categIndepStruct,varargin)
%[indexMat packDataBool] = DefaultArgs(varargin,{[],0});
% given a struct returns the data from all branches of the struct and a cell
% array deliniating the branch matrix
% optional argument indexMat is an n by 2 mat with the first column
% designating the dimension of the index in the second column
% if packDataBool: the data at end of each branch is packed in a single element cell array 

[indexMat packDataBool] = DefaultArgs(varargin,{[],0});

outCell = {};
if isstruct(categIndepStruct)
    names = fieldnames(categIndepStruct);
    for i=1:length(names)
        [tempOutCell] = Struct2CellArray(getfield(categIndepStruct,names{i}),indexMat,packDataBool);
        %size(tempData,1)
        outCell = cat(1,outCell,cat(2,repmat(names(i),size(tempOutCell,1),1),tempOutCell));
        %data = cat(1,data,tempData);
    end
else
    categIndepStruct = NDimSub(categIndepStruct,indexMat);
    
    if packDataBool
        outCell =  {categIndepStruct};
    else
        if iscell(categIndepStruct)
            outCell = categIndepStruct;
        else
            kloogText = ['mat2cell(categIndepStruct,ones(size(categIndepStruct,1),1)'];
            for i=2:ndims(categIndepStruct)
                kloogText = [kloogText ',' num2str(size(categIndepStruct,i))];
            end
            kloogText = [kloogText ')'];
            outCell =  eval(kloogText);
        end
    end
end
return