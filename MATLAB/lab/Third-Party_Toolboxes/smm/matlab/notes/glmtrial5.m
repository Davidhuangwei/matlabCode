function glmtrial5(depVar)
%function glmtrial4(description,fileBaseMat,fileExt,midPointsText,minSpeed,winLength,thetaNW,gammaNW,depVar,trialMeanBool,contIndepCell,categIndepStruct)

fileBaseMat = [LoadVar('AlterFiles.mat');LoadVar('CircleFiles.mat')];
minSpeed = 0;
description = 'CalcRunningSpectra5_noExp';
winLength = 626;
thetaNW = 2;
gammaNW = 4;
fileExt = '.eeg';
midPointsText = '_MidPoints';
badChan = load('BadChanEEG.txt');
addpath(genpath('/u12/smm/matlab/econometrics/'))
nChan = 96;
removeOutliersBool = 1;
% remove outliers from power/speed/accel

trialDesig = [];

if 0
    trialDesig.alter.returnArm = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 1],0.5};
    trialDesig.alter.centerArm = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 1 0 0 0 0],0.5};
    trialDesig.alter.Tjunction = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 1 0 0 0 0 0],0.4};
    trialDesig.alter.goalArm =   {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 1 0 0],0.5};
end
if 1
    trialDesig.alter.err.returnArm = {'alter',[0 1 0 1 0 1 0 1 0 1 0 1 0],0.6,[0 0 0 0 0 0 0 1 1],0.5};
    trialDesig.alter.err.centerArm = {'alter',[0 1 0 1 0 1 0 1 0 1 0 1 0],0.6,[0 0 0 0 1 0 0 0 0],0.5};
    trialDesig.alter.err.Tjunction = {'alter',[0 1 0 1 0 1 0 1 0 1 0 1 0],0.6,[0 0 0 1 0 0 0 0 0],.9};
    trialDesig.alter.err.goalArm =   {'alter',[0 1 0 1 0 1 0 1 0 1 0 1 0],0.6,[0 0 0 0 0 1 1 0 0],.9};
    trialDesig.alter.corr.returnArm = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 1],0.5};
    trialDesig.alter.corr.centerArm = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 1 0 0 0 0],0.5};
    trialDesig.alter.corr.Tjunction = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 1 0 0 0 0 0],0.4};
    trialDesig.alter.corr.goalArm =   {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 1 0 0],0.5};
    trialMeanBool = 0;
    removeOutliersBool = 0;

end
if 0
    trialDesig.circle.q1 = cat(1,{'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 0 1],0.5},...
        {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 0],0.5});
    trialDesig.circle.q2 = cat(1,{'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 1 0 0],0.5},...
        {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 0 0 0],0.5});
    trialDesig.circle.q3 = cat(1,{'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 0 0 0],0.5},...
        {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 1 0 0],0.5});
    trialDesig.circle.q4 = cat(1,{'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 0],0.5},...
        {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 0 1],0.5});
    trialMeanBool = 0;

end
if 0
    trialDesig.q1 = cat(1,{'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 0 1],0.5},...
        {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 0],0.5});
    trialDesig.q2 = cat(1,{'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 1 0 0],0.5},...
        {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 0 0 0],0.5});
    trialDesig.q3 = cat(1,{'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 0 0 0],0.5},...
        {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 1 0 0],0.5});
    trialDesig.q4 = cat(1,{'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 0],0.5},...
        {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 0 1],0.5});
    trialMeanBool = 1;
end
if 0
    trialDesig.returnArm = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 1],0.5};
    trialDesig.centerArm = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 1 0 0 0 0],0.5};
    trialDesig.Tjunction = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 1 0 0 0 0 0],0.4};
    trialDesig.goalArm =   {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 1 0 0],0.5};
    trialMeanBool = 1;
end

dirName = [description midPointsText '_MinSpeed' num2str(minSpeed) 'Win' num2str(winLength)...
    'ThetaNW' num2str(thetaNW) 'GammaNW' num2str(gammaNW) fileExt];

