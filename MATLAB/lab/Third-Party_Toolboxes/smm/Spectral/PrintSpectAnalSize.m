function PrintSpectAnalSize(fileBaseCell,analDir)

for j=1:length(fileBaseCell)
    dirName = [SC(fileBaseCell{j}) SC(analDir)];
    temp = dir(dirName);
    for k=3:length(temp)
        if ~strcmp(temp(k).name,'infoStruct')
            fprintf('%s\n',temp(k).name)
            var = LoadVar([dirName temp(k).name]);
            if isstruct(var) & isfield(var,'yo')
                size(var.yo)
            else
                size(var)
            end
        end
    end
end