% function PlotCohVsChanDist(depVar,fileExt,spectAnalBase,analRoutine,varargin)
% [holdOnBool,plotColors,analDirs,glmVersion] ...
%     = DefaultArgs(varargin,{1,[0 0 0;1 0 0;0 1 0;0 0 1;1 0 1;0.5 0.5 0.5],{[pwd '/']},'GlmWholeModel08'});
function PlotCohVsChanDist(animalDirs,depVar,fileExt,spectAnalBase,analRoutine,varargin)
[holdOnBool,plotColors,chanLocVersion,glmVersion] ...
    = DefaultArgs(varargin,{1,[0 0 0;1 0 0;0 1 0;0 0 1;1 0 1;0.5 0.5 0.5],...
    'Min','GlmWholeModel08'});
%analRoutine = 'CalcRunningSpectra9_noExp';
% analRoutine = 'RemVsRun_noExp';
% winLength = 1250;
% midPointsBool=0;
% %analRoutine = 'AlterGood_MR';
% analRoutine = 'RemVsRun';
% glmVersion = 'GlmWholeModel05';
chanDir = 'ChanInfo/';
% % fileExt = '.eeg';
% % fileExt = '_NearAveCSD1.csd';
% % fileExt = '_LinNearCSD121.csd';
cwd = pwd;
% for z=1:length(analDirs)
%     cd(analDirs{z})
% depVar = 'powSpec.yo';
cd(animalDirs{1}{1})
selChansCell = Struct2CellArray(LoadVar([chanDir 'SelChan' fileExt '.mat']));
% for j=1:size(selChansCell,1)
%     selChansCell{j,1} = ['ch' num2str(selChansCell{j,2})];
% end
selChanBool = 1;

load(['TrialDesig/' glmVersion '/' analRoutine '.mat'])
fileName = ParseStructName(depVar);
%  fileBaseCell = fileBaseCell(1:3);

dirName = [spectAnalBase  fileExt];

% files = MatStruct2StructMat(dir('sm96*'),'name');
files.name = fileBaseCell;
chanLocVersion

depCell = Struct2CellArray(LoadSpectAnalResults01(animalDirs,spectAnalBase,fileExt,[depVar] ,glmVersion,...
    analRoutine,selChanBool,'chan',chanLocVersion),[],1);

chanDist = LoadChanDistance02(animalDirs,fileExt,chanLocVersion);

keyboard
powCell = Struct2CellArray(LoadSpectAnalResults01(animalDirs,spectAnalBase,fileExt,['thetaPowLMPeak6-12Hz'] ,glmVersion,...
    analRoutine,0,'chan','Full'),[],1);

cohCell = Struct2CellArray(LoadSpectAnalResults01(animalDirs,spectAnalBase,fileExt,['thetaCohLMPeak6-12Hz.mol'] ,glmVersion,...
    analRoutine,0,'chan','Full'),[],1);

phaseCell = Struct2CellArray(LoadSpectAnalResults01(animalDirs,spectAnalBase,fileExt,['thetaPhaseLMPeak6-12Hz.mol'] ,glmVersion,...
    analRoutine,0,'chan','Full'),[],1);


data = [powCell{1,2}{5}, UnATanCoh(cohCell{1,2}{5}), angle(phaseCell{1,2}{5})]

                  'thetaPowLMPeak6-12Hz',...
                  'thetaCohLMPeak6-12Hz',...
                 'thetaPhaseLMPeak6-12Hz',...

clf
for k=1:size(depCell,1)
    antidiagChanDist = Antidiag(chanDist);
    antidiagDepCell = Antidiag(depCell{1,2});
    [xVals,groupedDep] = GroupData(cat(1,antidiagChanDist{:}),cat(1,antidiagDepCell{:}));
    subplot(1,size(depCell,1),k)
    if k==1
        title({depVar,fileExt,chanLocVersion,depCell{k,1}})
    else
        title(depCell{k,1})
    end
    hold on
    yVals = [];
    for j=1:length(groupedDep)
         yVals(:,j) = mean(groupedDep{j});
%        yVals(:,j) = BsErrBars(@median,95,1000,@median,1,groupedDep{j});
    end
    plot(xVals,UnATanCoh(yVals(1,:)),'k.');
    [b] = robustfit(xVals,UnATanCoh(yVals(1,:)));
    xlimits = get(gca,'xlim');
    plot([0 xlimits(2)],[b(1) b(1)+b(2)*xlimits(2)],'k','linewidth',3)
     text(xlimits(2)-0.25,b(1)+b(2)*xlimits(2)-0.01,num2str(b(2),2),'color','k');
    
    diagChanDist = diag(chanDist);
    diagDepCell = diag(depCell{1,2});    
    [xVals,groupedDep] = GroupData(cat(1,diagChanDist{:}),cat(1,diagDepCell{:}));
    subplot(1,size(depCell,1),k)
    hold on   
    yVals = [];
    for j=1:length(groupedDep)
        yVals(:,j) = mean(groupedDep{j});
