% tests Cluster Correspondence measures by splitting a file in two.

%function Equiv = CluCorrespond(FileBase1, FileBase2, Tet1, Tet2)
% if nargin<4
%     Tet2 = Tet1;
% end

function Out = CluCorrespondTest(FileBase, Tet);
%	FileBase = '/u15/xaj/Awake/l21-02/n1'; Tet = 4;

if 1
    % load data
	N = 1e6; % max number of spikes to load
	
	
	AllSpk = LoadSpk([FileBase '.spk.' num2str(Tet)],4,32,N);
	AllFet = Feature(AllSpk);
	AllClu = LoadClu([FileBase '.clu.' num2str(Tet)]);
	
	nSpk = size(AllSpk,3);
	nSpk1 = floor(nSpk/2);
	nSpk2 = nSpk-nSpk1;
	
	%load stuff
	Spk1 = AllSpk(:,:,1:nSpk1);
	Spk2 = AllSpk(:,:,1+nSpk1:end);
	Clu1 = AllClu(1:nSpk1);
	Clu2 = AllClu(1+nSpk1:end);
	Fet1 = AllFet(1:nSpk1,:);
	Fet2 = AllFet(1+nSpk1:end,:);
	
	nClu1 = max(AllClu); 
    nClu2 = max(AllClu);
	nSamp = size(Spk1,2);
end	
if 1
	% compute mean spikes
    MeanFet1 = zeros(12, nClu1);
    MeanFet2 = zeros(12, nClu1);
    CovFet1 = zeros(12, 12, nClu1);
    CovFet2 = zeros(12, 12, nClu2);
    MeanSpk1 = zeros(4, nSamp, nClu1);
    MeanSpk2 = zeros(4, nSamp, nClu1);
    Good1 = [];
    Good2 = [];
    
    
    nSpkThresh = 12;
	for c1=2:nClu1
        My = find(Clu1==c1);
        if length(My)>nSpkThresh
            Good1 = [Good1 c1];
            MeanSpk1(:,:,c1) = mean(Spk1(:,:,My),3);
            StdSpk1(:,:,c1) = std(Spk1(:,:,My),0,3);
            MeanFet1(:,c1) = mean(Fet1(My,:))';
            CovFet1(:,:,c1) = cov(Fet1(My,:),1);
        end
	end
	for c2=2:nClu2
        My = find(Clu2==c2);
        if length(My)>nSpkThresh
            Good2 = [Good2 c2];
            MeanSpk2(:,:,c2) = mean(Spk2(:,:,My),3);
            StdSpk2(:,:,c2) = std(Spk2(:,:,My),0,3);
            MeanFet2(:,c2) = mean(Fet2(My,:))';
            CovFet2(:,:,c2) = cov(Fet2(My,:),1);
        end
    end
	
	top = max([MeanSpk1(:) ; MeanSpk2(:)]);
	bot = min([MeanSpk1(:) ; MeanSpk2(:)]);

end

%Scale = mean(abs([Spk1(:) ; Spk2(:)])); % scale of comparison is mean absolute wave value

% make matrix of cluster differences between groups
% according to various measures MAHALANOBIS IS CHAMPION!
for c1=Good1
    for c2 = Good2
        DiffFet = MeanFet1(:,c1) - MeanFet2(:,c2);
        Between0(c1, c2) = ...
            DiffFet' * inv(CovFet1(:,:,c1)+CovFet2(:,:,c2)) * DiffFet;
%         DiffWave = MeanSpk1(:,:,c1) - MeanSpk2(:,:,c2);
%         WaveDiff1(c1, c2) = norm(DiffWave(:),1); % 
%         WaveDiff2(c1, c2) = norm(DiffWave(:),2); % 
%         FetDiff1(c1, c2) = norm(DiffFet(:),1); % 
%         FetDiff2(c1, c2) = norm(DiffFet(:),2); % 
%         KLSum(c1, c2) = MVGKL(MeanFet1(:,c1), CovFet1(:,:,c1), MeanFet2(:,c2), CovFet2(:,:,c2)) +...
%             MVGKL(MeanFet2(:,c2), CovFet2(:,:,c2), MeanFet1(:,c1), CovFet1(:,:,c1));
%         MeanMean = (MeanFet1(:,c1)+MeanFet2(:,c2))/2;
%         MeanCov = (CovFet1(:,:,c1) + CovFet2(:,:,c2))/2;
%         LikRat(c1, c2) = ...
%             MVGLik(MeanFet1(:,c1), CovFet1(:,:,c1), MeanFet1(:,c1), CovFet1(:,:,c1)) + ...
%             MVGLik(MeanFet2(:,c2), CovFet2(:,:,c2), MeanFet2(:,c2), CovFet2(:,:,c2)) - ...
%             MVGLik(MeanFet1(:,c1), CovFet1(:,:,c1), MeanMean, MeanCov) - ...
%             MVGLik(MeanFet2(:,c2), CovFet2(:,:,c2), MeanMean, MeanCov);
    end
