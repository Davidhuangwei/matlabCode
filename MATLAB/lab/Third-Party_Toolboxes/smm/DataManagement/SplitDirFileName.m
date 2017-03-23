function [dirName fileName] = SplitDirFileName(depVar);
%function [dirName fileName] = SplitDirFileName(depVar);

index = find(depVar == '/',1,'last');
if ~isempty(index)
dirName = depVar(1:index);
fileName = depVar(index+1:end);
else
    dirName = './';
    fileName = depVar;
end
return