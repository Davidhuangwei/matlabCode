function PlotPlaceCells1(fileBase)

whlData = load([fileBase '.whl']);

whlSamp = 39.065;
datSamp = 20000;

for i = 1:9
    cluData = load(['../m236-244/JudyProcessed/' fileBase(1:6) '-' fileBase(10:12) '.clu.' num2str(i)]);
    resData = load(['../m236-244/JudyProcessed/' fileBase(1:6) '-' fileBase(10:12) '.res.' num2str(i)]);
    for j = 2:cluData(1)
        clf
        plot(whlData(:,1),whlData(:,2),'.','color',[0.5 0.5 0.5])
        hold on
        cellData = resData(find(cluData(2:end)==j));
        plot(whlData(max(1,floor(cellData*whlSamp/datSamp)),1),whlData(max(1,floor(cellData*whlSamp/datSamp)),2),'r.')
        title([fileBase ' elec:' num2str(i) ' clu:' num2str(j)]);
        keyIn = input('next','s');
        if strcmp(keyIn,'n')
            return
        end
    end
end
return
    

%cell3Elec8 = res8(find(clu8(2:end)==3));
%plot(whldat(round(cell2Elec8*39.065/20000),1),whldat(round(cell2Elec8*39.065/20000),2),'.')
%'sm9603m2_240_s1_285.whl'