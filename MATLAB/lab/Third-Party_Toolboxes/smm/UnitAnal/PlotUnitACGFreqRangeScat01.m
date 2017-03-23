function PlotUnitACGFreqRangeScat01(analDirs,spectAnalDir,statsAnalFunc,...
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

acgs = [];
ccgs = [];
for j=1:length(analDirs)
    cd(analDirs{j})
    load(['TrialDesig/' statsAnalFunc '/' analRoutine '.mat'])
    cellLayers = LoadCellLayers([fileBaseCell{1} '/' fileBaseCell{1} '.cellLayer']);
    cellTypes = LoadCellTypes([fileBaseCell{1} '/' fileBaseCell{1} '.type']);
    tempCCG = Struct2CellArray(MeanDesigVar(1,fileBaseCell,spectAnalDir,...
        [freqRangeName num2str(freqRange(1)) '-' num2str(freqRange(2)) 'HzCCGBin' num2str(binSize) normalization],trialDesig),[],1);
    size(tempCCG{1,2})
    for k=1:size(tempCCG,1)
        if isempty(ccgs) 
            acgs = tempCCG;
            ccgs = tempCCG;
        end
        if ~isstruct(ccgs{k,end})
            acgs{k,end} = struct([]);
            ccgs{k,end} = struct([]);
        end
       acgs{k,end} = UnionStructMatCat(1,acgs{k,end},SortACG2LayerTypes(squeeze(tempCCG{k,end}),cellLayers,cellTypes));
      ccgs{k,end} = UnionStructMatCat(1,ccgs{k,end},SortCCG2LayerTypes(squeeze(tempCCG{k,end}),cellLayers,cellTypes));
    end
end
cd(cwd)

% 2 axis scatter plot
figure
clf
cellLayers = {'or','ca1Pyr','rad','lm','mol','gran','hil','ca3Pyr','noLayer'};
cellTypes = {'w' 'n' 'x'};
minVal = 0;
maxVal = 1;
%cellLayers = fieldnames(acgs{1,end});
for m=1:length(cellLayers)
    %cellTypes = acgs{1,end}.(cellLayers{m});
    for n=1:length(cellTypes)
            subplot(length(cellLayers),length(cellTypes),(m-1)*length(cellTypes)+n)
            hold on
        if isfield(acgs{1,end},cellLayers{m}) & isfield(acgs{1,end}.(cellLayers{m}),cellTypes{n})
            plot(acgs{1,end}.(cellLayers{m}).(cellTypes{n}),...
                acgs{2,end}.(cellLayers{m}).(cellTypes{n}),'.')
            minVal = min([acgs{1,end}.(cellLayers{m}).(cellTypes{n});...
                acgs{2,end}.(cellLayers{m}).(cellTypes{n})]);
            maxVal = max([acgs{1,end}.(cellLayers{m}).(cellTypes{n});...
                acgs{2,end}.(cellLayers{m}).(cellTypes{n})]);
            minVal = minVal-.1*(maxVal-minVal);
            maxVal = maxVal+.1*(maxVal-minVal);
            
            plot([minVal maxVal],[minVal maxVal])
            title(['n=' num2str(size(acgs{1,end}.(cellLayers{m}).(cellTypes{n}),1))])
        end 
        if n==1 & m==1
            title([freqRangeName num2str(freqRange(1)) '-' num2str(freqRange(2)) ' Unit Firing ACG'])
        end
        if n==1
            ylabel({cellLayers{m},acgs{1,1}})
        end
        if m==length(cellLayers)
            xlabel({acgs{2,1},cellTypes{n}})
        end
        set(gca,'xlim',[minVal maxVal],'ylim',[minVal maxVal])
    end
end
return