%         yVals(:,j) = BsErrBars(@median,95,1000,@median,1,groupedDep{j});
    end
    plot(xVals,UnATanCoh(yVals(1,:)),'r.');
    [b] = robustfit(xVals,UnATanCoh(yVals(1,:)));
    xlimits = get(gca,'xlim');
    plot([0 xlimits(2)],[b(1) b(1)+b(2)*xlimits(2)],'r','linewidth',3)
     text(xlimits(2)-0.25,b(1)+b(2)*xlimits(2)-0.01,num2str(b(2),2),'color','r');
    xlabel('channel pair distance (mm)')
    ylabel(depVar)
end
return


keyboard
clf
for k=1:size(depCell,1)
    [xVals,yVals] = GroupData(cat(1,chanDist{:}),cat(1,depCell{1,2}{:}))
    subplot(1,size(depCell,1),k)
    hold on
    
    for m=1:size(chanDist,1)
        for n=1:size(chanDist,2)
            if m==n
                plot(chanDist{m,n},UnATanCoh(depCell{k,2}{m,n}),'r.')
            else
                plot(chanDist{m,n},UnATanCoh(depCell{k,2}{m,n}),'k.')
            end
        end
    end
end

return


for m=1:size(selChansCell,1)
    depCell = Struct2CellArray(LoadSpectAnalResults01(animalDirs,spectAnalBase,fileExt,[depVar '.yo.' selChansCell{m,1}] ,glmVersion,...
    analRoutine,selChanBool,catMethod,chanLocVersion),[],1);

    if m==3
keyboard
    end
       
% depCell = Struct2CellArray(LoadDesigVar(intersect(fileBaseCell,files.name),dirName,[depVar '.yo.' selChansCell{m,1}],trialDesig),[],1);
        foCell = Struct2CellArray(LoadDesigInfo(intersect(fileBaseCell,files.name),dirName,[depVar '.fo'],trialDesig),[],1);
        for j=1:size(foCell,1)
        try fo = foCell{j,end}(1,:);
            break
        end
    end
    for j=1:size(selChansCell,1)
        if j<=m
            %     subplot(size(selChansCell,1),1,j)
            subplot(size(selChansCell,1),size(selChansCell,1),(m-1)*size(selChansCell,1)+j)
            %figure(j)
            if ~holdOnBool
                clf
            end
            hold on
            for k=1:size(depCell,1)
                plotTemp = UnATanCoh(squeeze(mean(depCell{k,2}{j},1)));
                stdTemp = squeeze(std(UnATanCoh(depCell{k,2}{j}),1))/sqrt(size(depCell{k,2}{j},1));
%                 plotTemp = UnATanCoh(squeeze(mean(depCell{k,2}(:,selChansCell{j,2},:))));
                try 
%                     plot(fo,plotTemp,'color',plotColors(k,:),'linewidth',2);
                    plot(fo,plotTemp,'color',plotColors(k,:));
                    plot([fo; fo],[plotTemp-stdTemp; plotTemp+stdTemp],'color',plotColors(k,:));
                 
                    if m==1 & j==1
                        yLimits = get(gca,'ylim');
                        text(100,yLimits(2)-k*(yLimits(2)-yLimits(1))/size(depCell,1),[depCell{k,1:end-1}],'color',plotColors(k,:));
                    end
                end
                %         plot(fo,squeeze(mean(depCell{k,2}(:,selChansCell{j,2},:))...
                %             -std(depCell{k,2}(:,selChansCell{j,2},:))...
                %             /(size(depCell{k,2}(:,selChansCell{j,2},:),1)-1)),':','color',plotColors(k,:));
                %         plot(fo,squeeze(mean(depCell{k,2}(:,selChansCell{j,2},:))...
                %             +std(depCell{k,2}(:,selChansCell{j,2},:))...
                %             /(size(depCell{k,2}(:,selChansCell{j,2},:),1)-1)),':','color',plotColors(k,:));

            end
            if m==size(selChansCell,1)
                xlabel(selChansCell{j,1})
            end
            if j==1
                ylabel(selChansCell{m,1})
            end
            set(gca,'ylim',[0 1])
            set(gca,'xlim',[0 140],'xtick',[0:20:160])
            set(gcf,'name',[depVar Dot2Underscore(fileExt)])
            yLimits = get(gca,'ylim');
        end
    end
    %  ReportFigSM(1:8,['/u12/smm/public_html/NewFigs/ForGyuri/PowSpec/' analRoutine '/'])
end
% end
cd(cwd)
 return