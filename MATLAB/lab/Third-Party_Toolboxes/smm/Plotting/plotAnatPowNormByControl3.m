function plotAnatPowNormByControl3(expTaskType,expFileBaseMat,controlTaskType,controlFileBaseMat,fileNameFormat,lowCut,highCut,fileExt,chanMat,badchan,onePointBool,samescale,dbscale)

if fileNameFormat == 0,
    ERROR_NOT_PROGRAMMED_FOR_THIS_FILE_NAME_FORMAT
    if onePointBool
        fileName = [taskType '_' fileBaseMat(1,[1:7 10:12 14 17:19]) '-' fileBaseMat(end,[7 10:12 14 17:19]) ...
            fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_point_AnatMazeRegionPow.mat'];
    else
        fileName = [taskType '_' fileBaseMat(1,[1:7 10:12 14 17:19]) '-' fileBaseMat(end,[7 10:12 14 17:19]) ...
            fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_mean_AnatMazeRegionPow.mat'];
    end
end
if fileNameFormat == 2,
    if onePointBool
        expFileName = [expTaskType '_' expFileBaseMat(1,[1:10]) '-' expFileBaseMat(end,[8:10]) ...
            fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_point_AnatMazeRegionPow.mat'];
        controlFileName = [controlTaskType '_' controlFileBaseMat(1,[1:10]) '-' controlFileBaseMat(end,[8:10]) ...
            fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_point_AnatMazeRegionPow.mat'];
    else
        expFileName = [expTaskType '_' expFileBaseMat(1,[1:10]) '-' expFileBaseMat(end,[8:10]) ...
            fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_mean_AnatMazeRegionPow.mat'];
        controlFileName = [controlTtaskType '_' controlFileBaseMat(1,[1:10]) '-' controlFileBaseMat(end,[8:10]) ...
            fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_mean_AnatMazeRegionPow.mat'];
    end
end
if exist(expFileName,'file')
    fprintf('loading %s',expFileName)
    load(expFileName);
else
    ERROR_RUN_CalcAnatMazeRegionPow
end
expReturnarmPowMat = returnarmPowMat;
expCenterarmPowMat = centerarmPowMat;
expChoicearmPowMat = choicepointPowMat;
expChoicepointPowMat = choicearmPowMat;

if exist(controlFileName,'file')
    fprintf('loading %s',controlFileName)
    load(controlFileName);
else
    ERROR_RUN_CalcAnatMazeRegionPow
end
controlReturnarmPowMat = returnarmPowMat;
controlCenterarmPowMat = centerarmPowMat;
controlChoicearmPowMat = choicepointPowMat;
controlChoicepointPowMat = choicearmPowMat;

meanCenter = mean(expCenterarmPowMat,1)./mean(controlCenterarmPowMat,1);   
meanChoice = mean(expChoicearmPowMat,1)./mean(controlChoicearmPowMat,1);
meanCP = mean(expChoicepointPowMat,1)./mean(controlChoicepointPowMat,1);
meanReturn = mean(expReturnarmPowMat,1)./mean(controlReturnarmPowMat,1);

if ~exist('samescale','var')
    samescale = 0;
end
if ~exist('badchan','var')
    badchan = 0;
end
if ~exist('dbscale','var')
    dbscale = 0;
end

centerAnatPowMat = zeros(size(chanMat))*NaN;
rewardAnatPowMat = zeros(size(chanMat))*NaN;
returnAnatPowMat = zeros(size(chanMat))*NaN;
choiceAnatPowmat = zeros(size(chanMat))*NaN;

avepowperchan =  zeros(size(chanMat))*NaN;

avecenterAnatPowMat = zeros(size(chanMat))*NaN;
averewardAnatPowMat = zeros(size(chanMat))*NaN;
avereturnAnatPowMat = zeros(size(chanMat))*NaN;
avechoiceAnatPowmat = zeros(size(chanMat))*NaN;

centermin = [];
centermax = [];
rewardmin = [];
rewardmax = [];
returnmin = [];
returnmax = [];
choicemin = [];
choicemax = [];

avecentermin = [];
avecentermax = [];
averewardmin = [];
averewardmax = [];
avereturnmin = [];
avereturnmax = [];
avechoicemin = [];
avechoicemax = [];


[nChanY nChanX] = size(chanMat);
for x=1:nChanX
    for y=1:nChanY
    if isempty(find(badchan==chanMat(y,x))), % if the channel isn't bad
           
        if dbscale,    
            avepowperchan(y,x) = 10*log10(mean([meanCenter(chanMat(y,x)) meanChoice(chanMat(y,x)) meanReturn(chanMat(y,x)) meanCP(chanMat(y,x))]));
            centerAnatPowMat(y,x) = 10*log10(meanCenter(chanMat(y,x)));
            rewardAnatPowMat(y,x) = 10*log10(meanChoice(chanMat(y,x)));  
            returnAnatPowMat(y,x) = 10*log10(meanReturn(chanMat(y,x)));
            choiceAnatPowmat(y,x) = 10*log10(meanCP(chanMat(y,x)));
            
            avecenterAnatPowMat(y,x) = centerAnatPowMat(y,x) - avepowperchan(y,x);
            averewardAnatPowMat(y,x) = rewardAnatPowMat(y,x) - avepowperchan(y,x);
            avereturnAnatPowMat(y,x) =  returnAnatPowMat(y,x) - avepowperchan(y,x);
            avechoiceAnatPowmat(y,x) = choiceAnatPowmat(y,x) - avepowperchan(y,x);
        else
            centerAnatPowMat(y,x) = meanCenter(chanMat(y,x));
            rewardAnatPowMat(y,x) = meanChoice(chanMat(y,x));
            returnAnatPowMat(y,x) = meanReturn(chanMat(y,x));
            choiceAnatPowmat(y,x) = meanCP(chanMat(y,x));
            
            avepowperchan(y,x) = mean([centerAnatPowMat(y,x) rewardAnatPowMat(y,x) returnAnatPowMat(y,x) choiceAnatPowmat(y,x)]);
            avecenterAnatPowMat(y,x) = centerAnatPowMat(y,x) - avepowperchan(y,x);
            averewardAnatPowMat(y,x) = rewardAnatPowMat(y,x) - avepowperchan(y,x);
            avereturnAnatPowMat(y,x) =  returnAnatPowMat(y,x) - avepowperchan(y,x);
            avechoiceAnatPowmat(y,x) = choiceAnatPowmat(y,x) - avepowperchan(y,x);
          
        end
        if samescale,
            centermin = min([centermin centerAnatPowMat(y,x)]);
            centermax = max([centermax centerAnatPowMat(y,x)]);
            rewardmin = min([rewardmin rewardAnatPowMat(y,x)]);
            rewardmax = max([rewardmax rewardAnatPowMat(y,x)]);
            returnmin = min([returnmin returnAnatPowMat(y,x)]);
            returnmax = max([returnmax returnAnatPowMat(y,x)]);
            choicemin = min([choicemin choiceAnatPowmat(y,x)]);
            choicemax = max([choicemax choiceAnatPowmat(y,x)]);
            
            avecentermin = min([avecentermin avecenterAnatPowMat(y,x)]);
            avecentermax = max([avecentermax avecenterAnatPowMat(y,x)]);
            averewardmin = min([averewardmin averewardAnatPowMat(y,x)]);
            averewardmax = max([averewardmax averewardAnatPowMat(y,x)]);
            avereturnmin = min([avereturnmin avereturnAnatPowMat(y,x)]);
            avereturnmax = max([avereturnmax avereturnAnatPowMat(y,x)]);
            avechoicemin = min([avechoicemin avechoiceAnatPowmat(y,x)]);
            avechoicemax = max([avechoicemax avechoiceAnatPowmat(y,x)]);
        end
    end   
    end
end


if expFileBaseMat(1,1:6) == 'sm9601'
    zeromat = ones(16,1)*NaN;
    
    centerAnatPowMat = [centerAnatPowMat(:,1) zeromat centerAnatPowMat(:,2:5)];
    rewardAnatPowMat = [rewardAnatPowMat(:,1) zeromat rewardAnatPowMat(:,2:5)];
    returnAnatPowMat = [returnAnatPowMat(:,1) zeromat returnAnatPowMat(:,2:5)];
    choiceAnatPowmat = [choiceAnatPowmat(:,1) zeromat choiceAnatPowmat(:,2:5)];

    avecenterAnatPowMat = [avecenterAnatPowMat(:,1) zeromat avecenterAnatPowMat(:,2:5)];
    averewardAnatPowMat = [averewardAnatPowMat(:,1) zeromat averewardAnatPowMat(:,2:5)];
    avereturnAnatPowMat = [avereturnAnatPowMat(:,1) zeromat avereturnAnatPowMat(:,2:5)];
    avechoiceAnatPowmat = [avechoiceAnatPowmat(:,1) zeromat avechoiceAnatPowmat(:,2:5)];
end

absmin = min([centermin rewardmin returnmin choicemin]);
absmax = max([centermax rewardmax returnmax choicemax]);

aveabsmin = min([avecentermin averewardmin avereturnmin avechoicemin]);
aveabsmax = max([avecentermax averewardmax avereturnmax avechoicemax]);

avecentermin
avecentermax

figure(1)
title(expFileBaseMat(1,1:6));
%absmin = 48;
%absmax = 64;
%if isempty(find(badchan==chanMat(y,x))), % if the channel isn't bad
% now plot
subplot(2,2,1);
imagesc(centerAnatPowMat);
if samescale,
    set(gca,'clim',[absmin absmax]);
end
colorbar;
title('center');
subplot(2,2,2);
imagesc(rewardAnatPowMat);
if samescale,
    set(gca,'clim',[absmin absmax]);
end
colorbar;  
title('reward');
subplot(2,2,3);
imagesc(returnAnatPowMat);
if samescale,
    set(gca,'clim',[absmin absmax]);
end
colorbar;
title('return');
subplot(2,2,4);
imagesc(choiceAnatPowmat);
if samescale,
    set(gca,'clim',[absmin absmax]);
end
colorbar;
title('choice');

figure(2)
title(expFileBaseMat(1,1:6));
%aveabsmin = -2.5;
%aveabsmax = 2.5
%if isempty(find(badchan==chanMat(y,x))), % if the channel isn't bad
% now plot
subplot(2,2,1);
imagesc(avecenterAnatPowMat);
if samescale,
    set(gca,'clim',[aveabsmin aveabsmax]);
end
colorbar;
title('center');
subplot(2,2,2);
imagesc(averewardAnatPowMat);
if samescale,
    set(gca,'clim',[aveabsmin aveabsmax]);
end
colorbar;  
title('reward');
subplot(2,2,3);
imagesc(avereturnAnatPowMat);
if samescale,
    set(gca,'clim',[aveabsmin aveabsmax]);
end
colorbar;
title('return');
subplot(2,2,4);
imagesc(avechoiceAnatPowmat);
if samescale,
    set(gca,'clim',[aveabsmin aveabsmax]);
end
colorbar;
title('choice');
