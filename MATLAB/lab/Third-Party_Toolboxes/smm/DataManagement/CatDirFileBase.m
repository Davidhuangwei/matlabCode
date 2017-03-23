% function fileBase = CatDirFileBase(fileBase)
% performs fileBase = [fileBase '/' fileBase];
% If fileBase is a cell array vector, performs for each cell.
function fileBase = CatDirFileBase(fileBase)

if iscell(fileBase)
    for j=1:length(fileBase)
    fileBase{j} = [fileBase{j} '/' fileBase{j}];
    end
else
    fileBase = [fileBase '/' fileBase];
end
    