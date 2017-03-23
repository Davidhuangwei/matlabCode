function glmtrial8(nameNote,depVar,fileExt,nChan,freqBool,resizeWinBool)
%function glmtrial4(description,fileBaseMat,fileExt,midPointsText,minSpeed,winLength,thetaNW,gammaNW,depVar,trialMeanBool,contIndepCell,categIndepStruct)
if resizeWinBool
end
%fileBaseMat = [LoadVar('AlterFiles.mat');LoadVar('CircleFiles.mat')];
fileBaseMat = [LoadVar('AlterFiles.mat')];
keyboard
minSpeed = 0;
description = 'CalcRunningSpectra6_noExp';
winLength = 626;
thetaNW = 2;
gammaNW = 4;
w0 = 8
%nChan = 96;
%fileExt = '_LinNear.eeg'
%fileExt = '_LinNearCSD121.csd';
%fileExt = '.eeg';
midPointsText = '_MidPoints';
badChan = load('BadChanEEG.txt');
addpath(genpath('/u12/smm/matlab/econometrics/'))
removeOutliersBool = 1;
interpFunc = 'linear';
%interpFunc = [];
wholeModelBool = 0;
maxFreq = 150;
selectedChannels = 33:48;

dirName = [description midPointsText '_MinSpeed' num2str(minSpeed) 'Win' num2str(winLength)...
    'W0' num2str(w0) fileExt];
%dirName = [description midPointsText '_MinSpeed' num2str(minSpeed) 'Win' num2str(winLength)...
%    'ThetaNW' num2str(thetaNW) 'GammaNW' num2str(gammaNW) fileExt];

contIndepCell = {'speed.p0','accel.p0'}
if freqBool
    fs = LoadVar([fileBaseMat(1,:) '/' dirName '/fo.mat']);
else
    fs = 1;
end
% remove outliers from power/speed/accel
plotAnatBool = 1;
fileNameFormat = 0;
if plotAnatBool
    if fileNameFormat == 1
        anatOverlayName = ['sm9601' 'AnatCurves.mat'];
    else
        anatOverlayName = [fileBaseMat(1,1:6) 'AnatCurves.mat'];
    end
    anatLineWidth = 2;
    if strcmp(fileExt,'.eeg') | strcmp(fileExt,'_linNear.eeg')
        plotOffset = [0 0];
    end
    if strcmp(fileExt,'.csd1') | strcmp(fileExt,'.csd.1') | strcmp(fileExt,'_NearAveCSD1.csd')
        plotOffset = [1 0];
    end
    if strcmp(fileExt,'.csd121') | strcmp(fileExt,'.csd.121') | strcmp(fileExt,'_LinNearCSD121.csd')
        plotOffset = [2 0];
    end
    %plotOffset
    %plotOffset(2) = 2;
    plotSize = [16.5,6.5];
    %plotSize = size(chanMat) + plotOffset.*2;
else
    anatOverlayName = [];
end
trialDesig = [];

if 0
    trialDesig.alter.returnArm = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 1],0.5};
    trialDesig.alter.centerArm = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 1 0 0 0 0],0.5};
    trialDesig.circle.Tjunction = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 1 0 0 0 0 0],0.4};
    trialDesig.circle.goalArm =   {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 1 0 0],0.5};
    depthVar = 2;
    trialMeanBool = 0;
end
if 1
    trialDesig.returnArm = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 1],0.5};
    trialDesig.centerArm = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 1 0 0 0 0],0.5};
    trialDesig.Tjunction = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 1 0 0 0 0 0],0.4};
    trialDesig.goalArm =   {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 1 0 0],0.5};
    trialMeanBool = 1;
    depthVar = 1;
end
if 0
    %trialDesig.alter.returnArm = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 1],0.5};
    trialDesig.centerArm =  {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 1 0 0 0 0],0.5};
    trialDesig.q12 = cat(1,{'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 0 1],0.4},...
        {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 0],0.5});
    trialMeanBool = 0;
    removeOutliersBool = 0;
