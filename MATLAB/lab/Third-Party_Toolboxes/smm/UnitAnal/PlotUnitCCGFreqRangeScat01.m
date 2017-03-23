function PlotUnitCCGFreqRangeScat01(analDirs,spectAnalDir,statsAnalFunc,...
    analRoutine,freqRange,freqRangeName,normalization,binSize)

prevWarnSettings = SetWarnings({'off','LoadDesigVar:fileNotFound'});
% 
% analDirs = {...
%     '/BEEF01/smm/sm9603_Analysis/3-21-04/analysis/',...
%     '/BEEF02/smm/sm9608_Analysis/7-17-04/analysis/',...
%     '/BEEF02/smm/sm9614_Analysis/4-17-05/analysis/',...
%     };

% freqRange = [4 12];
% freqRangeName = 'theta';

% spectAnalDir = 'RemVsRun03_noExp_MinSpeed5wavParam6Win1250.eeg';
% analRoutine = 'RemVsMaze_Beh'
% statsAnalFunc = 'GlmWholeModel08';

 cwd = pwd;
% datSamp = 20000;
% eegSamp = 1250;
% winLen = 626;
% normalization = 'scale';
% binSize = 3;

rates = [];
acgs = [];
ccgs = [];
for j=1:length(analDirs)
    cd(analDirs{j})
    load(['TrialDesig/' statsAnalFunc '/' analRoutine '.mat'])
    cellLayers = LoadCellLayers([fileBaseCell{1} '/' fileBaseCell{1} '.cellLayer']);
    cellTypes = LoadCellTypes([fileBaseCell{1} '/' fileBaseCell{1} '.type']);
      tempRate = Struct2CellArray(MeanDesigVar(1,fileBaseCell,spectAnalDir,...
        ['unitRate'],trialDesig),[],1);
    if strcmp(normalization,'count')
        tempCCG = Struct2CellArray(SumDesigVar(1,fileBaseCell,spectAnalDir,...
            [freqRangeName num2str(freqRange(1)) '-' num2str(freqRange(2)) 'HzCCGBin' num2str(binSize) normalization],trialDesig),[],1);
    end
    tempCCG = Struct2CellArray(MeanDesigVar(1,fileBaseCell,spectAnalDir,...
        [freqRangeName num2str(freqRange(1)) '-' num2str(freqRange(2)) 'HzCCGBin' num2str(binSize) normalization],trialDesig),[],1);
    size(tempCCG{1,2})
    for k=1:size(tempCCG,1)
        if isempty(ccgs) 
            rates = tempRate;
            acgs = tempCCG;
            ccgs = tempCCG;
        end
        if ~isstruct(ccgs{k,end})
            rates{k,end} = struct([]);
            acgs{k,end} = struct([]);
            ccgs{k,end} = struct([]);
        end
       rates{k,end} = UnionStructMatCat(1,rates{k,end},SortRates2LayerTypes(squeeze(tempRate{k,end}),cellLayers,cellTypes));
       acgs{k,end} = UnionStructMatCat(1,acgs{k,end},SortACG2LayerTypes(squeeze(tempCCG{k,end}),cellLayers,cellTypes));
      ccgs{k,end} = UnionStructMatCat(1,ccgs{k,end},SortCCG2LayerTypes(squeeze(tempCCG{k,end}),cellLayers,cellTypes));
    end
end
cd(cwd)

% 2 axis scatter plot
cellLayers = {'or','ca1Pyr','rad','gran','hil','ca3Pyr'};
cellTypes = {'w' 'n'};
% cellLayers = {'or','ca1Pyr','rad','lm','mol','gran','hil','ca3Pyr','noLayer'};
% cellTypes = {'w' 'n' 'x'};
minVal = 0;
maxVal = 1;
%cellLayers = fieldnames(acgs{1,end});
for j=1:length(cellLayers)
    %cellTypes = acgs{1,end}.(cellLayers{m});
    for k=1:length(cellTypes)
        figure
        for m=1:length(cellLayers)
            %cellTypes = acgs{1,end}.(cellLayers{m});
            for n=1:length(cellTypes)
                subplot(length(cellLayers),length(cellTypes),(m-1)*length(cellTypes)+n)
                hold on
                if isfield(ccgs{1,end},cellLayers{j}) & isfield(ccgs{1,end}.(cellLayers{j}),cellTypes{k})...
                        & isfield(ccgs{1,end}.(cellLayers{j}).(cellTypes{k}),(cellLayers{m})) ...
                        & isfield(ccgs{1,end}.(cellLayers{j}).(cellTypes{k}).(cellLayers{m}),cellTypes{n}) ...
                        & ~isempty(find(~isnan(ccgs{1,end}.(cellLayers{j}).(cellTypes{k}).(cellLayers{m}).(cellTypes{n})))) ...
                        & ~isempty(find(~isnan(ccgs{2,end}.(cellLayers{j}).(cellTypes{k}).(cellLayers{m}).(cellTypes{n}))))
                    temp1 = ccgs{1,end}.(cellLayers{j}).(cellTypes{k}).(cellLayers{m}).(cellTypes{n});
                    temp2 = ccgs{2,end}.(cellLayers{j}).(cellTypes{k}).(cellLayers{m}).(cellTypes{n});
                    %                     temp1 = temp1(~isnan(temp1));
                    %                     temp2 = temp1(~isnan(temp2));

                    plot(temp1,temp2,'.')
                    minVal = min([temp1;temp2]);
                    maxVal = max([temp1;temp2]);
                    if minVal == maxVal
                        maxVal = minVal + 1;
                    end
                    minVal = minVal-.1*(maxVal-minVal);
                    maxVal = maxVal+.1*(maxVal-minVal);
                    plot([minVal maxVal],[minVal maxVal])
                    title(['n=' num2str(size(ccgs{1,end}.(cellLayers{j}).(cellTypes{k}).(cellLayers{m}).(cellTypes{n}),1))])
                end
                if n==1 & m==1
                    title({[cellLayers{j} ',' cellTypes{k}],...
                        [freqRangeName num2str(freqRange(1)) '-' num2str(freqRange(2)) ' Unit Firing CCG']})
                end
                if n==1
                    ylabel({cellLayers{m},ccgs{1,1}})
                end
                if m==length(cellLayers)
                    xlabel({ccgs{2,1},cellTypes{n}})
                end
                set(gca,'xlim',[minVal maxVal],'ylim',[minVal maxVal])
            end
        end
    end
end

return


