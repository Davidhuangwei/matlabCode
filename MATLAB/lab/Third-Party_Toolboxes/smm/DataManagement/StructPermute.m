% function outStruct = CatStruct(catDim,struct1,struct2)
function outStruct = CatStruct(catDim,struct1,struct2)

if ~CheckStructSim(struct1,struct2)
    ERROR_NOT_SAME_STRUCT_FORMAT
else

    if ~isstruct(struct1)
        outStruct = cat(catDim,struct1,struct2);
    else
        structFields = fieldnames(struct1);
        for j=1:length(structFields)
            outStruct.(structFields{j}) = CatStruct(catDim,struct1.(structFields{j}),struct2.(structFields{j}));
        end
    end
end
return