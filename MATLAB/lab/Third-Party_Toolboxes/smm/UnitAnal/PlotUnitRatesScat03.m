function PlotUnitRatesScat03(analDirs,spectAnalDir,statsAnalFunc,analRoutine)


prevWarnSettings = SetWarnings({'off','LoadDesigVar:fileNotFound'});
% spectAnalDir = 'RemVsRun03_noExp_MinSpeed5wavParam6Win1250.eeg';
% analRoutine = 'RemVsMaze_Beh'
% statsAnalFunc = 'GlmWholeModel08';

% selAnatRegions = {'or','ca1Pyr','rad','lm','mol','gran','hil','ca3Pyr','noLayer'};
% cellTypeLabels = {'w' 'n' 'x'}

 cwd = pwd;
% datSamp = 20000;
% eegSamp = 1250;
% winLen = 626;
% normalization = 'scale';
% binSize = 3;



% rates = [];
% rates = EmptyStruct({selAnatRegions,cellTypeLabels});
% acgs = EmptyStruct({selAnatRegions,cellTypeLabels});
% ccgs = EmptyStruct({selAnatRegions,cellTypeLabels,selAnatRegions,cellTypeLabels});
rates = [];
for j=1:length(analDirs)
    cd(analDirs{j})
    load(['TrialDesig/' statsAnalFunc '/' analRoutine '.mat'])
    cellLayers = LoadCellLayers([fileBaseCell{1} '/' fileBaseCell{1} '.cellLayer']);
    cellTypes = LoadCellTypes([fileBaseCell{1} '/' fileBaseCell{1} '.type']);
    tempRate = Struct2CellArray(MeanDesigVar(1,fileBaseCell,spectAnalDir,['unitRate'],trialDesig),[],1);
    size(tempRate{1,2})
    for k=1:size(tempRate,1)
        if isempty(rates) 
            rates = tempRate;
        end
        if ~isstruct(rates{k,end})
            rates{k,end} = struct([]);
        end
       rates{k,end} = UnionStructMatCat(1,rates{k,end},SortRates2LayerTypes(tempRate{k,end},cellLayers,cellTypes));
    end
end
cd(cwd)

% 2 axis scatter plot
figure
cellLayers = {'or','ca1Pyr','rad','lm','mol','gran','hil','ca3Pyr','noLayer'};
cellTypes = {'w' 'n' 'x'}
minVal = 0;
maxVal = 1;
%cellLayers = fieldnames(rates{1,end});
for m=1:length(cellLayers)
    %cellTypes = rates{1,end}.(cellLayers{m});
    for n=1:length(cellTypes)
            subplot(length(cellLayers),length(cellTypes),(m-1)*length(cellTypes)+n)
            hold on
        if isfield(rates{1,end},cellLayers{m}) & isfield(rates{1,end}.(cellLayers{m}),cellTypes{n})
            plot(rates{1,end}.(cellLayers{m}).(cellTypes{n}),...
                rates{2,end}.(cellLayers{m}).(cellTypes{n}),'.')
            minVal = min([rates{1,end}.(cellLayers{m}).(cellTypes{n});...
                rates{2,end}.(cellLayers{m}).(cellTypes{n})]);
            maxVal = max([rates{1,end}.(cellLayers{m}).(cellTypes{n});...
                rates{2,end}.(cellLayers{m}).(cellTypes{n})]);
            minVal = minVal-.1*(maxVal-minVal);
            maxVal = maxVal+.1*(maxVal-minVal);
            
            plot([minVal maxVal],[minVal maxVal])
            title(['n=' num2str(size(rates{1,end}.(cellLayers{m}).(cellTypes{n}),1))])
        end 
        if n==1 & m==1
            title('Unit Firing Rates')
        end
        if n==1
            ylabel({cellLayers{m},rates{1,1}})
        end
        if m==length(cellLayers)
            xlabel({rates{2,1},cellTypes{n}})
        end
        set(gca,'xlim',[minVal maxVal],'ylim',[minVal maxVal])
    end
end


