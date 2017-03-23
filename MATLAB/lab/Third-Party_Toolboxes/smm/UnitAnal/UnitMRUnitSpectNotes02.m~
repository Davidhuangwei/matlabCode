analDirs = {...
    '/BEEF02/smm/sm9614_Analysis/4-17-05/analysis',...
    '/BEEF01/smm/sm9603_Analysis/3-21-04/analysis/',...
    '/BEEF02/smm/sm9608_Analysis/7-17-04/analysis'};

spectAnalDir = 'CalcRunningSpectra12_noExp_MidPoints_MinSpeed0Win626wavParam8.eeg/';
spectAnalDir = 'RemVsRun02_noExp_MinSpeed0Win1250wavParam6.eeg/';
midPointsBool = 0;
minSpeed = 0;
winLength = 1250;
fileExt = '.eeg';
analRoutine = 'RemVsMaze_Beh';
statsAnalFunc = 'GlmWholeModel07';
selAnatRegions = {'or','ca1Pyr','rad','lm','mol','gran','hil','ca3Pyr'};
chanLocVersion = 'Full';


cwd = pwd;
cellTypesVecAll = [];
chanLayerVecAll = [];
firingRateStruct = [];
% mazeLocVecAll = [];
trialsByCellsAll = [];
if midPointsBool
    midPointsText = '_MidPoints';
else
    midPointsText = [];
end

for a=1:length(analDirs)
    cd(analDirs{a})
    fileBaseCell = LoadVar('FileInfo/AlterFiles');
    chanLoc = LoadVar(['ChanInfo/ChanLoc_' chanLocVersion '.eeg.mat']);
    cellType = LoadCellTypes([fileBaseCell{1} '/' fileBaseCell{1} '.type']);
    cluLoc = load([fileBaseCell{1} '/' fileBaseCell{1} '.cluloc']);
    rateTrialsByCells = [];
    spectTrialsByCells = [];
    mazeLocVec = {};
    cellTypesVec = cellType(:,3)';
    chanLayerVec = GetChanLayer(cluLoc(:,3),chanLoc);
    dirName = [spectAnalDir];
    %dirName = [spectAnalDir midPointsText '_MinSpeed' num2str(minSpeed) 'Win' num2str(winLength) fileExt];
    load(['TrialDesig/' statsAnalFunc '/' analRoutine '.mat'])

    rateTrialsByCells = LoadDesigVar(fileBaseCell,dirName,'unitPowSpec.rate',trialDesig);
    spectTrialsByCells = LoadDesigVar(fileBaseCell,dirName,'unitPowSpec.yo',trialDesig);
    elCluList = LoadField([fileBaseCell{1} '/' spectAnalDir 'unitPowSpec.elClu']);
    fo = LoadField([fileBaseCell{1} '/' spectAnalDir 'unitPowSpec.fo']);
    
    mazeLocFieldNames = fieldnames(rateTrialsByCells);
    for j=1:length(mazeLocFieldNames)
        if a==1
            firingRateStruct.(mazeLocFieldNames{j}) = mean(rateTrialsByCells.(mazeLocFieldNames{j}));
            firingSpectStruct.(mazeLocFieldNames{j}) = mean(spectTrialsByCells.(mazeLocFieldNames{j}));
        else
            firingRateStruct.(mazeLocFieldNames{j}) = cat(2,firingRateStruct.(mazeLocFieldNames{j}),...
                mean(rateTrialsByCells.(mazeLocFieldNames{j})));
            firingSpectStruct.(mazeLocFieldNames{j}) = cat(2,firingSpectStruct.(mazeLocFieldNames{j}),...
                mean(spectTrialsByCells.(mazeLocFieldNames{j})));
        end

    end
% trialsByCellsAll = cat(2,trialsByCellsAll,trialsByCells);
% size(mazeLocVec)
% size(mazeLocVecAll)
% mazeLocVecAll = cat(1,mazeLocVecAll,mazeLocVec);
    cellTypesVecAll = cat(2,cellTypesVecAll,cellTypesVec);
    chanLayerVecAll = cat(2,chanLayerVecAll,chanLayerVec);
end
cd(cwd);


