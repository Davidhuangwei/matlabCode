function outCellStruct = StructCell2CellStruct(inStructCell)
% function outCellStruct = StructCell2CellStruct(inStructCell)
% converts inStructCell.fields.fields.etc{n}(mXoX...) to
% outCellStruct{n}.fields.fields.etc(mXoX...)
% NOTE: only works for structs where all branches are equal length.

tempCell = Struct2CellArray(inStructCell,[],1);
endCell = tempCell{1,end};
for j=1:length(endCell(:))
    outCellStruct{j}(1:size(tempCell,1),1:size(tempCell,2)-1) = tempCell(1:end,1:end-1);
    for k=1:size(tempCell,1)
        endCell = tempCell{k,end};
        outCellStruct{j}(k,size(tempCell,2)) = endCell(j);
    end
    outCellStruct{j} = CellArray2Struct(outCellStruct{j});
end
outCellStruct = reshape(outCellStruct,size(tempCell{1,end}));
return