end
if 0
    trialDesig.err.returnArm = {'alter',[0 1 0 1 0 1 0 1 0 1 0 1 0],0.6,[0 0 0 0 0 0 0 1 1],0.5};
    trialDesig.err.centerArm = {'alter',[0 1 0 1 0 1 0 1 0 1 0 1 0],0.6,[0 0 0 0 1 0 0 0 0],0.5};
    trialDesig.err.Tjunction = {'alter',[0 1 0 1 0 1 0 1 0 1 0 1 0],0.6,[0 0 0 1 0 0 0 0 0],.9};
    trialDesig.err.goalArm =   {'alter',[0 1 0 1 0 1 0 1 0 1 0 1 0],0.6,[0 0 0 0 0 1 1 0 0],.9};
    trialDesig.corr.returnArm = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 1],0.5};
    trialDesig.corr.centerArm = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 1 0 0 0 0],0.5};
    trialDesig.corr.Tjunction = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 1 0 0 0 0 0],0.4};
    trialDesig.corr.goalArm =   {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 1 0 0],0.5};
    trialMeanBool = 0;
    depthVar = 0;

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


% load selected data
for i=1:length(contIndepCell)
    contCellStruct{i} = LoadDesigVar(fileBaseMat,dirName,contIndepCell{i},trialDesig);
end
depStruct = LoadDesigVar(fileBaseMat,dirName,depVar,trialDesig);

for ch=1:nChan
    fprintf('ch%i;',ch)
    for f=1:find(abs(fs-maxFreq)==min(abs(fs-maxFreq)),1)
        %fprintf('\n---- Channel %ch ----\n',ch)

        % extract all trials from specific channel/freq
        depStructSub = GetStructMatSub(depStruct,[2,ch; 3,f]);

        % remove outliers
        [tempCellStruct outlierStruct{ch,f}] = RemoveOutliers(cat(2,contCellStruct,{depStructSub}),depthVar,3);
        goodContCellStruct(1:length(contCellStruct)) = tempCellStruct(1:length(contCellStruct));
        goodDepStruct = tempCellStruct{end};

        
        % test assumptions of ANCOVA
        % 1) test normality of categories (jbtest)
        %mazeReg = 'centerArm'
        yNormPs(ch,f) = TestNormality(goodDepStruct);
        yVarZs(ch,f) = TestHomoVarMult(goodDepStruct);
        yVarPs(ch,f) = TestHomoVar(goodDepStruct);
        %figure(1)
        %hist(goodDepStruct.(mazeReg))
        %figure(2)
        %plot(goodDepStruct.(mazeReg),'.')
        
        % 2) test constant variance of categories (kstest2? or ftest)
        % 3) test normality mean and var of final residuals (jbtest & ftest)
        % 4) test non-parallel treatment
        % 5) time vs y correlation
        
        % convert data from structs to matrices for stat analysis
        goodDepCell = Struct2CellArray(goodDepStruct);
        depData = cell2mat(goodDepCell(:,end));
        categData = goodDepCell(:,1:end-1);

        contData = [];
        % make continuous data matrix
        for j=1:length(goodContCellStruct)
            [goodContCell] = Struct2CellArray(goodContCellStruct{j});
            contData(:,j) = cell2mat(goodContCell(:,end));
            %contData = cat(2,contData,contTemp);
        end

        % re-sort categData so each column is in separate cells
        newCategData = {};
        for j=1:size(categData,2)
            newCategData(j) = {categData(:,j)};
        end
        categData = newCategData;

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

        % create stat input mats
        yVar = depData;
        if trialMeanBool
            partialXvar = [ones(size(contData,1),1),contData,trialMeanDep];
        else
            partialXvar = [ones(size(contData,1),1),contData];
        end

        % perform "ANCOVA", regressing continuous data and running
        % ANOVA on residuals
        partialModel = ols(yVar,partialXvar);
        pVal = tcdf(-abs(partialModel.tstat),length(yVar)-1);
        for j=2:size(partialXvar,2);
            partialPs(j,ch,f) = pVal(j);
            contBetas(j,ch,f) = partialModel.beta(j);
        end
        if 1
            %% anova for parametric analysis %%
            [partialPs(size(partialXvar,2)+1:size(partialXvar,2)+size(categData,2),ch,f), T, categStats(:,ch,f), terms] = ...
                anovan(partialModel.resid,categData,'display','off');
        else
            %% kruskalwallis for non-parametric analysis %%
            [partialPs(size(partialXvar,2)+1:size(partialXvar,2)+size(categData,2),ch,f), T, categStats(:,ch,f),] = ...
                kruskalwallis(partialModel.resid,categData{1},'off');
        end
        nWayComps = {};
        for j=1:size(categData,2)
            nWayComps = cat(1,nWayComps,num2cell(nchoosek([1:size(categData,2)],j),2));
        end
        for j=1:size(nWayComps,1)
            [junk categMeans{j}(:,:,ch,f) junk2 groupCompNames{j}(:,:,ch,f)] = multcompare(categStats(:,ch,f),'dimension',nWayComps{j},'display','off');
        end

        % fit continuous and categorical data simultaneously
        wholeXvar = {};
        contVector = [];
        for j=2:size(partialXvar,2);
            wholeXvar = cat(2,wholeXvar,{partialXvar(:,j)});
            contVector = [contVector j-1];
        end
        %for j=1:size(categData,2)
        %    wholeXvar = cat(2,wholeXvar,{categData(:,j)});
        %end
        wholeXvar = cat(2,wholeXvar,categData);

        [wholeModelPs(:,ch,f), T, wholeModelStats(:,ch,f), terms] = anovan(yVar,wholeXvar,'continuous',contVector,'display','off');

