function outStruct = SortUnitFieldCoh2LayerTypes(ccgIn,cellLayers,cellTypes,selChan)
outStruct = [];
if ~isstruct(ccgIn)
    for j=1:size(cellLayers,1)
        for k=1:size(selChan,1)
            if isstruct(outStruct) & isfield(outStruct,cellLayers{j,3}) ...
                    & isfield(outStruct.(cellLayers{j,3}),cellTypes{j,3})...
                    & isfield(outStruct.(cellLayers{j,3}).(cellTypes{j,3}),selChan{k,1})
                outStruct.(cellLayers{j,3}).(cellTypes{j,3}).(selChan{k,1})...
                    = cat(1,outStruct.(cellLayers{j,3}).(cellTypes{j,3}).(selChan{k,1}),...
                    permute(ccgIn(j,k,:),[1,3,2]));
            else
                outStruct.(cellLayers{j,3}).(cellTypes{j,3}).(selChan{k,1})...
                    = permute(ccgIn(j,k,:),[1,3,2]);
            end
        end
    end
else
    structFields = fieldnames(ccgIn);
    for j=1:length(structFields)
        outStruct.(structFields{j}) = SortUnitFieldCoh2LayerTypes(ccgIn.(structFields{j}),cellLayers,cellTypes,selChan);
    end
end
return


