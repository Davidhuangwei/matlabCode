% function PlotBehavAnatMap03(depVar,fileExt,spectAnalDir,analRoutine,varargin)
% [colorLimits,interpFunc,glmVersion,subtractMeanBool] ...
%     = DefaultArgs(varargin,{[],'linear','GlmWholeModel08',1});
function PlotBehavAnatMap05(depVar,fileExt,spectAnalDir,analRoutine,varargin)
[colorLimits,interpFunc,glmVersion,subtractMeanBool] ...
    = DefaultArgs(varargin,{[],'linear','GlmWholeModel08',1});

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
if ~isstruct(analRoutine)
    load(['TrialDesig/' glmVersion '/' analRoutine '.mat']);
    fileName = ParseStructName(depVar);
    % fo = LoadField([fileBaseCell{1} '/' dirName '/' fileName{1} '.fo']);

    % depCell = Struct2CellArray(LoadDesigVar(fileBaseCell(1:4,:),dirName,depVar,trialDesig),[],1);
%     files = MatStruct2StructMat(dir('sm96*'),'name');
    if ~exist('fileBaseCell','var')
        fileBaseCell = mat2cell(fileBaseMat,ones(size(fileBaseMat,1),1),size(fileBaseMat,2));
    end
%     fileBaseCell = intersect(fileBaseCell,files.name);
    files.name = fileBaseCell ;
end
% fileBaseCell = fileBaseCell(1:3);
% keyboard
k=2
clf;
set(gcf,'name',depVar)
if strcmp(depVarType,'phase')
    try colormap(LoadVar('ColorMapSean6')); end
%     try colormap(LoadVar('CircularColorMap.mat')); end
else
    try colormap(LoadVar('ColorMapSean6')); end
end
if selChanBool
    try
        selChanNames = fieldnames(LoadVar([fileBaseCell{1} '/' dirName '/' depVar]));
    catch
        selChanNames = fieldnames(LoadVar(['ChanInfo/SelChan' fileExt '.mat']));
    end
else
    selChanNames = {''};
end

for k=1:length(selChanNames)
    if ~isstruct(analRoutine)
        depStruct = LoadDesigVar(cell2mat(intersect(fileBaseCell,files.name)),dirName,[depVar '.' selChanNames{k}],trialDesig);
%         depCell = Struct2CellArray(LoadDesigVar(cell2mat(intersect(fileBaseCell,files.name)),dirName,[depVar '.' selChanNames{k}],trialDesig),[],1);
    else
       depStruct = analRoutine;
    end
    if equalNbool
        depStruct = EqualizeN(depStruct);
    end
    depStruct
    depCell = Struct2CellArray(depStruct,[],1);
%  keyboard
    subplot(length(selChanNames),size(depCell,1)+1,(k-1)*(size(depCell,1)+1)+1)
    grandMean = squeeze(mean(cat(1,depCell{:,end})));
    try
        plotGrandMean = Make2DPlotMat(grandMean,chanMat,badChan,interpFunc);
    catch
        plotGrandMean = Make2DPlotMat(grandMean,chanMat,badChan);
    end
        
    if strcmp(depVarType,'coh')
        grandMean = UnATanCoh(grandMean);
        plotGrandMean = UnATanCoh(plotGrandMean);
    elseif strcmp(depVarType,'phase')
        grandMean = angle(grandMean);
        plotGrandMean = angle(plotGrandMean);
    end
   
     imagesc(plotGrandMean)
   
    if ~isempty(colorLimits)
        if iscell(colorLimits)
            if ~isempty(colorLimits{1})
                cLimits = colorLimits{1};
            else
                cLimits = [];
            end
        else
            cLimits = colorLimits;
        end
    else
         cLimits = [];
    end
    %     imagesc(Make2DPlotMat(grandMean,chanMat,badChan,interpFunc));
    
    if ~isempty(colorLimits)
        if iscell(colorLimits)
            if ~isempty(colorLimits{1})
                set(gca,'clim',colorLimits{1})
            end
        else
            set(gca,'clim',colorLimits)
        end
    end
    colorbar
    PlotAnatCurves('ChanInfo/AnatCurves.mat',size(eegChanMat),0.5-offset);
    set(gca,'xtick',[],'ytick',[])
    title('GrandMean')
%     colorbar;
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

        if ~isempty(colorLimits)
            if iscell(colorLimits)
                if length(colorLimits)>=(j+1) & ~isempty(colorLimits{j+1})
                    cLimits = colorLimits{j+1};
                else
                    cLimits = [];
                end
            else
                cLimits = colorLimits;
            end
        end

        try
%             ImageScRmNaN(Make2DPlotMat(temp,chanMat,badChan,interpFunc),cLimits);
            imagesc(Make2DPlotMat(temp,chanMat,badChan,interpFunc));
       catch
%             ImageScRmNaN(Make2DPlotMat(temp,chanMat,badChan),cLimits);
            imagesc(Make2DPlotMat(temp,chanMat,badChan));
        end
%         imagesc(Make2DPlotMat(temp,chanMat,badChan,interpFunc));
% keyboard
        PlotAnatCurves('ChanInfo/AnatCurves.mat',size(eegChanMat),0.5-offset);
        set(gca,'xtick',[],'ytick',[])
        title([depCell{j,1:end-1}])
        colorbar;
    end
end
return
