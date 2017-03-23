function outData = LoadVar(fileName,varargin)
% loads a mat file with single field into a variable with a specified name
% (rather than using "load" to put the data into a struct)
args=struct('warning','on');
args=parseArgs(varargin,args);

outData = [];
if exist(fileName,'file')
    StructData = load(fileName,'-mat');
elseif exist([fileName '.mat'],'file')
    StructData = load(fileName,'-mat');
else
    if strcmp(args.warning,'on')
        fprintf('\n%s or %s not found\n',fileName,[fileName '.mat']);
        error('LoadVar:fileNotFound');
    end
end
dataField = fieldnames(StructData);
if size(dataField,1) > 1
    problem_struct_too_big
else
    outData = getfield(StructData,dataField{1});
end
return