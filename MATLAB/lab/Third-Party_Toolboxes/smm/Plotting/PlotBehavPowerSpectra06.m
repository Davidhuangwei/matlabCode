% function PlotBehavPowerSpectra05(animalDirs,depVar,fileExt,spectAnalBase,analRoutine,varargin)
% [channels,figNum,holdOnBool,yLimits,plotColors,catMethod,chanLocVersion,glmVersion] ...
%     = DefaultArgs(varargin,{[],[],1,[],[0 0 0;1 0 0;0 1 0;0 0 1;1 0 1;0.5 0.5 0.5],...
%     'shank','Min','GlmWholeModel08'});
% 
function PlotBehavPowerSpectra05(animalDirs,depVar,fileExt,spectAnalBase,analRoutine,varargin)
[channels,figNum,holdOnBool,yLimits,plotColors,catMethod,chanLocVersion,glmVersion] ...
    = DefaultArgs(varargin,{[],[],1,[],[0 0 0;1 0 0;0 1 0;0 0 1;1 0 1;0.5 0.5 0.5],...
    'shank','Min','GlmWholeModel08'});
xLimit = 140;
chanDir = 'ChanInfo/';
% % fileExt = '.eeg';
% % fileExt = '_NearAveCSD1.csd';
% % fileExt = '_LinNearCSD121.csd';
cwd = pwd;
% for z=1:length(analDirs)
%     cd(analDirs{z})
% depVar = 'powSpec.yo';
cd(animalDirs{1}{1})
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
if ~isempty([strfind(depVar,'Phase') strfind(depVar,'phase')])
    depVarType = 'phase';
    selChanBool = 1;
elseif ~isempty([strfind(depVar,'Coh') strfind(depVar,'coh')])
    depVarType = 'coh';
    selChanBool = 1;
elseif ~isempty([strfind(depVar,'Pow') strfind(depVar,'pow')]);
    depVarType = 'pow';
    selChanNames = {''};
    selChanBool = 0;
else
    depVarType = 'undef';
    selChanNames = {''};
    selChanBool = 0;
end
dirName = [spectAnalBase fileExt];


load(['TrialDesig/' glmVersion '/' analRoutine '.mat'])
fileName = ParseStructName(depVar);
%  fileBaseCell = fileBaseCell(1:3);

files.name = fileBaseCell;
% files = MatStruct2StructMat(dir('sm96*'),'name');
depCellGM = Struct2CellArray(LoadSpectAnalResults01(animalDirs,spectAnalBase,fileExt,[depVar '.yo'] ,glmVersion,...
    analRoutine,selChanBool,'trial',chanLocVersion),[],1);
depCell = Struct2CellArray(LoadSpectAnalResults01(animalDirs,spectAnalBase,fileExt,[depVar '.yo'] ,glmVersion,...
    analRoutine,selChanBool,catMethod,chanLocVersion),[],1);
% depCell = Struct2CellArray(LoadDesigVar(intersect(fileBaseCell,files.name),dirName,[depVar '.yo'],trialDesig),[],1);
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

%%%%%%%% grand mean %%%%%%%%%%%%%%
for j=1:size(selChansCell,1)
    subplot(length(channels),2,(j-1)*2+1)
    hold on
    catTemp = [];
    catStdTemp = [];
    for k=1:size(depCellGM,1)
        temp = depCellGM{k,end}{j};
        catTemp = cat(1,catTemp,temp);
        catStdTemp = cat(1,catStdTemp,std(temp,[],1));
    end
    meanTemp = mean(catTemp,1);
%     stdTemp = std(catTemp,[],1);
    stdTemp = mean(catStdTemp,1)/sqrt(size(catStdTemp,1));
    if ~isempty(meanTemp)
    plot(fo,meanTemp,'k');
    plot(fo,meanTemp-stdTemp,':k');
    plot(fo,meanTemp+stdTemp,':k');
    end
    title(titles{j})
    set(gca,'xlim',[0 xLimit],'xtick',[0:20:xLimit])
    set(gcf,'name',[depVar  Dot2Underscore(fileExt)])
    if isempty(yLimits)
        yLimits = get(gca,'ylim');
    else
        set(gca,'ylim',yLimits)
    end
