function outPval = TestHomoMeans(dataStruct)
%function outPval = TestHomoMeans(dataStruct)
%uses anova1 to determine if group means of are significantly different

dataCell = Struct2CellArray(dataStruct,[],1);
nGroups = size(dataCell,1);

anovaData = [];
anovaCateg = [];
for i=1:nGroups
    anovaData = [anovaData; dataCell{i,end}];
    anovaCateg = [anovaCateg; repmat(i,size(dataCell{i,end}))];
end
outPval = anova1(anovaData,anovaCateg,'off');
return



% plotting help
colormap(LoadVar('ColorMapSean6.mat'))
imagesc(Make2DPlotMat(log10(yVarPs),MakeChanMat(6,16)));
set(gca,'clim',[-2 0]);
colorbar



%% leftover
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
