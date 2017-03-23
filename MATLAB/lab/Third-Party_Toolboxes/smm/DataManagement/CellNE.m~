% function neBoolean = CellNE(cellArray1,cellArray2)
% Recursively decends into each cell of the cell arrays to determine if
% the two arrays are not equal
% tag:cell array
% tag:ne

function neBoolean = CellNE(cellArray1,cellArray2)

neBoolean = 0;
if iscell(cellArray1)
    if ~iscell(cellArray2)
        neBoolean = logical(1);
    else
        if length(cellArray1(:)) ~= length(cellArray2(:))
            neBoolean = logical(1);
        else
            for j=1:length(cellArray1(:))
                neBoolean = neBoolean | CellNE(cellArray1{j},cellArray2{j});
            end
        end
    end
else
    if iscell(cellArray2)
        neBoolean = logical(1);
    else
        if all(size(cellArray1) == size(cellArray2)) & cellArray1 == cellArray2
            neBoolean = logical(0);
        else
           neBoolean = logical(1);
        end
    end
end
return
