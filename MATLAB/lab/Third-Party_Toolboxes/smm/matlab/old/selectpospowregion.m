function selectpospowregion(possum,powsum,channel)
figure(2);
clf;
[m n nchannels] = size(powsum);
figure(1);
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

figure(1);
clf
imagesc(possum);
zoom on;
input('In the figure window, select the right choice arm.\n   Then click back in this window and hit ENTER...','s');
rcax = xlim;
rcay = ylim;
figure(1);
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

figure(1);
clf
imagesc(possum);
zoom on;
input('In the figure window, select the right return arm.\n   Then click back in this window and hit ENTER...','s');
rrax = xlim;
rray = ylim;
figure(1);
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

figure(1);
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

chan=input('which channel? ');
while (chan ~= -1),
    figure(2);
    clf;
    hold on;
    
    
    centerArmNorm = centerArmPow(:,:,chan)./centerArmPos(:,:);
    flatCenterArmNorm = centerArmNorm(find(~isnan(centerArmNorm)));
    meanCenter = mean(10*log10(flatCenterArmNorm));
    stdCenter = std(10*log10(flatCenterArmNorm));
    bar(1,meanCenter);
    plot([1 1],[meanCenter-stdCenter meanCenter+stdCenter],'color',[1 0 0]);
    
    
    choiceArmNorm = choiceArmPow(:,:,chan)./choiceArmPos(:,:);   
    flatChoiceArmNorm = choiceArmNorm(find(~isnan(choiceArmNorm)));
    meanChoice = mean(10*log10(flatChoiceArmNorm));
    stdChoice = std(10*log10(flatChoiceArmNorm));
    bar(2,meanChoice);
    plot([2 2],[meanChoice-stdChoice meanChoice+stdChoice],'color',[1 0 0]);
    
    
    returnArmNorm = returnArmPow(:,:,chan)./returnArmPos(:,:);
    flatReturnArmNorm = returnArmNorm(find(~isnan(returnArmNorm)));
    meanReturn = mean(10*log10(flatReturnArmNorm));
    stdReturn = std(10*log10(flatReturnArmNorm));
    bar(3,meanReturn);
    plot([3 3],[meanReturn-stdReturn meanReturn+stdReturn],'color',[1 0 0]);
    
    
    choicePointNorm = choicePointPow(:,:,chan)./choicePointPos(:,:);
    flatChoicePointNorm = choicePointNorm(find(~isnan(choicePointNorm)));
    meanCP = mean(10*log10(flatChoicePointNorm));
    stdCP = std(10*log10(flatChoicePointNorm));
    bar(4,meanCP);
    plot([4 4],[meanCP-stdCP meanCP+stdCP],'color',[1 0 0]);
    
    set(gca, 'xtick', [1 2 3 4], 'xticklabel', ['center'; 'reward'; 'return'; 'choice']);
    set(gca, 'ylim', [min([meanCP-stdCP meanReturn-stdReturn meanChoice-stdChoice meanCenter-stdCenter])-1 max([meanCP+stdCP meanReturn+stdReturn meanChoice+stdChoice meanCenter+stdCenter])+1]);
    
    chan=input('which channel? ');
end
return