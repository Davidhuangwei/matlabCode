% function fileBaseCell = LoadFileBaseCell(fileNamesCell)
% tag:fileBaseCell
% tag:load

function fileBaseCell = LoadFileBaseCell(fileNamesCell)

fileBaseCell = {};
for j=1:length(fileNamesCell)
    fileBaseCell = cat(1,fileBaseCell,LoadVar([SC('FileInfo') fileNamesCell{j}]));
end