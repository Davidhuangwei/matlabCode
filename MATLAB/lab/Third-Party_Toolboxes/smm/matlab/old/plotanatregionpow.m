function plotanatregionpow(possum,powsum,channels,badchan,samescale,dbscale,animal)


[m n nchannels] = size(powsum);
figure(3);
clf
imagesc(possum);
xmax = xlim;
ymax = ylim;
zoom on;
input('In the figure window, select the center arm.\n   Then click back in this window and hit ENTER...','s');
cax = xlim;
cay = ylim;
%fprintf('%d %d %d %d',cax(1),cax(2),cay(1),cay(2));
centerArmPos = zeros(size(possum));
centerArmPos(floor(cay(1)):ceil(cay(2)),floor(cax(1)):ceil(cax(2))) = possum(floor(cay(1)):ceil(cay(2)),floor(cax(1)):ceil(cax(2)));
centerArmPow = zeros(size(powsum));
centerArmPow(floor(cay(1)):ceil(cay(2)),floor(cax(1)):ceil(cax(2)),:) = powsum(floor(cay(1)):ceil(cay(2)),floor(cax(1)):ceil(cax(2)),:);

figure(3);
clf
imagesc(possum);
zoom on;
input('In the figure window, select the right choice arm.\n   Then click back in this window and hit ENTER...','s');
rcax = xlim;
rcay = ylim;
figure(3);
clf
imagesc(possum);
zoom on;
input('In the figure window, select the left choice arm.\n   Then click back in this window and hit ENTER...','s');
lcax = xlim;
lcay = ylim;
%fprintf('%d %d %d %d',rcax(1),rcax(2),rcay(1),rcay(2));
choiceArmPos = zeros(size(possum));
choiceArmPos(floor(rcay(1)):ceil(rcay(2)),floor(rcax(1)):ceil(rcax(2))) = possum(floor(rcay(1)):ceil(rcay(2)),floor(rcax(1)):ceil(rcax(2)));
choiceArmPos(floor(lcay(1)):ceil(lcay(2)),floor(lcax(1)):ceil(lcax(2))) = possum(floor(lcay(1)):ceil(lcay(2)),floor(lcax(1)):ceil(lcax(2)));
choiceArmPow = zeros(size(powsum));
choiceArmPow(floor(rcay(1)):ceil(rcay(2)),floor(rcax(1)):ceil(rcax(2)),:) = powsum(floor(rcay(1)):ceil(rcay(2)),floor(rcax(1)):ceil(rcax(2)),:);
choiceArmPow(floor(lcay(1)):ceil(lcay(2)),floor(lcax(1)):ceil(lcax(2)),:) = powsum(floor(lcay(1)):ceil(lcay(2)),floor(lcax(1)):ceil(lcax(2)),:);

figure(3);
clf
imagesc(possum);
zoom on;
input('In the figure window, select the right return arm.\n   Then click back in this window and hit ENTER...','s');
rrax = xlim;
rray = ylim;
figure(3);
clf
imagesc(possum);
zoom on;
input('In the figure window, select the left return arm.\n   Then click back in this window and hit ENTER...','s');
lrax = xlim;
lray = ylim;
%fprintf('%d %d %d %d',rrax(1),rrax(2),rray(1),rray(2));
returnArmPos = zeros(size(possum));
returnArmPos(floor(rray(1)):ceil(rray(2)),floor(rrax(1)):ceil(rrax(2))) = possum(floor(rray(1)):ceil(rray(2)),floor(rrax(1)):ceil(rrax(2)));
returnArmPos(floor(lray(1)):ceil(lray(2)),floor(lrax(1)):ceil(lrax(2))) = possum(floor(lray(1)):ceil(lray(2)),floor(lrax(1)):ceil(lrax(2)));
returnArmPow = zeros(size(powsum));
returnArmPow(floor(rray(1)):ceil(rray(2)),floor(rrax(1)):ceil(rrax(2)),:) = powsum(floor(rray(1)):ceil(rray(2)),floor(rrax(1)):ceil(rrax(2)),:);
returnArmPow(floor(lray(1)):ceil(lray(2)),floor(lrax(1)):ceil(lrax(2)),:) = powsum(floor(lray(1)):ceil(lray(2)),floor(lrax(1)):ceil(lrax(2)),:);