%%% plot spectrum norm by rate %%%
figure
clf
plotColors = 'bgrcmk'
cellTypeLabels = ['w' 'n']
for m=1:length(selAnatRegions)
    for k=1:length(cellTypeLabels)
        titleText = [];
        for j=1:length(mazeLocFieldNames)
            subplot(length(selAnatRegions),length(cellTypeLabels),(m-1)*length(cellTypeLabels)+k)
            hold on
            chanInd = strcmp(chanLayerVecAll,selAnatRegions{m})...
                    & strcmp(cellTypesVecAll,cellTypeLabels(k))...
                    & firingRateStruct.(mazeLocFieldNames{j})(1,:)>0;
            if sum(chanInd)>0
                plot(fo,squeeze(mean(firingSpectStruct.(mazeLocFieldNames{j})(:,chanInd,:)./...
                    repmat(firingRateStruct.(mazeLocFieldNames{j})(:,chanInd),...
                    [1,1,size(firingSpectStruct.(mazeLocFieldNames{j}),3)]),2)),'color',plotColors(j));
            end
            titleText = [titleText ',' cellTypeLabels(k) '=' num2str(sum(chanInd))];
            ylabel(selAnatRegions{m})
            if m==1 & k==1
                text(fo(end),0-j*diff(get(gca,'ylim'))/2,mazeLocFieldNames{j},'color',plotColors(j))
            end
            set(gca,'xlim',[fo(1) fo(end)],'ylim',[0.5 1.5]);
        end
        title(titleText)
    end
end

%%% plot spectrum %%%
figure
clf
plotColors = 'bgrcmk'
cellTypeLabels = ['w' 'n']
for m=1:length(selAnatRegions)
    for k=1:length(cellTypeLabels)
        titleText = [];
        for j=1:length(mazeLocFieldNames)
            subplot(length(selAnatRegions),length(cellTypeLabels),(m-1)*length(cellTypeLabels)+k)
            hold on
            chanInd = strcmp(chanLayerVecAll,selAnatRegions{m})...
                    & strcmp(cellTypesVecAll,cellTypeLabels(k));
            if sum(chanInd)>0
                plot(fo,squeeze(mean(firingSpectStruct.(mazeLocFieldNames{j})(:,chanInd,:),2)),'color',plotColors(j));
            end
            titleText = [titleText ',' cellTypeLabels(k) '=' num2str(sum(chanInd))];
            ylabel(selAnatRegions{m})
            if m==1 & k==1
                text(fo(end),0-j*diff(get(gca,'ylim'))/2,mazeLocFieldNames{j},'color',plotColors(j))
            end
            set(gca,'xlim',[fo(1) fo(end)])
            %'ylim',[0.5 1.5]);
        end
        title(titleText)
    end
end

%%% plot rate %%%
figure
clf
cellTypeLabels = ['w' 'n']
for m=1:length(selAnatRegions)
    for k=1:length(cellTypeLabels)
        titleText = [];
        for j=1:length(mazeLocFieldNames)
            subplot(length(selAnatRegions),length(cellTypeLabels),(m-1)*length(cellTypeLabels)+k)
            hold on
            chanInd = strcmp(chanLayerVecAll,selAnatRegions{m})...
                    & strcmp(cellTypesVecAll,cellTypeLabels(k))...
                    & firingRateStruct.(mazeLocFieldNames{j})(1,:)>0;
            if sum(chanInd)>0
                plot(j,mean(firingRateStruct.(mazeLocFieldNames{j})(:,chanInd),2),'o');
            end
            titleText = [titleText ',' cellTypeLabels(k) '=' num2str(sum(chanInd))];
            ylabel(selAnatRegions{m})
            %if m==1 & k==1
            %    text(fo(end),0-j*diff(get(gca,'ylim'))/2,mazeLocFieldNames{j},'color',plotColors(j))
            %end
            %set(gca,'xlim',[fo(1) fo(end)],'ylim',[0.5 1.5]);
            set(gca,'xtick',[],'xlim',[0 length(mazeLocFieldNames)+1]);
            if m==length(selAnatRegions)
                text(j,0,[mazeLocFieldNames{j} ' '],'horizontalalignment','right','rotation',90)
            end
        end
        title(titleText)
    end
end


%%% plot rate2 %%%
figure
clf
cellTypeLabels = ['w' 'n']
for m=1:length(selAnatRegions)
    for k=1:length(cellTypeLabels)
        titleText = [];
        subplot(length(selAnatRegions),length(cellTypeLabels),(m-1)*length(cellTypeLabels)+k)
        hold on
        chanInd = strcmp(chanLayerVecAll,selAnatRegions{m})...
            & strcmp(cellTypesVecAll,cellTypeLabels(k));
        %                    & firingRateStruct.(mazeLocFieldNames{j})(1,:)>0;
        plot(firingRateStruct.(mazeLocFieldNames{2})(:,chanInd),firingRateStruct.(mazeLocFieldNames{1})(:,chanInd),'.');
        titleText = [titleText ',' cellTypeLabels(k) '=' num2str(sum(chanInd))];
        ylabel({selAnatRegions{m},mazeLocFieldNames{1}})
        xlabel(mazeLocFieldNames{2});
        %if m==1 & k==1
        %    text(fo(end),0-j*diff(get(gca,'ylim'))/2,mazeLocFieldNames{j},'color',plotColors(j))
        %end
        %set(gca,'xlim',[fo(1) fo(end)],'ylim',[0.5 1.5]);
        yLimits = get(gca,'ylim');
        xLimits = get(gca,'xlim');
        plot(xLimits,xLimits,'k--')
        %set(gca,'ylim',[0 yLimits(2)]);
        %set(gca,'xtick',[],'xlim',[0 length(mazeLocFieldNames)+1]);
