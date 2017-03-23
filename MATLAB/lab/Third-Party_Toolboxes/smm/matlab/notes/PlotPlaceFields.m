function PlotPlaceFields(fileBaseCell)
nEl = 11;
maxClu = 6;
for m = 1:length(fileBaseCell)
    fileBase = fileBaseCell{m}
    cluLoc = load([fileBase '/' fileBase '.cluloc']);
    figure(m)
    clf
    for k=1:nEl

        elecNum = k;
        res = load([fileBase '/' fileBase '.res.' num2str(elecNum)]);
        clu = load([fileBase '/' fileBase '.clu.' num2str(elecNum)]);
        pos = load([fileBase '/' fileBase '.whl']);
        

        for j=2:clu(1)-1
            selRes = res(find(clu==j)-1);
            subplot(maxClu,nEl,(j-2)*nEl+k)
            keyboard
            PlaceField(selRes,pos);
            title(['ch: ' num2str(cluLoc(cluLoc(:,1)==k & cluLoc(:,2)==j,3))]);
        end
    end
end
