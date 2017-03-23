% function PlotUnitTrigRates(analDirs,fileNamesCell,trigRateFileName, varargin)
% tag:unit
% tag:rates
% tag:trigger

function PlotUnitTrigRates(analDirs,fileNamesCell,trigRateFileName, varargin)


[xLimits] = DefaultArgs(varargin,{[-5 5]});

cwd = pwd;
rateStruct = struct([]);
for j=1:length(analDirs)
   cd(analDirs{j})
   sumRates = [];

   fileBaseCell = LoadFileBaseCell(fileNamesCell);
   for k=1:length(fileBaseCell)
       fileBase = fileBaseCell{k};
       trigRates = LoadVar([SC(fileBase) trigRateFileName]);
       if isempty(sumRates)
           sumRates = trigRates.rates*trigRates.numEpochs;
           sumEpochs = trigRates.numEpochs;
       else
           sumRates = sumRates + trigRates.rates*trigRates.numEpochs;
           sumEpochs = sumEpochs + trigRates.numEpochs;
       end
   end
   cellTypes = LoadCellTypes([SC(fileBase) fileBase '.type' ]);
   cellLayers = LoadCellLayers([SC(fileBase) fileBase '.cellLayer' ]);
   rateStruct = UnionStructMatCat(1,rateStruct,...
       SortUnitSpec2LayerTypes(sumRates/sumEpochs,cellLayers,cellTypes));
end

to = LoadVar([SC(fileBase) trigRateFileName]);
to = to.to;

selChanCell = Struct2CellArray(LoadVar('ChanInfo/SelChan.eeg.mat'));
cd(cwd)

cellLayers = selChanCell(:,1);
cellTypes = {'w','n','x'};
% keyboard
figure
clf
for j=1:length(cellLayers)
    for k=1:length(cellTypes)
        subplot(length(cellLayers),length(cellTypes),(j-1)*length(cellTypes)+k)
        titleText = {};
        nText = [];
        if j==1 & k==2
            titleText = cat(1,{trigRateFileName},...
                {['timeWin=' num2str(trigRates.timeWin)...
                ',' 'timeBin=' num2str(trigRates.timeWin)]});
        end
        if IsBranch(rateStruct,cellLayers{j},cellTypes{k})
            
            tempRate = rateStruct.(cellLayers{j}).(cellTypes{k});
            hold on
            plot(to,mean(tempRate,1))
            plot(to,mean(tempRate,1)-std(tempRate,1)/size(tempRate,1),':')
             plot(to,mean(tempRate,1)+std(tempRate,1)/size(tempRate,1),':')
             yLimits = get(gca,'ylim');
            set(gca,'ylim',[0 yLimits(2)])
            nText = {['n=' num2str(size(tempRate,1))]};
        end
        title(SaveTheUnderscores(cat(1,titleText,nText)))
        
        set(gca,'xlim',xLimits)
%         set(gca,'xtick',[-3:3])
        if k==1
            ylabel(cellLayers{j})
        end
        if j==length(cellLayers)
            xlabel(cellTypes{k})
        end
    end
end
       