%        keyboard
    end
end
keyboard
save(['glmtrial8_' nameNote depVar fileExt]);
return
keyboard

nextFig = 1;
colorStyle = LoadVar('ColorMapSean6');
figSizeFactor = 2.5;
figVertOffset = .25;
figHorzOffset = 0;
%figHorzSubt = -1;
%colorStyle = 'bone';
set(gcf,'DefaultAxesPosition',[0.05,0.15,0.92,0.75]);

%%%%% for wavelets %%%%%
nShanks = 6
sitesPerShank = 12;
figure(1)
set(gcf, 'Units', 'inches')
%set(gcf, 'Position', [figHorzOffset,figVertOffset,figSizeFactor*(i-1+j+1),figSizeFactor])
for i=1:nShanks
    subplot(1,nShanks,i)
    a = partialPs(5,(i-1)*sitesPerShank+1:(i)*sitesPerShank,:);
    a(find(a==0)) = 1.1e-16;
    imagesc(fs(1:find(abs(fs-maxFreq)==min(abs(fs-maxFreq)),1)),1:sitesPerShank,squeeze(log10(a)));
    pcolor(fs(1:find(abs(fs-maxFreq)==min(abs(fs-maxFreq)),1)),sitesPerShank:-1:1,squeeze(log10(a)));
    %imagesc(squeeze(log10(a)));
    shading 'interp'
    set(gca,'clim',log10([10^(-10) 1]))
    %set(gca,'xtick',fs(1:30:find(abs(fs-maxFreq)==min(abs(fs-maxFreq)),1)),'xticklabel',fs(1:30:find(abs(fs-maxFreq)==min(abs(fs-maxFreq)),1)))
    colormap(flipud(colorStyle))
    colorbar
end
set(gcf,'name','test1')
figure(2)
set(gcf, 'Units', 'inches')
%set(gcf, 'Position', [figHorzOffset,figVertOffset,figSizeFactor*(i-1+j+1),figSizeFactor])
for j=1:4
    for i=1:nShanks
        subplot(4,nShanks,(j-1)*nShanks+i);
        pcolor(fs(1:find(abs(fs-maxFreq)==min(abs(fs-maxFreq)),1)),sitesPerShank:-1:1,squeeze(categMeans{1}(j,1,(i-1)*sitesPerShank+1:(i)*sitesPerShank,:))); 
        set(gca,'clim',[-1 1]); 
            shading 'interp'
    colormap(colorStyle)
