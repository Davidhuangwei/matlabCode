function outData = LoadField(depVar,varargin)  
%function outData = LoadField(depVar)  
%loads a specific field from a single struct in a .mat file
% e.g. depVar = happy.joy.love loads the joy.love field from the 
% .mat file happy
args=struct('warning','on');
args=parseArgs(varargin,args);

[dirName fileName] = SplitDirFileName(depVar);
depVarCell = ParseStructName(fileName);
outData = [];
if exist([dirName depVarCell{1}],'file')
    outData = LoadVar([dirName depVarCell{1}]);
    for j=2:length(depVarCell)
        outData = getfield(outData,depVarCell{j});
    end
    return
else
    if strcmp(args.warning,'on')
        fprintf([dirName depVarCell{1} ' not found']);
    end
    error('')
end
