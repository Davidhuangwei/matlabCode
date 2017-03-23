function temp(chanLocVersion,inNameNote,fileExt,dirname,reportFigBool)
chanInfoDir = 'ChanInfo/';
reportFigBool = 0;

%dirname = 'GlmWholeModel01';
%inNameNote = 'Alter_secondRun_';
dirname = 'GlmWholeModel05';
%dirname = 'GlmPartialModel03';
%inNameNote = 'Alter_Vs_Control_EachRegion_firstRun';
%inNameNote = 'Alter_groupAnal1';
%inNameNote = 'RemVsThetaFreq_01';
inNameNote = 'RemVsRun_01';
%inNameNote = 'RemVsRun_allTrials_01';
%inNameNote = 'RemVsRun_thetaFreq_01';
%inNameNote = 'RemVsRun_thetaFreq_allTrials_01';
%inNameNote = 'RemVsRunXthetaFreq_01';
%inNameNote = 'RemVsRunXthetaFreq_allTrials_01';
%inNameNote = 'RemVsRun_thetaFreq_X_01';
%inNameNote = 'RemVsRun_thetaFreq_X_allTrials_01';

%inNameNote = 'RemVsRun_01';
fileExt = '.eeg';
%fileExt = '_LinNearCSD121.csd';
%fileExt = '_LinNearCSD121.csd';
%depVar = 'thetaCohMedian4-12Hz';
%depVar = 'gammaCohMedian60-120Hz';
%depVar = 'thetaPhaseMean4-12Hz';
%depVar = 'gammaPhaseMean60-120Hz';
depVarCell = {...
    'thetaCohMedian4-12Hz',...
    'gammaCohMedian60-120Hz',...
    'thetaPhaseMean4-12Hz',...
    'gammaPhaseMean60-120Hz',...
    }

    


selChanNums = 1:6
selChanNames = {'pyr1','rad','lm','mol','gran','pyr3'};
for a=1:length(depVarCell)
    depVar = depVarCell{a};
for j=1:length(selChanNums)
%    fileName = [depVar '_selChan=' num2str(selChans(j))];
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
        if selChanNums
            selChans = load([chanInfoDir 'SelectedChannels' fileExt '.txt']);
            j;
            selChanNums(j);
            selChans(selChanNums(j));
            selChanName = ['.ch' num2str(selChans(selChanNums(j)))];
        else
            selChanName = '';
        end
        fprintf('\nLoading %s',[dirname '/' inNameNote '/' fileExt '/' depVar selChanName '.mat'])
        load([dirname '/' inNameNote '/' fileExt '/' depVar selChanName '.mat']);
        chanMat = LoadVar([chanInfoDir 'ChanMat' fileExt '.mat']);
        chanLoc = LoadVar([chanInfoDir 'ChanLoc_' chanLocVersion fileExt '.mat']);
        badChans = load([chanInfoDir 'BadChan' fileExt '.txt']);

        anatFields = fieldnames(chanLoc);
        for n=1:length(anatFields)
            %%%%%%% Betas %%%%%%%%
            varNames = model.coeffNames;
            for m=1:length(varNames);
                coeffs.(GenFieldName(varNames{m})).(anatFields{n}).(animalDirs{k}(13:18)) = ...
                    model.coeffs(m,setdiff(chanLoc.(anatFields{n}),badChans))';
            end