colorbar
    end
end

%%%%% for fourier %%%%%
nShanks = 6
sitesPerShank = 16;
figure(1)
set(gcf, 'Units', 'inches')
%set(gcf, 'Position', [figHorzOffset,figVertOffset,figSizeFactor*(i-1+j+1),figSizeFactor])
for i=1:nShanks
    subplot(1,nShanks,i)
    a = partialPs(5,(i-1)*sitesPerShank+1:(i)*sitesPerShank,:);
    a(find(a==0)) = 1.1e-16;
    imagesc(Smooth(squeeze(log10(a)),[1.2,.16]));
    %imagesc(squeeze(log10(a)));
    set(gca,'clim',log10([10^(-10) 1]))
    %shading 'interp'
        colormap(flipud(colorStyle))
    colorbar
end
set(gcf,'name','test1')
%WebPrint
%categMeans{j}(:,k,1)
figure(2)
set(gcf, 'Units', 'inches')
%set(gcf, 'Position', [figHorzOffset,figVertOffset,figSizeFactor*(i-1+j+1),figSizeFactor])
for j=1:4
    for i=1:nShanks
        subplot(4,nShanks,(j-1)*nShanks+i);
        imagesc(Smooth(squeeze(categMeans{1}(j,1,(i-1)*sitesPerShank+1:(i)*sitesPerShank,:)),[1.2, .16]));
        %pcolor(squeeze(categMeans{1}(j,1,(i-1)*sitesPerShank+1:(i)*sitesPerShank,:)));
        set(gca,'clim',[-1.5 1.5]);
        %shading 'interp'
        colormap(colorStyle)
        colorbar
    end
end

set(gcf, 'Units', 'inches')
    set(gcf, 'Position', [figHorzOffset,figVertOffset,figSizeFactor*(i-1+j+1),figSizeFactor])

categTitles = {};
for i=1:length(categData{1})
    categTitles = cat(2,categTitles,categData{1}{i}(1));
end
if resizeWinBool
    close all
end

if removeOutliersBool
    figure(nextFig)
    clf
    nextFig = nextFig +1;
    [outliersCell] = Struct2CellArray(outlierTrials(1));
    %outliers{1} = cell2mat(outliersCell(:,end));
    outliers{1} = outliersCell(:,end);
    outCategs = outliersCell(:,1:end-1);
    trialOutliers = cell(length(outliers{1}),1);
    for i=1:nChan
        [outliersCell] = Struct2CellArray(outlierTrials(i));
        %outliers{i} = cell2mat(outliersCell{:,end});
        outliers{i} = outliersCell(:,end);
        for j=1:length(outliers{i});
            chanOutliers(i,j) = length(outliers{i}{j});
            trialOutliers{j} = cat(1,trialOutliers{j},outliers{i}{j});
        end
    end
    for j=1:length(trialOutliers)
        subplot(2,length(trialOutliers),j);
        h = ImageScRmNaN(Make2DPlotMat(chanOutliers(:,j),MakeChanMat(6,16),badChan));
        if plotAnatBool
            XYPlotAnatCurves({anatOverlayName},h,plotSize,plotOffset)
        end
        title([{'Outliers per Channel'} outCategs(j,:)]);
        subplot(2,length(trialOutliers),j+length(trialOutliers));
        bar(Accumulate(trialOutliers{j}),'r')
        title([{'Outliers Per Trial'} outCategs(j,:)])
        colormap(colorStyle)
    end
    if resizeWinBool
        set(gcf, 'Units', 'inches')
        %set(gcf, 'Position', [-1,8.5-(nextFig-2)*(figSizeFactor+figVertOffset),figSizeFactor*2,figSizeFactor*length(trialOutliers)])
        set(gcf, 'Position', [figHorzOffset,figVertOffset,figSizeFactor*length(trialOutliers),figSizeFactor*2])
    end
