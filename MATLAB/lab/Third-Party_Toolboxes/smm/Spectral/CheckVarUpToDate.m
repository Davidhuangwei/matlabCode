% function CheckVarUpToDate(fileBaseCell,spectAnalBase,fileExtCell,spectVarName)
% tag:check
% tag:var
% tag:uptodate

function CheckVarUpToDate(fileBaseCell,spectAnalBase,fileExtCell,spectVarName)

for j=1:length(fileBaseCell)
    for k=1:length(fileExtCell)
        dirName = [SC(fileBaseCell{j}) SC([spectAnalBase fileExtCell{k}])];
        timeLen = length(LoadVar([dirName 'time']));
        varLen = size(LoadVar([dirName spectVarName]),1));
        if timeLen ~= varLen
            fprintf('TRIAL NUMS DO NOT MATCH: %s\n',[dirName spectVarName]);
            fprintf('time')
            timeLen
            fprintf('%s',spectVarName)
            varLen
        end
    end
end