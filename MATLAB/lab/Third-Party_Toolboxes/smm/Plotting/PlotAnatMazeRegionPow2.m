function PlotAnatMazeRegionPow2(taskType,fileBaseMat,fileNameFormat,fileExt,chanMat,badchan,lowCut,highCut,onePointBool,samescale,dbscale)


if fileNameFormat == 0,
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
        fileName = [taskType '_' fileBaseMat(1,[1:10]) '-' fileBaseMat(end,[8:10]) ...
            fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_point_AnatMazeRegionPow.mat'];
    else
        fileName = [taskType '_' fileBaseMat(1,[1:10]) '-' fileBaseMat(end,[8:10]) ...
            fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_mean_AnatMazeRegionPow.mat'];
    end
end

if exist(fileName,'file')
    fprintf('loading %s',fileName)
    load(fileName);
else
    fileName
    ERROR_RUN_CalcAnatMazeRegionPow
end

meanReturn = mean(returnArmPowMat,1);
meanCenter = mean(centerArmPowMat,1);
meanCP = mean(TjunctionPowMat,1);
meanChoice = mean(goalArmPowMat,1);


if ~exist('samescale','var')
    samescale = 0;
end
if ~exist('badchan','var')
    badchan = 0;
end
if ~exist('dbscale','var')
    dbscale = 0;
end
if ~exist('onePointBool','var')
    onePointBool = 0;
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
        
        %col = ceil(channels(i)/nrow);
        %row = mod(channels(i)-1,nrow)+1;
        
        centerAnatPowMat(y,x) = meanCenter(chanMat(y,x));
        rewardAnatPowMat(y,x) = meanChoice(chanMat(y,x));
        returnAnatPowMat(y,x) = meanReturn(chanMat(y,x));
        choiceAnatPowmat(y,x) = meanCP(chanMat(y,x));

        avepowperchan(y,x) = mean([centerAnatPowMat(y,x) rewardAnatPowMat(y,x) returnAnatPowMat(y,x) choiceAnatPowmat(y,x)]);
        avecenterAnatPowMat(y,x) = centerAnatPowMat(y,x)./avepowperchan(y,x);
        averewardAnatPowMat(y,x) = rewardAnatPowMat(y,x)./avepowperchan(y,x);
        avereturnAnatPowMat(y,x) =  returnAnatPowMat(y,x)./avepowperchan(y,x);
        avechoiceAnatPowmat(y,x) = choiceAnatPowmat(y,x)./avepowperchan(y,x);

        if dbscale
            centerAnatPowMat(y,x) = 10*log10(centerAnatPowMat(y,x));
            rewardAnatPowMat(y,x) = 10*log10(rewardAnatPowMat(y,x));
            returnAnatPowMat(y,x) = 10*log10(returnAnatPowMat(y,x));
            choiceAnatPowmat(y,x) = 10*log10(choiceAnatPowmat(y,x));
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


if fileBaseMat(1,1:6) == 'sm9601'
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

avecentermin;
avecentermax;

    
figure(1)
load('ColorMapSean3.mat')
    colormap(ColorMapSean3);
title(fileBaseMat(1,1:6));
%absmin = 48;
%absmax = 64;
%if isempty(find(badchan==chanMat(y,x))), % if the channel isn't bad
% now plot
subplot(2,2,1);
imagesc(centerAnatPowMat);
if samescale,
    set(gca,'clim',[absmin absmax]);
end
%shading('interp')
colorbar;
title('center');
subplot(2,2,2);
imagesc(choiceAnatPowmat);
if samescale,
    set(gca,'clim',[absmin absmax]);
end
colorbar;
title('choice');
subplot(2,2,3);
imagesc(rewardAnatPowMat);
if samescale,
    set(gca,'clim',[absmin absmax]);
end
colorbar;  
title('reward');
subplot(2,2,4);
imagesc(returnAnatPowMat);
if samescale,
    set(gca,'clim',[absmin absmax]);
end
colorbar;
title('return');

figure(2)
load('ColorMapSean3.mat')
    colormap(ColorMapSean3);

if 0
    avecenterAnatPowMat(16) = avecenterAnatPowMat(15);
    avecenterAnatPowMat(81) = avecenterAnatPowMat(82);
    bscnoe =  [21 23 25 27 29 31 55 69 71 73 86 93]; % bad single channels not on end of shank
    for i=1:length(bscnoe)
        avecenterAnatPowMat(bscnoe(i)) = (avecenterAnatPowMat(bscnoe(i)-1) + avecenterAnatPowMat(bscnoe(i)+1))/2;
    end
    tempchan = (avecenterAnatPowMat(74) + avecenterAnatPowMat(77))/2;
    avecenterAnatPowMat(75) = (tempchan + avecenterAnatPowMat(74))/2;
    avecenterAnatPowMat(76) = (tempchan + avecenterAnatPowMat(77))/2;
    
    avechoiceAnatPowmat(16) = avechoiceAnatPowmat(15);
    avechoiceAnatPowmat(81) = avechoiceAnatPowmat(82);
    bscnoe =  [21 23 25 27 29 31 55 69 71 73 86 93]; % bad single channels not on end of shank
    for i=1:length(bscnoe)
        avechoiceAnatPowmat(bscnoe(i)) = (avechoiceAnatPowmat(bscnoe(i)-1) + avechoiceAnatPowmat(bscnoe(i)+1))/2;
    end
    tempchan = (avechoiceAnatPowmat(74) + avechoiceAnatPowmat(77))/2;
    avechoiceAnatPowmat(75) = (tempchan + avechoiceAnatPowmat(74))/2;
    avechoiceAnatPowmat(76) = (tempchan + avechoiceAnatPowmat(77))/2;

end

title(fileBaseMat(1,1:6));
aveabsmin = 0.43;
aveabsmax = 1.7;
%if isempty(find(badchan==channels(i))), % if the channel isn't bad
% now plot
subplot(2,2,1);
imagesc(avecenterAnatPowMat);
if samescale,
    set(gca,'clim',[aveabsmin aveabsmax]);
end
%shading('interp')
colorbar;
title('center');
subplot(2,2,2);
imagesc(avechoiceAnatPowmat);
if samescale,
    set(gca,'clim',[aveabsmin aveabsmax]);
end
%shading('interp')
colorbar;
title('choice');
subplot(2,2,3);
imagesc(averewardAnatPowMat);
if samescale,
    set(gca,'clim',[aveabsmin aveabsmax]);
end
colorbar;  
title('reward');
subplot(2,2,4);
imagesc(avereturnAnatPowMat);
if samescale,
    set(gca,'clim',[aveabsmin aveabsmax]);
end
colorbar;
title('return');