end

% compute differences within groups
Within0 = [];
for i1=1:length(Good1); c1 = Good1(i1);
    for i2=i1+1:length(Good1); c2 = Good1(i2);
        DiffFet = MeanFet1(:,c1) - MeanFet1(:,c2);
        Within0 = [Within0 ...
            DiffFet' * inv(CovFet1(:,:,c1)+CovFet1(:,:,c2)) * DiffFet];
    end
end
for i1=1:length(Good2); c1 = Good2(i1);
    for i2=i1+1:length(Good2); c2 = Good2(i2);
        DiffFet = MeanFet2(:,c1) - MeanFet2(:,c2);
        Within0 = [Within0 ...
            DiffFet' * inv(CovFet2(:,:,c1)+CovFet2(:,:,c2)) * DiffFet];
    end
end

% normalizing transformation
Between = Between0.^.25;
Within = Within0.^.25;

% make mean and sd for within groups
MeanWithin = mean(Within);
StdWithin = std(Within);

% now we want to associate the clusters in pairs who are each other's nearest neighbor
% find nearest neighbors of file 1 cells
[sorted index] = sort(Between(Good1,Good2),2);
Nearest1(Good1) = Good2(index(:,1)); 

% same for file 2 cells
[sorted index] = sort(Between(Good1,Good2),1);
Nearest2(Good2) = Good1(index(1,:)); 

% now match pairs which are each others nearest neighbor
Equiv = [];
for c1=Good1
    c2 = Nearest1(c1);
    if c2==0 continue; end
    if Nearest2(c2)==c1
        % we found a pair
        Equiv = [Equiv; c1 c2 Between(c1, c2) (Between(c1, c2)-MeanWithin)/StdWithin];
    end
end

figure(1);
imagescXY(Between);

figure(2);
bot = min([Between(:); Within(:)]);
top = max([Between(:); Within(:)]);
xr = bot:(top-bot)/20:top;
nb = histc(Equiv(:,3), xr);
nw = histc(Within(:), xr);
bar(xr, [nb, nw]);
shading flat
xlim([bot-1 top+1])

Equiv
fprintf('Min Within %f\n', (min(Within)-MeanWithin)/StdWithin);

pause;
return


%AllDiffs = {WaveDiff1, WaveDiff2, FetDiff1, FetDiff2, KLSum, LikRat, Mahal};

AllDiffs = {Between};

for i=1:length(AllDiffs)

    dMat = log10(AllDiffs{i});
    
	% find diagonal and off-diagnoal elements
	% get rid of cluster 1
    Good = intersect(Good1, Good2);
	No1 = dMat(Good, Good);
	DiagDist = diag(No1);
    dMat = AllDiffs{i};
	UpperInds = find(triu(ones(size(No1)),1));
	UpperDist = No1(UpperInds);
	
    bot = min([DiagDist; UpperDist]);
    top = max([DiagDist; UpperDist]);
	xr = bot:(top-bot)/20:top;
	nd = histc(DiagDist, xr);
	nu = histc(UpperDist, xr);

    figure(1)
    subplot(4,2,i);
	bar(xr, [nu, nd]);
    shading flat
    xlim([bot top])
    
    figure(2)
    subplot(4,2,i);
    imagesc(dMat);
    
    Out.DiagDist{i} = DiagDist;
    Out.UpperDist{i} = UpperDist;
    Out.dMat{i} = dMat;
    Out.t(i) = (mean(DiagDist)-mean(UpperDist)) /...
        std([DiagDist-mean(DiagDist) ; UpperDist-mean(UpperDist)]);
  
end
drawnow
Out.n1 = Accumulate(Clu1);
Out.n2 = Accumulate(Clu2);
Out.t
    
return

% THIS IS WHAT YOU CALL
CellIDs = FindCells('extra', 30, 'p', 'George');
CellIDs = mysql('select CellID FROM View WHERE eDist>30 AND FileBase NOT LIKE ''%l19%''', 'extra', '%d');
%Out = ForCells(CellIDs(216:end), 'OutG', '', 'extra', '', 'OutG = CluCorrespondTest(FileBase, ElecGpNo)');
Out = ForCells(CellIDs, 'OutG', '', 'extra', '', 'OutG = CluCorrespondTest(FileBase, ElecGpNo)');