contIndepCell = {'speed.p0','accel.p0'}

% load selected data
for i=1:length(contIndepCell)
    contStructCell{i} = LoadDesigVar(fileBaseMat,dirName,contIndepCell{i},trialDesig);
end
depStruct = LoadDesigVar(fileBaseMat,dirName,depVar,trialDesig);

for i=1:nChan
    %fprintf('\n---- Channel %i ----\n',i)
    
    % remove outliers
    if 1
    [goodContStructCell goodDepStruct outlierTrials(i)] = RemoveOutlierTrials5(contStructCell,depStruct,i,{10,0});
    else
        goodContStructCell = contStructCell;
        goodDepStruct = depStruct(i);
    end
    
    % calculate trial means
    if trialMeanBool 
        mazeRegionNames = fieldnames(trialDesig);
        if isstruct(eval(['trialDesig.' mazeRegionNames{1}]))
            ERROR_MEANING_OF_TRIAL_MEAN_UNCLEAR
        else
            tempDep = [];
            for j=1:length(mazeRegionNames)
                tempDep = cat(ndims(getfield(goodDepStruct,mazeRegionNames{j}))+1,...
                    tempDep,getfield(goodDepStruct,mazeRegionNames{j}));
            end
            trialMeanDep = mean(tempDep,ndims(getfield(goodDepStruct,mazeRegionNames{j}))+1);
            trialMeanDep = repmat(trialMeanDep,length(mazeRegionNames),1);
        end
    end
    
    % convert data from structs to matrices for stat analysis
    goodDepCell = GetAllFields(goodDepStruct);
	depData = cell2mat(goodDepCell(:,end));
	categData{i} = goodDepCell(:,1:end-1);

    contData = [];
    for j=1:length(goodContStructCell)
        [goodContCell] = GetAllFields(goodContStructCell{j});
	  contData(:,j) = cell2mat(goodContCell(:,end));
        %contData = cat(2,contData,contTemp);
    end

    % re-sort categData so each column is in separate cells
    newCategData = {};
    for j=1:size(categData{i},2)
        newCategData{i}(j) = {categData{i}(:,j)};
    end
    categData{i} = newCategData{i};
    
    % create stat input mats
    yVar = depData;
    if trialMeanBool
        partialXvar = [ones(size(contData,1),1),contData,trialMeanDep];
    else
        partialXvar = [ones(size(contData,1),1),contData];
    end        
    % perform "ANCOVA", regressing continuous data and running
    % ANOVA on residuals
    keyboard
    partialModel(i) = ols(yVar,partialXvar);
    pVal = tcdf(-abs(partialModel(i).tstat),length(yVar)-1);
    for j=2:size(partialXvar,2);
        contPs(i,j) = pVal(j);
        contBetas(i,j) = partialModel(i).beta(j);
    end
    
    % re-sort categData to be in separate cells
    if 0
        execText = ['categData{' num2str(i) '} = {'];
        for j=1:size(categData{i},2)
            if j~=1
                execText = [execText ','];
            end
            execText = [execText 'categData{' num2str(i) '}(:,' num2str(j) ')'];
        end
        execText = [execText '}'];
        eval(execText)
    end

    [categPs(i,:), T, categStats(i,:), terms] = anovan(partialModel(i).resid,categData{i},'display','off');
    nWayComps = {};
    for j=1:size(categData{i},2)
        nWayComps = cat(1,nWayComps,num2cell(nchoosek([1:size(categData{i},2)],j),2));     
    end
    for j=1:size(nWayComps,1)
        [junk categMeans{j}(i,:,:) junk2 groupCompNames{j}(i,:,:)] = multcompare(categStats(i),'dimension',nWayComps{j},'display','off');
    end
       
    % fit continuous and categorical data simultaneously
    wholeXvar = {};
    contVector = [];
    for j=2:size(partialXvar,2);
        wholeXvar = cat(2,wholeXvar,{partialXvar(:,j)});
        contVector = [contVector j-1];
    end
    %for j=1:size(categData{i},2)
    %    wholeXvar = cat(2,wholeXvar,{categData{i}(:,j)});
    %end
    wholeXvar = cat(2,wholeXvar,categData{i});

    [wholeModelPs(i,:), T, wholeModelStats(i,:), terms] = anovan(yVar,wholeXvar,'continuous',contVector,'display','off');
