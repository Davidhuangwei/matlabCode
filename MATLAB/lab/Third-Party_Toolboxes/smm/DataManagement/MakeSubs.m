function indexes = MakeSubs(dimVector)
% Makes a matrix of indexes for a matrix of dims specified by dimVector

indexes = [];
if ndims(dimVector) < 2 | (ndims(dimVector)==2 & size(dimVector,2)==1)
    dimVector(1)
    indexes = [1:dimVector(1)]';
    size(indexes)
else
    for i=1:dimVector(1)
        tempInd = MakeSubs(dimVector(2:end));
        indexes =  cat(1,indexes,cat(2,repmat(i,size(tempInd,1),1),tempInd));
    end
end
