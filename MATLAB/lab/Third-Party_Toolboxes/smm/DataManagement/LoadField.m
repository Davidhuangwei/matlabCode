function outData = LoadField(depVar)  
%function outData = LoadField(depVar)  
%loads a specific field from a single struct in a .mat file
% e.g. depVar = happy.joy.love loads the joy.love field from the 
% .mat file happy
[dirName fileName] = SplitDirFileName(depVar);
depVarCell = ParseStructName(fileName);
outData = LoadVar([dirName depVarCell{1}]);
for j=2:length(depVarCell)
    outData = getfield(outData,depVarCell{j});
end
return