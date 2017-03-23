function PlotPlaceCells1(fileBaseMat,electrode,cluster)

% [1 0 1 0 0 0 0 0 0 0 0 0 0]
% [1 1 1 1 1 1 1 1 1]
    mazeLocationsBool = [1   1   1  1  1   1   1   1   1];
                      % rwp lwp  da Tj ca rga lga rra lra
xlimits = [50 325];
ylimits = [0 250];

whlSamp = 39.065;
datSamp = 20000;

figure(1)
clf

trialTypesBool = [1  0  1  0  0   0   0   0   0   0   0   0  0];
               % LR RR RL LL LRP RRP RLP LLP LRB RRB RLB LLB XP
   
trialsMat = CountTrialTypes(fileBaseMat,1);

subplot(3,2,1)
for i = 1:size(fileBaseMat,1)
    whlData = LoadMazeTrialTypes(fileBaseMat(i,:),trialTypesBool,mazeLocationsBool,0);
    plot(whlData(:,1),whlData(:,2),'.','color',[0.75 0.75 0.75])
    hold on
end
for i = 1:size(fileBaseMat,1)
    cluData = load(['../m236-244/JudyProcessed/' fileBaseMat(i,1:6) '-' fileBaseMat(i,10:12) '.clu.' num2str(electrode)]);
    resData = load(['../m236-244/JudyProcessed/' fileBaseMat(i,1:6) '-' fileBaseMat(i,10:12) '.res.' num2str(electrode)]);
    cellData = resData(find(cluData(2:end)==cluster));
    
    trialTypesBool = [1  0  0  0  0   0   0   0   0   0   0   0  0];
                   % LR RR RL LL LRP RRP RLP LLP LRB RRB RLB LLB XP
    whlData = LoadMazeTrialTypes(fileBaseMat(i,:),trialTypesBool,mazeLocationsBool,0);
    plot(whlData(max(1,floor(cellData*whlSamp/datSamp)),1),whlData(max(1,floor(cellData*whlSamp/datSamp)),2),'b.','markersize',5)
    
    trialTypesBool = [0  0  1  0  0   0   0   0   0   0   0   0  0];
                   % LR RR RL LL LRP RRP RLP LLP LRB RRB RLB LLB XP
    whlData = LoadMazeTrialTypes(fileBaseMat(i,:),trialTypesBool,mazeLocationsBool,0);
    plot(whlData(max(1,floor(cellData*whlSamp/datSamp)),1),whlData(max(1,floor(cellData*whlSamp/datSamp)),2),'r.','markersize',5)

    title({'LR (blue) RL (red): ', ['LR n=' num2str(trialsMat(1)) ',  RL n=' num2str(trialsMat(3))], [fileBaseMat(1,1:6) '\_' fileBaseMat(1,10:12) '-' fileBaseMat(end,10:12) ' elec:' num2str(electrode) ' clu:' num2str(cluster)]});
    set(gca,'xlim',xlimits,'ylim',ylimits,'xtick',[],'ytick',[]);
end

trialTypesBool = [0  1  0  1  0   0   0   0   0   0   0   0  0];
               % LR RR RL LL LRP RRP RLP LLP LRB RRB RLB LLB XP
subplot(3,2,2)
for i = 1:size(fileBaseMat,1)
    whlData = LoadMazeTrialTypes(fileBaseMat(i,:),trialTypesBool,mazeLocationsBool,0);
    plot(whlData(:,1),whlData(:,2),'.','color',[0.75 0.75 0.75])
    hold on
end
for i = 1:size(fileBaseMat,1)
    cluData = load(['../m236-244/JudyProcessed/' fileBaseMat(i,1:6) '-' fileBaseMat(i,10:12) '.clu.' num2str(electrode)]);
    resData = load(['../m236-244/JudyProcessed/' fileBaseMat(i,1:6) '-' fileBaseMat(i,10:12) '.res.' num2str(electrode)]);
    cellData = resData(find(cluData(2:end)==cluster));
    
    trialTypesBool = [0  1  0  0  0   0   0   0   0   0   0   0  0];
                   % LR RR RL LL LRP RRP RLP LLP LRB RRB RLB LLB XP
    whlData = LoadMazeTrialTypes(fileBaseMat(i,:),trialTypesBool,mazeLocationsBool,0);
    plot(whlData(max(1,floor(cellData*whlSamp/datSamp)),1),whlData(max(1,floor(cellData*whlSamp/datSamp)),2),'b.','markersize',5)
    
    trialTypesBool = [0  0  0  1  0   0   0   0   0   0   0   0  0];
                   % LR RR RL LL LRP RRP RLP LLP LRB RRB RLB LLB XP
    whlData = LoadMazeTrialTypes(fileBaseMat(i,:),trialTypesBool,mazeLocationsBool,0);
    plot(whlData(max(1,floor(cellData*whlSamp/datSamp)),1),whlData(max(1,floor(cellData*whlSamp/datSamp)),2),'r.','markersize',5)

    title({'RR (blue) LL (red): ',['RR n=' num2str(trialsMat(2)) ',  LL n=' num2str(trialsMat(4))], [fileBaseMat(1,1:6) '\_' fileBaseMat(1,10:12) '-' fileBaseMat(end,10:12) ' elec:' num2str(electrode) ' clu:' num2str(cluster)]});
    set(gca,'xlim',xlimits,'ylim',ylimits,'xtick',[],'ytick',[]);
