function PlotGlmScat(chanLocVersion,depVar,dirname,inNameNote,fileExt)
chanInfoDir = 'ChanInfo/';

%dirname = 'GlmWholeModel01';
%inNameNote = 'Alter_secondRun_';
%dirname = 'GlmWholeModel03';
dirname = 'GlmPartialModel03';
%inNameNote = 'Alter_Vs_Control_EachRegion_firstRun';
inNameNote = 'Alter_groupAnal1';
fileExt = '.eeg';
%fileExt = '_LinNearCSD121.csd';
%fileExt = '_LinNearCSD121.csd';
%depVar = 'gammaCohMedian60-120Hz'; categMeansYlim = [-0.5 0.5]; selChan = 2;
%depVar = 'thetaCohMedian6-12Hz'; categMeansYlim = [-0.5 0.5]; selChan = 2;
depVar = 'gammaPowIntg60-120Hz'; categMeansYlim = [-1.75 1.75]; selChan = 0;
%depVar = 'thetaPowPeak6-12Hz'; categMeansYlim = [-4 4]; selChan = 0;
animalDirs = {...
              '/BEEF01/smm/sm9601_Analysis/analysis03/',...
              '/BEEF01/smm/sm9603_Analysis/analysis04/',...
              '/BEEF02/smm/sm9608_Analysis/analysis02/',...
              '/BEEF02/smm/sm9614_Analysis/analysis02'...
              };
origDir = pwd;
          
% for k=1:10
%     figure(k)
%     clf
% end
close all
key
plotColors = [1 0 0;0 0 1;0 1 0;0 0 0];
for k=1:length(animalDirs)  
    fprintf('\ncd %s',animalDirs{k})
    cd(animalDirs{k})
    if selChan
        selChans = load([chanInfoDir 'SelectedChannels' fileExt '.txt']);
        selChanName = ['.ch' num2str(selChans(2))];
    else
        selChanName = '';
    end
    fprintf('\nLoading %s',[dirname '/' inNameNote '/' fileExt '/' depVar selChanName '.mat'])
    chanMat = LoadVar([chanInfoDir 'ChanMat' fileExt '.mat']);
    chanLoc = LoadVar([chanInfoDir 'ChanLoc_' chanLocVersion fileExt '.mat']);
    badChans = load([chanInfoDir 'BadChan' fileExt '.txt']);
    
    anatFields = fieldnames(chanLoc);
    for j=1:length(anatFields)
        varNames = model.varNames;
        for m=1:length(varNames);
            pVals.(Dot2Underscore(varNames{m})).(anatFields{j}).(animalDirs{k}(13:18)) = ...
                model.pVals(:,setdiff(chanLoc.(anatFields{j}),badChans));
        end
        varNames = model.rSqNames;
        for m=1:length(varNames);
            rSqs.(Dot2Underscore(varNames{m})).(anatFields{j}).(animalDirs{k}(13:18)) = ...
                model.rSq(:,setdiff(chanLoc.(anatFields{j}),badChans));
        end
        varNames = model.coeffNames(2:length(model.contVarNames)+1);
        for m=1:length(varNames);
            coeffs.(Dot2Underscore(varNames{m})).(anatFields{j}).(animalDirs{k}(13:18)) = ...
                model.coeffs(2:length(model.contVarNames)+1,:);
        end
        for n = 1:length(model.categMeans)
            varNames = model.categNames{n};
            for m=1:length(varNames);
                categMeans{n}.(GenFieldName(varNames{m})).(anatFields{j}).(animalDirs{k}(13:18)) = ...
                    squeeze(model.categMeans{j}(:,1,:)-repmat(mean(model.categMeans{j}(:,1,:)),size(model.categMeans{j}(:,1,:),1),1));
            end
        end
    end
end


if 0
    
    %%%%% plot p-values %%%%%%
    plotData = model.pVals;
    titlesBase = [model.varNames];
    titlesExt = 'pVals';
    log10Bool = 1;
    yLimits = [];
    nextFig = ScatPlotHelper(nextFig,plotData,titlesBase,titlesExt,fileExt,log10Bool,yLimits,chanLocVersion,plotColors(k,:));
    %%%%% plot rSq %%%%%% 
    plotData = model.rSq;
    titlesBase = [model.rSqNames];
    titlesExt = 'rSq';
    log10Bool = 0;
    yLimits = [];
    nextFig = ScatPlotHelper(nextFig,plotData,titlesBase,titlesExt,fileExt,log10Bool,yLimits,chanLocVersion,plotColors(k,:));
   %%%%%%%% plot contBetas %%%%%%%%
    plotData = model.coeffs(2:length(model.contVarNames)+1,:);
    titlesBase = [model.coeffNames(2:length(model.contVarNames)+1)];
    titlesExt = 'beta';
    log10Bool = 0;
    yLimits = [];
    nextFig = ScatPlotHelper(nextFig,plotData,titlesBase,titlesExt,fileExt,log10Bool,yLimits,chanLocVersion,plotColors(k,:));
    %%%%%%%% plot categMeans %%%%%%%%
    for j=1:length(model.categMeans)
        plotData = squeeze(model.categMeans{j}(:,1,:)-repmat(mean(model.categMeans{j}(:,1,:)),size(model.categMeans{j}(:,1,:),1),1));
        titlesBase = [model.categNames{j}];
        titlesExt = 'categMeans';
        log10Bool = 0;
         yLimits = [categMeansYlim];
    nextFig = ScatPlotHelper(nextFig,plotData,titlesBase,titlesExt,fileExt,log10Bool,yLimits,chanLocVersion,plotColors(k,:));
   end
end
%plotData = log10(model.pVals);
%plotNames = model.varNames%model.rSqNames
cd(origDir)
return



function nextFig = ScatPlotHelper(nextFig,plotData,titlesBase,titlesExt,fileExt,log10Bool,yLimits,chanLocVersion,plotColor)
resizeWinBool = 1;

chanInfoDir = 'ChanInfo/';
chanMat = LoadVar([chanInfoDir 'ChanMat' fileExt '.mat']);
chanLoc = LoadVar([chanInfoDir 'ChanLoc_' chanLocVersion fileExt '.mat']);
badChans = load([chanInfoDir 'BadChan' fileExt '.txt']);
figSizeFactor = 3;
figVertOffset = 0.5;
figHorzOffset = 0;

figure(nextFig)
%clf

defaultAxesPosition = [0.05,0.1,0.90,0.70];
set(gcf,'DefaultAxesPosition',defaultAxesPosition);
if resizeWinBool
    set(gcf, 'Units', 'inches')
    set(gcf, 'Position', [figHorzOffset,figVertOffset,figSizeFactor*(size(plotData,1)),figSizeFactor])
end



nextFig = nextFig + 1;
fields = fieldnames(chanLoc);
for j=1:size(plotData,1)
    subplot(1,size(plotData,1),j)
    hold on
    for k=1:length(fields)
        if ~isempty(chanLoc.(fields{k}))
            if log10Bool
                plot(k,log10(plotData{j,setdiff(chanLoc.(fields{k}),badChans),:}),'o');
            else
                plot(k,plotData{j,setdiff(chanLoc.(fields{k}),badChans),:},'o');
            end
        end
    end
    title(SaveTheUnderscores([titlesBase(j) titlesExt]))
    set(gca,'fontsize',8,'xtick',[1:length(fields)],'xticklabel',fields)
    if ~isempty(yLimits)
        set(gca,'ylim',yLimits)
    end
end

return

