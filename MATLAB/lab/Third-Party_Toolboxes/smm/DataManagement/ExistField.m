function outBool = ExistField(depVar)  
%function outBool = LoadField(depVar)  
%checks to see if a specific field exists from a single struct in a .mat file
% e.g. depVar = happy.joy.love checks to see if the joy.love field exists from the 
% .mat file happy
[dirName fileName] = SplitDirFileName(depVar);
depVarCell = ParseStructName(fileName);
outBool = 1;
if exist([dirName depVarCell{1} '.mat'],'file')
    data = LoadVar([dirName depVarCell{1}]);
    for j=2:length(depVarCell)
        if isfield(data,depVarCell{j})
            data = getfield(data,depVarCell{j});
        else
            outBool = 0;
            return
        end
    end
else
    outBool = 0;
end
return