%             keyboard
%             residNormPs.(GenFieldName(varNames{m})).(anatFields{n}).(animalDirs{k}(13:18)) = ...
%                     assumTest.residNormPs(m,setdiff(chanLoc.(anatFields{n}),badChans))';
%             residMeanPs.(GenFieldName(varNames{m})).(anatFields{n}).(animalDirs{k}(13:18)) = ...
%                     assumTest.residMeanPs(m,setdiff(chanLoc.(anatFields{n}),badChans))';
%              prllPvals.(GenFieldName(varNames{m})).(anatFields{n}).(animalDirs{k}(13:18)) = ...
%                     assumTest.prllPvals(m,setdiff(chanLoc.(anatFields{n}),badChans))';
       end
    end
    analData = coeffs;
    analNames = fieldnames(analData);
    for n=1:length(analNames)
        anatNames = fieldnames(analData.(analNames{n}));
        for k=1:length(anatNames)%length(anatNames):-1:1
            animalNames = fieldnames(analData.(analNames{n}).(anatNames{k}));
            ttestData = [];
            for m=1:length(animalNames)
                ttestData = [ttestData; analData.(analNames{n}).(anatNames{k}).(animalNames{m})];
                
            end
            if a==1 | a==2
                if n==1
                    constantMu.(analNames{n})(k,j) = mean(ttestData);
                    mu.(analNames{n})(k,j) = ((tanh(mean(ttestData))./1.999)+0.5);
                    h.(analNames{n})(k,j) = NaN;
                    p.(analNames{n})(k,j) = NaN;
                else
                    mu.(analNames{n})(k,j) = ((tanh(mean(ttestData)+constantMu.(analNames{1})(k,j))./1.999)+0.5)...
                        - ((tanh(constantMu.(analNames{1})(k,j))./1.999)+0.5);
                    [h.(analNames{n})(k,j) p.(analNames{n})(k,j)] = ttest(ttestData,[],0.01);
                end
            else
                mu.(analNames{n})(k,j) = mean(ttestData)./pi.*360;
                [h.(analNames{n})(k,j) p.(analNames{n})(k,j)] = ttest(ttestData,[],0.01);
            end
        end
    end
end
figure(a)
clf
resizeWinBool = 1;
figSizeFactor = 2.5;
figVertOffset = 0.5;
figHorzOffset = 0;

% defaultAxesPosition = [0.1,0.1,0.85,0.70];
% set(gcf,'DefaultAxesPosition',defaultAxesPosition);
set(gcf,'name',depVar)
analNames = fieldnames(analData);
if resizeWinBool
    set(gcf, 'Units', 'inches')
    set(gcf, 'Position', [figHorzOffset,figVertOffset,figSizeFactor*(length(analNames)),figSizeFactor*2])
end
for j=1:length(analNames)
    subplot(2,length(analNames),j)
    hold on
    if j==1
        ImageScMask(mu.(analNames{j}));
    else
    ImageScMask(mu.(analNames{j}),[],[-max(max(abs(mu.(analNames{j})))) max(max(abs(mu.(analNames{j}))))]);
    end
    title(SaveTheUnderscores(['Beta ' analNames{j}]),'fontsize',3);
    set(gca,'fontsize',3,'ytick',[1:length(anatNames)],'yticklabel',anatNames,'ylim',[0.5 length(anatNames)+0.5])
    set(gca,'fontsize',3,'xtick',[1:length(selChanNames)],'xticklabel',selChanNames,'xlim',[0.5 length(selChanNames)+0.5])
    plot(0:length(selChanNames)+1,1:length(anatNames),'-','color',[0.5 0.5 0.5])
    %set(gca,'ytick'
    %colorbar
        if j==1
        depVar
        text(0,-0.75,depVar)
    end
subplot(2,length(analNames),length(analNames)+j)
hold on
%    ImageScRmNaN(log10(p.(analNames{j})),[0 -5])
    ImageScMask(log10(p.(analNames{j})),[],[0 -5]);
    set(gca,'fontsize',3,'ytick',[1:length(anatNames)],'yticklabel',anatNames,'ylim',[0.5 length(anatNames)+0.5])
    set(gca,'fontsize',3,'xtick',[1:length(selChanNames)],'xticklabel',selChanNames,'xlim',[0.5 length(selChanNames)+0.5])
    title(SaveTheUnderscores(['pVal ' analNames{j}]),'fontsize',3);
        plot(0:length(selChanNames)+1,1:length(anatNames),'-','color',[0.5 0.5 0.5])
%colorbar
end
end   

%keyboard
nextFig = 1;

if 0
    cd(origDir)
    if reportFigBool
        for j=1:length(animalDirs)
            comment{j} = [animalDirs{j} ' = ' num2str(plotColors(j,:))];
        end
        ReportFigSM(1:nextFig-1,Dot2Underscore(['/u12/smm/public_html/NewFigs/' dirname '/' inNameNote '/' fileExt '/']),[],[],comment);
    end
end
return

