function eqBoolean = CellEQ(cellArray1,cellArray2)
% Recursively decends into each cell of the cell arrays to determine if
% the two arrays are equal
eqBoolean = ~CellNE(cellArray1,cellArray2);
