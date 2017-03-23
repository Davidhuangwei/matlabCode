% function outStruct = StructMatSqueeze(struct1)
function outStruct = StructMatSqueeze(struct1)

if ~isstruct(struct1)
    outStruct = squeeze(struct1);
else
    structFields = fieldnames(struct1);
    for j=1:length(structFields)
        outStruct.(structFields{j}) = ...
            StructMatSqueeze(struct1.(structFields{j}));
    end
end
return