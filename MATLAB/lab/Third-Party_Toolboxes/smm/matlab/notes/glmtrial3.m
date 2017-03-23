function xxx(description,fileBaseMat,fileExt,midPointsText,minSpeed,winLength,thetaNW,gammaNW,...
    depVar,trialMeanBool,contIndepCell,categIndepStruct)

fileBaseMat = LoadVar('AlterFiles.mat');
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
% remove outliers from power/speed/accel

trialDesig = [];
if 0
trialDesig.alter.returnArm = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 1],0.5};
trialDesig.alter.centerArm = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 1 0 0 0 0],0.5};
trialDesig.alter.Tjunction = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 1 0 0 0 0 0],0.4};
trialDesig.alter.goalArm =   {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 1 0 0],0.5};
trialDesig.circle.returnArm = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 1],0.5};
trialDesig.circle.centerArm = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 1 0 0 0 0],0.5};
trialDesig.circle.Tjunction = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 1 0 0 0 0 0],0.4};
trialDesig.circle.goalArm =   {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 1 0 0],0.5};
end
trialDesig.returnArm = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 1],0.5};
trialDesig.centerArm = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 1 0 0 0 0],0.5};
trialDesig.Tjunction = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 1 0 0 0 0 0],0.4};
trialDesig.goalArm =   {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 1 0 0],0.5};

%mazeRegionNames = fieldnames(trialDesig);
%for i=1:length(mazeRegionNames)
%    taskTypes(i) = getfield(trialDesig,mazeRegionNames{i},{1});
%end
dirName = [description midPointsText '_MinSpeed' num2str(minSpeed) 'Win' num2str(winLength)...
    'ThetaNW' num2str(thetaNW) 'GammaNW' num2str(gammaNW) fileExt];

contIndepCell = {'speed.p0','accel.p0'}
depVar = 'thetaPowPeak';
trialMeanBool = 1;

%contData = [];
%for i=1:length(contIndepCell)
%    [contTemp categData] = GetAllFields(LoadDesigVar(fileBaseMat,dirName,contIndepCell{i},trialDesig));
%    contData = cat(2,contData,contTemp);
%end

%contData = [];
for i=1:length(contIndepCell)
    contDataCell{i} = LoadDesigVar(fileBaseMat,dirName,contIndepCell{i},trialDesig);
end
depData = LoadDesigVar(fileBaseMat,dirName,depVar,trialDesig);


if 0
    [newContDataCell newDepData] = RemoveOutlierTrials4(contDataCell,depData,96,badChan,{3,1});
    junk = {'alter','circle'};
    junk2 = {'returnArm','centerArm','Tjunction','goalArm'}
    junk2 = {'returnArm','Tjunction','goalArm'}
    j=1
    for i=1:2
        for k=1:4
            cat(2,[1:length(getfield(contDataCell{i},junk{j},junk2{k}))]',...
                diff(cat(2,getfield(contDataCell{i},junk{j},junk2{k}),...
                getfield(newContDataCell{i},junk{j},junk2{k})),[],2))
        end
    end
    for i=1:2
        for k=1:4
            cat(2,[1:length(getfield(newDepData,junk{j},junk2{k},{1:38,1}))]',...
                diff(cat(2,getfield(depData,junk{j},junk2{k},{1:38,1}),...
                getfield(newDepData,junk{j},junk2{k},{1:38,1})),[],2))
        end
    end
    chan =85;
    for i=1:2
        for k=1:4
            cat(2,[1:length(getfield(newDepData,junk{j},junk2{k}))]',...
                diff(cat(2,getfield(depData,junk{j},junk2{k},{1:38,chan}),...
                getfield(newDepData,junk{j},junk2{k})),[],2))
        end
    end
    if trialMeanBool
        mazeRegionNames = fieldnames(trialDesig);
        if isstruct(eval(['trialDesig.' mazeRegionNames{1}]))
            ERROR_MEANING_OF_TRIAL_MEAN_UNCLEAR
        else
            tempDep = [];
            for i=1:length(mazeRegionNames)
                tempDep = cat(ndims(depData)+1,tempDep,getfield(depData,mazeRegionNames{i}));
            end
            trialMeanDep = mean(tempDep,ndims(depData)+1);
            trialMeanDep = repmat(trialMeanDep,length(mazeRegionNames),1);
        end
    end