cpx = [lcax(2)+1 rcax(1)-1];
cpy = [ymax(1)+1 cay(1)-1];
choicePointPos = zeros(size(possum));
choicePointPos(floor(cpy(1)):ceil(cpy(2)),floor(cpx(1)):ceil(cpx(2))) = possum(floor(cpy(1)):ceil(cpy(2)),floor(cpx(1)):ceil(cpx(2)));
choicePointPow = zeros(size(powsum));
choicePointPow(floor(cpy(1)):ceil(cpy(2)),floor(cpx(1)):ceil(cpx(2)),:) = powsum(floor(cpy(1)):ceil(cpy(2)),floor(cpx(1)):ceil(cpx(2)),:);

figure(3);
clf
imagesc(possum);
hold on;
plot([cax(1) cax(1)],[cay(1) cay(2)],'color',[1 0 0]);
plot([cax(2) cax(2)],[cay(1) cay(2)],'color',[1 0 0]);
plot([cax(1) cax(2)],[cay(1) cay(1)],'color',[1 0 0]);
plot([cax(1) cax(2)],[cay(2) cay(2)],'color',[1 0 0]);

plot([rcax(1) rcax(1)],[rcay(1) rcay(2)],'color',[1 0 0]);
plot([rcax(2) rcax(2)],[rcay(1) rcay(2)],'color',[1 0 0]);
plot([rcax(1) rcax(2)],[rcay(1) rcay(1)],'color',[1 0 0]);
plot([rcax(1) rcax(2)],[rcay(2) rcay(2)],'color',[1 0 0]);

plot([lcax(1) lcax(1)],[lcay(1) lcay(2)],'color',[1 0 0]);
plot([lcax(2) lcax(2)],[lcay(1) lcay(2)],'color',[1 0 0]);
plot([lcax(1) lcax(2)],[lcay(1) lcay(1)],'color',[1 0 0]);
plot([lcax(1) lcax(2)],[lcay(2) lcay(2)],'color',[1 0 0]);

plot([rrax(1) rrax(1)],[rray(1) rray(2)],'color',[1 0 0]);
plot([rrax(2) rrax(2)],[rray(1) rray(2)],'color',[1 0 0]);
plot([rrax(1) rrax(2)],[rray(1) rray(1)],'color',[1 0 0]);
plot([rrax(1) rrax(2)],[rray(2) rray(2)],'color',[1 0 0]);

plot([lrax(1) lrax(1)],[lray(1) lray(2)],'color',[1 0 0]);
plot([lrax(2) lrax(2)],[lray(1) lray(2)],'color',[1 0 0]);
plot([lrax(1) lrax(2)],[lray(1) lray(1)],'color',[1 0 0]);
plot([lrax(1) lrax(2)],[lray(2) lray(2)],'color',[1 0 0]);

plot([cpx(1) cpx(1)],[cpy(1) cpy(2)],'color',[1 0 0]);
plot([cpx(2) cpx(2)],[cpy(1) cpy(2)],'color',[1 0 0]);
plot([cpx(1) cpx(2)],[cpy(1) cpy(1)],'color',[1 0 0]);
plot([cpx(1) cpx(2)],[cpy(2) cpy(2)],'color',[1 0 0]);

centerArmPos(find(centerArmPos==0)) = NaN;
choiceArmPos(find(choiceArmPos==0)) = NaN;
returnArmPos(find(returnArmPos==0)) = NaN;
choicePointPos(find(choicePointPos==0)) = NaN;



if ~exist('samescale','var')
    samescale = 0;
end
if ~exist('badchan','var')
    badchan = 0;
end
if ~exist('dbscale','var')
    dbscale = 0;