end

categTitles = {};
for i=1:length(categData{1})
    categTitles = cat(2,categTitles,categData{1}{i}(1));
end
nextFig = 1;
colorStyle = 'default';
%colorStyle = 'bone';
    
if removeOutliersBool
    figure(nextFig)
    clf
    nextFig = nextFig +1;
    [outliersCell] = GetAllFields(outlierTrials(1));
    %outliers{1} = cell2mat(outliersCell(:,end));
    outliers{1} = outliersCell(:,end);
    outCategs = outliersCell(:,1:end-1);
    trialOutliers = cell(length(outliers{1}),1);
    for i=1:nChan
        [outliersCell] = GetAllFields(outlierTrials(i));
        %outliers{i} = cell2mat(outliersCell{:,end});
        outliers{i} = outliersCell(:,end);
        for j=1:length(outliers{i});
            chanOutliers(i,j) = length(outliers{i}{j});
            trialOutliers{j} = cat(1,trialOutliers{j},outliers{i}{j});
        end
    end
    for j=1:length(trialOutliers)
        subplot(2,length(trialOutliers),j);
        colormap(colorStyle)
        ImageScRmNaN(Make2DPlotMat(chanOutliers(:,j),MakeChanMat(6,16),badChan));
        title([{'Outliers per Channel'} outCategs(j,:)]);
        subplot(2,length(trialOutliers),j+length(trialOutliers));
        bar(Accumulate(trialOutliers{j}),'r')
        title([{'Outliers Per Trial'} outCategs(j,:)])
        %title([outCategs(j,:)])
    end
end

figure(nextFig)
nextFig = nextFig +1;
clf
colormap(colorStyle)
set(gcf,'name',[depVar ' partial']);
colorLimits = log10([1 10^-15]);
if trialMeanBool
    titles = cat(2,contIndepCell, 'trial means',categTitles);
else
    titles = cat(2,contIndepCell,categTitles);
end
for i=2:size(partialXvar,2)
    subplot(1,size(partialXvar,2)-1+size(categData{i},2),i-1);
    ImageScRmNaN(Make2DPlotMat(log10(contPs(:,i)),MakeChanMat(6,16),badChan,'linear'),colorLimits);
    %set(gca,'clim',colorLimits);
    %colorbar
    title([titles{i-1} ' pVal']);
end
for j=1:size(categData{i},2)
    subplot(1,size(partialXvar,2)-1+size(categData{i},2),i-1+j);
    temp = log10(categPs(:,j));
    temp(temp==-inf) = -16;
    ImageScRmNaN(Make2DPlotMat(temp,MakeChanMat(6,16),badChan,'linear'),colorLimits);
    %set(gca,'clim',colorLimits);
    title([titles{size(partialXvar,2)+j-1} ' pVal'])
    %colorbar
end

figure(nextFig)
nextFig = nextFig +1;
clf
colormap(colorStyle)
set(gcf,'name',[depVar ' partial']);
colorLimits = [];
if trialMeanBool
    titles = cat(2,contIndepCell, 'trial means',categTitles)
else
    titles = cat(2,contIndepCell,categTitles)
end
for i=2:size(partialXvar,2)
    subplot(1,size(partialXvar,2)-1+size(categData{i},2),i-1);
    ImageScRmNaN(Make2DPlotMat(contBetas(:,i),MakeChanMat(6,16),badChan,'linear'),colorLimits);
    %set(gca,'clim',colorLimits);
    %colorbar
    title([titles{i-1} ' Beta']);
end


