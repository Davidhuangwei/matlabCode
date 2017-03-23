function plotAnatPowNormByControl4(expTaskType,expFileBaseMat,controlTaskType,controlFileBaseMat,fileNameFormat,fileExt,lowCut,highCut,chanMat,badchan,onePointBool,samescale,subtractBool)

if fileNameFormat == 0,
    if onePointBool
        expFileName = [expTaskType '_' expFileBaseMat(1,[1:7 10:12 14 17:19]) '-' expFileBaseMat(end,[7 10:12 14 17:19]) ...
            fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_point_AnatMazeRegionPow.mat'];
        controlFileName = [controlTaskType '_' controlFileBaseMat(1,[1:7 10:12 14 17:19]) '-' controlFileBaseMat(end,[7 10:12 14 17:19]) ...
            fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_point_AnatMazeRegionPow.mat'];
    else
        expFileName = [expTaskType '_' expFileBaseMat(1,[1:7 10:12 14 17:19]) '-' expFileBaseMat(end,[7 10:12 14 17:19]) ...
            fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_mean_AnatMazeRegionPow.mat'];
        controlFileName = [controlTtaskType '_' controlFileBaseMat(1,[1:7 10:12 14 17:19]) '-' controlFileBaseMat(end,[7 10:12 14 17:19]) ...
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
    fprintf('loading %s\n',expFileName)
    load(expFileName);
else
    ERROR_RUN_CalcAnatMazeRegionPow
end
expReturnarmPowMat = returnarmPowMat;
expCenterarmPowMat = centerarmPowMat;
expChoicearmPowMat = choicepointPowMat;
expChoicepointPowMat = choicearmPowMat;

if exist(controlFileName,'file')
    fprintf('loading %s\n',controlFileName)
    load(controlFileName);
else
    ERROR_RUN_CalcAnatMazeRegionPow
end
controlReturnarmPowMat = returnarmPowMat;
controlCenterarmPowMat = centerarmPowMat;
controlChoicearmPowMat = choicepointPowMat;
controlChoicepointPowMat = choicearmPowMat;

if subtractBool
    normMeanCenter = mean(expCenterarmPowMat,1) - mean(controlCenterarmPowMat,1);
    normMeanReward = mean(expChoicearmPowMat,1) - mean(controlChoicearmPowMat,1);
    normMeanCP = mean(expChoicepointPowMat,1) - mean(controlChoicepointPowMat,1);
    normMeanReturn = mean(expReturnarmPowMat,1) - mean(controlReturnarmPowMat,1);
else
    normMeanCenter = mean(expCenterarmPowMat,1) ./ mean(controlCenterarmPowMat,1);
    normMeanReward = mean(expChoicearmPowMat,1) ./ mean(controlChoicearmPowMat,1);
    normMeanCP = mean(expChoicepointPowMat,1) ./ mean(controlChoicepointPowMat,1);
    normMeanReturn = mean(expReturnarmPowMat,1) ./ mean(controlReturnarmPowMat,1);
end

if ~exist('samescale','var')
    samescale = 0;
end
if ~exist('badchan','var')
    badchan = 0;
end
if ~exist('dbscale','var')
    dbscale = 0;
end

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

centerAnatPowMat = zeros(size(chanMat))*NaN;
rewardAnatPowMat = zeros(size(chanMat))*NaN;
returnAnatPowMat = zeros(size(chanMat))*NaN;
choiceAnatPowmat = zeros(size(chanMat))*NaN;

[nChanY nChanX] = size(chanMat);
for x=1:nChanX
    for y=1:nChanY
        if isempty(find(badchan==chanMat(y,x))), % if the channel isn't bad

            if samescale,
                centermin = min([centermin normMeanCenter(chanMat(y,x))]);
                centermax = max([centermax normMeanCenter(chanMat(y,x))]);
                rewardmin = min([rewardmin normMeanReward(chanMat(y,x))]);
                rewardmax = max([rewardmax normMeanReward(chanMat(y,x))]);
                returnmin = min([returnmin normMeanReturn(chanMat(y,x))]);
                returnmax = max([returnmax normMeanReturn(chanMat(y,x))]);
                choicemin = min([choicemin normMeanCP(chanMat(y,x))]);
                choicemax = max([choicemax normMeanCP(chanMat(y,x))]);
            end
            centerAnatPowMat(y,x) = normMeanCenter(chanMat(y,x));
            rewardAnatPowMat(y,x) = normMeanReward(chanMat(y,x));
            returnAnatPowMat(y,x) = normMeanReturn(chanMat(y,x));
            choiceAnatPowmat(y,x) = normMeanCP(chanMat(y,x));
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

figure(1)
load('ColorMapSean3.mat')
    colormap(ColorMapSean3);
title(expFileBaseMat(1,1:6));
if subtractBool
    absmin = -3.5*10^5;
    absmax = 3.5*10^5;
else
    absmin = .43;
    absmax = 1.57;
end
%if isempty(find(badchan==chanMat(y,x))), % if the channel isn't bad
% now plot
subplot(2,2,1);
imagesc(returnAnatPowMat);
if samescale,
    set(gca,'clim',[absmin absmax]);
end
colorbar;
title('return');

subplot(2,2,2);
imagesc(centerAnatPowMat);
if samescale,
    set(gca,'clim',[absmin absmax]);
end
colorbar;
title('center');

subplot(2,2,3);
imagesc(choiceAnatPowmat);
if samescale,
    set(gca,'clim',[absmin absmax]);
end
colorbar;
title('choice');

subplot(2,2,4);
imagesc(rewardAnatPowMat);
if samescale,
    set(gca,'clim',[absmin absmax]);
end
colorbar;  
title('reward');
