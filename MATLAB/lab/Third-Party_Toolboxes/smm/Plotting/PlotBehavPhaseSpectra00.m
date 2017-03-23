function PlotBehavPhaseSpectra01(depVar,fileExt,spectAnalBase,analRoutine,varargin)
[holdOnBool,plotColors,analDirs,glmVersion] ...
    = DefaultArgs(varargin,{1,[0 0 0;1 0 0;0 1 0;0 0 1;1 0 1;0.5 0.5 0.5],{[pwd '/']},'GlmWholeModel08'});
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
for z=1:length(analDirs)
    cd(analDirs{z})
% depVar = 'powSpec.yo';
selChansCell = Struct2CellArray(LoadVar([chanDir 'SelChan' fileExt '.mat']));
% selChanNames = selChans(:,1);
% selChans = cell2mat(selChans(:,2));
selChansCell = {'ch33',33;'ch35',35;'ch37',37;'ch40',40;'ch57',57;'ch59',59;'ch61',61;'ch62',62}

dirName = [spectAnalBase  fileExt];

load(['TrialDesig/' glmVersion '/' analRoutine '.mat'])
fileName = ParseStructName(depVar);

files = MatStruct2StructMat(dir('sm96*'),'name');
   fileBaseCell = {'sm9603m2_236_s1_280';'sm9603m2_237_s1_281'}
for m=1:size(selChansCell,1)
    depCell = Struct2CellArray(LoadDesigVar(intersect(fileBaseCell,files.name),dirName,[depVar '.yo.' selChansCell{m,1}],trialDesig),[],1);
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
                plotTemp = angle(squeeze(mean(depCell{k,2}(:,selChansCell{j,2},:))));
                try plot(fo,plotTemp,'color',plotColors(k,:),'linewidth',2);
                    if m==1 & j==1
                        text(100,yLimits(2)-k*5,[depCell{k,1:end-1}],'color',plotColors(k,:));
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
            set(gca,'ylim',[-pi pi])
            set(gca,'xlim',[0 140],'xtick',[0:20:160])
            set(gcf,'name',Dot2Underscore(fileExt))
            yLimits = get(gca,'ylim');
        end
    end
    %  ReportFigSM(1:8,['/u12/smm/public_html/NewFigs/ForGyuri/PowSpec/' analRoutine '/'])
end
end
cd(cwd)
 return