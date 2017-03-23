% function CheckSpectraVar(fileBaseCell,spectAnalBaseCell,fileExtCell,spectVarCell)
% Checks to see whether spectral files exist and are the same length as
% time.mat
% tag:check
% tag:spectral
% tag:var

function CheckSpectraVar(fileBaseCell,spectAnalBaseCell,fileExtCell,spectVarCell)


for j=1:length(fileBaseCell)
    for n=1:length(spectAnalBaseCell)
    for k=1:length(fileExtCell)
        for m=1:length(spectVarCell)
            dirName = [SC(fileBaseCell{j}) SC([spectAnalBaseCell{n} fileExtCell{k}])];
            fieldArray = ParseStructName(spectVarCell{m});
            fileName = [dirName fieldArray{1}];
            if ~exist(fileName,'file') & ~exist([fileName '.mat'],'file')
                fprintf('FILE MISSING: %s\n',fileName)
            else
               varTemp = LoadField([dirName spectVarCell{m}]);
               time = LoadVar([dirName 'time']);
               if size(time,1) ~= size(varTemp,1)
                   fprintf('FILE SIZE MISMATCH: %s\n',fileName)
               end
            end
        end
    end
    end
end
            