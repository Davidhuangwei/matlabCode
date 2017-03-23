function outStruct = CCG2LayerTypes(ccgIn,cellLayers,cellTypes)
outStruct = [];
for j=1:length(cellLayers)
    for k=1:length(cellLayers)
        if j<k
            if isstruct(outStruct) & isfield(outStruct,cellLayers{j,3}) ...
                    & isfield(outStruct.(cellLayers{j,3}),cellTypes{j,3})...
                    & isfield(outStruct.(cellLayers{j,3}).(cellTypes{j,3}),cellLayers{k,3}) ...
                    & isfield(outStruct.(cellLayers{j,3}).(cellTypes{j,3}).(cellLayers{k,3}),cellTypes{k,3})
                outStruct.(cellLayers{j,3}).(cellTypes{j,3}).(cellLayers{k,3}).(cellTypes{k,3})...
                    = cat(1,outStruct.(cellLayers{j,3}).(cellTypes{j,3}).(cellLayers{k,3}).(cellTypes{k,3}),...
                    permute(ccgIn(j,k,:),[1,3,2]));
            else
                outStruct.(cellLayers{j,3}).(cellTypes{j,3}).(cellLayers{k,3}).(cellTypes{k,3})...
                    = permute(ccgIn(j,k,:),[1,3,2]);
            end
        end
    end
end
return


