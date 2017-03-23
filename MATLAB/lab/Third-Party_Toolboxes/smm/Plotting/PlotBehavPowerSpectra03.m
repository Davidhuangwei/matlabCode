function PlotBehavPowerSpectra03(depVar,fileExt,spectAnalDir,analRoutine,varargin)
[channels,figNum,holdOnBool,yLimits,plotColors,analDirs,glmVersion] ...
    = DefaultArgs(varargin,{[],[],1,[],[0 0 0;1 0 0;0 1 0;0 0 1;1 0 1;0.5 0.5 0.5],{[pwd '/']},'GlmWholeModel08'});
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
if isempty(channels)
    selChansCell = Struct2CellArray(LoadVar([chanDir 'SelChan' fileExt '.mat']));
    titles = selChansCell(:,1);
    channels = [selChansCell{:,2}]';
else
    for j=1:length(channels)
        titles{j} = ['ch' num2str(channels(j))];
    end
end
% selChanNames = selChans(:,1);
% selChans = cell2mat(selChans(:,2));

dirName = [spectAnalDir fileExt];

load(['TrialDesig/' glmVersion '/' analRoutine '.mat'])
fileName = ParseStructName(depVar);

files = MatStruct2StructMat(dir('sm96*'),'name');

depCell = Struct2CellArray(LoadDesigVar(intersect(fileBaseCell,files.name),dirName,[depVar '.yo'],trialDesig),[],1);
foCell = Struct2CellArray(LoadDesigInfo(intersect(fileBaseCell,files.name),dirName,[depVar '.fo'],trialDesig),[],1);
for j=1:size(foCell,1)
    try fo = foCell{j,end}(1,:);
    end
end

if isempty(figNum)
    figure
else
    figure(figNum)
end
if ~holdOnBool
    clf
end
for j=1:length(channels)
    subplot(length(channels),2,(j-1)*2+1)
    %figure(j)
    hold on
    for k=1:size(depCell,1)
        temp = cat(1,depCell{:,2});
        try plot(fo,squeeze(mean(temp(:,channels(j),:))),'k','linewidth',2);
            %text(100,yLimits(2)-k*5,[depCell{k,1:end-1}],'color',plotColors(k,:));
        end
    end
    title(titles{j})
    set(gca,'xlim',[0 140],'xtick',[0:20:160])
    set(gcf,'name',Dot2Underscore(fileExt))
    if isempty(yLimits)
        yLimits = get(gca,'ylim');
    else
        set(gca,'ylim',yLimits)
    end
end
%  ReportFigSM(1:8,['/u12/smm/public_html/NewFigs/ForGyuri/PowSpec/' analRoutine '/'])
end
cd(cwd)

for j=1:length(channels)
    %     subplot(length(channels),1,j)
    subplot(length(channels),2,(j-1)*2+2)
    %figure(j)
    hold on
    for k=1:size(depCell,1)
        try plot(fo,squeeze(mean(depCell{k,2}(:,channels(j),:))),'color',plotColors(k,:),'linewidth',2);
            text(100,yLimits(2)-k*5,[depCell{k,1:end-1}],'color',plotColors(k,:));
        end
    end
    title(titles{j})
    set(gca,'xlim',[0 140],'xtick',[0:20:160])
    set(gcf,'name',Dot2Underscore(fileExt))
    if isempty(yLimits)
        yLimits = get(gca,'ylim');
    else
        set(gca,'ylim',yLimits)
    end
end
%  ReportFigSM(1:8,['/u12/smm/public_html/NewFigs/ForGyuri/PowSpec/'
%  analRoutine '/'])
cd(cwd)
return