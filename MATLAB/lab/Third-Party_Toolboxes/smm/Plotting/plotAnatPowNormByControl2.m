function plotAnatPowNormByControl2(alterReturnarmPowMat,alterCenterarmPowMat,alterChoicepointPowMat,alterChoicearmPowMat,forceReturnarmPowMat,forceCenterarmPowMat,forceChoicepointPowMat,forceChoicearmPowMat,badchan,samescale,dbscale,animal)

meanCenter = mean(alterCenterarmPowMat,1)./mean(forceCenterarmPowMat,1);   
meanChoice = mean(alterChoicearmPowMat,1)./mean(forceChoicearmPowMat,1);
meanCP = mean(alterChoicepointPowMat,1)./mean(forceChoicepointPowMat,1);
meanReturn = mean(alterReturnarmPowMat,1)./mean(forceReturnarmPowMat,1);

if ~exist('samescale','var')
    samescale = 0;
end
if ~exist('badchan','var')
    badchan = 0;
end
if ~exist('dbscale','var')
    dbscale = 0;
end
channels =1:96;
if animal == 1
    ncol = 5;
    nrow = 16;
else
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
        
        if dbscale,    
            avepowperchan(row,col) = 10*log10(mean([meanCenter(channels(i)) meanChoice(channels(i)) meanReturn(channels(i)) meanCP(channels(i))]));
            centerAnatPowMat(row,col) = 10*log10(meanCenter(channels(i)));
            rewardAnatPowMat(row,col) = 10*log10(meanChoice(channels(i)));  
            returnAnatPowMat(row,col) = 10*log10(meanReturn(channels(i)));
            choiceAnatPowmat(row,col) = 10*log10(meanCP(channels(i)));
            
            avecenterAnatPowMat(row,col) = centerAnatPowMat(row,col) - avepowperchan(row,col);
            averewardAnatPowMat(row,col) = rewardAnatPowMat(row,col) - avepowperchan(row,col);
            avereturnAnatPowMat(row,col) =  returnAnatPowMat(row,col) - avepowperchan(row,col);
            avechoiceAnatPowmat(row,col) = choiceAnatPowmat(row,col) - avepowperchan(row,col);
        else
            centerAnatPowMat(row,col) = meanCenter(channels(i));
            rewardAnatPowMat(row,col) = meanChoice(channels(i));
            returnAnatPowMat(row,col) = meanReturn(channels(i));
            choiceAnatPowmat(row,col) = meanCP(channels(i));
            
            avepowperchan(row,col) = mean([centerAnatPowMat(row,col) rewardAnatPowMat(row,col) returnAnatPowMat(row,col) choiceAnatPowmat(row,col)]);
            avecenterAnatPowMat(row,col) = centerAnatPowMat(row,col) - avepowperchan(row,col);
            averewardAnatPowMat(row,col) = rewardAnatPowMat(row,col) - avepowperchan(row,col);
            avereturnAnatPowMat(row,col) =  returnAnatPowMat(row,col) - avepowperchan(row,col);
            avechoiceAnatPowmat(row,col) = choiceAnatPowmat(row,col) - avepowperchan(row,col);
          
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


if animal == 1
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
title(animal);
%absmin = 48;
%absmax = 64;
%if isempty(find(badchan==channels(i))), % if the channel isn't bad
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
title(animal);
%aveabsmin = -2.5;
%aveabsmax = 2.5
%if isempty(find(badchan==channels(i))), % if the channel isn't bad
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
