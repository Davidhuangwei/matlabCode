% loads a mat file with single field into a variable with a specified name
% (rather than using "load" to put the data into a struct)
% tag:load
% tag:data management
function outData = LoadVar(fileName)

% try 
if exist([fileName '.mat'],'file')
    StructData = load([fileName '.mat'],'-mat');
else
    StructData = load(fileName,'-mat');
end
% catch
%     try StructData = load([fileName '.mat'],'-mat');
%     catch
%         fprintf('\n%s or %s not found\n',fileName,[fileName '.mat']);
%         ERROR
%     end
% end
dataField = fieldnames(StructData);
if size(dataField,1) > 1
    problem_struct_too_big
else
    outData = getfield(StructData,dataField{1});
end
return