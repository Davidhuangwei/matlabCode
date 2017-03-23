

figTitle = 'NotesOnCSD2';

processedDir = '../processed/';

if ~exist('aveSeg','var')
    mazeRegionsBool = [0 0 0 1 1 0 0 1 1];

    animal = 'sm9603';
    trigChan = 39;
    nChan = 97;
    nShanks = 6;
    chansPerShank = 16;
    
    eegSamp = 1250;
    whlSamp = 39.065;

    %cd /BEEF2/smm/sm9603_Analysis/analysis03
    %addpath /u12/smm/matlab/MazeBehavior
    load AlterFiles
    segs = [];
    for k=1:size(alterFiles,1)
        fileBase = alterFiles(k,:);
        whl = LoadMazeTrialTypes([fileBase '/' fileBase],[],mazeRegionsBool);
        fprintf('Reading: %s\n',fileBase);
        eegTrigChan = readmulti([fileBase '/' fileBase '.eeg'],nChan,trigChan);
        points = diff(whl(:,1)~=-1);
        begining = find(points==1);
        ending = find(points==-1);

        eegBegin = round(begining*eegSamp/whlSamp);
        eegEnd = round(ending*eegSamp/whlSamp);

        firfiltb = fir1(ceil(eegSamp/2),[6/eegSamp*2,30/eegSamp*2]);
        filtTrigChan = Filter0(firfiltb, eegTrigChan');

        minsTrigChan = LocalMinima(filtTrigChan,eegSamp/15,0);
        set(gca,'xlim',[eegBegin(1) eegEnd(1)])
        segs = [];


        interv = round(0.3*eegSamp);
        for j=1:length(eegBegin)
            goodPoints = find(minsTrigChan>eegBegin(j));
            begining = goodPoints(1);
            goodPoints = find(minsTrigChan<eegEnd(j));
            ending = goodPoints(end);
            for i=begining:ending
                eegSeg = bload([fileBase '/' fileBase '.eeg'],[nChan interv],round(minsTrigChan(i)-interv/2)*nChan*2,'int16');
                filtSeg = Filter0(firfiltb, eegSeg');

                segs = cat(3,segs,filtSeg');
                %segs = [segs eeg39(i-.2*eegSamp:i+.2*eegSamp)];
            end
        end
    end
    %plot(whl(:,1)~=-1,'.')

    %plot(eegTrigChan(begining(1):ending(1)));

    %plot(filtTrigChan(eegBegin(:):eegEnd(:)));
    figure(3)
    clf
    set(gca,'xlim',[eegBegin(1) eegEnd(1)])
    hold on

    plot([eegBegin(1):eegEnd(1)],eegTrigChan(eegBegin(1):eegEnd(1)))
    plot(minsTrigChan,ones(length(minsTrigChan)),'.')

    figure(4)
    clf
    %plot(segs(trigChan,:,1))

    aveSeg = mean(segs,3);
    stdSeg = squeeze(std(permute(segs,[3 1 2])));

    for j=0:1:nShanks-1
        plotChans = j*chansPerShank+1:(j+1)*chansPerShank;
        subplot(1,nShanks,j+1)
        for i=1:length(plotChans)

            %subplot(length(plotChans),1,i)
            hold on
            plot(aveSeg(plotChans(i),:)-i*4000)
            plot(aveSeg(plotChans(i),:)+stdSeg(plotChans(i),:)-i*4000,'--r')
            plot(aveSeg(plotChans(i),:)-stdSeg(plotChans(i),:)-i*4000,'--r')
        end
    end
end
%        outputMat(:,x) = interp1(find(~isnan(outputMat(:,x))),outputMat(find(~isnan(outputMat(:,x))),x),[1:nChanY],interpFunc)';

figure(1)
clf
figure(2)
clf
for j=0:1:nShanks-1
    channels = j*chansPerShank+1:(j+1)*chansPerShank;
    if ~exist('badchan','var')
        badchan = load([animal 'EEGBadChan.txt']);
    end
    goodChan = [];
    for i=1:length(channels)
        if isempty(find(channels(i)==badchan))
            goodChan = [goodChan channels(i)];
        end
    end

    figure(1)
    set(gcf,'name',figTitle)
    subplot(1,nShanks,j+1)
    shankcsd = diff(aveSeg(channels,:),2);
    
    %imagesc(shankcsd)
    pcolor(flipud(shankcsd))
    shading interp
    hold on

    hold on
    normVal = 2000;
    for i=1:length(channels)
        plot(aveSeg(channels(i),:)./normVal+length(channels)-i)
    end
    set(gca,'xtick',[0:93.75:375])
    set(gca,'xticklabel',[0:93.75:375]/1.250-187.5/1.250)
    set(gca,'clim',[-1000 1000]);
    if j==0
        xLimits = get(gca,'xlim');
        yLimits = get(gca,'ylim');
        text(xLimits(1)-diff(xLimits)*1.3,yLimits(2)-diff(yLimits)/2,{['mazeRegions='],mat2str(mazeRegionsBool)});
    end
    colorbar

    hold off

    %interpSeg = zeros(length(channels),size(aveSeg,2));
    for i=1:size(aveSeg,2)
        interpSeg(:,i) = interp1(goodChan'-channels(1)+1,aveSeg(goodChan',i),1:length(channels),'linear','extrap')';
    end
    figure(2)
    set(gcf,'name',figTitle)
    subplot(1,nShanks,j+1)

    shankcsd = diff(interpSeg(1:chansPerShank,:),2);
    csdChan = channels(2:end-1);
    goodCsdChan = [];
    for i=1:length(csdChan)
        if ~isempty(find(csdChan(i)==goodChan))
            goodCsdChan = [goodCsdChan csdChan(i)];
        end
    end
    for i=1:size(shankcsd,2)
        interpShankCsd(:,i) = interp1(goodCsdChan'-csdChan(1)+1,shankcsd(goodCsdChan-csdChan(1)+1,i),1:length(csdChan),'linear','extrap')';
    end
    
    %imagesc(interpShankCsd)
    pcolor(flipud(interpShankCsd))
    shading interp
    hold on

    normVal = 2000;
    for i=1:length(channels)
        %plot(interpSeg(i,:)./normVal+length(channels)-i)
    end

    set(gca,'xtick',[0:93.75:375])
    set(gca,'xticklabel',[0:93.75:375]/1.250-187.5/1.250)
    set(gca,'FontSize',12)
    set(gca,'clim',[-1000 1000]);
    if j==0
        xLimits = get(gca,'xlim');
        yLimits = get(gca,'ylim');
        text(xLimits(1)-diff(xLimits)*1.3,yLimits(2)-diff(yLimits)/2,{['mazeRegions='],mat2str(mazeRegionsBool)});
    end
    colorbar

    hold off

end
return

for j=0:1:nShanks-1
    channels = j*chansPerShank+1:(j+1)*chansPerShank;
    goodChan = [];
    for i=1:length(channels)
        if isempty(find(channels(i)==badchan))
            goodChan = [goodChan channels(i)];
        end
    end
    for i=1:size(aveSeg,2)
        oldInterp(j+1,:,i) = interp1(goodChan'-channels(1)+1,aveSeg(goodChan',i),1:length(channels),'linear');
    end
end


oldChans = [];
for i=1:size(aveSeg,2)
    oldChans(:,:,i) = Make2DPlotMat(aveSeg(:,i),MakeChanMat(6,16));
    [interpChans(:,:,i) distWeights(:,:,i)] = FunkyInterp(oldChans(:,:,i),badchan,100);
end
oldChans = permute(oldChans,[2,1,3]);

figure(5)
clf
for i=1:6
    subplot(1,6,i)
    hold on
    for j=1:16
        plot(squeeze(oldInterp(i,j,:))-j*4000,'g')
        plot(squeeze(oldChans(i,j,:))-j*4000,'k')
        plot(squeeze(interpChans(i,j,:))-j*4000,'r')
    end
end

csdMat = [];
for i=1:size(aveSeg,2)
    if 0
        csdMat(:,:,i) = Csd2D(interpChans(:,:,i),distWeights(:,:,i),3);
    else
        for j=1:6
            csdMat(j,:,i) = diff(interpChans(j,:,i),2);
        end
    end
end
csdBadChan = badchan(mod(badchan,16)~=0 & mod(badchan+15,16)~=0);
csdBadChan = csdBadChan-floor(csdBadChan/16)-ceil(csdBadChan/16);
for i=1:size(aveSeg,2)
    [csdMat(:,:,i) junk] = FunkyInterp(csdMat(:,:,i)',csdBadChan,100);
end
    
figure(6)
clf
for j=0:1:nShanks-1
    subplot(1,nShanks,j+1)
    pcolor(flipud(squeeze(csdMat(j+1,:,:))))
    shading interp
    hold on

    normVal = 2000;
    %for i=1:length(channels)
     %   plot(csdMat(i,:)./normVal+length(channels)-i)
    %end

    set(gca,'xtick',[0:93.75:375])
    set(gca,'xticklabel',[0:93.75:375]/1.250-187.5/1.250)
    set(gca,'FontSize',12)
    set(gca,'clim',[-1000 1000]);
    if j==0
        xLimits = get(gca,'xlim');
        yLimits = get(gca,'ylim');
        text(xLimits(1)-diff(xLimits)*1.3,yLimits(2)-diff(yLimits)/2,{['mazeRegions='],mat2str(mazeRegionsBool)});
    end
    colorbar

    hold off
end










goodChans = [];
for i=1:96
    if isempty(find(i==badchan))
        goodChans = [goodChans i];
    end
end
   
allChanInterpSeg = [];
for j=0:1:5
    channels = j*16+1:(j+1)*16;
    if ~exist('badchan','var')
        badchan = load('sm9603EEGBadChan.txt');
    end
    goodChan = [];
    for i=1:length(channels)
        if isempty(find(channels(i)==badchan))
            goodChan = [goodChan channels(i)];
        end
    end
    for i=1:size(aveSeg,2)
        interpSeg(:,i) = interp1(goodChan'-channels(1)+1,aveSeg(goodChan',i),1:length(channels),'linear','extrap')';
    end
    allChanInterpSeg = cat(3,allChanInterpSeg, interpSeg);
end
allChanInterpSeg = permute(allChanInterpSeg,[1 3 2]);

for i=1:size(aveSeg,2)
    for j=1:size(allChanInterpSeg,1)
        interpSeg2(j,:,i) = interp1(1:3:16,allChanInterpSeg(j,:,i),1:16,'linear');
    end
end


return

csd2D = diff(diff(interpSeg2,2,2),2,1);
%csd2D = -diff(interpSeg2,2,1);

figure(5)
clf
for j=1:14
    set(gcf,'name',figTitle)
    subplot(1,14,j,'align')

    shankCsd = squeeze(csd2D(:,j,:));
    %shankCsd = squeeze(interpSeg2(:,j,:));
    %shankCsd = squeeze(allChanInterpSeg(:,j,:));
    %imagesc(interpShankCsd)
    pcolor(flipud(shankCsd))
    shading interp
    hold on

    normVal = 2000;
    for i=1:length(channels)
        plot(interpSeg(i,:)./normVal+length(channels)-i)
    end

    set(gca,'xtick',[0:93.75:375])
    set(gca,'xticklabel',[0:93.75:375]/1.250-187.5/1.250)
    set(gca,'FontSize',12)
    %set(gca,'clim',[-1000 1000]);
    set(gca,'clim',[-500 500])
    if j==0
        xLimits = get(gca,'xlim');
        yLimits = get(gca,'ylim');
        text(xLimits(1)-diff(xLimits)*1.3,yLimits(2)-diff(yLimits)/2,{['mazeRegions='],mat2str(mazeRegionsBool)});
    end
    colorbar

    hold off

end

if 0
    clf
    pcolor(shank3csd)
    shading interp
    figure
    plot(shank3csd(7,:))
    plot(aveSeg(39,:))
    segs = [];
end