end
%%%%%%% each behavior %%%%%%%%%
for j=1:size(selChansCell,1)
    subplot(length(channels),2,(j-1)*2+2)
    hold on
    for k=1:size(depCell,1)
        temp = depCell{k,end}{j};
%     meanTemp = mean(temp,1);
stdTemp = [];
   if ~isempty(temp)
%      stdTemp = std(temp,[],1)/sqrt(size(temp,1));
%      keyboard
     for z=1:size(temp,2)
         stdTemp(:,z) = BsErrBars(@mean,95,100,@mean,1,temp(:,z),1);
     end
     plot(fo,stdTemp(1,:),'color',plotColors(k,:));
    plot([fo; fo],[stdTemp(2,:); stdTemp(3,:)],'color',plotColors(k,:));
%     plot(fo,meanTemp,'color',plotColors(k,:));
    text(100,yLimits(2)-k*5,[depCell{k,1:end-1}],'color',plotColors(k,:));
    
%     plot([fo; fo],[meanTemp-stdTemp; meanTemp+stdTemp],'color',plotColors(k,:));
   end
%     plot(fo,meanTemp+stdTemp,':','color',plotColors(k,:));
%     plot(fo,meanTemp-stdTemp,':','color',plotColors(k,:));
%     plot(fo,meanTemp+stdTemp,':','color',plotColors(k,:));
% %     plot(fo,meanTemp+stdTemp,':k');
    end
    title(titles{j})
    set(gca,'xlim',[0 xLimit],'xtick',[0:20:xLimit])
    set(gcf,'name',[depVar  Dot2Underscore(fileExt)])
    if isempty(yLimits)
        yLimits = get(gca,'ylim');
    else
        set(gca,'ylim',yLimits)
    end
end
cd(cwd)

% 
% 
% for j=1:length(channels)
%     subplot(length(channels),2,(j-1)*2+1)
%     %figure(j)
%     hold on
%     for k=1:size(depCell,1)
%         temp = cat(1,depCell{:,2});
%         try plot(fo,squeeze(mean(temp(:,channels(j),:))),'k','linewidth',2);
%             %text(100,yLimits(2)-k*5,[depCell{k,1:end-1}],'color',plotColors(k,:));
%         end
%     end
%     title(titles{j})
%     set(gca,'xlim',[0 140],'xtick',[0:20:160])
%     set(gcf,'name',[depVar  Dot2Underscore(fileExt)])
%     if isempty(yLimits)
%         yLimits = get(gca,'ylim');
%     else
%         set(gca,'ylim',yLimits)
%     end
% end
% %  ReportFigSM(1:8,['/u12/smm/public_html/NewFigs/ForGyuri/PowSpec/' analRoutine '/'])
% end
% cd(cwd)
% 
% for j=1:length(channels)
%     %     subplot(length(channels),1,j)
%     subplot(length(channels),2,(j-1)*2+2)
%     %figure(j)
%     hold on
%     for k=1:size(depCell,1)
%         try plot(fo,squeeze(mean(depCell{k,2}(:,channels(j),:))),'color',plotColors(k,:),'linewidth',2);
%             text(100,yLimits(2)-k*5,[depCell{k,1:end-1}],'color',plotColors(k,:));
%         end
%     end
%     title(titles{j})
%     set(gca,'xlim',[0 140],'xtick',[0:20:160])
%     set(gcf,'name',[depVar  Dot2Underscore(fileExt)])
%     if isempty(yLimits)
%         yLimits = get(gca,'ylim');
%     else
%         set(gca,'ylim',yLimits)
%     end
% end
% %  ReportFigSM(1:8,['/u12/smm/public_html/NewFigs/ForGyuri/PowSpec/'
% %  analRoutine '/'])
cd(cwd)
return