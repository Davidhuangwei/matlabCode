% function PlotTrigSegs(fileBaseCell,fileName,csdExt,eegExt,varargin)
% [firstFig,plotSize,colorLimits,eegOffset,csdOffset,chanMat,trialDesigCell] = DefaultArgs(varargin,...
%     {1,[10 8],[],eegOffset,csdOffset,chanMat,cat(2,{'alter';'circle';'z'},repmat({[1 0 1 0 0 0 0 0 0 0 0 0 0]},3,1),repmat({0.5},3,1),repmat({[0 0 0 1 1 1 1 1 1]},3,1),repmat({0.6},3,1))});
function PlotTrigSegs(fileBaseCell,fileName,csdExt,eegExt,varargin)


chanInfoDir = 'ChanInfo/';
% chanMat = LoadVar([chanInfoDir 'ChanMat' eegExt '.mat']);
chanMat = LoadVar([chanInfoDir 'ChanMat.eeg.mat']);
baseOffset  = load([chanInfoDir 'Offset.eeg.txt']);
if ~isempty(eegExt)
    eegOffset = load([chanInfoDir 'Offset' eegExt '.txt']);
else
    eegOffset = [];
end
if ~isempty(csdExt)
    csdOffset = load([chanInfoDir 'Offset' csdExt '.txt']);
else
    csdOffset = [];
end
[firstFig,plotSize,colorLimits,eegOffset,csdOffset,chanMat,trialDesigCell] = DefaultArgs(varargin,...
    {1,[10 8],[],eegOffset,csdOffset,chanMat,cat(2,{'alter';'circle';'z'},repmat({[1 0 1 0 0 0 0 0 0 0 0 0 0]},3,1),repmat({0.5},3,1),repmat({[0 0 0 1 1 1 1 1 1]},3,1),repmat({0.6},3,1))});

nVertChan = size(chanMat,1);

plotColors = [0 0 0;1 0 0;0 0 1;0 1 0];


figure(firstFig)
clf
figHandle = subplot(1,1,1);

