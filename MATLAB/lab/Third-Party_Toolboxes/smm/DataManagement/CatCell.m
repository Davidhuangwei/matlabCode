% function outCell = CatCell(cellArray1,cellArray2,catDim)
% cats mats in cellArray1 to mats in cellArray2
% tag:cat
% tag:cell

function outCell = CatCell(cellArray1,cellArray2,catDim)

if any(size(cellArray1) ~= size(cellArray2))
    error([mfilename ':arraysNotSameSize'],'Cell arrays must be same size')
end
for j=1:length(cellArray1(:))
    outCell{j} = cat(catDim,cellArray1{j},cellArray2{j});
end

outCell = reshape(outCell,size(cellArray1));