end
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
        
        centerArmNorm = centerArmPow(:,:,channels(i))./centerArmPos(:,:);
        flatCenterArmNorm = centerArmNorm(find(~isnan(centerArmNorm)));
        
        choiceArmNorm = choiceArmPow(:,:,channels(i))./choiceArmPos(:,:);   
        flatChoiceArmNorm = choiceArmNorm(find(~isnan(choiceArmNorm)));
        
        returnArmNorm = returnArmPow(:,:,channels(i))./returnArmPos(:,:);
        flatReturnArmNorm = returnArmNorm(find(~isnan(returnArmNorm)));
        
        choicePointNorm = choicePointPow(:,:,channels(i))./choicePointPos(:,:);
        flatChoicePointNorm = choicePointNorm(find(~isnan(choicePointNorm)));
        
        col = ceil(channels(i)/nrow);
        row = mod(channels(i)-1,nrow)+1;
        if dbscale,
            meanCenter = mean(flatCenterArmNorm);
            
            meanChoice = mean(flatChoiceArmNorm);
            
            meanReturn = mean(flatReturnArmNorm);
            
            meanCP = mean(flatChoicePointNorm);
                    
            avepowperchan(row,col) = 10*log10(mean([meanCenter meanChoice meanReturn meanCP]));
            centerAnatPowMat(row,col) = 10*log10(meanCenter);
            rewardAnatPowMat(row,col) = 10*log10(meanChoice);  
            returnAnatPowMat(row,col) = 10*log10(meanReturn);
            choiceAnatPowmat(row,col) = 10*log10(meanCP);
            
            avecenterAnatPowMat(row,col) = centerAnatPowMat(row,col) - avepowperchan(row,col);
            averewardAnatPowMat(row,col) = rewardAnatPowMat(row,col) - avepowperchan(row,col);
            avereturnAnatPowMat(row,col) =  returnAnatPowMat(row,col) - avepowperchan(row,col);
            avechoiceAnatPowmat(row,col) = choiceAnatPowmat(row,col) - avepowperchan(row,col);
        else
            meanCenter = mean(flatCenterArmNorm);
            centerAnatPowMat(row,col) = meanCenter;
            
            meanChoice = mean(flatChoiceArmNorm);
            rewardAnatPowMat(row,col) = meanChoice;
            
            meanReturn = mean(flatReturnArmNorm);
            returnAnatPowMat(row,col) = meanReturn;
            
            meanCP = mean(flatChoicePointNorm);
            choiceAnatPowmat(row,col) = meanCP;
            
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
%if isempty(find(badchan==channels(i))), % if the channel isn't bad
% now plot
subplot(2,2,1);
imagesc(centerAnatPowMat);
if samescale,
    set(gca,'clim',[centermin centermax]);
    set(gca,'clim',[absmin absmax]);
end
colorbar;
title('center');
subplot(2,2,2);
imagesc(rewardAnatPowMat);
if samescale,
    set(gca,'clim',[rewardmin rewardmax]);
    set(gca,'clim',[absmin absmax]);
end
colorbar;  
title('reward');
subplot(2,2,3);
imagesc(returnAnatPowMat);
if samescale,
    set(gca,'clim',[returnmin returnmax]);
    set(gca,'clim',[absmin absmax]);
end
colorbar;
title('return');
subplot(2,2,4);
imagesc(choiceAnatPowmat);
if samescale,
    set(gca,'clim',[choicemin choicemax]);
    set(gca,'clim',[absmin absmax]);
end
colorbar;
title('choice');

figure(2)
%if isempty(find(badchan==channels(i))), % if the channel isn't bad
% now plot
subplot(2,2,1);
imagesc(avecenterAnatPowMat);
if samescale,
    set(gca,'clim',[avecentermin avecentermax]);
    set(gca,'clim',[aveabsmin aveabsmax]);
end
colorbar;
title('center');
subplot(2,2,2);
imagesc(averewardAnatPowMat);
if samescale,
    set(gca,'clim',[averewardmin averewardmax]);
    set(gca,'clim',[aveabsmin aveabsmax]);
end
colorbar;  
title('reward');
subplot(2,2,3);
imagesc(avereturnAnatPowMat);
if samescale,
    set(gca,'clim',[avereturnmin avereturnmax]);
    set(gca,'clim',[aveabsmin aveabsmax]);
end
colorbar;
title('return');
subplot(2,2,4);
imagesc(avechoiceAnatPowmat);
if samescale,
    set(gca,'clim',[avechoicemin avechoicemax]);
    set(gca,'clim',[aveabsmin aveabsmax]);
end
colorbar;
title('choice');