for i=1:size(trialDesigCell,1)
    selectedSegs = [];
    
    if ~isempty(csdExt)
        for j=1:length(fileBaseCell)
            fileBase = fileBaseCell{j};
            inName = [fileBase '/' fileName csdExt '.mat'];
            fprintf('Loading: %s\n',inName)
            load(inName);

            try selectedTrials = zeros(length(taskType),1);
                selectedTrials = selectedTrials | ...
                    (strcmp(trialDesigCell{i,1},taskType) & trialType*trialDesigCell{i,2}'>trialDesigCell{i,3}...
                    & mazeRegion*trialDesigCell{i,4}'>trialDesigCell{i,5});
                selectedTrials = find(selectedTrials);
                selectedSegs = cat(3,selectedSegs,segs(:,:,selectedTrials));
            catch
                fprintf('Trial Designation Failed. All Segs Included.\n')
                selectedSegs = cat(3,selectedSegs,segs);
            end
        end
        try
            sampRate = getfield(infoStruct,'sampRate');
        catch
            try
                sampRate = getfield(infoStruct,'eegSamp');
            catch
                sampRate = getfield(infoStruct,'datSamp');
            end
        end
        %csdChansPerShank = getfield(infoStruct,'chansPerShank');
        %csdNShanks  = getfield(infoStruct,'nShanks');
        %csdBadChan = getfield(infoStruct,'badChans');
        csdChanMat = LoadVar([chanInfoDir 'ChanMat' csdExt '.mat']);
        csdChansPerShank = size(csdChanMat,1);
        csdNShanks = size(csdChanMat,2);
        csdBadChan = load([chanInfoDir 'BadChan' csdExt '.txt']);
        csdAveSeg = mean(selectedSegs,3);
        csdStdSeg = squeeze(std(permute(selectedSegs,[3 1 2])));
        clear selectedSegs

        %     for k=1:size(csdAveSeg,2)
        %         csdAveSeg2D(:,:,k) = Make2DPlotMat(csdAveSeg(:,k),MakeChanMat(csdNShanks,csdChansPerShank),0);
        %         csdStdSeg2D(:,:,k) = Make2DPlotMat(csdStdSeg(:,k),MakeChanMat(csdNShanks,csdChansPerShank),0);
        %     end

        %%%% Plotting CSD %%%%%%
        %     plotBuff = round(0.1*size(csdAveSeg2D,3));

        %     csdPlot = NaN*ones(size(csdAveSeg2D,1),size(csdAveSeg2D,2)*(size(csdAveSeg2D,3)+plotBuff));
        %     for j=1:size(csdAveSeg2D,2)
        %         csdPlot(:,(j-1)*(size(csdAveSeg2D,3)+plotBuff)+round(plotBuff/2) + 1:...
        %             (j-1)*(size(csdAveSeg2D,3)+plotBuff)+round(plotBuff/2) + ...
        %             size(csdAveSeg2D,3)) = squeeze(csdAveSeg2D(:,j,:));
        %     end

        csdPlot = MakeBufferedPlotMat(permute(csdAveSeg,[1,3,2]),csdChanMat,[],[]);
        figure(firstFig)
        clf;
        set(gcf,'name',[fileName '_Color' csdExt '_Trace' eegExt])
        figHandle = ImageScInterpRmNaN({[1:size(csdPlot,2)],csdOffset(1)+1:size(chanMat,1)-csdOffset(1),csdPlot},4,'linear',colorLimits);
    end
    % set(gcf,'renderer','painters')
    %      pcolor(1:size(csdPlot,2),-1-csdOffset(1):-1:-size(csdPlot,1)-csdOffset,csdPlot)
    %     shading interp

    if ~isempty(eegExt)
        selectedSegs = [];
        for j=1:length(fileBaseCell)
            fileBase = fileBaseCell{j};
            inName = [fileBase '/' fileName eegExt '.mat'];
            fprintf('Loading: %s\n',inName)
            load(inName);

            try
                selectedTrials = zeros(length(taskType),1);
                selectedTrials = selectedTrials | ...
                    (strcmp(trialDesigCell{i,1},taskType) & trialType*trialDesigCell{i,2}'>trialDesigCell{i,3}...
                    & mazeRegion*trialDesigCell{i,4}'>trialDesigCell{i,5});
                selectedTrials = find(selectedTrials);
                selectedSegs = cat(3,selectedSegs,segs(:,:,selectedTrials));
            catch
                fprintf('Trial Designation Failed. All Segs Included.\n')
                selectedSegs = cat(3,selectedSegs,segs);
            end
        end

        eegChanMat = LoadVar([chanInfoDir 'ChanMat' eegExt '.mat']);
        eegChansPerShank = size(eegChanMat,1);
        eegNShanks = size(eegChanMat,2);
        eegBadChan = load([chanInfoDir 'BadChan' eegExt '.txt']);
        %         eegChansPerShank = getfield(infoStruct,'chansPerShank');
        %         eegNShanks  = getfield(infoStruct,'nShanks');
        %         eegBadChan = getfield(infoStruct,'badChans');
        try
            eegSamp = getfield(infoStruct,'sampRate');
        catch
            try
                eegSamp = getfield(infoStruct,'eegSamp');
            catch
                eegSamp  = getfield(infoStruct,'datSamp');
            end
        end
        segLen = getfield(infoStruct,'segLen');

        eegAveSeg = mean(selectedSegs,3);
%         eegStdSeg = squeeze(std(permute(selectedSegs,[3 1 2])));
        clear selectedSegs

%         for k=1:size(eegAveSeg,2)
%             eegAveSeg2D(:,:,k) = Make2DPlotMat(eegAveSeg(:,k),MakeChanMat(eegNShanks,eegChansPerShank),0);
%             eegStdSeg2D(:,:,k) = Make2DPlotMat(eegStdSeg(:,k),MakeChanMat(eegNShanks,eegChansPerShank),0);
%         end
%         eegPlot = NaN*ones(size(eegAveSeg2D,1),size(eegAveSeg2D,2)*(size(eegAveSeg2D,3)+plotBuff));
%         for j=1:size(eegAveSeg2D,2)
%             eegPlot(:,(j-1)*(size(eegAveSeg2D,3)+plotBuff)+round(plotBuff/2) + 1:...
%                 (j-1)*(size(eegAveSeg2D,3)+plotBuff)+round(plotBuff/2) + ...
%                 size(eegAveSeg2D,3)) = squeeze(eegAveSeg2D(:,j,:));
%         end
        eegPlot = MakeBufferedPlotMat(permute(eegAveSeg,[1,3,2]),eegChanMat);

        normFactor = abs(max(max(eegPlot))-min(min(eegPlot)));
        PlotAnatCurves('ChanInfo/AnatCurves.mat',[nVertChan size(eegPlot,2)] ,...
            [0.5-baseOffset(1)*size(eegPlot,1)/size(chanMat,1) 0.5+baseOffset(2)*size(eegPlot,2)/size(chanMat,2)],...
            [0.65 0.65 0.65],3);

         subplot(figHandle)
         hold on
         for j=1:size(eegPlot,1)
%            plot(1:size(eegPlot,2),eegPlot(j,:)/normFactor-j-eegOffset(1),'k','linewidth',3);
            plot(1:size(eegPlot,2),-eegPlot(j,:)/normFactor+j+eegOffset(1),'k','linewidth',2);
        end
        badChanEegAveSeg = NaN*ones(size(eegAveSeg));
        badChanEegAveSeg(eegBadChan,:) = eegAveSeg(eegBadChan,:);
        badEegPlot = MakeBufferedPlotMat(permute(badChanEegAveSeg,[1,3,2]),eegChanMat);
%         badChanEegAveSeg2D = eegAveSeg2D;
%         for j=1:size(eegChanMat,1)
%             for k=1:size(eegChanMat,2)
%                 if isempty(find(eegBadChan==eegChanMat(j,k)))
%                     badChanEegAveSeg2D(j,k,:) = NaN;
%                 end
%             end
%         end
%         badEegPlot = NaN*ones(size(badChanEegAveSeg2D,1),size(badChanEegAveSeg2D,2)*(size(badChanEegAveSeg2D,3)+plotBuff));
%         for j=1:size(badChanEegAveSeg2D,2)
%             badEegPlot(:,(j-1)*(size(badChanEegAveSeg2D,3)+plotBuff)+round(plotBuff/2) + 1:...
%                 (j-1)*(size(badChanEegAveSeg2D,3)+plotBuff)+round(plotBuff/2) + ...
%                 size(badChanEegAveSeg2D,3)) = squeeze(badChanEegAveSeg2D(:,j,:));
%         end
%         for j=1:size(badEegPlot,1)
%             plot(1:size(badEegPlot,2),badEegPlot(j,:)/normFactor-j-eegOffset(1),'color',[.65 .65 .65]);
%         end
        set(gca,'xtick',[[1:size(csdPlot,2)/size(chanMat,2):size(csdPlot,2)]+size(csdPlot,2)/size(chanMat,2)/2 size(eegPlot,2)])
        set(gca,'xticklabel',[1:size(chanMat,2) size(eegPlot,2)])

        set(gca,'ytick',[eegOffset(1)+1:size(chanMat,1)-eegOffset(1)]);
        %set(gca,'ytick',fliplr(-1-csdOffset(1):-1:-size(csdPlot,1)-csdOffset));
        %PlotGrid
        %set(gca,'yticklabel',abs(fliplr(-1-csdOffset(1):-1:-size(csdPlot,1)-csdOffset)));
        set(gca,'ylim',[0 nVertChan+1])
%         set(gca,'ylim',[-nVertChan-1 0])
        %set(gca,'xtick',[],'ytick',[])
        colormap(LoadVar('ColorMapRmNaN.mat'));
%         colormap(LoadVar('ColorMapSean6.mat'));
%         colorbar
         text(1+0.025*size(eegPlot,2),nVertChan+2,{[num2str(size(eegAveSeg,2)/sampRate) ' sec'],...
            [num2str(normFactor) ' bits']});
%           text(1+0.025*size(eegPlot,2),-nVertChan-nVertChan*0.025,{[num2str(size(eegAveSeg,2)/sampRate) ' sec'],...
%             [num2str(normFactor) ' bits']});
        set(gcf,'PaperPosition',[(8.5-plotSize(1))/2,(11-plotSize(2))/2,plotSize(1),plotSize(2)]);
        set(gcf, 'Units', 'inches')
        set(gcf, 'Position', [(8.5-plotSize(1))/2,(11-plotSize(2))/2,plotSize(1),plotSize(2)])
        grid on
        return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%







        figure(firstFig+1);
        if i==1
            shiftEEG = 2*max(max(max(abs(eegAveSeg+eegStdSeg))));
        end
        PlotTrigEEG(eegAveSeg2D,shiftEEG,{eegStdSeg2D,[],plotColors(i,:)})
        set(gcf,'name', eegExt)
        figure(firstFig+1+i)
        set(gcf, 'Units', 'inches')
        plotSize=[14 3];
        set(gcf, 'Position', [(8.5-plotSize(1))/2,(11-plotSize(2))/2,plotSize(1),plotSize(2)])
        PlotTrigCSD(csdAveSeg2D,eegAveSeg2D,{eegBadChan,gcf,eegSamp});
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

