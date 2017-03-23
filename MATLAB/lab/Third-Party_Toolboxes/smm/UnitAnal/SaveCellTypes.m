% function SaveCellTypes(cellTypes,cellTypesFile)

function SaveCellTypes(cellTypes,cellTypesFile)
cellTypesFile
fid = fopen(cellTypesFile,'w');
if fid>0
    for j=1:size(cellTypes,1)
        fprintf(fid,'%i %i %s %i\n',cellTypes{j,:});
    end
else
    error_opening_file
end
if fclose(fid) <0
    error_closing_file
end
return