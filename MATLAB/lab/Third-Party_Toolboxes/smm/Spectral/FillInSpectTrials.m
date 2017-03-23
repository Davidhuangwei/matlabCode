% function FillInSpectTrials(fileBaseCell,spectAnalDir,varName,varValue)
% tag:spectral
% tag:fill
% tag:fix
% tag:update

function FillInSpectTrials(fileBaseCell,spectAnalDir,varName,varValue)

for j=1:length(fileBaseCell)
    variable = LoadVar([SC(fileBaseCell{j}) SC(spectAnalDir) varName]);
    time = LoadVar([SC(fileBaseCell{j}) SC(spectAnalDir) 'time.mat']);
    if size(varValue,1) == 1
        variable = cat(1,variable,repmat(varValue,[size(time,1)-size(variable,1), 1]));
        nAdded = size(time,1)-size(variable,1);
    else
        variable = cat(1,variable,varValue);
        nAdded = size(varValue,1);
    end
    fprintf([SC(fileBaseCell{j}) SC(spectAnalDir) varName ...
        ': ' num2str(nAdded) ' trials added\n']);
    save([SC(fileBaseCell{j}) SC(spectAnalDir) varName],SaveAsV6,'variable');
end

