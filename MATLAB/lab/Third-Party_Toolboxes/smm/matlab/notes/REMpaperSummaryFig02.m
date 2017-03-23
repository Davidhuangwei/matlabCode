for j=1:size(temp1,1)
    test(j,:) = cat(2,{cat(1,temp1{j,1:4})},{cat(1,temp1{j,5:7})},{cat(1,temp1{j,8})});
end

temp1 = test;


for j=1:size(temp2,2)
    test(:,j) = cat(1,{cat(1,temp2{1:4,j})},{cat(1,temp2{5:7,j})},{cat(1,temp2{8,j})});
end

temp2 = test;

depVarCell = {'gammaPow','gammaCoh'}
for j=1:length(depVarCell)
    summaryStruct.(depVarCell{j}) = rmfield(summaryStruct.(depVarCell{j}),'Constant');
end
depVarCell = {'unitGammaPow','unitGammaCoh'}
for j=1:length(depVarCell)
    temp = summaryStruct.(depVarCell{j});
    temp(:,[1,2,4]) = [];
    % temp(strcmp(temp(:,2),'phasic'),:) = [];
    temp = temp([1,3,2,4,6,5],:)
    summaryStruct.(depVarCell{j}) = CellArray2Struct(temp(:,[2,3]))
end







nBehav = 3;
nLayers = 3;
nVar = 12;
plotMat = NaN*ones(nBehav,nVar);


%maze
%DG
plotMat(1,1) = summaryStruct2.csdPow.gamma.behavior_maze(2);
plotMat(1,2) = summaryStruct2.csdCoh.gamma.behavior_maze(2,2);
plotMat(1,4) = summaryStruct2.unitPow.gamma.maze(2);
plotMat(1,3) = summaryStruct2.unitCoh.gamma.maze(2);
%DG-CA3
plotMat(1,5) = summaryStruct2.csdCoh.gamma.behavior_maze(2,3);
plotMat(1,6) = summaryStruct2.unitCoh.gamma.maze(3);
%CA3
plotMat(1,7) = summaryStruct2.csdPow.gamma.behavior_maze(3);
plotMat(1,8) = summaryStruct2.unitPow.gamma.maze(3);
%CA3-CA1
plotMat(1,9) = summaryStruct2.csdCoh.gamma.behavior_maze(3,1);
%CA1
plotMat(1,10) = summaryStruct2.csdPow.gamma.behavior_maze(1);
plotMat(1,11) = summaryStruct2.csdCoh.gamma.behavior_maze(1,1);
plotMat(1,12) = summaryStruct2.unitPow.gamma.maze(1);

%tonic
%DG
plotMat(2,1) = summaryStruct2.csdPow.gamma.behavior_Tonic(2);
plotMat(2,2) = summaryStruct2.csdCoh.gamma.behavior_Tonic(2,2);
plotMat(2,4) = summaryStruct2.unitPow.gamma.tonic(2);
plotMat(2,3) = summaryStruct2.unitCoh.gamma.tonic(2);
%DG-CA3
plotMat(2,5) = summaryStruct2.csdCoh.gamma.behavior_Tonic(3);
plotMat(2,6) = summaryStruct2.unitCoh.gamma.tonic(3);
%CA3
plotMat(2,7) = summaryStruct2.csdPow.gamma.behavior_Tonic(3);
plotMat(2,8) = summaryStruct2.unitPow.gamma.tonic(3);
%CA3-CA1
plotMat(2,9) = summaryStruct2.csdCoh.gamma.behavior_Tonic(3,1);
%CA1
plotMat(2,10) = summaryStruct2.csdPow.gamma.behavior_Tonic(1);
plotMat(2,11) = summaryStruct2.csdCoh.gamma.behavior_Tonic(1,1);
plotMat(2,12) = summaryStruct2.unitPow.gamma.tonic(1);

%phasic
%DG
plotMat(3,1) = summaryStruct2.csdPow.gamma.behavior_phasic(2);
plotMat(3,2) = summaryStruct2.csdCoh.gamma.behavior_phasic(2,2);
%DG-CA3
plotMat(3,5) = summaryStruct2.csdCoh.gamma.behavior_phasic(2,3);
%CA3
plotMat(3,7) = summaryStruct2.csdPow.gamma.behavior_phasic(3);
%CA3-CA1
plotMat(3,9) = summaryStruct2.csdCoh.gamma.behavior_phasic(3,1);
%CA1
plotMat(3,10) = summaryStruct2.csdPow.gamma.behavior_phasic(1);
plotMat(3,11) = summaryStruct2.csdCoh.gamma.behavior_phasic(1,1);

ImageScRmNaN(plotMat)
colormap(LoadVar('ColorMapSean'))
set(gca,'xtick',[])
set(gca,'ytick',[])
colorbar
PrintSaveFig('SummaryFigGamma02')


%%% coh %%%
depVar = 'unitCoh';
figure(1)
junk= Struct2CellArray(summaryStruct.(depVar),[],1)
junk2 = reshape(cat(3,junk{:,end}),nLayers,nBehav)
imagesc(junk2)
colorbar
colormap(LoadVar('ColorMapSean'))

depVarCell = fieldnames(summaryStruct);
for m=1:length(depVarCell)
    depVar = depVarCell{m};
depNames = fieldnames(summaryStruct.(depVar));
catTemp = [];
for j=1:length(depNames)
    behNames = fieldnames(summaryStruct.(depVar).(depNames{j}));
    for k=1:length(behNames)
        catTemp = cat(3,catTemp,summaryStruct.(depVar).(depNames{j}).(behNames{k}));
    end
end
for j=1:length(depNames)
    behNames = fieldnames(summaryStruct.(depVar).(depNames{j}));
    for k=1:length(behNames)
        summaryStruct2.(depVar).(depNames{j}).(behNames{k}) = ...
            (summaryStruct.(depVar).(depNames{j}).(behNames{k}) - min(catTemp(:))) ...
            /(max(catTemp(:)) - min(catTemp(:)));
    end
end
end


figure(2)
junk= Struct2CellArray(summaryStruct2.(depVar),[],1)
junk2 = reshape(cat(3,junk{:,end}),nLayers,nBehav)
imagesc(junk2)
colorbar
colormap(LoadVar('ColorMapSean'))



depVar = 'gammaCoh'
figure(1)
junk= Struct2CellArray(summaryStruct.(depVar),[],1)
junk2 = reshape(cat(3,junk{2:end,2}),nLayers*nLayers,nBehav)
imagesc(junk2)
colorbar
colormap(LoadVar('ColorMapSean'))

behavNames = fieldnames(summaryStruct.(depVar))
temp = [];
for j=2:length(behavNames)
    for k=1:size(summaryStruct.(depVar).(behavNames{1}),1)
        for m=1:size(summaryStruct.(depVar).(behavNames{1}),2)
            temp = cat(1,temp,summaryStruct.(depVar).(behavNames{j})(k,m));
        end
    end
end
for j=2:length(behavNames)
    for k=1:size(summaryStruct.(depVar).(behavNames{1}),1)
        for m=1:size(summaryStruct.(depVar).(behavNames{1}),2)
            summaryStruct2.(depVar).(behavNames{j})(k,m) = ...
                (summaryStruct.(depVar).(behavNames{j})(k,m)-min(temp))/(max(temp)-min(temp));
        end
    end
end
figure(2)
junk= Struct2CellArray(summaryStruct2.(depVar),[],1)
junk2 = reshape(cat(3,junk{2:end,2}),nLayers*nLayers,nBehav)
imagesc(junk2)
colorbar
colormap(LoadVar('ColorMapSean'))


