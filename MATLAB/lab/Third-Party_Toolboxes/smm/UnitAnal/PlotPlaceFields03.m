function PlotPlaceFields03(fileBaseCell,varargin)
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
        cluLoc = load([fileBase '.cluloc']);
        cellType = LoadCellTypes([fileBase '.type']);
        neuronQuality = LoadVar([fileBase '.NeuronQuality.mat']);
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

for n=1:length(trialTypes)
    figure
    set(gcf,'unit','inches')
    set(gcf,'position',[0.5 0.5 1.5*nEl maxClu])
    set(gcf,'paperposition',[0.5 0.5 1.5*nEl maxClu])
    for k=1:nEl
        for j=2:maxClu
            placeMapTemp = squeeze(sum(PlaceMap(:,n,k,j,:,:)));
            occupancyMapTemp = squeeze(sum(OccupancyMap(:,n,k,j,:,:)));
%             if n==1
%                 topRate(k,j) = max(placeMapTemp(find(occupancyMapTemp>1)));
%             end
            subplot(maxClu-1,nEl,(j-2)*nEl+k)
            PFPlot(placeMapTemp,occupancyMapTemp,topRate(k,j));
            set(gca,'xtick',[],'ytick',[])
            if k<=length(neuronQuality) & j-1<=length(neuronQuality(k).eDist)
                neuroQual = neuronQuality(k).eDist(j-1);
            else
                neuroQual = [];
            end
            title(['ch' num2str(cluLoc(cluLoc(:,1)==k & cluLoc(:,2)==j,3)) ...
                ',' cellType{cell2mat(cellType(:,1))==k & cell2mat(cellType(:,2))==j,3} ...
                ',' num2str(neuroQual)]);
            if k==1 & j==maxClu
                xlabel(trialTypes{n})
            end
        end
    end
end
catch
    keyboard
end