end


trialTypesBool = [0  0  0  0  1   0   1   0   0   0   0   0  0];
               % LR RR RL LL LRP RRP RLP LLP LRB RRB RLB LLB XP
subplot(3,2,3)
for i = 1:size(fileBaseMat,1)
    whlData = LoadMazeTrialTypes(fileBaseMat(i,:),trialTypesBool,mazeLocationsBool,0);
    plot(whlData(:,1),whlData(:,2),'.','color',[0.75 0.75 0.75])
    hold on
end
for i = 1:size(fileBaseMat,1)
    cluData = load(['../m236-244/JudyProcessed/' fileBaseMat(i,1:6) '-' fileBaseMat(i,10:12) '.clu.' num2str(electrode)]);
    resData = load(['../m236-244/JudyProcessed/' fileBaseMat(i,1:6) '-' fileBaseMat(i,10:12) '.res.' num2str(electrode)]);
    cellData = resData(find(cluData(2:end)==cluster));
    
    trialTypesBool = [0  0  0  0  1   0   0   0   0   0   0   0  0];
                   % LR RR RL LL LRP RRP RLP LLP LRB RRB RLB LLB XP
    whlData = LoadMazeTrialTypes(fileBaseMat(i,:),trialTypesBool,mazeLocationsBool,0);
    plot(whlData(max(1,floor(cellData*whlSamp/datSamp)),1),whlData(max(1,floor(cellData*whlSamp/datSamp)),2),'b.','markersize',5)
    
    trialTypesBool = [0  0  0  0  0   0   1   0   0   0   0   0  0];
                   % LR RR RL LL LRP RRP RLP LLP LRB RRB RLB LLB XP
    whlData = LoadMazeTrialTypes(fileBaseMat(i,:),trialTypesBool,mazeLocationsBool,0);
    plot(whlData(max(1,floor(cellData*whlSamp/datSamp)),1),whlData(max(1,floor(cellData*whlSamp/datSamp)),2),'r.','markersize',5)

title({'LRP (blue) RLP (red): ', ['LRP n=' num2str(trialsMat(5)) ',  RLP n=' num2str(trialsMat(7))], [fileBaseMat(1,1:6) '\_' fileBaseMat(1,10:12) '-' fileBaseMat(end,10:12) ' elec:' num2str(electrode) ' clu:' num2str(cluster)]});
    set(gca,'xlim',xlimits,'ylim',ylimits,'xtick',[],'ytick',[]);
end

trialTypesBool = [0  0  0  0  0   1   0   1   0   0   0   0  0];
               % LR RR RL LL LRP RRP RLP LLP LRB RRB RLB LLB XP
subplot(3,2,4)
for i = 1:size(fileBaseMat,1)
    whlData = LoadMazeTrialTypes(fileBaseMat(i,:),trialTypesBool,mazeLocationsBool,0);
    plot(whlData(:,1),whlData(:,2),'.','color',[0.75 0.75 0.75])
    hold on
end
for i = 1:size(fileBaseMat,1)
    cluData = load(['../m236-244/JudyProcessed/' fileBaseMat(i,1:6) '-' fileBaseMat(i,10:12) '.clu.' num2str(electrode)]);
    resData = load(['../m236-244/JudyProcessed/' fileBaseMat(i,1:6) '-' fileBaseMat(i,10:12) '.res.' num2str(electrode)]);
    cellData = resData(find(cluData(2:end)==cluster));
    
    trialTypesBool = [0  0  0  0  0   1   0   0   0   0   0   0  0];
                   % LR RR RL LL LRP RRP RLP LLP LRB RRB RLB LLB XP
    whlData = LoadMazeTrialTypes(fileBaseMat(i,:),trialTypesBool,mazeLocationsBool,0);
    plot(whlData(max(1,floor(cellData*whlSamp/datSamp)),1),whlData(max(1,floor(cellData*whlSamp/datSamp)),2),'b.','markersize',5)
    
    trialTypesBool = [0  0  0  0  0   0   0   1   0   0   0   0  0];
                   % LR RR RL LL LRP RRP RLP LLP LRB RRB RLB LLB XP
    whlData = LoadMazeTrialTypes(fileBaseMat(i,:),trialTypesBool,mazeLocationsBool,0);
    plot(whlData(max(1,floor(cellData*whlSamp/datSamp)),1),whlData(max(1,floor(cellData*whlSamp/datSamp)),2),'r.','markersize',5)

    title({'RRP (blue) LLP (red): ', ['RRP n=' num2str(trialsMat(6)) ',  LLP n=' num2str(trialsMat(8))], [fileBaseMat(1,1:6) '\_' fileBaseMat(1,10:12) '-' fileBaseMat(end,10:12) ' elec:' num2str(electrode) ' clu:' num2str(cluster)]});
    set(gca,'xlim',xlimits,'ylim',ylimits,'xtick',[],'ytick',[]);