%         if m==length(selAnatRegions)
%             text(j,0,[mazeLocFieldNames{j} ' '],'horizontalalignment','right','rotation',90)
%         end
        
        title(titleText)
    end
end

figure
clf
cellTypeLabels = ['w' 'n']
for m=1:length(selAnatRegions)
    for k=1:length(cellTypeLabels)
        titleText = [];
        for j=1:length(mazeLocFieldNames)
            subplot(length(selAnatRegions),length(cellTypeLabels),(m-1)*length(cellTypeLabels)+k)
            hold on
            chanInd = strcmp(chanLayerVecAll,selAnatRegions{m})...
                    & strcmp(cellTypesVecAll,cellTypeLabels(k));
%                    & firingRateStruct.(mazeLocFieldNames{j})(1,:)>0;
            plot(j,firingRateStruct.(mazeLocFieldNames{j})(:,chanInd),2),'o');
            titleText = [titleText ',' cellTypeLabels(k) '=' num2str(sum(chanInd))];
            ylabel(selAnatRegions{m})
            %if m==1 & k==1
            %    text(fo(end),0-j*diff(get(gca,'ylim'))/2,mazeLocFieldNames{j},'color',plotColors(j))
            %end
            %set(gca,'xlim',[fo(1) fo(end)],'ylim',[0.5 1.5]);
            yLimits = get(gca,'ylim');
            set(gca,'ylim',[0 yLimits(2)]);
            set(gca,'xtick',[],'xlim',[0 length(mazeLocFieldNames)+1]);
            if m==length(selAnatRegions)
                text(j,0,[mazeLocFieldNames{j} ' '],'horizontalalignment','right','rotation',90)
            end
        end
        title(titleText)
    end
end

iter = 1;
plot(fo,squeeze(mean(spectTrialsByCells(:,iter,:)./repmat(rateTrialsByCells(:,iter),[1,1,size(spectTrialsByCells,3)])))); title([chanLayerVec{iter} ' ' cellTypesVec(iter) ' ' num2str(cluLoc(iter,3))]); iter=iter+1;
plot(fo,squeeze(mean(spectTrialsByCells(:,iter,:)))./repmat(squeeze(mean(rateTrialsByCells(:,iter))),[size(spectTrialsByCells,3),1])); title([chanLayerVec{iter} ' ' cellTypesVec(iter) ' ' num2str(cluLoc(iter,3))]); iter=iter+1;
plot(fo,squeeze(mean(spectTrialsByCells(:,iter,:)))); title([chanLayerVec{iter} ' ' cellTypesVec(iter) ' ' num2str(cluLoc(iter,3))]); iter=iter+1;

figure
plotColors = 'bgrcmk'
cellTypeLabels = ['w' 'n']
for m=1:length(selAnatRegions)
    for j=1:length(mazeLocFieldNames)
        for k=1:length(cellTypeLabels)
            subplot(length(selAnatRegions),length(cellTypeLabels),(m-1)*length(cellTypeLabels)+k)
            hold on
            if sum(strcmp(chanLayerVecAll,selAnatRegions{m})...
                    & strcmp(cellTypesVecAll,cellTypeLabels(k)))>0
                plot(fo,squeeze(mean(firingRateStruct.(mazeLocFieldNames{j})(:,strcmp(chanLayerVecAll,selAnatRegions{m})...
                    & strcmp(cellTypesVecAll,cellTypeLabels(k)),:),2)),'color',plotColors(j));
            end
            title([cellTypeLabels(k) '=' num2str(sum(strcmp(chanLayerVecAll,selAnatRegions{m})...
                & strcmp(cellTypesVecAll,cellTypeLabels(k))))])
            ylabel(selAnatRegions{m})
            if m==1 & k==1
                text(1,0-j,mazeLocFieldNames{j},'color',plotColors(j))
            end
            set(gca,'xlim',[fo(1) fo(end)]);
