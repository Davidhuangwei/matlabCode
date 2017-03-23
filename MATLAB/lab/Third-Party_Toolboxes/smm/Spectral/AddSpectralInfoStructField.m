% function AddSpectralInfoStructField(fileBaseCell,spectAnalBase,fileExtCell,fieldName,fieldValue)
function AddSpectralInfoStructField(fileBaseCell,spectAnalBase,fileExtCell,fieldName,fieldValue)

infoStruct.(fieldName) = fieldValue;

for k=1:length(fileExtCell)
    saveDir = SC([spectAnalBase fileExtCell{k}]);

    for j=1:length(fileBaseCell)

        dirName = [SC(fileBaseCell{j}) saveDir];
        
        infoStruct = [];
        infoStruct.(fieldName) = fieldValue;

        if exist([dirName 'infoStruct.mat'],'file')
            infoStruct = MergeStructs(LoadVar([dirName 'infoStruct.mat']),infoStruct);
        end

        save([dirName 'infoStruct.mat'],SaveAsV6,'infoStruct');
    end
end