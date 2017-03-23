% function outStruct = UnionStructMatCat(catDim,struct1,struct2)

function outStruct = UnionStructMatCat(catDim,struct1,struct2)

if ~isstruct(struct1) & ~isstruct(struct2)
        outStruct = cat(catDim,struct1,struct2);
else
    structFields = union(fieldnames(struct1),fieldnames(struct2));
    for j=1:length(structFields)
        if isfield(struct1,structFields{j})
            if isfield(struct2,structFields{j})
                outStruct.(structFields{j}) = UnionStructCat(catDim,struct1.(structFields{j}),struct2.(structFields{j}));
            else
                if isstruct(struct1.(structFields{j}))
                    outStruct.(structFields{j}) = UnionStructCat(catDim,struct1.(structFields{j}),struct([]));
                else
                    outStruct.(structFields{j}) = UnionStructCat(catDim,struct1.(structFields{j}),[]);

                end
            end
        else
            if isstruct(struct2.(structFields{j}))
                outStruct.(structFields{j}) = UnionStructCat(catDim,struct2.(structFields{j}),struct([]));
            else
                outStruct.(structFields{j}) = UnionStructCat(catDim,struct2.(structFields{j}),[]);
            end
        end
    end
end

% end
return