function outData = LoadVar(fileName)
% loads a mat file with single field into a variable with a specified name
% (rather than using "load" to put the data into a struct)

try StructData = load(fileName,'-mat');
catch
    try StructData = load([fileName '.mat'],'-mat');
    catch
        fprintf('\n%s or %s not found\n',fileName,[fileName '.mat']);
        ERROR
    end
end
dataField = fieldnames(StructData);
if size(dataField,1) > 1
    problem_struct_too_big
else
    outData = getfield(StructData,dataField{1});
end
return