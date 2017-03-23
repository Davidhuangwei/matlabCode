function outStruct = SortACG2LayerTypes(ccgIn,cellLayers,cellTypes)
outStruct = [];
if ~isstruct(ccgIn)
    for j=1:length(cellLayers)
        if isstruct(outStruct) & isfield(outStruct,cellLayers{j,3}) ...
                & isfield(outStruct.(cellLayers{j,3}),cellTypes{j,3})
            outStruct.(cellLayers{j,3}).(cellTypes{j,3})...
                = cat(1,outStruct.(cellLayers{j,3}).(cellTypes{j,3}),...
                permute(ccgIn(j,j,:),[1,3,2]));
        else
            outStruct.(cellLayers{j,3}).(cellTypes{j,3})...
                = permute(ccgIn(j,j,:),[1,3,2]);
        end
    end
else
    structFields = fieldnames(ccgIn);
    for j=1:length(structFields)
        outStruct.(structFields{j}) = SortACG2LayerTypes(ccgIn.(structFields{j}),cellLayers,cellTypes);
    end
end
return