end

trialTypesBool = [0  0  0  0  0   0   0   0   1   0   1   0  1];
               % LR RR RL LL LRP RRP RLP LLP LRB RRB RLB LLB XP
subplot(3,2,5)
for i = 1:size(fileBaseMat,1)
    whlData = LoadMazeTrialTypes(fileBaseMat(i,:),trialTypesBool,mazeLocationsBool,0);
    plot(whlData(:,1),whlData(:,2),'.','color',[0.75 0.75 0.75])
    hold on
end
for i = 1:size(fileBaseMat,1)
    cluData = load(['../m236-244/JudyProcessed/' fileBaseMat(i,1:6) '-' fileBaseMat(i,10:12) '.clu.' num2str(electrode)]);
    resData = load(['../m236-244/JudyProcessed/' fileBaseMat(i,1:6) '-' fileBaseMat(i,10:12) '.res.' num2str(electrode)]);
    cellData = resData(find(cluData(2:end)==cluster));
    
    trialTypesBool = [0  0  0  0  0   0   0   0   1   0   0   0  1];
                   % LR RR RL LL LRP RRP RLP LLP LRB RRB RLB LLB XP
    whlData = LoadMazeTrialTypes(fileBaseMat(i,:),trialTypesBool,mazeLocationsBool,0);
    plot(whlData(max(1,floor(cellData*whlSamp/datSamp)),1),whlData(max(1,floor(cellData*whlSamp/datSamp)),2),'b.','markersize',5)
    
    trialTypesBool = [0  0  0  0  0   0   0   0   0   0   1   0  1];
                   % LR RR RL LL LRP RRP RLP LLP LRB RRB RLB LLB XP
    whlData = LoadMazeTrialTypes(fileBaseMat(i,:),trialTypesBool,mazeLocationsBool,0);
    plot(whlData(max(1,floor(cellData*whlSamp/datSamp)),1),whlData(max(1,floor(cellData*whlSamp/datSamp)),2),'r.','markersize',5)

    title({'LRB (blue) RLB (red): ', ['LRB n=' num2str(trialsMat(9)) ',  RLB n=' num2str(trialsMat(11)) ',  XP n=' num2str(trialsMat(13))], [fileBaseMat(1,1:6) '\_' fileBaseMat(1,10:12) '-' fileBaseMat(end,10:12) ' elec:' num2str(electrode) ' clu:' num2str(cluster)]});
    set(gca,'xlim',xlimits,'ylim',ylimits,'xtick',[],'ytick',[]);
end

trialTypesBool = [0  0  0  0  0   0   0   0   0   1   0   1  1];
               % LR RR RL LL LRP RRP RLP LLP LRB RRB RLB LLB XP
subplot(3,2,6)
for i = 1:size(fileBaseMat,1)
    whlData = LoadMazeTrialTypes(fileBaseMat(i,:),trialTypesBool,mazeLocationsBool,0);
    plot(whlData(:,1),whlData(:,2),'.','color',[0.75 0.75 0.75])
    hold on
end
for i = 1:size(fileBaseMat,1)
    cluData = load(['../m236-244/JudyProcessed/' fileBaseMat(i,1:6) '-' fileBaseMat(i,10:12) '.clu.' num2str(electrode)]);
    resData = load(['../m236-244/JudyProcessed/' fileBaseMat(i,1:6) '-' fileBaseMat(i,10:12) '.res.' num2str(electrode)]);
    cellData = resData(find(cluData(2:end)==cluster));
    
    trialTypesBool = [0  0  0  0  0   0   0   0   0   1   0   0  1];
                   % LR RR RL LL LRP RRP RLP LLP LRB RRB RLB LLB XP
    whlData = LoadMazeTrialTypes(fileBaseMat(i,:),trialTypesBool,mazeLocationsBool,0);
    plot(whlData(max(1,floor(cellData*whlSamp/datSamp)),1),whlData(max(1,floor(cellData*whlSamp/datSamp)),2),'b.','markersize',5)
    
    trialTypesBool = [0  0  0  0  0   0   0   0   0   0   0   1  1];
                   % LR RR RL LL LRP RRP RLP LLP LRB RRB RLB LLB XP
    whlData = LoadMazeTrialTypes(fileBaseMat(i,:),trialTypesBool,mazeLocationsBool,0);
    plot(whlData(max(1,floor(cellData*whlSamp/datSamp)),1),whlData(max(1,floor(cellData*whlSamp/datSamp)),2),'r.','markersize',5)

    title({'RRB (blue) LLB (red): ', ['RRB n=' num2str(trialsMat(10)) ',  LLB n=' num2str(trialsMat(12)) ',  XP n=' num2str(trialsMat(13))], [fileBaseMat(1,1:6) '\_' fileBaseMat(1,10:12) '-' fileBaseMat(end,10:12) ' elec:' num2str(electrode) ' clu:' num2str(cluster)]});
    set(gca,'xlim',xlimits,'ylim',ylimits,'xtick',[],'ytick',[]);
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
        plot(whlData(:,1),whlData(:,2),'.','color',[0.75 0.75 0.75])
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