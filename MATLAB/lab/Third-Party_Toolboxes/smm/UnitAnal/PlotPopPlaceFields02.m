function PlotPopPlaceFields01(fileBaseCell,varargin)
temp.AllTrials = [1 1 1 1 1 1 1 1 1 1 1 1 1];
trialTypesBoolStruct = DefaultArgs(varargin,{temp});

try
trialTypes = fieldnames(trialTypesBoolStruct);
for n=1:length(trialTypes)
    %set(gcf,'name',trialTypes{n})
    trialTypesBool = trialTypesBoolStruct.(trialTypes{n});
%     trialTypesBool.AllTrials = [1 1 1 1 1 1 1 1 1 1 1 1 1]; %AllTrials
%     trialTypesBool.GoodTrials = [1 0 1 0 0 0 0 0 0 0 0 0 0]; %GoodTrials
%     trialTypesBool.RLAll = [0 0 1 0 0 0 1 0 0 0 1 0 0]; %RLAll
%     trialTypesBool.LRAll = [1 0 0 0 1 0 0 0 1 0 0 0 0]; %LRAll
%     trialTypesBool.RRAll = [0 1 0 0 0 1 0 0 0 1 0 0 0]; %RRAll
%     trialTypesBool.LLAll = [0 0 0 1 0 0 0 1 0 0 0 1 0]; %LLAll
%     trialTypesBool.AllCorrect = [1 0 1 0 1 0 1 0 1 0 1 0 0]; %AllCorrect
%     trialTypesBool.AllIncorrect = [0 1 0 1 0 1 0 1 0 1 0 1 0]; %AllIncorrect
    
    mazeLocBool = [1 1 1 1 1 1 1 1 1];
    for m = 1:length(fileBaseCell)
        fileBase = fileBaseCell{m}
        cd(fileBase);
        
        if n==1 & m==1
            nEl = length(dir('*.fet.*'));
            maxClu = 0;
            for k=1:nEl
                cluTemp = load([fileBase '.clu.' num2str(k)]);
                maxClu = max([maxClu cluTemp(1)]);
            end
            topRate = zeros(nEl,maxClu);
        end
        
        pos = LoadMazeTrialTypes([fileBase],trialTypesBool,mazeLocBool);
        %cluLoc = load([fileBase '.cluloc']);
        for k=1:nEl
            res = load([fileBase '.res.' num2str(k)]);
            clu = load([fileBase '.clu.' num2str(k)]);

            for j=2:clu(1)
                selRes = res(clu(2:end)==j);
                %subplot(maxClu,nEl,(j-2)*nEl+k)
                %keyboard
                [PlaceMap(m,n,k,j,:,:), OccupancyMap(m,n,k,j,:,:)] = PlaceField(selRes,pos);
            end
        end
        cd ..
    end
    for k=1:nEl
        for j=2:maxClu
            placeMapTemp = squeeze(sum(PlaceMap(:,n,k,j,:,:)));
            occupancyMapTemp = squeeze(sum(OccupancyMap(:,n,k,j,:,:)));
            topRate(k,j) = max([topRate(k,j) max(placeMapTemp(find(occupancyMapTemp>1)))]);
        end
    end
end

%chanLoc = LoadVar('ChanInfo/ChanLoc_Full.eeg.mat');
%chanLocNames = fieldnames(chanLoc);
cellType = LoadCellTypes([fileBaseCell{1} '/' fileBaseCell{1} '.type']);
neuronQuality = LoadVar([fileBaseCell{1} '/' fileBaseCell{1} '.NeuronQuality.mat']);
cellLayer = LoadCellLayers([fileBaseCell{1} '/' fileBaseCell{1} '.cellLayer']);
cellLayerNames = {...
    'or',...
    'ca1Pyr',...
    'rad',...
    'lm',...
    'mol',...
    'gran',...
    'hil',...
    'ca3Pyr',...
    'noLayer',...
    }
cellTypeLabels = {'w' 'n' 'x'};

for n=1:length(trialTypes)
    figure
    set(gcf,'unit','inches')
    set(gcf,'position',[0.5 0.5 1.5*length(cellTypeLabels) length(cellLayerNames) ])
    set(gcf,'paperposition',[0.5 0.5 1.5*length(cellTypeLabels) length(cellLayerNames)])
    for m=1:length(cellLayerNames)
        for p=1:length(cellTypeLabels)
            catPlaceMap = [];
            catOccupancyMap = [];
            counter = 0;
            for k=1:size(cellLayer,1)
                if sum(strcmp(cellLayerNames{m},cellLayer{k,3}) & strcmp(cellTypeLabels{p},cellType{k,3}))
                    %sum(cluLoc(k,3)==[chanLoc.(cellLayerNames{m}){:}])>0 & strcmp(cellTypeLabels{p},cellType{k,3})
                    catPlaceMap = cat(1,catPlaceMap,squeeze(PlaceMap(:,n,cellLayer{k,1},cellLayer{k,2},:,:)));
                    catOccupancyMap = cat(1,catOccupancyMap,squeeze(OccupancyMap(:,n,cellLayer{k,1},cellLayer{k,2},:,:)));
                    counter = counter + 1;
                end
            end
            subplot(length(cellLayerNames),length(cellTypeLabels),(m-1)*length(cellTypeLabels)+p)

            PFPlot(squeeze(sum(catPlaceMap)),squeeze(sum(catOccupancyMap)),20);
            %PFPlot(squeeze(sum(catPlaceMap)),squeeze(sum(catOccupancyMap)),topRate(cellLayer{k,1},cellLayer{k,2}));
           set(gca,'xtick',[],'ytick',[])
            if p==1
                ylabel(cellLayerNames{m})
            end
            title([cellTypeLabels{p} '=' num2str(counter)]);
            if m==length(cellLayerNames) & p==1 
                xlabel(trialTypes{n})
            end
        end
    end
end
catch
    keyboard
end
