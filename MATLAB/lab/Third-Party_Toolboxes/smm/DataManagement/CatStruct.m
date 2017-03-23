% function outStruct = CatStruct(catDim,struct1,struct2,...)
function outStruct = CatStruct(catDim,varargin)

if length(varargin) > 2
    tempStruct = CatStruct(catDim,varargin{1},varargin{2});
    tempInput = cat(2,{tempStruct},varargin(3:end));
    outStruct = CatStruct(catDim,tempInput{:});
else
    struct1 = varargin{1};
    struct2 = varargin{2};
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
end
return