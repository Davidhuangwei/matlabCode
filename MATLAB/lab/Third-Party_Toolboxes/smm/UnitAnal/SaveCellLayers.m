function SaveCellTypes(cellTypes,cellTypesFile)
cellTypesFile
fid = fopen(cellTypesFile,'w');
if fid ~= -1
    for j=1:size(cellTypes,1)
        fprintf(fid,'%i %i %s\n',cellTypes{j,:});
    end
else
    error_opening_file
end
if fclose(fid) == -1
    error_closing_file
end
return