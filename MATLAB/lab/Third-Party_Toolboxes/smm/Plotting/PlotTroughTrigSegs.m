function PlotTroughTrigSegs(fileBaseMat,csdExt,eegExt,trigChan,filtFreqRange,maxFreq,varargin)


[trialDesigCell] = DefaultArgs(varargin,...
    {cat(2,{'alter';'circle';'z'},repmat({[1 0 1 0 0 0 0 0 0 0 0 0 0]},3,1),repmat({0.5},3,1),repmat({[0 0 0 1 1 1 1 1 1]},3,1),repmat({0.6},3,1))});

plotColors = [0 0 0;1 0 0;0 0 1;0 1 0];

figure(1)
clf
figure(2)
clf
figure(3)
clf

for i=1:size(trialDesigCell,1)
    selectedSegs = [];
    for j=1:size(fileBaseMat,1)
        fileBase = fileBaseMat(j,:);
        inName = [fileBase '/' 'TroughTrigSegs_trigCh' num2str(trigChan) '_freq' num2str(filtFreqRange(1)) '-' num2str(filtFreqRange(2)) ...
            '_maxFreq' num2str(maxFreq) csdExt '.mat'];
        fprintf('Loading: %s\n',inName)
        load(inName);

        selectedTrials = zeros(length(taskType),1);
        selectedTrials = selectedTrials | ...
            (strcmp(trialDesigCell{i,1},taskType) & trialType*trialDesigCell{i,2}'>trialDesigCell{i,3}...
            & mazeRegion*trialDesigCell{i,4}'>trialDesigCell{i,5});
        selectedTrials = find(selectedTrials);
        selectedSegs = cat(3,selectedSegs,segs(:,:,selectedTrials));
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
    figure(1);
    if i==1
        shiftCSD = 2*max(max(max(abs(csdAveSeg+csdStdSeg))));
    end
    PlotTrigEEG(csdAveSeg2D,shiftCSD,{csdStdSeg2D,csdBadChan,plotColors(i,:)})

    set(gcf,'name', csdExt)

    
    if ~isempty(eegExt)
        selectedSegs = [];
        for j=1:size(fileBaseMat,1)
            fileBase = fileBaseMat(j,:);
            inName = [fileBase '/' 'TroughTrigSegs_trigCh' num2str(trigChan) '_freq' num2str(filtFreqRange(1)) '-' num2str(filtFreqRange(2)) ...
                '_maxFreq' num2str(maxFreq) eegExt '.mat'];
            fprintf('Loading: %s\n',inName)
            load(inName);

            selectedTrials = zeros(length(taskType),1);
            selectedTrials = selectedTrials | ...
                (strcmp(trialDesigCell{i,1},taskType) & trialType*trialDesigCell{i,2}'>trialDesigCell{i,3}...
                & mazeRegion*trialDesigCell{i,4}'>trialDesigCell{i,5});
            selectedTrials = find(selectedTrials);
            selectedSegs = cat(3,selectedSegs,segs(:,:,selectedTrials));
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
        

        figure(2);
        if i==1
            shiftEEG = 2*max(max(max(abs(eegAveSeg+eegStdSeg))));
        end
        PlotTrigEEG(eegAveSeg2D,shiftEEG,{eegStdSeg2D,eegBadChan,plotColors(i,:)})
        set(gcf,'name', eegExt)
        figure(3)
        PlotTrigCSD(csdAveSeg2D,eegAveSeg2D,{eegBadChan,gcf,segLen,eegSamp});
        set(gcf,'name', num2str(trialDesigCell{i,4}))
    end
      

    %trigChan = getfield(infoStruct,'trigChan');
    eegSamp = getfield(infoStruct,'eegSamp');
    segLen = getfield(infoStruct,'segLen');
        %nShanks = 6;
        %chansPerShank = 16;
        %trigChan = 40;
        %eegSamp = 1250;
        %segLen = round(2/filtFreqRange(1)*eegSamp); % at least 2 cycles

 
    
    %if csdBool
    %    csdBadChan = CalcCsdBadChans(badChans,chansPerShank);
    %    for k=1:size(aveSeg,2)
    %        aveSeg2d(:,:,k) = Make2DPlotMat(aveSeg(:,k),MakeChanMat(nShanks,chansPerShank),0);
    %        interpAveSeg2d(:,:,k) = ShankInterp(aveSeg2d(:,:,k),badChans,'funky',100);
    %        csdSegs(:,:,k) = ShankInterp(ShankCSD(interpAveSeg2d(:,:,k)),csdBadChan,'funky',100);
    %    end
    if 0
        figure(2);
        if i==1
            shiftCSD = 2*max(max(max(abs(csdSegs))));
        end
        PlotTrigEEG(csdSegs,shiftCSD,{[],csdBadChan,plotColors(i,:)})
        set(gcf,'name', 'csd')
        figure
        PlotTrigCSD(csdSegs,interpAveSeg2d,badChans,gcf);
        set(gcf,'name', num2str(trialDesigCell{i,4}))
    end

    if 0
        nShanks = 6;
        chansPerShank = 16;
        trigChan = 40;
        eegSamp = 1250;
        segLen = round(2/filtFreqRange(1)*eegSamp); % at least 2 cycles
    end
    
    if 0
        if i==1
            shift = 2*max(abs(aveSeg(trigChan,:)+stdSeg(trigChan,:)));
        end
        if 1
            %figure(i)
            for k=0:1:nShanks-1
                plotChans = k*chansPerShank+1:(k+1)*chansPerShank;
                subplot(1,nShanks,k+1)
                hold on
                grid on
                for l=1:length(plotChans)
                    if isempty(find(plotChans(l)==badChans))
                        plot(aveSeg(plotChans(l),:)-l*shift,'color',plotColors(i,:))
                        plot(aveSeg(plotChans(l),:)+stdSeg(plotChans(l),:)-l*shift,'--','color',mean([plotColors(i,:);[1 1 1]],1).^(1/2))
                        plot(aveSeg(plotChans(l),:)-stdSeg(plotChans(l),:)-l*shift,'--','color',mean([plotColors(i,:);[1 1 1]],1).^(1/2))
                    else
                        %plot(aveSeg(plotChans(l),:)-l*shift,'color',[0 0 0])
                        %plot(aveSeg(plotChans(l),:)+stdSeg(plotChans(l),:)-l*shift,'--','color',[0.5 0.5 0.5])
                        %plot(aveSeg(plotChans(l),:)-stdSeg(plotChans(l),:)-l*shift,'--','color',[0.5 0.5 0.5])
                    end
                end
                set(gca,'ylim',[-(chansPerShank+1)*shift 0],'xlim',[0 segLen],'ytick',[],...
                    'xtick',[0,(segLen+1)/2,segLen],'xticklabel',[-segLen/2/eegSamp*1000 0 segLen/2/eegSamp*1000]);
            end
        end
    end
end

