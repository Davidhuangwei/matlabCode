% function outStruct = StructMatPermute(struct1,permuteArray)
function outStruct = StructMatPermute(struct1,permuteArray)

if ~isstruct(struct1)
    outStruct = permute(struct1,permuteArray);
else
    structFields = fieldnames(struct1);
    for j=1:length(structFields)
        outStruct.(structFields{j}) = ...
            StructMatPermute(struct1.(structFields{j}),permuteArray);
    end
end
return