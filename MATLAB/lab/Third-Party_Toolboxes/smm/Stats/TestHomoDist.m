function outStruct = TestHomoDist(dataStruct)
%function outStruct = TestHomoDist(dataStruct)
%uses kstest2 to test whether any group distribution
%is different from the other three

dataCell = Struct2CellArray(dataStruct,[],1);
outCell = dataCell;
nGroups = size(dataCell,1);
groups = [1:nGroups];
for i=groups
    testData = dataCell{i,end};
    compData = cat(1,dataCell{groups~=i,end});
    [h outCell{i,end}] = kstest2(testData,compData);
end
outStruct = CellArray2Struct(outCell);
return


% plotting help
colormap(LoadVar('ColorMapSean6.mat'))
residDistPs2 = MatStruct2StructMat(residDistPs);
names = fieldnames(residDistPs2);
nGroups = 4;
for i=1:nGroups
    subplot(1,nGroups,i);
    imagesc(Make2DPlotMat(log10(residDistPs2.(names{i})),MakeChanMat(6,16)));
    title(names{i})
    set(gca,'clim',log10([0.05 1]));
    colorbar
end

colormap(LoadVar('ColorMapSean6.mat'))
residNormPs2 = MatStruct2StructMat(residNormPs);
names = fieldnames(residNormPs2);
nGroups = 4;
for i=1:nGroups
    subplot(1,nGroups,i);
    imagesc(Make2DPlotMat(log10(residNormPs2.(names{i})),MakeChanMat(6,16)));
    title(names{i})
    set(gca,'clim',log10([0.05 1]));
    colorbar
end
