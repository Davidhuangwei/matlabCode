%function ClustersPlot(FileBase, ElecID, ProjectDim, nSpikes)
% plots the scatterplot of one projecitons plain of Features from
% Fet file corresponding to electrode ElecID 
% nSpikes specifies how many spikes per cluster to plot (saves files size
% if you want to export it)

function ClustersPlot(FileBase, ElecID, ProjectDim, varargin)
[nSpikes] = DefaultArgs(varargin,{Inf});
Fet = LoadFet([FileBase '.fet.' num2str(ElecID)]);
Par = LoadPar([FileBase '.xml']);
UseCh = [1:3*Par.nChannels];


Clu = load([FileBase '.clu.' num2str(ElecID)]);
numClu = Clu(1);
Clu = Clu(2:end);

if isstr(ProjectDim)
    if strcmp(ProjectDim, 'pca')
        meanFet =[];
        for c=2:numClu
            meanFet = [meanFet; mean(Fet(find(Clu==c),UseCh),1)];
        end
        [pc ev explvar] = pcacov(cov(meanFet));
        NewFet = pc(:,1:2)'*Fet(:,UseCh)';
    end
    
else
    NewFet = Fet(:,ProjectDim)';
end
        
for c = 2:numClu
    mynSpk = sum(Clu==c);
    if  nSpikes> mynSpk
        SelSpks = Clu==c;
    else
        SelSpks = sort(randsample(mynSpk,nSpikes));
        mySel = find(Clu==c);
        SelSpks = mySel(SelSpks);
    end
    plot(NewFet(1,SelSpks),NewFet(2,SelSpks),'.', ...
        'Color',rand(1,3),'MarkerSize',4);
    hold on
end
    
