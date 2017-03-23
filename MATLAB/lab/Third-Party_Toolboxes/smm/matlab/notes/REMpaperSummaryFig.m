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
tempSummary.(depVarCell{j}) = CellArray2Struct(temp(:,[2,3]))

    summaryStruct.(depVarCell{j}) = rmfield(summaryStruct.(depVarCell{j}),'Constant');
end



summaryStruct2 = summaryStruct;

nBehav = 3;
nLayers = 3;
nVar = 12;
plotMat = NaN*ones(nBehav,nVar);


%%% pow %%%
depVar = 'gammaPow'

figure(1)
junk = Struct2CellArray(summaryStruct.(depVar),[],1)
junk2 = reshape([junk{2:end,2}],nLayers,nBehav)
imagesc(junk2)
colorbar
colormap(LoadVar('ColorMapSean'))

behavNames = fieldnames(summaryStruct.(depVar))
temp = [];
for j=2:length(behavNames)
    for k=1:length(summaryStruct.(depVar).(behavNames{1}))
        temp = cat(1,temp,summaryStruct.(depVar).(behavNames{j})(k));
    end
end
for j=2:length(behavNames)
    for k=1:length(summaryStruct.(depVar).(behavNames{1}))
        summaryStruct2.(depVar).(behavNames{j})(k) = ...
            (summaryStruct.(depVar).(behavNames{j})(k)-min(temp))/(max(temp)-min(temp));
    end
end
figure(2)
junk= Struct2CellArray(summaryStruct2.(depVar),[],1)
junk2 = reshape([junk{2:end,2}],nLayers,nBehav)
imagesc(junk2)
colorbar
colormap(LoadVar('ColorMapSean'))

%%% coh %%%
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


dataStart = 1;
nBehav = 2;
%%%% unit rhythmicity %%%%
depVar = 'unitGammaPow'

temp = summaryStruct.(depVar);
temp(:,[1,2,4]) = [];
% temp(strcmp(temp(:,2),'phasic'),:) = [];
temp = temp([1,3,2,4,6,5],:)
tempSummary.(depVar) = CellArray2Struct(temp(:,[2,3]))

figure(1)
junk = Struct2CellArray(tempSummary.(depVar),[],1)
junk2 = reshape([junk{dataStart:end,2}],nLayers,nBehav)
imagesc(junk2)
colorbar
colormap(LoadVar('ColorMapSean'))

behavNames = fieldnames(tempSummary.(depVar))
temp = [];
for j=dataStart:length(behavNames)
    for k=1:length(tempSummary.(depVar).(behavNames{1}))
        temp = cat(1,temp,tempSummary.(depVar).(behavNames{j})(k));
    end
end
for j=dataStart:length(behavNames)
    for k=1:length(tempSummary.(depVar).(behavNames{1}))
        tempSummary.(depVar).(behavNames{j})(k) = ...
            (tempSummary.(depVar).(behavNames{j})(k)-min(temp))/(max(temp)-min(temp));
    end
end
summaryStruct2.(depVar) = tempSummary.(depVar);
figure(2)
junk= Struct2CellArray(summaryStruct2.(depVar),[],1)
junk2 = reshape([junk{dataStart:end,2}],nLayers,nBehav)
imagesc(junk2)
colorbar
colormap(LoadVar('ColorMapSean'))



dataStart = 1;
nBehav = 2;
%%%% unit field Coh %%%%
depVar = 'unitGammaCoh'

temp = summaryStruct.(depVar);
temp(:,[1,2,4]) = [];
% temp(strcmp(temp(:,2),'phasic'),:) = [];
temp = temp([1,3,2,4,6,5],:)
tempSummary.(depVar) = CellArray2Struct(temp(:,[2,3]))

figure(1)
junk = Struct2CellArray(tempSummary.(depVar),[],1)
junk2 = reshape([junk{dataStart:end,2}],nLayers,nBehav)
imagesc(junk2)
colorbar
colormap(LoadVar('ColorMapSean'))

behavNames = fieldnames(tempSummary.(depVar))
temp = [];
for j=dataStart:length(behavNames)
    for k=1:length(tempSummary.(depVar).(behavNames{1}))
        temp = cat(1,temp,tempSummary.(depVar).(behavNames{j})(k));
    end
end
for j=dataStart:length(behavNames)
    for k=1:length(tempSummary.(depVar).(behavNames{1}))
        tempSummary.(depVar).(behavNames{j})(k) = ...
            (tempSummary.(depVar).(behavNames{j})(k)-min(temp))/(max(temp)-min(temp));
    end
end
summaryStruct2.(depVar) = tempSummary.(depVar);
figure(2)
junk= Struct2CellArray(summaryStruct2.(depVar),[],1)
junk2 = reshape([junk{dataStart:end,2}],nLayers,nBehav)
imagesc(junk2)
colorbar
colormap(LoadVar('ColorMapSean'))




plotMat