end

figure(nextFig)
clf
nextFig = nextFig +1;
set(gcf,'name',[depVar ' partial']);
colorLimits = log10([1 10^-15]);
if trialMeanBool
    titles = cat(2,contIndepCell, 'trial means',categTitles);
else
    titles = cat(2,contIndepCell,categTitles);
end
for i=2:size(partialXvar,2)
    subplot(1,size(partialXvar,2)-1+size(categData{i},2),i-1);
    h = ImageScRmNaN(Make2DPlotMat(log10(contPs(:,i)),MakeChanMat(6,16),badChan,interpFunc),colorLimits);
    if plotAnatBool
        XYPlotAnatCurves({anatOverlayName},h,plotSize,plotOffset)
    end
    %set(gca,'clim',colorLimits);
    %colorbar
    colormap(colorStyle)
    title([titles{i-1} ' pVal']);
end
for j=1:size(categData{i},2)
    subplot(1,size(partialXvar,2)-1+size(categData{i},2),i-1+j);
    temp = log10(categPs(:,j));
    temp(temp==-inf) = -16;
    h = ImageScRmNaN(Make2DPlotMat(temp,MakeChanMat(6,16),badChan,interpFunc),colorLimits);
    if plotAnatBool
        XYPlotAnatCurves({anatOverlayName},h,plotSize,plotOffset)
    end
    %set(gca,'clim',colorLimits);
    title([titles{size(partialXvar,2)+j-1} ' pVal']);
    %colorbar
end
if resizeWinBool
    set(gcf, 'Units', 'inches')
    set(gcf, 'Position', [figHorzOffset,figVertOffset,figSizeFactor*(i-1+j+1),figSizeFactor])
end

figure(nextFig)
nextFig = nextFig +1;
clf
set(gcf,'name',[depVar ' partial']);
colorLimits = [];
if trialMeanBool
    titles = cat(2,contIndepCell, 'trial means',categTitles);
else
    titles = cat(2,contIndepCell,categTitles);
end
for i=2:size(partialXvar,2)
    subplot(1,size(partialXvar,2)-1+size(categData{i},2),i-1);
    h = ImageScRmNaN(Make2DPlotMat(contBetas(:,i),MakeChanMat(6,16),badChan,interpFunc),colorLimits);
    if plotAnatBool
        XYPlotAnatCurves({anatOverlayName},h,plotSize,plotOffset)
    end
    %set(gca,'clim',colorLimits);
    %colorbar
    colormap(colorStyle)
    title([titles{i-1} ' Beta']);
end
if resizeWinBool
    set(gcf, 'Units', 'inches')
    set(gcf, 'Position', [figHorzOffset,figVertOffset,figSizeFactor*(size(partialXvar,2)-1+size(categData{i},2)+1),figSizeFactor])
end

for j=1:length(categMeans)
    figure(nextFig)
    nextFig = nextFig +1;
    clf
    set(gcf,'name',[depVar ' partial']);
    colorLimits = [-1 1];
    for k=1:size(categMeans{j},2)
        subplot(1,size(categMeans{j},2),k);
        h = ImageScRmNaN(Make2DPlotMat(categMeans{j}(:,k,1),MakeChanMat(6,16),badChan,interpFunc),colorLimits);
        if plotAnatBool
            XYPlotAnatCurves({anatOverlayName},h,plotSize,plotOffset)
        end
        colormap(colorStyle)
        title(groupCompNames{j}(:,k,1));
    end
    if resizeWinBool
        set(gcf, 'Units', 'inches')
        set(gcf, 'Position', [figHorzOffset,figVertOffset,figSizeFactor*(size(categMeans{j},2)+1),figSizeFactor])
    end
