function outStruct = TestHomoVarMult(dataStruct,nRandSamp)
%function outStruct = TestHomoVarMult(dataStruct,nRandSamp)
%uses shuffling/resampling to test homogeneity of variance across groups 
%in dataStruct and returns a separate z-score for each group (assumes normality).
%uses nRandSamp resampled datasets to estimate z-score
%default nRandSamp = 1000

if ~exist('nRandSamp','var') | isempty(nRandSamp)
    nRandSamp = 500;
end

dataCell = Struct2CellArray(dataStruct,[],1);
nGroups = size(dataCell,1);
catData = [];
for i=1:nGroups
    reCentData{i} = dataCell{i,end} - median(dataCell{i,end});
    dataVar(i) = var(reCentData{i});
    catData = cat(1,catData,reCentData{i});
    n = length(reCentData{i});
end

shuffVar = [];
for i=1:nRandSamp
    shuffVar(i) = var(randsample(catData,n(mod(i,length(n))+1)));
end
for i=1:nGroups
    %outStruct.(names{i}) = 2*(0.5-abs(0.5-length(find(shuffVar>dataVar(i)))/length(shuffVar)));
    dataCell{i,end} = mean(dataVar(i)-shuffVar)/std(shuffVar);
end

outStruct = CellArray2Struct(dataCell);
return


% plotting help
colormap(LoadVar('ColorMapSean6.mat'))
yVarZs2 = MatStruct2StructMat(yVarZs);
names = fieldnames(yVarZs2);
nGroups = 4;
for i=1:nGroups
    subplot(1,nGroups,i);
    imagesc(Make2DPlotMat(yVarZs2.(names{i}),MakeChanMat(6,16)));
    title(names{i})
    set(gca,'clim',[-3 3]);
    colorbar
end


yVarZs2 = MatStruct2StructMat(yVarPs);
names = {'a','b','c','d'};
nGroups = 4
for i=1:nGroups
    subplot(1,nGroups,i);
    imagesc(Make2DPlotMat(log10(yVarZs2.(names{i})),MakeChanMat(6,16)));
    set(gca,'clim',[-2 0]);
    colorbar
end