end
%[depData categData] = GetAllFields(LoadDesigVar(fileBaseMat,dirName,depVar,trialDesig));

for i=1:nChan
    % remove outliers
    [goodContDataCell goodDepData] = RemoveOutlierTrials5(contDataCell,depData,i,{3,1});
    
    if trialMeanBool % calculate trial means
        mazeRegionNames = fieldnames(trialDesig);
        if isstruct(eval(['trialDesig.' mazeRegionNames{1}]))
            ERROR_MEANING_OF_TRIAL_MEAN_UNCLEAR
        else
            tempDep = [];
            for j=1:length(mazeRegionNames)
                tempDep = cat(ndims(getfield(goodDepData,mazeRegionNames{i}))+1,...
                    tempDep,getfield(goodDepData,mazeRegionNames{j}));
            end
            trialMeanDep = mean(tempDep,ndims(getfield(goodDepData,mazeRegionNames{i}))+1);
            trialMeanDep = repmat(trialMeanDep,length(mazeRegionNames),1);
        end
    end
    
    % convert data from structs to matrices for stat analysis
    [depData categData] = GetAllFields(goodDepData);
    contData = [];
    for i=1:length(goodContDataCell)
        [contTemp categData] = GetAllFields(goodContDataCell);
        contData = cat(2,contData,contTemp);
    end

    % create inputs
    yVar = depData;
    if trialMeanBool
        partialXvar = [ones(size(contData),1),contData,trialMeanDep];
    else
        partialXvar = [ones(size(contData),1),contData];
    end        

    % perform "ANCOVA", regressing continuous data and running
    % ANOVA on residuals
    partialModel(i) = ols(yVar,partialXvar);
    pVal = tcdf(-abs(partialModel(i).tstat),length(yVar)-1);
    for j=2:size(partialXvar,2);
        contPs(i,j) = pVal(j);
        contBetas(i,j) = partialModel(i).beta(j);
    end
    [categPs(i,:), T, categStats(i,:), terms] = anovan(partialModel(i).resid,{categData},'display','off');
    
    % fit continuous and categorical data simultaneously
    wholeXvar = {};
    contVector = [];
    for j=2:size(partialXvar,2);
        wholeXvar = cat(2,wholeXvar,{partialXvar(:,j)});
        contVector = [contVector j-1];
    end
    for j=1:size(categData,2)
        wholeXvar = cat(2,wholeXvar,{categData(:,j)});
    end
    [wholeModelPs(i,:), T, wholeModelStats(i,:), terms] = anovan(yVar,wholeXvar,'continuous',contVector,'display','off');
end

%colorStyle = 'bone';
colorStyle = 'default';
figure(1)
clf
colormap(colorStyle)
set(gcf,'name',[depVar ' partial']);
colorLimits = log10([10^-15 1]);
titles = cat(2,contIndepCell, fieldnames(trialDesig)')
for i=2:size(partialXvar,2)
    subplot(1,size(partialXvar,2)-1+size(categData,2),i-1);
    imagesc(Make2DPlotMat(log10(contPs(:,i)),MakeChanMat(6,16),badChan,'linear'));
    set(gca,'clim',colorLimits);
    colorbar
    title([contIndepCell{i-1} ' pVal']);
end
for j=1:size(categData,2)
    subplot(1,size(partialXvar,2)-1+size(categData,2),i-1+j);
    imagesc(Make2DPlotMat(log10(categPs),MakeChanMat(6,16),badChan,'linear'));
    set(gca,'clim',colorLimits);
    colorbar
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



