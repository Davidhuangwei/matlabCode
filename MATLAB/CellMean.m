function mA=CellMean(A)
% mA=CellMean(A) compute the mean of cell matrix.
A=A(:);
lA=length(A);
mA=A{1};
for k=2:lA
    mA=mA+A{k};
end
mA=mA/lA;