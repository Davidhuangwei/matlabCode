function PlotAnatMazeRegionPow(taskType,fileBaseMat,fileExt,badchan,lowCut,highCut,fileNameFormat,onePointBool,samescale,dbscale)


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
    ERROR_RUN_CalcAnatMazeRegionPow
end

meanReturn = mean(returnarmPowMat,1);
meanCenter = mean(centerarmPowMat,1);
meanCP = mean(choicepointPowMat,1);
meanChoice = mean(choicearmPowMat,1);


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

channels =1:96;
if fileBaseMat(1,1:6) == 'sm9601'
    ncol = 5;
    nrow = 16;
end
if fileBaseMat(1,1:6) == 'sm9603' | fileBaseMat(1,1:6) == 'sm9608'
    ncol = 6;
    nrow = 16;
end

centerAnatPowMat = zeros(nrow,ncol)*NaN;
rewardAnatPowMat = zeros(nrow,ncol)*NaN;
returnAnatPowMat = zeros(nrow,ncol)*NaN;
choiceAnatPowmat = zeros(nrow,ncol)*NaN;

avepowperchan =  zeros(nrow,ncol)*NaN;

avecenterAnatPowMat = zeros(nrow,ncol)*NaN;
averewardAnatPowMat = zeros(nrow,ncol)*NaN;
avereturnAnatPowMat = zeros(nrow,ncol)*NaN;
avechoiceAnatPowmat = zeros(nrow,ncol)*NaN;

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

for i=1:length(channels)
    if isempty(find(badchan==channels(i))), % if the channel isn't bad
        
        col = ceil(channels(i)/nrow);
        row = mod(channels(i)-1,nrow)+1;
        
        centerAnatPowMat(row,col) = meanCenter(channels(i));
        rewardAnatPowMat(row,col) = meanChoice(channels(i));
        returnAnatPowMat(row,col) = meanReturn(channels(i));
        choiceAnatPowmat(row,col) = meanCP(channels(i));

        avepowperchan(row,col) = mean([centerAnatPowMat(row,col) rewardAnatPowMat(row,col) returnAnatPowMat(row,col) choiceAnatPowmat(row,col)]);
        avecenterAnatPowMat(row,col) = centerAnatPowMat(row,col)./avepowperchan(row,col);
        averewardAnatPowMat(row,col) = rewardAnatPowMat(row,col)./avepowperchan(row,col);
        avereturnAnatPowMat(row,col) =  returnAnatPowMat(row,col)./avepowperchan(row,col);
        avechoiceAnatPowmat(row,col) = choiceAnatPowmat(row,col)./avepowperchan(row,col);

        if dbscale
            centerAnatPowMat(row,col) = 10*log10(centerAnatPowMat(row,col));
            rewardAnatPowMat(row,col) = 10*log10(rewardAnatPowMat(row,col));
            returnAnatPowMat(row,col) = 10*log10(returnAnatPowMat(row,col));
            choiceAnatPowmat(row,col) = 10*log10(choiceAnatPowmat(row,col));
        end
        
        if samescale,
            centermin = min([centermin centerAnatPowMat(row,col)]);
            centermax = max([centermax centerAnatPowMat(row,col)]);
            rewardmin = min([rewardmin rewardAnatPowMat(row,col)]);
            rewardmax = max([rewardmax rewardAnatPowMat(row,col)]);
            returnmin = min([returnmin returnAnatPowMat(row,col)]);
            returnmax = max([returnmax returnAnatPowMat(row,col)]);
            choicemin = min([choicemin choiceAnatPowmat(row,col)]);
            choicemax = max([choicemax choiceAnatPowmat(row,col)]);
            
            avecentermin = min([avecentermin avecenterAnatPowMat(row,col)]);
            avecentermax = max([avecentermax avecenterAnatPowMat(row,col)]);
            averewardmin = min([averewardmin averewardAnatPowMat(row,col)]);
            averewardmax = max([averewardmax averewardAnatPowMat(row,col)]);
            avereturnmin = min([avereturnmin avereturnAnatPowMat(row,col)]);
            avereturnmax = max([avereturnmax avereturnAnatPowMat(row,col)]);
            avechoicemin = min([avechoicemin avechoiceAnatPowmat(row,col)]);
            avechoicemax = max([avechoicemax avechoiceAnatPowmat(row,col)]);
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
%if isempty(find(badchan==channels(i))), % if the channel isn't bad
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
%aveabsmax = 1.6;
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
