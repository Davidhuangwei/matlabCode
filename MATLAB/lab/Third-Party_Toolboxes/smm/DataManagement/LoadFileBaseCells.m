function fileBaseCell = LoadFileBaseCells(fileNamesCell)

fileBaseCell = {};
for j=1:length(fileNamesCell)
    fileBaseCell = cat(1,fileBaseCell,LoadVar([SC('FileInfo') fileNamesCell{j}]));
end