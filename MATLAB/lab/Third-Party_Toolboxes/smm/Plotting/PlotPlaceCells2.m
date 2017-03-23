function PlotPlaceCells1(fileBaseMat,electrode,cluster)

if ~exist('trialTypesBool','var') | isempty(trialTypesBool)
    trialTypesBool = [1  0  1  0  0   0   0   0   0   0   0   0  1];
                   % LR RR RL LL LRP RRP RLP LLP LRB RRB RLB LLB XP
end
if ~exist('mazeLocationsBool') | isempty(mazeLocationsBool)
    mazeLocationsBool = [1   1   1  1  1   1   1   1   1];
                      % rwp lwp  da Tj ca rga lga rra lra
end
% [1 0 1 0 0 0 0 0 0 0 0 0 0]
% [1 1 1 1 1 1 1 1 1]

whlSamp = 39.065;
datSamp = 20000;

figure(1)
clf

trialTypesBool = [1  0  1  0  0   0   0   0   0   0   0   0  1];
               % LR RR RL LL LRP RRP RLP LLP LRB RRB RLB LLB XP

subplot(1,2,1)
for i = 1:size(fileBaseMat,1)
    whlData = LoadMazeTrialTypes(fileBaseMat(i,:),trialTypesBool,mazeLocationsBool);
    plot(whlData(:,1),whlData(:,2),'.','color',[0.5 0.5 0.5])
    hold on
end
for i = 1:size(fileBaseMat,1)
    whlData = LoadMazeTrialTypes(fileBaseMat(i,:),trialTypesBool,mazeLocationsBool);
    cluData = load(['../m236-244/JudyProcessed/' fileBaseMat(i,1:6) '-' fileBaseMat(i,10:12) '.clu.' num2str(electrode)]);
    resData = load(['../m236-244/JudyProcessed/' fileBaseMat(i,1:6) '-' fileBaseMat(i,10:12) '.res.' num2str(electrode)]);
    cellData = resData(find(cluData(2:end)==cluster));
    plot(whlData(max(1,floor(cellData*whlSamp/datSamp)),1),whlData(max(1,floor(cellData*whlSamp/datSamp)),2),'r.','markersize',5)
    title(['LR (blue) RL (red): 'fileBaseMat(1,1:6) '\_' fileBaseMat(1,10:12) '-' fileBaseMat(end,10:12) ' elec:' num2str(electrode) ' clu:' num2str(cluster)]);
end


trialTypesBool = [0  0  0  0  1   0   1   0   0   0   0   0  1];
               % LR RR RL LL LRP RRP RLP LLP LRB RRB RLB LLB XP
subplot(1,2,2)
for i = 1:size(fileBaseMat,1)
    whlData = LoadMazeTrialTypes(fileBaseMat(i,:),trialTypesBool,mazeLocationsBool);
    plot(whlData(:,1),whlData(:,2),'.','color',[0.5 0.5 0.5])
    hold on
end
for i = 1:size(fileBaseMat,1)
    whlData = LoadMazeTrialTypes(fileBaseMat(i,:),trialTypesBool,mazeLocationsBool);
    cluData = load(['../m236-244/JudyProcessed/' fileBaseMat(i,1:6) '-' fileBaseMat(i,10:12) '.clu.' num2str(electrode)]);
    resData = load(['../m236-244/JudyProcessed/' fileBaseMat(i,1:6) '-' fileBaseMat(i,10:12) '.res.' num2str(electrode)]);
    cellData = resData(find(cluData(2:end)==cluster));
    plot(whlData(max(1,floor(cellData*whlSamp/datSamp)),1),whlData(max(1,floor(cellData*whlSamp/datSamp)),2),'r.','markersize',5)
    title(['LRP (blue) RLP (red): ' fileBaseMat(1,1:6) '\_' fileBaseMat(1,10:12) '-' fileBaseMat(end,10:12) ' elec:' num2str(electrode) ' clu:' num2str(cluster)]);
end
return
    
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