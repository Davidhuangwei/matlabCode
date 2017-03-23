function PlotRippTrigSegs(fileBaseMat,csdExt,eegExt,rippTrigChan,swTrigChan,varargin)

[firstFig,] = DefaultArgs(varargin,...
    {1})


%plotColors = [0 0 0;1 0 0;0 0 1;0 1 0];

figure(firstFig)
clf
figure(firstFig+1)
clf

selectedSegs = [];
for j=1:size(fileBaseMat,1)
    fileBase = fileBaseMat(j,:);
    inName = [fileBase '/' 'RippTrigSegs_RippTrigChan' num2str(rippTrigChan) '_SwTrigChan' num2str(swTrigChan) csdExt '.mat'];

    fprintf('Loading: %s\n',inName)
    load(inName);

    selectedSegs = cat(3,selectedSegs,segs);
end
csdChansPerShank = getfield(infoStruct,'chansPerShank');
csdNShanks  = getfield(infoStruct,'nShanks');
csdBadChan = getfield(infoStruct,'badChans');
csdAveSeg = mean(selectedSegs,3);
csdStdSeg = squeeze(std(permute(selectedSegs,[3 1 2])));
clear selectedSegs

for k=1:size(csdAveSeg,2)
    csdAveSeg2D(:,:,k) = Make2DPlotMat(csdAveSeg(:,k),MakeChanMat(csdNShanks,csdChansPerShank),0);
    csdStdSeg2D(:,:,k) = Make2DPlotMat(csdStdSeg(:,k),MakeChanMat(csdNShanks,csdChansPerShank),0);
end

% plot "csd" traces
figure(firstFig);
set(gcf, 'Units', 'inches')
plotSize=[13 9];
set(gcf, 'Position', [(8.5-plotSize(1))/2,(11-plotSize(2))/2,plotSize(1),plotSize(2)])
shiftCSD = 2*max(max(max(abs(csdAveSeg+csdStdSeg))));
PlotTrigEEG(csdAveSeg2D,shiftCSD,{csdStdSeg2D,[],[],[],[],{SaveTheUnderscores(csdExt)}})

set(gcf,'name', ['RippTrigSegs_RippTrigChan' num2str(rippTrigChan) '_SwTrigChan' num2str(swTrigChan) csdExt])


if ~isempty(eegExt)
    selectedSegs = [];
    for j=1:size(fileBaseMat,1)
        fileBase = fileBaseMat(j,:);
        inName = [fileBase '/' 'RippTrigSegs_RippTrigChan' num2str(rippTrigChan) '_SwTrigChan' num2str(swTrigChan) eegExt '.mat'];
        fprintf('Loading: %s\n',inName)
        load(inName);
        selectedSegs = cat(3,selectedSegs,segs);

    end

    eegChansPerShank = getfield(infoStruct,'chansPerShank');
    eegNShanks  = getfield(infoStruct,'nShanks');
    eegBadChan = getfield(infoStruct,'badChans');
    eegSamp = getfield(infoStruct,'eegSamp');
    segLen = getfield(infoStruct,'segLen');

    eegAveSeg = mean(selectedSegs,3);
    eegStdSeg = squeeze(std(permute(selectedSegs,[3 1 2])));
    clear selectedSegs

    for k=1:size(eegAveSeg,2)
        eegAveSeg2D(:,:,k) = Make2DPlotMat(eegAveSeg(:,k),MakeChanMat(eegNShanks,eegChansPerShank),0);
        eegStdSeg2D(:,:,k) = Make2DPlotMat(eegStdSeg(:,k),MakeChanMat(eegNShanks,eegChansPerShank),0);
    end


    figure(firstFig+1);
    set(gcf, 'Units', 'inches')
    plotSize=[13 9];
    set(gcf, 'Position', [(8.5-plotSize(1))/2,(11-plotSize(2))/2,plotSize(1),plotSize(2)])
    shiftEEG = 2*max(max(max(abs(eegAveSeg+eegStdSeg))));
    PlotTrigEEG(eegAveSeg2D,shiftEEG,{eegStdSeg2D,[],[],[],[],{SaveTheUnderscores(eegExt)}})
    set(gcf,'name', ['RippTrigSegs_RippTrigChan' num2str(rippTrigChan) '_SwTrigChan' num2str(swTrigChan) csdExt])
    figure(firstFig+2)
    set(gcf, 'Units', 'inches')
    plotSize=[14 3];
    set(gcf, 'Position', [(8.5-plotSize(1))/2,(11-plotSize(2))/2,plotSize(1),plotSize(2)])
    PlotTrigCSD(csdAveSeg2D,eegAveSeg2D,{eegBadChan,gcf,eegSamp,[],SaveTheUnderscores({'color=', csdExt,'','trace=', eegExt})});
    set(gcf,'name', ['RippTrigSegs_RippTrigChan' num2str(rippTrigChan) '_SwTrigChan' num2str(swTrigChan) csdExt])
end

