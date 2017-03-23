function outStructCell = CellStruct2StructCell(inCellStruct)
% function outStructCell = CellStruct2StructCell(inCellStruct)
% converts inCellStruct{n}.fields.fields.etc(mXoX...) to
% outStructCell.fields.fields.etc{n}(mXoX...)
% NOTE: only works for structs where all branches are equal length.

tempCell = Struct2CellArray(inCellStruct{1},[],1);
outStructCell(1:size(tempCell,1),1:size(tempCell,2)-1) = tempCell(1:end,1:end-1);
catCell = cell(size(tempCell,1),1);
tempCellStruct = inCellStruct(:);
for j=1:length(tempCellStruct)
    tempCell = Struct2CellArray(tempCellStruct{j},[],1);
    for k=1:size(tempCell,1)
        catCell{k} = cat(1,catCell{k},tempCell(k,end));
    end
end
for k=1:size(catCell,1)
    catCell{k} = reshape(catCell{k},size(inCellStruct));
end
outStructCell(:,size(tempCell,2)) = catCell;
outStructCell = CellArray2Struct(outStructCell);
return