function PlotPlaceFields02(fileBaseCell)
nEl = 11;
maxClu = 6;
for m = 1:length(fileBaseCell)
    fileBase = fileBaseCell{m}
    cluLoc = load([fileBase '/' fileBase '.cluloc']);
    for k=1:nEl
        res = load([fileBase '/' fileBase '.res.' num2str(k)]);
        clu = load([fileBase '/' fileBase '.clu.' num2str(k)]);
        pos = load([fileBase '/' fileBase '.whl']);
        
        for j=2:clu(1)-1
            selRes = res(find(clu==j)-1);
            %subplot(maxClu,nEl,(j-2)*nEl+k)
            %keyboard
            [PlaceMap(m,k,j,:,:), OccupancyMap(m,k,j,:,:)] = PlaceField(selRes,pos);
        end
    end
end
for k=1:nEl
    for j=2:maxClu+1
        subplot(maxClu,nEl,(j-2)*nEl+k)
        PFPlot(squeeze(sum(PlaceMap(:,k,j,:,:))), squeeze(sum(OccupancyMap(:,k,j,:,:))));
        set(gca,'xtick',[],'ytick',[])
        title(['ch: ' num2str(cluLoc(cluLoc(:,1)==k & cluLoc(:,2)==j,3))]);
    end
end

