function CalcSpatialComodulation6(taskType,fileBaseMat,fileExt,nchannels,channels,winLength,nOverlap,NW,thetaFreq,gammaFreq,binSize,gridYoffset,trialTypesBool)

whlFs = 39.065;
spectDir = 'spectrograms/';
videoRes = [368,240];
if ~exist('gridYoffset') | isempty(gridYoffset);
    gridYoffset = 0;
end
if ~exist('trialTypesBool','var') | isempty(trialTypesBool)
    trialTypesBool = [1 0 1 0 0 0 0 0 0 0 0 0 0];
end
if ~exist('stdev','var') | isempty(stdev)
    stdev = 3;
end


figure(1)
clf
set(gcf,'name','CalcSpatialComodulation')
hold on;
%plotBool = 1;

for i=1:size(fileBaseMat,1)
    whldat = LoadMazeTrialTypes(fileBaseMat(i,:),trialTypesBool);
    notMinusOnes = whldat(:,1)~=-1;    

    plot(whldat(notMinusOnes,1),whldat(notMinusOnes,2),'.','color',[0.5 0.5 0.5]);
    for m=1:binSize:videoRes(1)
        plot([m,m],[0,videoRes(2)])
    end
    for n=gridYoffset:binSize:videoRes(2)
        plot([videoRes(1),0],[n,n])
    end
end

if 0
    in = [];
    while ~strcmp(in,'n') & ~strcmp(in,'y') & ~strcmp(in,'')
        in = input('\nIs this grid good? [y]/n: ','s');
        if strcmp(in,'n')
            return
        end
    end
end

spatialComodData = cell(ceil(videoRes(1)/binSize),ceil(videoRes(2)/binSize));
nPoints = ones(ceil(videoRes(1)/binSize),ceil(videoRes(2)/binSize));
whlTimes = cell(ceil(videoRes(1)/binSize),ceil(videoRes(2)/binSize));
fileNames = cell(ceil(videoRes(1)/binSize),ceil(videoRes(2)/binSize));
spectTimes = cell(ceil(videoRes(1)/binSize),ceil(videoRes(2)/binSize));

for i=1:size(fileBaseMat,1)
    whldat = LoadMazeTrialTypes(fileBaseMat(i,:),trialTypesBool);
    binnedWhlDat = whldat(:,1:2); % bin the spatial information and offset to make bins fit nicely
    binnedWhlDat(whldat(:,1)~=-1,1:2) = [ceil(whldat(whldat(:,1)~=-1,1)./binSize) ceil((whldat(whldat(:,1)~=-1,2)+gridYoffset)./binSize)];
    
    wholeMaze = LoadMazeTrialTypes(fileBaseMat(i,:),trialTypesBool,[1 1 1 1 1 1 1 1 1]);
     
    inName = [spectDir fileBaseMat(i,:) fileExt 'Win' num2str(winLength) 'Ovrlp' num2str(nOverlap) 'NW' num2str(NW) '_mtpsg_' num2str(channels(1)) '.mat'];
    fprintf('\nLoading: %s', inName);
    spect = load(inName);
    to = spect.to;
    toIndexes = cell(ceil(videoRes(1)/binSize),ceil(videoRes(2)/binSize));

    trialEdges = GetTrialEdges(fileBaseMat(i,:),trialTypesBool);
    for j=1:size(trialEdges,1)
        for m=1:ceil(videoRes(1)/binSize)
            for n=1:ceil(videoRes(2)/binSize)
                indexes = trialEdges(j,1)-1+find(binnedWhlDat(trialEdges(j,1):trialEdges(j,2),1)==m & binnedWhlDat(trialEdges(j,1):trialEdges(j,2),2)==n);
                if ~isempty(indexes)
                    toIndex = find(to <= (indexes(1)-1)/whlFs);
                    toIndexes{m,n} = [toIndexes{m,n}; toIndex(end)];
                    whlTimes{m,n} = [whlTimes{m,n}; indexes(1)];
                    fileNames{m,n} = [fileNames{m,n}; fileBaseMat(i,:)];
                    spectTimes{m,n} = [spectTimes{m,n}; to(toIndex(end)) to(min(length(to),toIndex(end)+1))];
                    
                    figure(1)
                    plot(whldat(indexes(1),1),whldat(indexes(1),2),'.');
                    try plotWhl = [wholeMaze(round(spectTimes{m,n}(end,1)*whlFs+1):min(length(wholeMaze),round(spectTimes{m,n}(end,2)*whlFs+1)),1),...
                                   wholeMaze(round(spectTimes{m,n}(end,1)*whlFs+1):min(length(wholeMaze),round(spectTimes{m,n}(end,2)*whlFs+1)),2)];
                    catch
                        keyboard
                    end
                    plot(plotWhl(plotWhl(:,1)~=-1,1),plotWhl(plotWhl(:,1)~=-1,2),'r:')
                    %plot(whldat(round(to(toIndex(end))*whlFs+1):round(to(toIndex(end)+1)*whlFs+1),1),...
                    %     whldat(round(to(toIndex(end))*whlFs+1):round(to(toIndex(end)+1)*whlFs+1),2),'r:')
                    %plot(whldat(whldat(:,1)==whldat(round(to(toIndex(end))*whlFs+1):round(to(toIndex(end)+1)*whlFs+1),1) & whldat(:,1)~=1,1),...
                    %     whldat(whldat(:,1)==whldat(round(to(toIndex(end))*whlFs+1):round(to(toIndex(end)+1)*whlFs+1),1) & whldat(:,1)~=1,2),'r:')
                end
            end
        end
    end
    
    for k=1:length(channels)
        inName = [spectDir fileBaseMat(i,:) fileExt 'Win' num2str(winLength) 'Ovrlp' num2str(nOverlap) 'NW' num2str(NW) '_mtpsg_' num2str(channels(k)) '.mat'];
        %fprintf('\nLoading: %s', inName);
        spect = load(inName);
        %if median(diff(to))~=median(diff(spect.to))
        %    fprintf('\n\nwe gots problems to~=spect.to')
        %    keyboard
        %end
        thetaPow = 10.*log10(max(spect.yo(thetaFreq(1):thetaFreq(2),:),[],1));
        gammaPow = 10.*log10(sum(spect.yo(gammaFreq(1):gammaFreq(2),:),1));
        for m=1:ceil(videoRes(1)/binSize)
            for n=1:ceil(videoRes(2)/binSize)
                %1=freq,2=channel,3=trial
                if ~isempty(toIndexes{m,n})
                    spatialComodData{m,n}([1:2],k,nPoints(m,n):nPoints(m,n)+length(toIndexes{m,n})-1) ...
                        = cat(1,thetaPow(toIndexes{m,n}), gammaPow(toIndexes{m,n}));
                    
                end
            end
        end
    end
    for m=1:ceil(videoRes(1)/binSize)
        for n=1:ceil(videoRes(2)/binSize)
            nPoints(m,n) = nPoints(m,n) + length(toIndexes{m,n});
        end
    end
    figure(2)
    clf
    imagesc(nPoints)
    title('Occupancy')
    colorbar
