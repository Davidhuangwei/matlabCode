function outStruct = CatMirrorDiag(inStruct,varargin)
[phaseBool] = DefaultArgs(varargin,{1});

if ~isstruct(inStruct)
    for j=1:size(inStruct,1)
        for k=1:size(inStruct,2)
            if j==k
                outStruct{j,k} = inStruct{j,k};
            else
                if phaseBool
                    if isreal(inStruct{j,k})
                        outStruct{j,k} = cat(1,inStruct{j,k},-inStruct{k,j});
                    else
                        outStruct{j,k} = cat(1,inStruct{j,k},conj(inStruct{k,j}));
                    end
                else
                    outStruct{j,k} = cat(1,inStruct{j,k},inStruct{k,j});
                end
            end
        end
    end
else
    structFields = fieldnames(inStruct);
    for j=1:length(structFields)
        outStruct.(structFields{j}) = CatMirrorDiag(inStruct.(structFields{j}),phaseBool);
    end
end
return
    