%             set(gca,'xtick',[],'xlim',[0 length(mazeLocFieldNames)+1]);
%             if m==length(selAnatRegions)
%                 text(j,0,[mazeLocFieldNames{j} ' '],'horizontalalignment','right','rotation',90)
%             end
            %set(gca,'xtick',[1:length(mazeLocFieldNames)],'xticklabel',mazeLocFieldNames(:))
        end
    end
end


catFiringRate = [];
for j=1:length(mazeLocFieldNames)
    catFiringRate = cat(1,catFiringRate,firingRateStruct.(mazeLocFieldNames{j}));
end
meanFiringRate = mean(catFiringRate);
plotColors = 'bgrcmk'
cellTypeLabels = ['w' 'n']
figure
for m=1:length(selAnatRegions)
    for k=1:length(cellTypeLabels)
        subplot(length(selAnatRegions),length(cellTypeLabels),(m-1)*length(cellTypeLabels)+k)
        for j=1:length(mazeLocFieldNames)
            nPF = [];
            pfThresh = 1:0.1:7;
            selCells = strcmp(chanLayerVecAll,selAnatRegions{m})...
                & strcmp(cellTypesVecAll,cellTypeLabels(k));
            for n=pfThresh
                if sum(selCells)>0
                    nPF = cat(1,nPF,sum(firingRateStruct.(mazeLocFieldNames{j})(selCells)>n*meanFiringRate(:,selCells)));
                else
                    nPF = cat(1,nPF,0);
                end
            end
            plot(pfThresh,nPF,'color',plotColors(j))
            if m==1 & k==1
                text(max(pfThresh),0-j,mazeLocFieldNames{j},'color',plotColors(j))
            end
            ylabel(selAnatRegions{m})
            set(gca,'xlim',[1 max(pfThresh)])
            title([cellTypeLabels(k) '=' num2str(sum(strcmp(chanLayerVecAll,selAnatRegions{m})...
                & strcmp(cellTypesVecAll,cellTypeLabels(k))))])
            hold on
        end
    end
end
 
figure
cellTypeLabels = ['w' 'n']
for m=1:length(selAnatRegions)
    for j=1:length(mazeLocFieldNames)
        for k=1:length(cellTypeLabels)
            subplot(length(selAnatRegions),length(cellTypeLabels),(m-1)*length(cellTypeLabels)+k)
            hold on
            if sum(strcmp(chanLayerVecAll,selAnatRegions{m})...
                    & strcmp(cellTypesVecAll,cellTypeLabels(k)))>0
                plot(j,sum(firingRateStruct.(mazeLocFieldNames{j})(strcmp(chanLayerVecAll,selAnatRegions{m})...
                    & strcmp(cellTypesVecAll,cellTypeLabels(k))))...
                    /sum(strcmp(chanLayerVecAll,selAnatRegions{m})...
                    & strcmp(cellTypesVecAll,cellTypeLabels(k))),'o');
            end
            title([cellTypeLabels(k) '=' num2str(sum(strcmp(chanLayerVecAll,selAnatRegions{m})...
                & strcmp(cellTypesVecAll,cellTypeLabels(k))))])
            ylabel(selAnatRegions{m})
            set(gca,'xtick',[],'xlim',[0 length(mazeLocFieldNames)+1]);
            if m==length(selAnatRegions)
                text(j,0,[mazeLocFieldNames{j} ' '],'horizontalalignment','right','rotation',90)
            end
            %set(gca,'xtick',[1:length(mazeLocFieldNames)],'xticklabel',mazeLocFieldNames(:))
        end
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


figure
cellTypeLabels = ['w' 'n']
for m=1:length(selAnatRegions)
    for k=1:length(cellTypeLabels)
        popFiringRate = mean(trialsByCellsAll(:,strcmp(chanLayerVecAll,selAnatRegions{m})...
                & strcmp(cellTypesVecAll,cellTypeLabels(k))),2);
        for j=1:length(mazeLocFieldNames)
            subplot(length(selAnatRegions),length(cellTypeLabels),(m-1)*length(cellTypeLabels)+k)
            hold on
            plot([j,j],[-std(trialsByCellsAll(strcmp(mazeLocVecAll,mazeLocFieldNames{j}))),...
                std(trialsByCellsAll(strcmp(mazeLocVecAll,mazeLocFieldNames{j})))]+...
                mean(trialsByCellsAll(strcmp(mazeLocVecAll,mazeLocFieldNames{j}))),'k')
            plot(j,mean(trialsByCellsAll(strcmp(mazeLocVecAll,mazeLocFieldNames{j}))),'r')
            
            title([cellTypeLabels(k) '=' num2str(sum(strcmp(chanLayerVecAll,selAnatRegions{m})...
                & strcmp(cellTypesVecAll,cellTypeLabels(k))))])
            ylabel(selAnatRegions{m})
            set(gca,'xtick',[1:length(mazeLocFieldNames)],'xticklabel',mazeLocFieldNames(:))
        end
    end
