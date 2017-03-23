function outPvalsStruct = TestZeroMeans(dataStruct)
%function outPval = TestZeroMeans(dataStruct)
%uses ttest to determine if group means are each zero

dataCell = Struct2CellArray(dataStruct,[],1);
nGroups = size(dataCell,1);
outPvalCell = dataCell;

anovaData = [];
anovaCateg = [];
for i=1:nGroups
    [h outPvalCell{i,end}] = ttest(dataCell{i,end});
end
outPvalsStruct = CellArray2Struct(outPvalCell);

return

