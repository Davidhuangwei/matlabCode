function PlotGlmScat(chanLocVersion,depVar,dirname,inNameNote,fileExt)
chanInfoDir = 'ChanInfo/';

%dirname = 'GlmWholeModel01';
%inNameNote = 'Alter_secondRun_';
dirname = 'GlmWholeModel05';
%dirname = 'GlmPartialModel03';
%inNameNote = 'Alter_Vs_Control_EachRegion_firstRun';
%inNameNote = 'Alter_groupAnal1';
inNameNote = 'RemVsRun_thetaFreq_01';
fileExt = '.eeg';
%fileExt = '_LinNearCSD121.csd';
%fileExt = '_LinNearCSD121.csd';
%depVar = 'gammaCohMedian60-120Hz'; categMeansYlim = [-0.5 0.5]; selChan = 2;
%depVar = 'thetaCohMedian6-12Hz'; categMeansYlim = [-0.5 0.5]; selChan = 2;
%depVar = 'gammaCohMedian60-120Hz'; categMeansYlim = [-0.5 0.5]; selChan = 6;
%depVar = 'thetaCohMedian6-12Hz'; categMeansYlim = [-0.5 0.5]; selChan = 6;
%depVar = 'gammaPowIntg60-120Hz'; categMeansYlim = [-1.75 1.75]; selChan = 0;
%depVar = 'thetaPowPeak6-12Hz'; categMeansYlim = [-4 4]; selChan = 0;
depVar = 'thetaPowPeak4-12Hz'; categMeansYlim = [-4 4]; selChan = 0;

switch selChan
    case 2
        fileName = [depVar '_ref-rad'];
    case 6
        fileName = [depVar '_ref-Ca3'];
    otherwise
        fileName = depVar;
end

animalDirs = {...
              '/BEEF01/smm/sm9601_Analysis/analysis03/',...
              '/BEEF01/smm/sm9603_Analysis/analysis04/',...
              '/BEEF02/smm/sm9614_Analysis/analysis02'...
              '/BEEF02/smm/sm9608_Analysis/analysis02/',...
              };
origDir = pwd;
          
% for k=1:10
%     figure(k)
%     clf
% end
%close all
plotColors = [1 0 0;0 0 1;0 1 0;0 0 0];
for k=1:length(animalDirs)  
    fprintf('\ncd %s',animalDirs{k})
    cd(animalDirs{k})
    if selChan
        selChans = load([chanInfoDir 'SelectedChannels' fileExt '.txt']);
        selChanName = ['.ch' num2str(selChans(selChan))];
    else
        selChanName = '';
    end
    fprintf('\nLoading %s',[dirname '/' inNameNote '/' fileExt '/' depVar selChanName '.mat'])
    load([dirname '/' inNameNote '/' fileExt '/' depVar selChanName '.mat']);
    chanMat = LoadVar([chanInfoDir 'ChanMat' fileExt '.mat']);
    chanLoc = LoadVar([chanInfoDir 'ChanLoc_' chanLocVersion fileExt '.mat']);
    badChans = load([chanInfoDir 'BadChan' fileExt '.txt']);
    
    anatFields = fieldnames(chanLoc);
    for j=1:length(anatFields)
        varNames = model.varNames;
        for m=1:length(varNames);
            pVals.(GenFieldName(varNames{m})).(anatFields{j}).(animalDirs{k}(13:18)) = ...
                model.pVals(m,setdiff(chanLoc.(anatFields{j}),badChans));
        end
        varNames = model.rSqNames;
        for m=1:length(varNames);
            rSqs.(GenFieldName(varNames{m})).(anatFields{j}).(animalDirs{k}(13:18)) = ...
                model.rSq(m,setdiff(chanLoc.(anatFields{j}),badChans));
        end
        varNames = model.contVarNames;
        for m=1:length(varNames);
            coeffs.(GenFieldName(varNames{m})).(anatFields{j}).(animalDirs{k}(13:18)) = ...
                model.coeffs(m,setdiff(chanLoc.(anatFields{j}),badChans));
        end
        keyboard
        %try 
        for n = 1:length(model.categMeans)
            varNames = model.categNames{n};
            for m=1:length(varNames);
