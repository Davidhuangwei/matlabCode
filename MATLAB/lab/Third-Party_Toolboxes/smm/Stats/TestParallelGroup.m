function [pValStruct betas] = TestParallelGroup(depStruct,indepStruct,varargin)
%function TestParallelGroup(depStruct,indepStruct,indepNames,nRandSamp)
%Uses resampling to test whether groupXcont interaction is greater
%than expected by chance.

if isempty(indepStruct) | isempty(depStruct)
    pValStruct = NaN;
    betas = NaN;
    return
end

[indepNames, nRandSamp] = DefaultArgs(varargin,...
    {{'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p'},500});

depCell = Struct2CellArray(depStruct,[],1);
indepCell = Struct2CellArray(indepStruct,[],1);
CheckCellArraySim(depCell(:,1:end-1),indepCell(:,1:end-1));

%%% using resampling
catDep = [];
catIndep = [];
nGroups = size(depCell,1);
for i=1:nGroups
    betas(i,:) = regress(depCell{i,end},indepCell{i,end});
    catDep = cat(1,catDep,depCell{i,end});
    catIndep = cat(1,catIndep,indepCell{i,end});
    n(i) = size(depCell{i,end},1);
end
varBetas = var(betas);

indexes = 1:length(catDep);
for i=1:nRandSamp
    resampInd = randsample(indexes,length(catDep));
    num = 1;
    for j=1:nGroups
        ind = resampInd(num:num+n(j)-1);
        shuffBetas(j,:) = regress(catDep(ind,:),catIndep(ind,:));
        %shuffBetas(j,:) = shuffModel(j).beta';
        num = num + n(j);
    end
    varShuffBetas(i,:) = var(shuffBetas);
end
for i=1:size(varShuffBetas,2)
    pValStruct.(GenFieldName(indepNames{i})) = (1+length(find(varShuffBetas(:,i)>=varBetas(i))))/length(varShuffBetas);
end
    
return


%%% plotting help
shuffPvals2 = MatStruct2StructMat(testPrllPvals);
fields = fieldnames(shuffPvals2);
for i=1:length(fields)
    subplot(1,length(fields),i);
    colormap(LoadVar('ColorMapSean6.mat'))
    imagesc(Make2DPlotMat(log10(shuffPvals2.(fields{i})),MakeChanMat(6,16)));
    set(gca,'clim',[-2 0]);
    colorbar
end

figure
[nRow nCol] = size(betas{1});
for i = 1:96
    for j=1:nRow
        for k=1:nCol
            betas2{j,k}(i) = betas{i}(j,k);
        end
    end
end
for k=1:nCol
    for j=1:nRow
        subplot(nRow,nCol,(j-1)*nCol+k);
        colormap(LoadVar('ColorMapSean6.mat'))
        imagesc(Make2DPlotMat(betas2{j,k},MakeChanMat(6,16)));
        %set(gca,'clim',[-0.01 0.01])
        colorbar
    end
end



fPvals2 = MatStruct2StructMat(fPvals);
fields = fieldnames(fPvals2);
for i=1:length(fields)
    subplot(1,length(fields),i)
    colormap(LoadVar('ColorMapSean6.mat'))
    imagesc(Make2DPlotMat(log10(fPvals2.(fields{i})),MakeChanMat(6,16)));
    set(gca,'clim',[-16 0]);
    colorbar
end

clf
colorMat = [1 0 0;0 1 0; 0 0 1;1 0 1];
for i=1:length(model(1).beta)
    %subplot(1,length(model{2}),j)
    hold on
    for j=1:length(model)
        plot(i,model(j).beta(i),'o','color',colorMat(j,:))
        plot(i,model(j).beta(i)+model(j).bstd(i),'^','color',colorMat(j,:))
        plot(i,model(j).beta(i)-model(j).bstd(i),'v','color',colorMat(j,:))
    end
end
set(gca,'xlim',[0 length(model(1).beta)+1])


%%% calculate p using F(MS(beta)/MS(bstd))
nGroups = size(depCell,1);
for i=1:nGroups
    model(i) = ols(depCell{i,end},indepCell{i,end});
    betas(i,:) = model(i).beta;
    bstds(i,:) = model(i).bstd;
    n(i) = size(depCell{i,end},1);
end
DFtotal = sum(n)-1;
DFmodel = length(n)-1;
DFerr = DFtotal - DFmodel;
MSmodel = sum(repmat(n',1,size(betas,2)).*((betas-repmat(mean(betas),size(betas,1),1)).^2))/DFmodel;
MSerr = sum(repmat(n',1,size(betas,2)).*(bstds.^2))/DFerr;
Fval = MSmodel./MSerr;
for i=1:length(MSmodel)
   fPvals.(indepNames{i}) = 1-fcdf(Fval(i),DFmodel,DFerr);
end

%%% using ols
% shuffBetas = [];
% indexes = 1:length(catDep);
% for i=1:nRandSamp
%     reSampInd = randsample(indexes,length(catDep));
%     num = 1;
%     for j=1:nGroups
%         ind = reSampInd(num:num+n(j)-1);
%         shuffModel(j) = ols(catDep(ind,:),catIndep(ind,:));
%         shuffBetas(j,:) = shuffModel(j).beta';
%         num = num + n(j);
%     end
%     varShuffBetas(i,:) = var(shuffBetas);
% end
% for i=1:size(varShuffBetas,2)
%     outPvals(i) = length(find(varShuffBetas(i,:)>=varBetas(i)))/length(varShuffBetas);
% end