end

%[b,bint,r,rint,stats] = regress

%keyboard
%NewWorkSpace
%load tempSpatComod.mat

spatialSlopes = NaN*ones(size(spatialComodData,1),size(spatialComodData,2),nchannels,2,2);
spatialRSquare = NaN*ones(size(spatialComodData,1),size(spatialComodData,2),nchannels,2,2);
spatialPvalues = NaN*ones(size(spatialComodData,1),size(spatialComodData,2),nchannels,2,2);

outlierCount = zeros([size(spatialComodData) nchannels]);
totalCount = zeros(size(spatialComodData));

%spatialCorrCoefs = NaN*ones(size(spatialComodData,1),size(spatialComodData,2),nchannels,2,2);
%spatialPvalues = NaN*ones(size(spatialComodData,1),size(spatialComodData,2),nchannels,2,2);
warning off MATLAB:divideByZero
for m=1:size(spatialComodData,1)
    for n=1:size(spatialComodData,2)
        if size(spatialComodData{m,n})>1 & size(spatialComodData{m,n},3)>1 %| size(spatialComodData{m,n},3)==1
            %fprintf('m=%i,n=%i; ',m,n)
            totalCount(m,n) = totalCount(m,n) + length(spatialComodData{m,n}(1,channels(1),:));

            for j=1:length(channels)
                %fprintf('%i,',j)
                lim1 = [mean(spatialComodData{m,n}(1,channels(j),:))-stdev*std(spatialComodData{m,n}(1,channels(j),:)), ...
                    mean(spatialComodData{m,n}(1,channels(j),:))+stdev*std(spatialComodData{m,n}(1,channels(j),:))];
                lim2 = [mean(spatialComodData{m,n}(2,channels(j),:))-stdev*std(spatialComodData{m,n}(2,channels(j),:)), ...
                    mean(spatialComodData{m,n}(2,channels(j),:))+stdev*std(spatialComodData{m,n}(2,channels(j),:))];
                outliers = spatialComodData{m,n}(1,channels(j),:)<lim1(1) | spatialComodData{m,n}(1,channels(j),:)>lim1(2)...
                    | spatialComodData{m,n}(2,channels(j),:)<lim2(1) | spatialComodData{m,n}(2,channels(j),:)>lim2(2);

                outlierCount(m,n,channels(j)) = outlierCount(m,n,channels(j)) + length(find(outliers));
                if 0
                    figure(6)
                    clf
                    hold on
                    plot(squeeze(spatialComodData{m,n}(1,channels(j),:)),squeeze(spatialComodData{m,n}(2,channels(j),:)),'.')
                    xLimits = get(gca,'xlim');
                    yLimits = get(gca,'ylim');
                    plot(xLimits,[lim2(1) lim2(1)],':k')
                    plot(xLimits,[lim2(2) lim2(2)],':k')
                    plot([lim1(1) lim1(1)],yLimits,':k')
                    plot([lim1(2) lim1(2)],yLimits,':k')
                    keyboard
                end

                if ~isempty(find(~outliers))
                    try
                        %keyboard
                        [b,bint,r,rint,stats] = regress(squeeze(spatialComodData{m,n}(1,channels(j),~outliers)),...
                            [ones(size(squeeze(spatialComodData{m,n}(2,channels(j),~outliers)))) squeeze(spatialComodData{m,n}(2,channels(j),~outliers))],0.05);
                        %[spatialCorrCoefs(m,n,channels(j),:,:) spatialPvalues(m,n,channels(j),:,:)] = corrcoef(spatialComodData{m,n}(1,channels(j),:),spatialComodData{m,n}(2,channels(j),:));
                        spatialSlopes(m,n,channels(j)) = b(2);
                        spatialRSquare(m,n,channels(j)) = stats(1);
                        spatialPvalues(m,n,channels(j)) = stats(3);
                    catch
                        fprintf('\ncaught again')
                        keyboard
                    end
                end
            end
        end
    end
