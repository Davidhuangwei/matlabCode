function outPval = TestHomoVar(dataStruct,nRandSamp)
%function outPval = TestHomoVar(dataStruct,nRandSamp)
%uses shuffling/resampling to test homogeneity of variance across groups 
%in dataStruct and returns a single p-value for all groups.
%uses nRandSamp resampled datasets to estimate p-value
%default nRandSamp = 1000

if ~exist('nRandSamp','var') | isempty(nRandSamp)
    nRandSamp = 500;
end

dataCell = Struct2CellArray(dataStruct,[],1);
%dataCell = struct2cell(dataStruct);
nGroups = size(dataCell,1);
catData = [];
for i=1:nGroups
    reCentData{i} = dataCell{i,end} - median(dataCell{i,end});
    dataVar(i) = var(reCentData{i});
    catData = cat(1,catData,reCentData{i});
    n(i) = length(reCentData{i});
end

shuffVar =[];
shuffVarVar = [];
for i=1:nRandSamp
    reSampData = randsample(catData,length(catData));
    num = 1;
    for j=1:nGroups
        shuffVar(j) = var(reSampData(num:num+n(j)-1));
        num = num + n(j);
    end
    shuffVarVar(i) = var(shuffVar);
end
outPval = (1+length(find(shuffVarVar>=var(dataVar))))/length(shuffVarVar);

return


% plotting help
colormap(LoadVar('ColorMapSean6.mat'))
imagesc(Make2DPlotMat(log10(yVarPs),MakeChanMat(6,16)));
set(gca,'clim',[-2 0]);
colorbar