for j=1:length(categMeans)
	figure(nextFig)
	nextFig = nextFig +1;
	clf
	colormap(colorStyle)
	set(gcf,'name',[depVar ' partial']);
	colorLimits = [-1 1];
	for k=1:size(categMeans{j},2)
		subplot(1,size(categMeans{j},2),k);
		ImageScRmNaN(Make2DPlotMat(categMeans{j}(:,k,1),MakeChanMat(6,16),badChan,'linear'),colorLimits);
		title(groupCompNames{j}(:,k,1));
	end
end

keyboard
return


if trialMeanBool
    titles = cat(2,contIndepCell, 'trial means',categData{i}(1,:))
else
    titles = cat(2,contIndepCell,categData{i}(1,:))
end
for i=2:size(partialXvar,2)
    subplot(1,size(partialXvar,2)-1+size(categData{i},2),i-1);
    %ImageScRmNaN(Make2DPlotMat(partialModel.resid(,MakeChanMat(6,16),badChan,'linear'),colorLimits));
    %set(gca,'clim',colorLimits);
    %colorbar
    title([titles{i-1} ' Beta']);
end



figure(1)
clf
colormap(colorStyle)
set(gcf,'name',depVar);
subplot(1,4,1)
colorLimits = log10([10^-15 1])
imagesc(Make2DPlotMat(log10(speedP),MakeChanMat(6,16),badChan,'linear'));
set(gca,'clim',colorLimits)
title('Speed Pval')
colorbar
subplot(1,4,2)
imagesc(Make2DPlotMat(log10(accelP),MakeChanMat(6,16),badChan,'linear'));
set(gca,'clim',colorLimits)
title('Accel Pval')
colorbar
subplot(1,4,3)
imagesc(Make2DPlotMat(log10(meanPowP),MakeChanMat(6,16),badChan,'linear'));
set(gca,'clim',colorLimits*4)
title('Trial Pval')
colorbar
subplot(1,4,4)
imagesc(Make2DPlotMat(log10(mazeP),MakeChanMat(6,16),badChan,'linear'));
set(gca,'clim',colorLimits)
title('MazeRegion Pval')
colorbar

figure(2)
clf
colormap(colorStyle)
set(gcf,'name',depVar);
subplot(1,4,1)
colorLimits = [];
imagesc(Make2DPlotMat(speedB,MakeChanMat(6,16),badChan,'linear'));
set(gca,'clim',colorLimits)
title('Speed Bval')
colorbar
subplot(1,4,2)
imagesc(Make2DPlotMat(accelB,MakeChanMat(6,16),badChan,'linear'));
set(gca,'clim',colorLimits)
title('Accel Bval')
colorbar
subplot(1,4,3)
imagesc(Make2DPlotMat(meanPowB,MakeChanMat(6,16),badChan,'linear'));
set(gca,'clim',colorLimits)
title('Trial Bval')
colorbar

for i=1:96
    normMean(i) = mean(results(i).resid);
    normStd(i) = std(results(i).resid);
    returnNorm(i) = mean(results(i).resid(1:38))-mean(results(i).resid)/normStd(i);
    centerNorm(i) = mean(results(i).resid(38+1:38+38))-mean(results(i).resid)/normStd(i);
    tNorm(i) = mean(results(i).resid(2*38+1:2*38+38))-mean(results(i).resid)/normStd(i);
    goalNorm(i) = mean(results(i).resid(3*38+1:3*38+38))-mean(results(i).resid)/normStd(i);
end
figure(3)
clf
colormap(colorStyle)
set(gcf,'name',depVar);
colorLimits = [-1 1]
subplot(1,4,1)
imagesc(Make2DPlotMat(returnNorm,MakeChanMat(6,16),badChan,'linear'));
set(gca,'clim',colorLimits)
colorbar
subplot(1,4,2)
imagesc(Make2DPlotMat(centerNorm,MakeChanMat(6,16),badChan,'linear'));
set(gca,'clim',colorLimits)
colorbar
subplot(1,4,3)
imagesc(Make2DPlotMat(tNorm,MakeChanMat(6,16),badChan,'linear'));
set(gca,'clim',colorLimits)
colorbar
subplot(1,4,4)
imagesc(Make2DPlotMat(goalNorm,MakeChanMat(6,16),badChan,'linear'));
set(gca,'clim',colorLimits)
colorbar

