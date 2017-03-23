function PlotBehavAnatMap02(depVar,fileExt,spectAnalDir,analRoutine,varargin)
[colorLimits,interpFunc,glmVersion,subtractMeanBool] ...
    = DefaultArgs(varargin,{[],'linear','GlmWholeModel08',1});
% [colorLimits,interpFunc,glmVersion,midPointsBool,minSpeed,winLength] ...
%     = DefaultArgs(varargin,{[],'linear','GlmWholeModel08',1,0,626});
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

% depVar = 'powSpec.yo';
% selChansCell = Struct2CellArray(LoadVar([chanDir 'SelChan' fileExt '.mat']));
% selChanNames = selChans(:,1);
% selChans = cell2mat(selChans(:,2));
% if midPointsBool
%     midPointsText = '_MidPoints';
% else
%     midPointsText = [];
% end
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
chanMat = LoadVar(['ChanInfo/ChanMat' fileExt '.mat']);
eegChanMat = LoadVar(['ChanInfo/ChanMat' '.eeg' '.mat']);
badChan = load(['ChanInfo/BadChan' fileExt '.txt']);
offset = load(['ChanInfo/Offset' fileExt '.txt']);

dirName = [spectAnalDir fileExt];
% dirName = [spectAnalDir midPointsText '_MinSpeed' num2str(minSpeed) 'Win' num2str(winLength) fileExt];

load(['TrialDesig/' glmVersion '/' analRoutine '.mat']);
fileName = ParseStructName(depVar);
% fo = LoadField([fileBaseCell{1} '/' dirName '/' fileName{1} '.fo']);

% depCell = Struct2CellArray(LoadDesigVar(fileBaseCell(1:4,:),dirName,depVar,trialDesig),[],1);
files = MatStruct2StructMat(dir('sm96*'),'name');
if ~exist('fileBaseCell','var')
    fileBaseCell = mat2cell(fileBaseMat,ones(size(fileBaseMat,1),1),size(fileBaseMat,2));
end
fileBaseCell = intersect(fileBaseCell,files.name);

clf;
set(gcf,'name',depVar)
if strcmp(depVarType,'phase')
    try colormap(LoadVar('CircularColorMap.mat')); end
else
    try colormap(LoadVar('ColorMapSean6')); end
end
if selChanBool
    selChanNames = fieldnames(LoadVar([fileBaseCell{1} '/' dirName '/' depVar]));
    %selChanNames = fieldnames(LoadVar(['ChanInfo/SelChan' fileExt '.mat']));
else
    selChanNames = {''};
end
for k=1:length(selChanNames)
    depCell = Struct2CellArray(LoadDesigVar(cell2mat(intersect(fileBaseCell,files.name)),dirName,[depVar '.' selChanNames{k}],trialDesig),[],1);
    subplot(length(selChanNames),size(depCell,1)+1,(k-1)*(size(depCell,1)+1)+1)
    if strcmp(depVarType,'coh')
        grandMean = UnATanCoh(squeeze(mean(cat(1,depCell{:,end}))));
    elseif strcmp(depVarType,'phase')
        grandMean = angle(squeeze(mean(cat(1,depCell{:,end}))));
    else
        grandMean = squeeze(mean(cat(1,depCell{:,end})));
    end
    imagesc(Make2DPlotMat(grandMean,chanMat,badChan,interpFunc));

    if ~isempty(colorLimits)
        set(gca,'clim',colorLimits)
    end
    PlotAnatCurves('ChanInfo/AnatCurves.mat',size(eegChanMat),0.5-offset);
    set(gca,'xtick',[],'ytick',[])
    title('GrandMean')
    colorbar;
    ylabel(selChanNames{k});
    for j=1:size(depCell,1)
        subplot(length(selChanNames),size(depCell,1)+1,(k-1)*(size(depCell,1)+1)+j+1)
        if strcmp(depVarType,'coh')
            temp = UnATanCoh(squeeze(mean(depCell{j,end})));
        elseif strcmp(depVarType,'phase')
            temp = angle(squeeze(mean(depCell{j,end})));
        else
            temp = squeeze(mean(depCell{j,end}));
        end
        if subtractMeanBool
            if strcmp(depVarType,'phase')
                temp = angle(complex(cos(temp-grandMean),sin(temp-grandMean)));
            else
                temp = temp - grandMean;
            end
        end
        imagesc(Make2DPlotMat(temp,chanMat,badChan,interpFunc));

        if ~isempty(colorLimits)
            set(gca,'clim',colorLimits)
        end
        PlotAnatCurves('ChanInfo/AnatCurves.mat',size(eegChanMat),0.5-offset);
        set(gca,'xtick',[],'ytick',[])
        title([depCell{j,1:end-1}])
        colorbar;
    end
end
return
