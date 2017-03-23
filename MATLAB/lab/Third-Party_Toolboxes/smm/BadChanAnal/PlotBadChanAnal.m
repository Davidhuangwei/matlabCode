function PlotBadChanAnal(animal,behaviorCell,depMeasureCell,fileBaseMat,shanks,allChans,frequencies,saveFigBool)
% function PlotBadChanAnal(animal,behaviorCell,depMeasureCell,fileBaseMat,shanks,allChans,frequencies,saveFigBool)
% behaviorCell defines behaviors across which each measure in
% depMeasureCell will be averaged

onlyreal = 0;
diag = 1;

if ~exist('shanks','var') | isempty(shanks)
    shanks = [1:16;17:32;33:48;49:64;65:80;81:96];
end
if ~exist('allChans','var') | isempty(allChans)
    allChans = 1:96;
end
if ~exist('frequencies','var') | isempty(frequencies)
    frequencies = [4; 10; 50; 100; 180; 300; 700; 1000; 1900];
end
if ~exist('saveFigBool','var') | isempty(saveFigBool)
    saveFigBool = 1;
end

for z=1:length(depMeasureCell)
    behavior = [];
    aveDepVar = [];
    depMeasure = depMeasureCell{z};
    for i=1:length(behaviorCell)
        if isempty(behavior)
            behavior = behaviorCell{i};
        else
            behavior = [behavior '+' behaviorCell{i}];
        end
        if ~exist('fileBaseMat','var') | isempty(fileBaseMat)
            fileName = [animal '_' behaviorCell{i} '_BadChanAnal_Segs.mat'];
            load(fileName);
            fprintf('\nLoading: %s\n',fileName');
        else
            fprintf('\n%s\n',fileBaseMat');
        end

        if strcmp(animal,'sm9608') | strcmp(animal,'sm9614')
            firstFile = fileBaseMat(1,8:10);
            lastFile = fileBaseMat(end,8:10);
        end
        if strcmp(animal,'sm9603') | strcmp(animal,'sm9601')
            firstFile = fileBaseMat(1,10:12);
            lastFile = fileBaseMat(end,10:12);
        end

        if strcmp(depMeasure,'powDiff')
            depMeasFile = depMeasure;
            fileName = [behaviorCell{i} '_' depMeasFile '_' firstFile '-' lastFile '.mat'];
            load(fileName);
            fprintf('\nLoading: %s\n',fileName);
            depVar = avePowDiff;
            clear avePowDiff;
        elseif strcmp(depMeasure,'coh')
            depMeasFile = depMeasure;
            fileName = [behaviorCell{i} '_' depMeasFile '_' firstFile '-' lastFile '.mat'];
            load(fileName);
            fprintf('\nLoading: %s\n',fileName);
            depVar = aveCohYo;
            clear aveCohYo;
        elseif strcmp(depMeasure,'csd')
            depMeasFile = depMeasure;
            fileName = [behaviorCell{i} '_' depMeasFile '_' firstFile '-' lastFile '.mat'];
            load(fileName);
            fprintf('\nLoading: %s\n',fileName);
            depVar = aveYo;
            clear aveYo;
        elseif strcmp(depMeasure,'phase')
            depMeasFile = 'coh';
            fileName = [behaviorCell{i} '_' depMeasFile '_' firstFile '-' lastFile '.mat'];
            load(fileName);
            fprintf('\nLoading: %s\n',fileName);
            depVar = aveCohYo;
            clear aveCohYo;
        end

        if isempty(aveDepVar)
            aveDepVar = zeros(size(depVar));
        end
        aveDepVar = aveDepVar + depVar./length(behaviorCell);
        clear depVar;
        clear fileBaseMat;
    end

    %% for shanks individually %%
    figure(1)
    for k=1:size(shanks,1)
        clf;
        for i=1:length(frequencies)
            subplot(ceil(sqrt(length(frequencies))),ceil(sqrt(length(frequencies))),i)
            lb=frequencies(i);
            hb=lb+1;
            plotData = squeeze(mean(aveDepVar(find(fo>lb & fo<hb),shanks(k,:),shanks(k,:)),1));
            if strcmp(depMeasure,'coh') | strcmp(depMeasure,'csd')
                if onlyreal == 0
                    plotData = abs(plotData);
                else
                    plotData = real(plotData);
                end
            end
            if strcmp(depMeasure,'phase')
                %plotData = angle(plotData);
                plotData = 1-(abs(angle(plotData))./pi);
            end
            if diag == 0;
                plotData = tril(plotData,-1);
            end
            imagesc(plotData);
            title([depMeasure ': ' behavior ' files ' firstFile '-' lastFile ', ch ' num2str(shanks(k,1)) '-' num2str(shanks(k,end)) ', freq=' num2str(lb)],'fontsize',7);
            set(gca,'xtick',[1:length(shanks(k,:))],'xticklabel',shanks(k,:),'ytick',[1:length(shanks(k,:))],'yticklabel',shanks(k,:),'fontsize',5);
            set(gca,'clim',[0 1]);
            colorbar;
        end
        if saveFigBool
            print([depMeasure '_' behavior num2str(shanks(k,1)) '-' num2str(shanks(k,end))], '-dpng', '-r125');
        else
            keyboard
        end
    end
    %% for all Channels %%
    figure(2)
    for i=1:length(frequencies)
        clf;
        lb=frequencies(i);
        hb=lb+1;
        plotData = squeeze(mean(aveDepVar(find(fo>lb & fo<hb),allChans,allChans),1));
        if strcmp(depMeasure,'coh') | strcmp(depMeasure,'csd')
            if onlyreal == 0
                plotData = abs(plotData);
            else
                plotData = real(plotData);
            end
        end
        if strcmp(depMeasure,'phase')
            %plotData = angle(plotData);
            plotData = 1-(abs(angle(plotData))./pi);
        end
        if diag == 0;
            %plotData = tril(plotData,-1);
        end
        imagesc(plotData);
        title([depMeasure ': ' behavior ' files ' firstFile '-' lastFile ', ch ' num2str(allChans(1)) '-' num2str(allChans(end)) ', freq=' num2str(lb)],'fontsize',7);
        set(gca,'xtick',[allChans(1:2:length(allChans))],'xticklabel',[allChans(1:2:length(allChans))],'ytick',[allChans(1:2:length(allChans))],'yticklabel',[allChans(1:2:length(allChans))],'fontsize',4);
        set(gca,'clim',[0 1]);
        colorbar;
        if saveFigBool
            print(['SFNposter2005/' depMeasure '_' behavior '_ch' num2str(allChans(1)) '-' num2str(allChans(end)) '_' num2str(frequencies(i)) 'Hz'], '-depsc', '-adobecset')

            %print([depMeasure '_' behavior num2str(allChans(1)) '-' num2str(allChans(end)) '_' num2str(frequencies(i)) 'Hz'], '-dpng', '-r150');
        else
            keyboard
            %print(['SFNposter2005/' depMeasure '_' behavior '_ch' num2str(allChans(1)) '-' num2str(allChans(end)) '_' num2str(frequencies(i)) 'Hz'], '-depsc', '-adobecset')

        end
    end
end