SMPrint([1:3],0,[11 2],0,0,'buzlaserATspike')
%xVar = [ones(size(speed)),rand(size(speed)),rand(size(speed))];
xVar = [ones(size(speed)),mazeDesig];
xVar = [ones(size(speed)),speed];
xVar = [ones(size(speed)),speed,accel];
xVar = [ones(size(speed)),speed,accel,meanpow37];
xVar = [ones(size(speed)),speed,accel,meanpow37,mazeDesig];

xVar = {speed,accel};
xVar = {accel};
xVar = {speed,accel,mazeDesigChar};
xVar = {speed,accel,meanpow(:,i),mazeDesigNum};
xVar = {mazeDesigNum};
xVar = {speed,mazeDesigNum};
xVar = {speed};

p=anovan(yVar,xVar)
p=anovan(yVar,xVar,'continuous',1)
p=anovan(yVar,xVar,'continuous',[1 2])

results = ols(yVar,xVar);
results.tstat
tcdf(-abs(results.tstat),length(yVar)-1)
p=anovan(results.resid,{mazeDesigChar})

[B,BINT,R,RINT,STATS] = regress_sm(yVar,xVar);


col = [2:size(xVar,2)];
DFmodel = length(col)
DFtotal = length(yVar)-1
DFerr = DFtotal-DFmodel
%MStreat = length(yVar)*sum(results.beta(col).^2)/DFmodel
MStreat = sum(results.beta(col).^2)
MSerr = sum(results.bstd(col).^2)
%MSerr ones(size(speed)),= sum(results.bstd(col).^2)/DFerr
Fval = MStreat/MSerr
Fpval = 1-fcdf(Fval,DFmodel,DFerr)
Tval = results.beta(col)/results.bstd(col)
Tpval = tcdf(-abs(Tval),DFtotal)*2

STATS
results.tstat(col)
results.bstd(col)
SERRORS

sstot = var(pow37)*(length(pow37)-1)
sserr = sum(RESIDS.^2)
ssmaze = sum(BETA(4:6).^2)*sstot 
dftot = 152-1
dfmaze = 4-1
dferr = 152-7
(ssmaze/dfmaze)/(sserr-dferr)

clear c
clear devi
clear statis
for i=1:size(pow,2)
%b(i,:) = glmfit([ones(size(regionSpeed.returnArm)), regionSpeed.returnArm],regionPow.returnArm(:,i),'normal');
%b(i,:) = glmfit(regionSpeed.returnArm,regionPow.returnArm(:,i),'normal');
%c(i,:) = regress(regionPow.returnArm(:,i),[ones(size(regionSpeed.returnArm)), regionSpeed.returnArm, regionAccel.returnArm]);
%c(i,:) = regress(pow(:,i),[ones(size(speed)), speed, accel, mazeDesig]);
%[c(i,:) devi(i,:) statis(i,:)] = glmfit([speed, accel, mazeDesig],pow(:,i),'normal');
[c(i,:) devi(i,:) statis(i,:)] = glmfit([mazeDesig],pow(:,i),'normal');

end
pVal = [];
for i=1:length(statis)
    pVal = [pVal; getfield(statis(i),'p')'];
end
    
imagesc(Make2DPlotMat((c(:,4)+c(:,5)+c(:,6))./3,MakeChanMat(6,16),badChan));colorbar
imagesc(Make2DPlotMat((c(:,2)+c(:,3)+c(:,4))./3,MakeChanMat(6,16),badChan));colorbar

imagesc(Make2DPlotMat(c(:,2),MakeChanMat(6,16),badChan));colorbar
imagesc(Make2DPlotMat(log10(pVal(:,5)),MakeChanMat(6,16),badChan));set(gca,'clim',log10([10^-10 1]));colorbar


