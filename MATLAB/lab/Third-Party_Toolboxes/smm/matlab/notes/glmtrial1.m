
% remove outliers from power/speed/accel
fileBaseMat = LoadVar('AlterFiles.mat');
minSpeed = 0;
description = 'CalcRunningSpectra5_noExp';
winLength = 626;
thetaNW = 2;
gammaNW = 4;
fileExt = '.eeg';
midPointsText = '_MidPoints';
badchan = load('BadChanEEG.txt');
addpath(genpath('/u12/smm/matlab/econometrics/'))

trialDesig.returnArm = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 1],0.5};
trialDesig.centerArm = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 1 0 0 0 0],0.5};
trialDesig.Tjunction = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 1 0 0 0 0 0],0.4};
trialDesig.goalArm =   {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 1 0 0],0.5};

mazeRegionNames = fieldnames(trialDesig);
for i=1:length(mazeRegionNames)
    taskTypes(i) = getfield(trialDesig,mazeRegionNames{i},{1});
end



dirName = [description midPointsText '_MinSpeed' num2str(minSpeed) 'Win' num2str(winLength)...
    'ThetaNW' num2str(thetaNW) 'GammaNW' num2str(gammaNW) fileExt];

depVar = 'thetaPowPeak';
depVar = 'gammaPowIntg';
regionPow = LoadDesigVar(fileBaseMat,dirName,depVar,trialDesig)
regionSpeed = LoadDesigVar(fileBaseMat,dirName,'speed.p0',trialDesig)
regionAccel = LoadDesigVar(fileBaseMat,dirName,'accel.p0',trialDesig)

pow = [];
speed = [];
accel = [];
mazeDesigChar = [];
meanpow = [];
overParam = 0;
if overParam
    mazeDesig = zeros(size(getfield(regionPow,mazeRegionNames{1}))*4,length(mazeRegionNames));
else
    mazeDesig = zeros(size(getfield(regionPow,mazeRegionNames{1}))*4,length(mazeRegionNames)-1);
end
for i=1:length(mazeRegionNames)
    %size(pow,1)+1
    %size(pow,1)+size(getfield(regionPow,mazeRegionNames{i}),1)
    %if overParam
    %    mazeDesig(size(pow,1)+1:size(pow,1)+size(getfield(regionPow,mazeRegionNames{i}),1),i) = 1;
    %else
    %    if i==length(mazeRegionNames)
    %        mazeDesig(size(pow,1)+1:size(pow,1)+size(getfield(regionPow,mazeRegionNames{i}),1),:) = -1;
    %    else
    %        mazeDesig(size(pow,1)+1:size(pow,1)+size(getfield(regionPow,mazeRegionNames{i}),1),i) = 1;
    %    end
    %end
    pow = [pow; getfield(regionPow,mazeRegionNames{i})];
    
    speed = [speed; getfield(regionSpeed,mazeRegionNames{i})];
    accel = [accel; getfield(regionAccel,mazeRegionNames{i})];  
    mazeDesigChar = cat(1,mazeDesigChar,repmat(mazeRegionNames{i}(1),size(getfield(regionPow,mazeRegionNames{i})),1));
    meanpow = cat(3,meanpow,getfield(regionPow,mazeRegionNames{i}));
end
%mazeDesigNum = [ones(38,1); 2*ones(38,1); 3*ones(38,1);  4*ones(38,1)];
%mazeDesigChar = [repmat(mazeRegionNames{i},38,1); repmat('c',38,1); repmat('t',38,1); repmat('g',38,1)];
%meanpow = cat(3,regionPow.returnArm, regionPow.centerArm, regionPow.Tjunction, regionPow.goalArm);
meanpow = mean(meanpow,3);
meanpow = [meanpow;meanpow;meanpow;meanpow];

for i=1:96
    yVar = pow(:,i);
    xVar = [ones(size(speed)),speed,accel,meanpow(:,i)];
    %xVar = [ones(size(speed)),speed,accel];
    results(i) = ols(yVar,xVar);
    results(i).tstat;
    pVal = tcdf(-abs(results(i).tstat),length(yVar)-1);
    speedP(i) = pVal(2);
    speedB(i) = results(i).beta(2);
    accelP(i) = pVal(3);
    accelB(i) = results(i).beta(3);
    meanPowP(i) = pVal(4);
    meanPowB(i) = results(i).beta(4);
    [mazeP(i) T,STATS(i),TERMS] = anovan(results(i).resid,{mazeDesigChar},'display','off');
end
%colorStyle = 'bone';
colorStyle = 'default';

figure(1)
clf
colormap(colorStyle)
set(gcf,'name',depVar);
subplot(1,4,1)
colorLimits = log10([10^-15 1])
imagesc(Make2DPlotMat(log10(speedP),MakeChanMat(6,16),badchan,'linear'));
set(gca,'clim',colorLimits)
title('Speed Pval')
colorbar
subplot(1,4,2)
imagesc(Make2DPlotMat(log10(accelP),MakeChanMat(6,16),badchan,'linear'));
set(gca,'clim',colorLimits)
title('Accel Pval')
colorbar
subplot(1,4,3)
imagesc(Make2DPlotMat(log10(meanPowP),MakeChanMat(6,16),badchan,'linear'));
set(gca,'clim',colorLimits*4)
title('Trial Pval')
colorbar
subplot(1,4,4)
imagesc(Make2DPlotMat(log10(mazeP),MakeChanMat(6,16),badchan,'linear'));
set(gca,'clim',colorLimits)
title('MazeRegion Pval')
colorbar

figure(2)
clf
colormap(colorStyle)
set(gcf,'name',depVar);
subplot(1,4,1)
colorLimits = [];
imagesc(Make2DPlotMat(speedB,MakeChanMat(6,16),badchan,'linear'));
set(gca,'clim',colorLimits)
title('Speed Bval')
colorbar
subplot(1,4,2)
imagesc(Make2DPlotMat(accelB,MakeChanMat(6,16),badchan,'linear'));
set(gca,'clim',colorLimits)
title('Accel Bval')
colorbar
subplot(1,4,3)
imagesc(Make2DPlotMat(meanPowB,MakeChanMat(6,16),badchan,'linear'));
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
imagesc(Make2DPlotMat(returnNorm,MakeChanMat(6,16),badchan,'linear'));
set(gca,'clim',colorLimits)
colorbar
subplot(1,4,2)
imagesc(Make2DPlotMat(centerNorm,MakeChanMat(6,16),badchan,'linear'));
set(gca,'clim',colorLimits)
colorbar
subplot(1,4,3)
imagesc(Make2DPlotMat(tNorm,MakeChanMat(6,16),badchan,'linear'));
set(gca,'clim',colorLimits)
colorbar
subplot(1,4,4)
imagesc(Make2DPlotMat(goalNorm,MakeChanMat(6,16),badchan,'linear'));
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
    
imagesc(Make2DPlotMat((c(:,4)+c(:,5)+c(:,6))./3,MakeChanMat(6,16),badchan));colorbar
imagesc(Make2DPlotMat((c(:,2)+c(:,3)+c(:,4))./3,MakeChanMat(6,16),badchan));colorbar

imagesc(Make2DPlotMat(c(:,2),MakeChanMat(6,16),badchan));colorbar
imagesc(Make2DPlotMat(log10(pVal(:,5)),MakeChanMat(6,16),badchan));set(gca,'clim',log10([10^-10 1]));colorbar



