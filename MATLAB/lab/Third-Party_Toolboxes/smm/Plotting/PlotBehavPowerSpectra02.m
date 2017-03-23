function PlotBehavPowerSpectra02(depVar,fileExt,spectAnalBase,analRoutine,varargin)
[holdOnBool,plotColors,analDirs,glmVersion,midPointsBool,minSpeed,winLength,wavParam] ...
    = DefaultArgs(varargin,{1,[0 0 0;1 0 0;0 1 0;0 0 1;1 0 1;0.5 0.5 0.5],{[pwd '/']},'GlmWholeModel08',1,0,626,8});
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
if midPointsBool
    midPointsText = '_MidPoints';
else
    midPointsText = [];
end

dirName = [spectAnalBase midPointsText '_MinSpeed' num2str(minSpeed) 'Win' num2str(winLength) 'wavParam' num2str(wavParam) fileExt];

load(['TrialDesig/' glmVersion '/' analRoutine '.mat'])
fileName = ParseStructName(depVar);

files = MatStruct2StructMat(dir('sm96*'),'name');

depCell = Struct2CellArray(LoadDesigVar(intersect(fileBaseCell,files.name),dirName,[depVar '.yo'],trialDesig),[],1);
foCell = Struct2CellArray(LoadDesigInfo(intersect(fileBaseCell,files.name),dirName,[depVar '.fo'],trialDesig),[],1);
for j=1:size(foCell,1)
    try fo = foCell{j,end}(1,:);
        break
    end
end

figure
for j=1:size(selChansCell,1)
    %     subplot(size(selChansCell,1),1,j)
    subplot(size(selChansCell,1),1,(j-1)*2+1)
    %figure(j)
    if ~holdOnBool
        clf
    end
    hold on
    for k=1:size(depCell,1)
        temp = cat(1,depCell{:,2});
        try plot(fo,squeeze(mean(temp(:,selChansCell{j,2},:))),'color',k,'linewidth',2);
            %text(100,yLimits(2)-k*5,[depCell{k,1:end-1}],'color',plotColors(k,:));
        end
        %         plot(fo,squeeze(mean(depCell{k,2}(:,selChansCell{j,2},:))...
        %             -std(depCell{k,2}(:,selChansCell{j,2},:))...
        %             /(size(depCell{k,2}(:,selChansCell{j,2},:),1)-1)),':','color',plotColors(k,:));
        %         plot(fo,squeeze(mean(depCell{k,2}(:,selChansCell{j,2},:))...
        %             +std(depCell{k,2}(:,selChansCell{j,2},:))...
        %             /(size(depCell{k,2}(:,selChansCell{j,2},:),1)-1)),':','color',plotColors(k,:));

    end
    title(selChansCell{j,1})
    set(gca,'xlim',[0 140],'xtick',[0:20:160])
    set(gcf,'name',Dot2Underscore(fileExt))
    yLimits = get(gca,'ylim');
end
%  ReportFigSM(1:8,['/u12/smm/public_html/NewFigs/ForGyuri/PowSpec/' analRoutine '/'])
end
cd(cwd)

for j=1:size(selChansCell,1)
    %     subplot(size(selChansCell,1),1,j)
    subplot(size(selChansCell,1),2,(j-1)*2+2)
    %figure(j)
    if ~holdOnBool
        clf
    end
    hold on
    for k=1:size(depCell,1)
        try plot(fo,squeeze(mean(depCell{k,2}(:,selChansCell{j,2},:))),'color',plotColors(k,:),'linewidth',2);
            text(100,yLimits(2)-k*5,[depCell{k,1:end-1}],'color',plotColors(k,:));
        end
        %         plot(fo,squeeze(mean(depCell{k,2}(:,selChansCell{j,2},:))...
        %             -std(depCell{k,2}(:,selChansCell{j,2},:))...
        %             /(size(depCell{k,2}(:,selChansCell{j,2},:),1)-1)),':','color',plotColors(k,:));
        %         plot(fo,squeeze(mean(depCell{k,2}(:,selChansCell{j,2},:))...
        %             +std(depCell{k,2}(:,selChansCell{j,2},:))...
        %             /(size(depCell{k,2}(:,selChansCell{j,2},:),1)-1)),':','color',plotColors(k,:));

    end
    title(selChansCell{j,1})
    set(gca,'xlim',[0 140],'xtick',[0:20:160])
    set(gcf,'name',Dot2Underscore(fileExt))
    yLimits = get(gca,'ylim');
end
%  ReportFigSM(1:8,['/u12/smm/public_html/NewFigs/ForGyuri/PowSpec/' analRoutine '/'])
end
cd(cwd)
return