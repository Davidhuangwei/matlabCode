function outStruct = SortCCG2LayerTypes(ccgIn,cellLayers,cellTypes)
outStruct = [];
if ~isstruct(ccgIn)
    for j=1:size(cellLayers,1)
        for k=1:size(cellLayers,1)
            if j~=k
                if isstruct(outStruct) & ...
                        IsBranch(outStruct,cellLayers{j,3},cellTypes{j,3},cellLayers{k,3},cellTypes{k,3})
                    outStruct.(cellLayers{j,3}).(cellTypes{j,3}).(cellLayers{k,3}).(cellTypes{k,3})....
                        = cat(1,outStruct.(cellLayers{j,3}).(cellTypes{j,3}).(cellLayers{k,3}).(cellTypes{k,3}),...
                        permute(ccgIn(j,k,:),[1,3,2]));
                else
                    outStruct.(cellLayers{j,3}).(cellTypes{j,3}).(cellLayers{k,3}).(cellTypes{k,3})...
                        = permute(ccgIn(j,k,:),[1,3,2]);
                end
            end
        end
    end
else
    structFields = fieldnames(ccgIn);
    for j=1:length(structFields)
        outStruct.(structFields{j}) = SortCCG2LayerTypes(ccgIn.(structFields{j}),cellLayers,cellTypes);
    end
end
return


