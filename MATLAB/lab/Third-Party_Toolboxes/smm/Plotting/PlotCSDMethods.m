function PlotTroughTrigSegs(fileBaseMat,trigChan,filtFreqRange,maxFreq,varargin)


[chanMat,badChans,trialDesigCell,channels, stdev] = DefaultArgs(varargin,{MakeChanMat(6,16),load(['BadChanEEG.txt']),...
    cat(2,{'alter'},repmat({[1 0 1 0 0 0 0 0 0 0 0 0 0]},3,1),repmat({0.5},3,1),repmat({[0 0 0 1 1 1 1 1 1]},3,1),repmat({0.6},3,1)),...
    1:96,3.0});

fileExt = '.eeg';

plotColors = [0 0 0;1 0 0;0 0 1;0 1 0];
figure(1)
clf

for i=1:size(trialDesigCell,1)
    selectedSegs = [];
    for j=1:size(fileBaseMat,1)
        fileBase = fileBaseMat(j,:);
        inName = [fileBase '/' 'TroughTrigSegs_trigCh' num2str(trigChan) '_freq' num2str(filtFreqRange(1)) '-' num2str(filtFreqRange(2)) ...
            '_maxFreq' num2str(maxFreq) '_' fileExt(2:end) '.mat'];
        fprintf('Loading: %s\n',inName)
        load(inName);

        selectedTrials = zeros(length(taskType),1);
        selectedTrials = selectedTrials | ...
            (strcmp(trialDesigCell{i,1},taskType) & trialType*trialDesigCell{i,2}'>trialDesigCell{i,3}...
            & mazeRegion*trialDesigCell{i,4}'>trialDesigCell{i,5});
        selectedTrials = find(selectedTrials);
        selectedSegs = cat(3,selectedSegs,segs(:,:,selectedTrials));
    end

    aveSeg = mean(selectedSegs,3);
    stdSeg = squeeze(std(permute(selectedSegs,[3 1 2])));

    csdBadChan = badChans(mod(badChans,16)~=0 & mod(badChans+15,16)~=0);
    csdBadChan = csdBadChan-floor(csdBadChan/16)-ceil(csdBadChan/16);
    
    method = {'cubic','linear','funky'}
    for l=1:length(method)
        for m=1:length(method)
            for k=1:size(aveSeg,2)
                aveSeg2d(:,:,k) = Make2DPlotMat(aveSeg(:,k),MakeChanMat(6,16),0);
                interpAveSeg2d(:,:,k) = ShankInterp(aveSeg2d(:,:,k),badChans,method{l},100);
                csdSegs(:,:,k) = ShankInterp(ShankCSD(interpAveSeg2d(:,:,k)),csdBadChan,method{m},100);
            end
        end
        PlotTrigCSD(csdSegs,interpAveSeg2d,badChans,(l-1)*length(method)+m);
        set(gcf,'name',[method{l} '-' method{m}])
    end
end