end
if 0 %% work in progress
    
    for i=1:4
        subplot(1,4,i);
        h = ImageScRmNaN(Make2DPlotMat(categMeans{1}(i,1,:),MakeChanMat(6,16)));
        set(gca,'clim',[25 110]);
        if plotAnatBool
            XYPlotAnatCurves({anatOverlayName},h,plotSize,plotOffset)
        end
    end
    
    for j=1:size(categMeans{1})
        figure(nextFig)
        nextFig = nextFig +1;
        clf
        set(gcf,'name',[depVar ' partial']);
        colorLimits = [-1 1];
        for k=1:size(categMeans{j},2)
            subplot(1,size(categMeans{j},2),k);
            h = ImageScRmNaN(Make2DPlotMat(categMeans{j}(:,k,1),MakeChanMat(6,16),badChan,interpFunc),colorLimits);
            if plotAnatBool
                XYPlotAnatCurves({anatOverlayName},h,plotSize,plotOffset)
            end
            colormap(colorStyle)
            title(groupCompNames{j}(:,k,1));
        end
        if resizeWinBool
            set(gcf, 'Units', 'inches')
            set(gcf, 'Position', [figHorzOffset,figVertOffset,figSizeFactor*(size(categMeans{j},2)+1),figSizeFactor])
        end
    end
end
    

for i=nextFig-1:-1:1
    figure(i)
end
return


if trialMeanBool
    titles = cat(2,contIndepCell, 'trial means',categData{i}(1,:));
else
    titles = cat(2,contIndepCell,categData{i}(1,:));
end
for i=2:size(partialXvar,2)
    subplot(1,size(partialXvar,2)-1+size(categData{i},2),i-1);
    %ImageScRmNaN(Make2DPlotMat(partialModel.resid(,MakeChanMat(6,16),badChan,interpFunc),colorLimits));
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
imagesc(Make2DPlotMat(log10(speedP),MakeChanMat(6,16),badChan,interpFunc));
set(gca,'clim',colorLimits)
title('Speed Pval')
colorbar
subplot(1,4,2)
imagesc(Make2DPlotMat(log10(accelP),MakeChanMat(6,16),badChan,interpFunc));
set(gca,'clim',colorLimits)
title('Accel Pval')
colorbar
subplot(1,4,3)
imagesc(Make2DPlotMat(log10(meanPowP),MakeChanMat(6,16),badChan,interpFunc));
set(gca,'clim',colorLimits*4)
title('Trial Pval')
colorbar
subplot(1,4,4)
imagesc(Make2DPlotMat(log10(mazeP),MakeChanMat(6,16),badChan,interpFunc));
set(gca,'clim',colorLimits)
title('MazeRegion Pval')
colorbar

figure(2)
clf
colormap(colorStyle)
set(gcf,'name',depVar);
subplot(1,4,1)
colorLimits = [];
imagesc(Make2DPlotMat(speedB,MakeChanMat(6,16),badChan,interpFunc));
set(gca,'clim',colorLimits)
title('Speed Bval')
colorbar
subplot(1,4,2)
imagesc(Make2DPlotMat(accelB,MakeChanMat(6,16),badChan,interpFunc));
set(gca,'clim',colorLimits)
title('Accel Bval')
colorbar
subplot(1,4,3)
imagesc(Make2DPlotMat(meanPowB,MakeChanMat(6,16),badChan,interpFunc));
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
imagesc(Make2DPlotMat(returnNorm,MakeChanMat(6,16),badChan,interpFunc));
set(gca,'clim',colorLimits)
colorbar
subplot(1,4,2)
imagesc(Make2DPlotMat(centerNorm,MakeChanMat(6,16),badChan,interpFunc));
set(gca,'clim',colorLimits)
colorbar
subplot(1,4,3)
imagesc(Make2DPlotMat(tNorm,MakeChanMat(6,16),badChan,interpFunc));
set(gca,'clim',colorLimits)
colorbar
subplot(1,4,4)
imagesc(Make2DPlotMat(goalNorm,MakeChanMat(6,16),badChan,interpFunc));
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