%                 categMeans{n}.(GenFieldName(varNames{m})).(anatFields{j}).(animalDirs{k}(13:18)) = ...
%                     squeeze(model.categMeans{n}(m,1,setdiff(chanLoc.(anatFields{j}),badChans))-...
%                     mean(model.categMeans{n}(:,1,setdiff(chanLoc.(anatFields{j}),badChans))));
               categMeans{n}.(GenFieldName(varNames{m})).(anatFields{j}).(animalDirs{k}(13:18)) = ...
                    squeeze(model.categMeans{n}(m,1,setdiff(chanLoc.(anatFields{j}),badChans))-...
                    mean(model.categMeans{n}(:,1,setdiff(chanLoc.(anatFields{j}),badChans))));
            end
        end
        %catch keyboard
        %end
    end
end

nextFig = 1;

%%%%% plot p-values %%%%%%
plotData = pVals;
titlesExt = 'pVals';
log10Bool = 1;
yLimits = [];
nextFig = ScatPlotHelper(nextFig,plotData,titlesExt,fileExt,log10Bool,yLimits,chanLocVersion,plotColors,fileName);
%%%%% plot rSq %%%%%%
plotData = rSqs;
titlesExt = 'rSq';
log10Bool = 0;
yLimits = [];
nextFig = ScatPlotHelper(nextFig,plotData,titlesExt,fileExt,log10Bool,yLimits,chanLocVersion,plotColors,fileName);
%%%%%%%% plot contBetas %%%%%%%%
plotData = coeffs;
titlesExt = 'beta';
log10Bool = 0;
yLimits = [];
nextFig = ScatPlotHelper(nextFig,plotData,titlesExt,fileExt,log10Bool,yLimits,chanLocVersion,plotColors,fileName);
%%%%%%%% plot categMeans %%%%%%%%
for j=1:length(categMeans)
    plotData = categMeans{j};
    titlesExt = 'categMeans';
    log10Bool = 0;
    yLimits = [categMeansYlim];
    nextFig = ScatPlotHelper(nextFig,plotData,titlesExt,fileExt,log10Bool,yLimits,chanLocVersion,plotColors,fileName);
end

%plotData = log10(model.pVals);
%plotNames = model.varNames%model.rSqNames
cd(origDir)
reportFigBool = 0;
if reportFigBool
    %fprintf('%s',[pwd '/NewFigs/' dirName])
    ReportFigSM(1:nextFig-1,Dot2Underscore(['/u12/smm/public_html/NewFigs/' dirname '/' inNameNote '/' fileExt '/']));
end

return



function nextFig = ScatPlotHelper(nextFig,plotData,titlesExt,fileExt,log10Bool,yLimits,chanLocVersion,plotColors,fileName)
resizeWinBool = 1;

% chanInfoDir = 'ChanInfo/';
% chanMat = LoadVar([chanInfoDir 'ChanMat' fileExt '.mat']);
% chanLoc = LoadVar([chanInfoDir 'ChanLoc_' chanLocVersion fileExt '.mat']);
% badChans = load([chanInfoDir 'BadChan' fileExt '.txt']);
figSizeFactor = 2.5;
figVertOffset = 0.5;
figHorzOffset = 0;

figure(nextFig)
clf
nextFig = nextFig + 1;

plotNames=fieldnames(plotData);

set(gcf,'name',fileName);
defaultAxesPosition = [0.05,0.1,0.90,0.70];
set(gcf,'DefaultAxesPosition',defaultAxesPosition);
if resizeWinBool
    set(gcf, 'Units', 'inches')
    set(gcf, 'Position', [figHorzOffset,figVertOffset,figSizeFactor*(length(plotNames)),figSizeFactor])
end

%nextFig = nextFig + 1;
%fields = fieldnames(chanLoc);
%plotNames=fieldnames(plotData);
for j=1:length(plotNames)
    subplot(1,length(plotNames),j)
    hold on
    anatNames = fieldnames(plotData.(plotNames{j}));
    for k=1:length(anatNames)
        animalNames = fieldnames(plotData.(plotNames{j}).(anatNames{k}));
        for m=1:length(animalNames)
            if ~isempty(plotData.(plotNames{j}).(anatNames{k}).(animalNames{m}))
                if log10Bool
                    plot(k,log10(plotData.(plotNames{j}).(anatNames{k}).(animalNames{m})),'o','color',plotColors(m,:));
                else
                    plot(k,plotData.(plotNames{j}).(anatNames{k}).(animalNames{m}),'o','color',plotColors(m,:));
                end
            end
        end
    end
    title(SaveTheUnderscores([plotNames{j} ' ' titlesExt]))
    set(gca,'fontsize',8,'xtick',[1:length(anatNames)],'xticklabel',anatNames)
    if ~isempty(yLimits)
        set(gca,'ylim',yLimits)
    end
end
return



fields = []
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

