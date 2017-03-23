function outStruct = CellArray2Struct(inCell)
%function outStruct = CellArray2Struct(inCell)
%Each row of inCell delineates a branch of outStruct ending in the
%in the data at inCell(i,end)
%The inverse of Struct2CellArray

outStruct = [];
if size(inCell,2) > 1 
    fields = unique(inCell(:,1));
    origOrder = [];
    for i=1:length(fields)
        origOrder(i) = find(strcmp(fields{i},inCell(:,1)),1);
    end
    [y ind] = sort(origOrder);
    fields = fields(ind);
    for i=1:length(fields)
        outStruct.(fields{i}) = CellArray2Struct(inCell(strcmp(inCell(:,1),fields{i}),2:end));
    end
else
    for i=1:length(inCell)
        outStruct = cat(1,outStruct,inCell{i});
    end
end
return