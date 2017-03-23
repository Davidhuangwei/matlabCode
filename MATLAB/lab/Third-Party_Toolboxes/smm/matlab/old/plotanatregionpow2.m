function workinprog(filebasemat,fileext,nchannels,channels,badchan,lowband,highband,samescale,dbscale,animal)

if ~exist('trialtypesbool')
    trialtypesbool = [1  0  1  0  0   0   0   0   0   0   0   0  0];
                    %cr ir cl il crp irp clp ilp crb irb clb ilb xp
end
if ~exist('mazelocationsbool')
    mazelocationsbool = [0  0  0  1  1  1   1   1   1];
                       %rp lp dp cp ca rca lca rra lra
end
% [1 0 1 0 0 0 0 0 0 0 0 0 0]
% [0 0 0 1 1 1 1 1 1]

[numfiles n] = size(filebasemat);
ntrials=0;

returnarmPowMat = [];
centerarmPowMat = [];
choicepointPowMat = [];
choicearmPowMat = [];

for i=1:numfiles
    
    dspowname = [filebasemat(i,:) '_' num2str(lowband) '-' num2str(highband) 'Hz' fileext '.100DBdspow'];
    powerdat = 10.^((bload(dspowname,[nchannels inf],0,'int16')')/1000);
    [dspm n] = size(powerdat);
    
    correcttrials = loadmazetrialtypes(filebasemat(i,:),[1 0 1 0 0 0 0 0 0 0 0 0 0],[0 0 0 1 1 1 1 1 1]);
    [whlm n] = size(correcttrials);
    if whlm~=dspm
        FILES_NOT_SAME_SIZE
    end
    
    atports = loadmazetrialtypes(filebasemat(i,:),[1 0 1 0 0 0 0 0 0 0 0 0 0],[1 1 0 0 0 0 0 0 0]);
    
    choicepoint = loadmazetrialtypes(filebasemat(i,:),[1 0 1 0 0 0 0 0 0 0 0 0 0],[0 0 0 1 0 0 0 0 0]);
    centerarm   = loadmazetrialtypes(filebasemat(i,:),[1 0 1 0 0 0 0 0 0 0 0 0 0],[0 0 0 0 1 0 0 0 0]);
    choicearm   = loadmazetrialtypes(filebasemat(i,:),[1 0 1 0 0 0 0 0 0 0 0 0 0],[0 0 0 0 0 1 1 0 0]);
    returnarm   = loadmazetrialtypes(filebasemat(i,:),[1 0 1 0 0 0 0 0 0 0 0 0 0],[0 0 0 0 0 0 0 1 1]);
    
    %plot(correcttrials(:,1),correcttrials(:,2))
    trialbegin = find(correcttrials(:,1)~=-1);
    while ~isempty(trialbegin),
        trialend = trialbegin(1) + find(atports((trialbegin(1)+1):end,1)~=-1);
        if isempty(trialend),
            breaking = 1
            break;
        end
        
        trialreturnarm = trialbegin(1)-1+find(returnarm(trialbegin(1):(trialend(1)-1),1)~=-1);
        trialcenterarm = trialbegin(1)-1+find(centerarm(trialbegin(1):(trialend(1)-1),1)~=-1);
        trialchoicepoint = trialbegin(1)-1+find(choicepoint(trialbegin(1):(trialend(1)-1),1)~=-1);
        trialchoicearm = trialbegin(1)-1+find(choicearm(trialbegin(1):(trialend(1)-1),1)~=-1);
        
        trialbegin = trialend(1)-1+find(correcttrials(trialend(1):end,1)~=-1);
        
        %clf
        %figure(3)
        %hold on
        %plot(returnarm(trialreturnarm,1),returnarm(trialreturnarm,2),'.','color',[0 0 1],'markersize',7);
        %plot(centerarm(trialcenterarm,1),centerarm(trialcenterarm,2),'.','color',[1 0 0],'markersize',7);
        %plot(choicepoint(trialchoicepoint,1),choicepoint(trialchoicepoint,2),'.','color',[0 0 0],'markersize',7);
        %plot(choicearm(trialchoicearm,1),choicearm(trialchoicearm,2),'.','color',[0 1 1],'markersize',7);
        %set(gca,'xlim',[0 368],'ylim',[0 240]);    
        
        returnarmPowMat = [returnarmPowMat; mean(powerdat(trialreturnarm,:),1)];
        centerarmPowMat = [centerarmPowMat; mean(powerdat(trialcenterarm,:),1)];
        choicepointPowMat = [choicepointPowMat; mean(powerdat(trialchoicepoint,:),1)];
        choicearmPowMat = [choicearmPowMat; mean(powerdat(trialchoicearm,:),1)];
        ntrials = ntrials + 1;
        fprintf('n=%d : ',ntrials);
        %input('next?');

        
    end
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