end
figure(3)
clf
title('Outlier Count')
plot(squeeze(sum(sum(outlierCount,1),2)))
figure(4)
clf
title('Outlier Count')
imagesc(squeeze(sum(outlierCount,3))./length(channels))
colorbar
figure(5)
clf
title('Total Count')
imagesc(totalCount)
colorbar

outName = ['SpatialComod_' taskType fileExt '_Win' num2str(winLength) '_NW' num2str(NW) '_' ...
    num2str(thetaFreq(1)) '-' num2str(thetaFreq(2)) 'Hz_vs_' num2str(gammaFreq(1)) '-' num2str(gammaFreq(2)) ...
    'Hz_grid_' num2str(binSize) '.mat']

spatialComodStruct = [];
spatialComodStruct = setfield(spatialComodStruct,'spatialComodData',spatialComodData);
spatialComodStruct = setfield(spatialComodStruct,'outlierCount',outlierCount);
spatialComodStruct = setfield(spatialComodStruct,'totalCount',totalCount);
spatialComodStruct = setfield(spatialComodStruct,'spatialSlopes',spatialSlopes);
spatialComodStruct = setfield(spatialComodStruct,'spatialRSquare',spatialRSquare);
spatialComodStruct = setfield(spatialComodStruct,'spatialPvalues',spatialPvalues);
spatialComodStruct = setfield(spatialComodStruct,'nPoints',nPoints);
spatialComodStruct = setfield(spatialComodStruct,'whlTime',whlTimes);
spatialComodStruct = setfield(spatialComodStruct,'spectTime',spectTimes);
spatialComodStruct = setfield(spatialComodStruct,'fileName',fileNames);
spatialComodStruct = setfield(spatialComodStruct,'info','taskType',taskType);
spatialComodStruct = setfield(spatialComodStruct,'info','fileBaseMat',fileBaseMat);
spatialComodStruct = setfield(spatialComodStruct,'info','fileExt',fileExt);
spatialComodStruct = setfield(spatialComodStruct,'info','nchannels',nchannels);
spatialComodStruct = setfield(spatialComodStruct,'info','channels',channels);
spatialComodStruct = setfield(spatialComodStruct,'info','winLength',winLength);
spatialComodStruct = setfield(spatialComodStruct,'info','nOverlap',nOverlap);
spatialComodStruct = setfield(spatialComodStruct,'info','NW',NW);
spatialComodStruct = setfield(spatialComodStruct,'info','thetaFreq',thetaFreq);
spatialComodStruct = setfield(spatialComodStruct,'info','gammaFreq',gammaFreq);
spatialComodStruct = setfield(spatialComodStruct,'info','binSize',binSize);
spatialComodStruct = setfield(spatialComodStruct,'info','saveName',outName);
spatialComodStruct = setfield(spatialComodStruct,'info','whlFs',whlFs);
spatialComodStruct = setfield(spatialComodStruct,'info','spectDir',spectDir);
spatialComodStruct = setfield(spatialComodStruct,'info','videoRes',videoRes);
spatialComodStruct = setfield(spatialComodStruct,'info','gridYoffset',gridYoffset);
spatialComodStruct = setfield(spatialComodStruct,'info','trialTypesBool',trialTypesBool);

save(outName,'spatialComodStruct');


return
