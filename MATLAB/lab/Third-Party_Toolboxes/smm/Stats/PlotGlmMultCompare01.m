function PlotGlmBarh06(depVarCell,spectAnalDir,fileExt,chanLocVersion,analRoutine,varargin)

[analDirs betaXlimCell reportFigBool printFigBool statsDir saveDir bonfFactor statAlpha] = ...
    DefaultArgs(varargin,{[],[],0,0,'GlmWholeModel08','/u12/smm/public_html/NewFigs/',1,0.01});


chanInfoDir = 'ChanInfo/';

prevWarn = SetWarnings({'off','MATLAB:divideByZero'});

% depVarPoss = {...
%     'gammaCohMean60-120Hz',...
%     'gammaCohMean40-100Hz',...
%     'gammaCohMean40-120Hz',...
%     'gammaCohMean50-100Hz',...
%     'gammaCohMean50-120Hz',...
%     'thetaCohMean6-12Hz',...
%     'thetaCohPeakSelChF6-12Hz',...
%     'thetaCohMedian6-12Hz',...
%     'gammaCohMedian60-120Hz',...
%     'thetaCohPeakLMF6-12Hz',...
%     'thetaPowIntg4-12Hz',...
%     'thetaPowIntg6-12Hz',...
%     'gammaPowIntg40-100Hz',...
%     'gammaPowIntg40-120Hz',...
%     'gammaPowIntg50-100Hz',...
%     'gammaPowIntg50-120Hz',...
%     'gammaCohMean40-100Hz',...
%     'thetaCohMean4-12Hz',...
%     'thetaPhaseMean4-12Hz',...
%     'gammaPhaseMean40-100Hz',...
%     };
% 
% 
% depVarCell = intersect(depVarCell,depVarPoss);

anatNames = fieldnames(LoadVar([analDirs{1}{1} 'ChanInfo/ChanLoc_' chanLocVersion fileExt]));

for a=1:length(depVarCell)
    depVar = depVarCell{a}

    if ~isempty([strfind(depVar,'Phase') strfind(depVar,'phase')])
        depVarType = 'phase';
        selChanNames = fieldnames(LoadVar([analDirs{1}{1} 'ChanInfo/SelChan' fileExt]));
        selChanBool = 1;
    elseif ~isempty([strfind(depVar,'Coh') strfind(depVar,'coh')])
        depVarType = 'coh';
        selChanNames = fieldnames(LoadVar([analDirs{1}{1} 'ChanInfo/SelChan' fileExt]));
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
    dataStruct = GlmResultsLoad01(depVar,chanLocVersion,spectAnalDir,fileExt,analRoutine,analDirs,statsDir,selChanBool);
    dataStruct = GlmResultsCatAnimal(dataStruct,0);
    
     varNames = fieldnames(dataStruct.coeffs);
     [nLayers nSelChan] = size(dataStruct.coeffs.(varNames{1}));
%     alpha = baseAlpha/(nLayers*nSelChan);
    for b=1:nSelChan
        fileName = [depVar '_' selChanNames{b} '_barh'];

        nextFig = 1;

        %%%%%%% coeffs %%%%%%%%
        plotData = dataStruct.coeffs;
        for c=1:length(varNames)
            GlmResultsMultCompare01(plotData.(varNames{c}),anatNames,'kruskalwallis');  
            if printFigBool
                PrintSaveFig([depVarCell{a} '_' analRoutine Dot2Underscore(fileExt) '_' varNames{c} '_KW_test'],gcf-1);
                PrintSaveFig([depVarCell{a} '_' analRoutine Dot2Underscore(fileExt) '_' varNames{c} '_MultComp'],gcf);
            end                
        end
    end
end
end

