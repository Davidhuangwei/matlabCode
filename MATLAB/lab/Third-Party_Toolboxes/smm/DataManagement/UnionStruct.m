% function outStruct = CatStruct(catDim,struct1,struct2)
% struct1 must have all fields in struct2, but struct2 does not have to
% have all fields in struct1
function outStruct = CatStruct(catDim,struct1,struct2)

% if ~CheckStructSim(struct1,struct2)
%     ERROR_NOT_SAME_STRUCT_FORMAT
% else
    
if ~isstruct(struct1)
    if isfield(struct2,structFields{j})
        outStruct = cat(catDim,struct1,struct2);
    else
        outStruct = struct1;
    end
else
    structFields1 = fieldnames(struct1);
    structFields2 = fieldnames(struct2);
    for j=1:length(structFields)
        if isfield(struct2,structFields{j})
            outStruct.(structFields{j}) = CatStruct(catDim,struct1.(structFields{j}),struct2.(structFields{j}));
        else
            outStruct.(structFields{j}) = CatStruct(catDim,struct1.(structFields{j}),struct1.(structFields{j}));
        end
    end
end
% end
return