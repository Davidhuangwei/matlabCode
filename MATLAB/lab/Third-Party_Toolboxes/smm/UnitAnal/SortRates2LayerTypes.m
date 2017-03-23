function outStruct = SortRates2LayerTypes(ratesIn,cellLayers,cellTypes)

outStruct = [];

if ~isstruct(ratesIn)
    for j=1:length(cellLayers)
        if isstruct(outStruct) & isfield(outStruct,cellLayers{j,3}) ...
                & isfield(outStruct.(cellLayers{j,3}),cellTypes{j,3})
            outStruct.(cellLayers{j,3}).(cellTypes{j,3})...
                = cat(1,outStruct.(cellLayers{j,3}).(cellTypes{j,3}),...
                permute(ratesIn(j),[2,1]));
        else
            outStruct.(cellLayers{j,3}).(cellTypes{j,3})...
                = permute(ratesIn(j),[2,1]);
        end
    end
else
    structFields = fieldnames(ratesIn);
    for j=1:length(structFields)
        outStruct.(structFields{j}) = SortRates2LayerTypes(ratesIn.(structFields{j}),cellLayers,cellTypes);
    end
end
return