end







for a=1:length(analDirs)
    cd(analDirs{a})
fileBaseCell = LoadVar('FileInfo/AlterFiles');
spectAnalDir = 'CalcRunningSpectra12_noExp_MidPoints_MinSpeed0Win626wavParam8.eeg/';
selAnatRegions = {'mol','gran','hil','ca3Pyr'};
chanLocVersion = 'Full';
chanLoc = LoadVar(['ChanInfo/ChanLoc_' chanLocVersion '.eeg.mat']);
cellType = LoadCellTypes([fileBaseCell{1} '/' fileBaseCell{1} '.type']);
% anatNames = fieldnames(chanLoc);
% selAnat
cluLoc = load([fileBaseCell{1} '/' fileBaseCell{1} '.cluloc']);
for k=1:length(selAnatRegions)
    selInd = ismember(cluLoc(:,3),[chanLoc.(selAnatRegions{k}){:}]);
    selFetClu{k} = cluLoc(selInd,1:2);
    if a==1
        selCellType{k} = [];
    end
    selCellType{k} = cat(1,selCellType{k},cellType(selInd,3);
end

mazeLocName = LoadVar([fileBaseCell{1} '/' spectAnalDir 'mazeLocName.mat']);
for m=1:length(mazeLocFieldNames)
    for j=1:length(fileBaseCell)
        fileBase = fileBaseCell{j};
        firingRateStruct.(mazeLocFieldNames{m}){j} = [];
        firingRate = LoadVar([fileBase '/' spectAnalDir 'firingRate.mat']);
        for k=1:length(selAnatRegions)
            mazeLocFieldNames = unique(mazeLocName);
            for n=1:length(selFetClu{k})
                firingRateStruct.(mazeLocFieldNames{m}){j} = cat(1,firingRateStruct.(mazeLocFieldNames{m}){j}...
                    ,sum(firingRate.(['elec' num2str(selFetClu{k}(n,1))]).(['clu' num2str(selFetClu{k}(n,2))])...
                    (strcmp(mazeLocFieldNames{m},mazeLocName)))...
                    /sum(strcmp(mazeLocFieldNames{m},mazeLocName)));
            end
        end
    end
    if a==1
        firingRateStruct2.(mazeLocFieldNames{m}) = [];
    end
    firingRateStruct2.(mazeLocFieldNames{m}) = cat(1,firingRateStruct2.(mazeLocFieldNames{m}),...
        mean(cat(2,firingRateStruct.(mazeLocFieldNames{m}){:}),2));    
end
for m=1:length(mazeLocFieldNames)
    if a==1
        firingRateStruct2.(mazeLocFieldNames{m}) = [];
    end
    firingRateStruct2.(mazeLocFieldNames{m}) = cat(1,firingRateStruct2.(mazeLocFieldNames{m}),...
        mean(cat(2,firingRateStruct.(mazeLocFieldNames{m}){:}),2));
end
selCellType2{m} = cat(1,selCellType2{m},selCellType

figure
cellTypeLabels = ['w' 'n']
for m=1:length(selAnatRegions)
    for j=1:length(mazeLocFieldNames)
        for k=1:length(cellTypeLabels)
            subplot(length(selAnatRegions),length(cellTypeLabels),(m-1)*length(cellTypeLabels)+k)
            hold on
            plot(j,sum(firingRateStruct2.(mazeLocFieldNames{j})([selCellType2{m}{:}]==...
                cellTypeLabels(k)))/sum([selCellType2{m}{:}]==cellTypeLabels(k)),'o')
            title([cellTypeLabels(k) '=' num2str(sum([selCellType2{m}{:}]==cellTypeLabels(k)))])
            ylabel(selAnatRegions{m})
            set(gca,'xtick',[1:length(mazeLocFieldNames)],'xticklabel',mazeLocFieldNames(:))
        end
    end
end

%         for m=unique(selFetClu{k}(:,1))'
%             clu = load([fileBase '.clu.' num2str(m)]);
%             res = load([fileBase '.res.' num2str(m)]);
%             for n=[selFetClu{k}(ismember(selFetClu{k}(:,1),m),2)]'
%                 selRes = res(clu(2:end)==n);
%                 fprintf('%i,%i\n',m,n);
%             end
%         end
%     end
% end
% 

