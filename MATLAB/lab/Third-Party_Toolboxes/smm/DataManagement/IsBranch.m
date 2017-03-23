% function outBool = IsBranch(inStruct,subFieldName1,subFieldName2,...)
% Determines if inStruct has a branch of fields designated by subFieldNames
% inputs
% tag:struct
% tag:field
% tag:branch
function outBool = IsBranch(inStruct,varargin)
if isempty(varargin)
    outBool = 1;
else
    if isfield(inStruct,varargin{1})
        inStruct = inStruct.(varargin{1});
        varargin(1) = [];
        outBool = IsBranch(inStruct,varargin{:});
    else
        outBool = 0;
    end
end
return
    