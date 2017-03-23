 PlotChanResCntNotes01(fileBaseCell,chanMat,Electrodes,Overwrite)

 ssh basket
addpath  /u12/antsiro/matlab/General/
addpath /u12/antsiro/matlab/draft
addpath /u12/smm/matlab/Ant

Spikes2Spikes('ec013.816_835')
NeuronQuality('ec013.816_835')
cluloc = ClusterLocation('ec013.816_835')
save('ec013.816_835.cluloc','-ascii','cluloc')
NeuroClass('ec013.816_835')
 
cluLoc = cluloc;
counts = zeros(max(cluLoc(:,3)),1);

fileBase = 'ec013.816_835'
elecNum = 0;
for j=1:size(cluLoc,1)
    if cluLoc(j,1) ~= elecNum % saves time loading files
        clu = load([fileBase '/' fileBase '.clu.' num2str(cluLoc(j,1))]);
    end
    elecNum = cluLoc(j,1);
    
    counts(cluLoc(j,3)) = counts(cluLoc(j,3)) + sum(clu(2:end) == cluLoc(j,2));
end
    
imagesc(Make2DPlotMat(counts,chanMat));
PlotChanMatText(chanMat)
set(gca,'clim',[0 30000]) 
colorbar
set(gcf,'name','ChanResCnt')

figure
numCells = Accumulate(cluLoc(:,3),1,max(cluLoc(:,3)));
imagesc(Make2DPlotMat(numCells,chanMat));
PlotChanMatText(chanMat)
colorbar
set(gcf,'name','NumCells')





% 
% totalNumSpikes
% numCells
% aveCellSize
% 
% cellSize = cell(max(cluLoc(:,3)),1);
% for j=1:size(cluLoc,1)
%     cellSize{cluLoc(j,3)} = cat(1,...
%         cellSize{cluLoc(j,3)},nq(cluLoc(j,1)).CenterMax(cluLoc(j,2)));
% end

nq = LoadVar([fileBase '/' fileBase '.NeuronQuality.mat']);
cellSize = cell(max(cluLoc(:,3)),1);
n=0;
for j=1:length(nq)
    for k=1:length(nq(j).CenterMax)
        n=n+1;
    cellSize{cluLoc(n,3)} = cat(1,...
        cellSize{cluLoc(n,3)},nq(j).CenterMax(k));
    end
end
for j=1:length(cellSize)
    cellMean(j) = mean(cellSize{j});
end
        
figure
% imagesc(flipud(Make2DPlotMat(abs(cellMean),chanMat)));
imagesc(Make2DPlotMat(abs(cellMean),chanMat));
% PlotChanMatText(flipud(chanMat))
PlotChanMatText(chanMat)
colorbar
set(gcf,'name','SpikeHeight')




cellTypes = LoadCellTypes('ec013.895_902.type');

clf
hold on
PlotChanMatText(chanMat,[],{'k'})
n=0;
plotColors = 'rgbcmy';
for j=1:length(nq)
    for k=1:length(nq(j).CenterMax)
        n=n+1;
        [a b] = find(chanMat == cluLoc(n,3));
        hold on
        if ~isempty(a)
            x = b-1/3+rand*2/3;
            y = a-1/3+rand*2/3;
            plot(x,y,'.','markersize',...
                abs(nq(j).CenterMax(k))/6,...
                'color',plotColors(mod(k,length(plotColors))+1))
            text(x,y,num2str(nq(j).FirRate(k),2),'color','w');
%             fprintf('\n%f',abs(nq(j).CenterMax(k))/6);
            
%         text(a-1/3+rand*2/3,b-1/3+rand*2/3,...
%             {[cellTypes{n,3} ':ch' num2str(cluLoc(n,3)) ':' ...
%             num2str(nq(j).FirRate(k),2)]},'fontSize',...
%             abs(nq(j).CenterMax(k))/6);
        end
    end
end
set(gca,'xlim',[0 9],'ylim',[0 9])


segs = [];
for j=1:length(remFiles)-1
     temp = load([remFiles{j} '/DentateSpikeTrigSegs_TrigExt.eeg.eeg.mat']);
    
   segs = cat(3,segs,temp.segs);
end
    pcolor(MakeBufferedPlotMat(mean(segs,3),chanMat')')
    shading interp
