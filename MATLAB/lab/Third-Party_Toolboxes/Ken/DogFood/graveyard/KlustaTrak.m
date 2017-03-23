% Equiv = KlustaTrak(FileBase1, FileBase2, Tet1, Tet2)
%
% attempts to find cells in the two cluster files which correspond
% to each other.
%
% It works by computing a distance measure between every pair of 
% clusters.  A match is postulated when there is a pair of cells
% which are each others nearest neigbors.
%
% Each row of the output array Equiv corresponds to a match.
% The array has 4 columns.  The first and second give the cluster
% numbers of the matched pair in the 2 files.  The third gives
% the distance measure of the pair.
% 
% The fourth column is an attempt at a significance value.  There's no
% point testing the hypothesis that the two clusters are identical, 
% because there's always going to be some drift.  Instead, it compares
% the distance of the matching pair to the distances of all other possible
% matches to either cell.  Do be careful about these though, because there
% will be a "multiple comparisons effect" - you are comparing a lot of pairs
% there will be a few significant ones even if there is no match.

function Equiv = KlustaTrak(FileBase1, FileBase2, Tet1, Tet2);

if nargin<4
    Tet2 = Tet1;
end

% load data
% N = 2e5; % max number of spikes to load
 
Par1 = LoadPar1([FileBase1 '.par.' num2str(Tet1)]);
Par2 = LoadPar1([FileBase2 '.par.' num2str(Tet2)]);

nSamp = Par1.WaveSamples; 
if Par2.WaveSamples~=nSamp
    error('sample numbers don''t match');
end
nCh = Par1.nSelectedChannels;
if Par2.nSelectedChannels~=nCh
    error('number of channels doesn''t match');
end
nDim = Par2.nSelectedChannels*3; % 3 PCs per channel
nSpkThresh = nDim;

if 0
	Clu1 = LoadClu([FileBase1 '.clu.' num2str(Tet1)]);
	Clu2 = LoadClu([FileBase2 '.clu.' num2str(Tet2)]);
	
	Spk1 = LoadSpk([FileBase1 '.spk.' num2str(Tet1)],nCh, nSamp,N);
	Spk2 = LoadSpk([FileBase2 '.spk.' num2str(Tet2)],nCh, nSamp,N);
	nClu1 = max(Clu1);
	nClu2 = max(Clu2);
	
	if nClu1<2 | nClu2<2
        Equiv=[];
        return
	end
	
	if length(Clu1)>N
        Clu1 = Clu1(1:N);
        fprintf('truncating file 1 at %d spikes\n', N);
	end
	if length(Clu2)>N
        Clu2 = Clu2(1:N);
        fprintf('truncating file 2 at %d spikes\n', N);
	end
	
	nSpk1 = length(Clu1);
	nSpk2 = length(Clu2);
	nSamp = size(Spk1,2);
	
	AllSpk = cat(3, Spk1, Spk2);
	AllFet = Feature(AllSpk);
	AllClu = [Clu1 ; Clu2];
	Fet1 = AllFet(1:nSpk1,:);
	Fet2 = AllFet((1:nSpk2)+nSpk1, :);
	nDim = size(AllFet,2);
	
	% compute mean spikes
	MeanFet1 = zeros(nDim, nClu1);
	MeanFet2 = zeros(nDim, nClu1);
	CovFet1 = zeros(nDim, nDim, nClu1);
	CovFet2 = zeros(nDim, nDim, nClu2);
	Good1 = [];
	Good2 = [];
	
	
	for c1=2:nClu1
        My = find(Clu1==c1);
        if length(My)>nSpkThresh
            Good1 = [Good1 c1];
            MeanFet1(:,c1) = mean(Fet1(My,:))';
            CovFet1(:,:,c1) = cov(Fet1(My,:),1);
        end
	end
	for c2=2:nClu2
        My = find(Clu2==c2);
        if length(My)>nSpkThresh
            Good2 = [Good2 c2];
            MeanFet2(:,c2) = mean(Fet2(My,:))';
            CovFet2(:,:,c2) = cov(Fet2(My,:),1);
        end
	end
end

% load in cluster shapes
Shape1 = load([FileBase1 '.canshape.' num2str(Tet1)]);
nClu1 = size(Shape1, 1);
nSpk1 = Shape1(:,1);
MeanFet1 = Shape1(:,2:1+nDim)';
CovFet1 = reshape(Shape1(:,2+nDim:1+nDim+nDim^2)', [nDim nDim nClu1]);;
Good1 = find(nSpk1(2:end)>nSpkThresh)+1;

Shape2 = load([FileBase2 '.canshape.' num2str(Tet2)]);
nClu2 = size(Shape2, 1);
nSpk2 = Shape2(:,1);
MeanFet2 = Shape2(:,2:1+nDim)';
CovFet2 = reshape(Shape2(:,2+nDim:1+nDim+nDim^2)', [nDim nDim nClu2]);
Good2 = find(nSpk2(2:end)>nSpkThresh)+1;

if isempty(Good1) | isempty(Good2)
    Equiv = [];
    return
end

% make matrix of cluster differences between groups
% according to various measures MAHALANOBIS IS CHAMPION!
for c1=Good1(:)'
    for c2 = Good2(:)';
        DiffFet = MeanFet1(:,c1) - MeanFet2(:,c2);
        Between0(c1, c2) = ...
            DiffFet' * inv(CovFet1(:,:,c1)+CovFet2(:,:,c2)) * DiffFet;
    end
end

% compute differences within groups
for i1=1:length(Good1); c1 = Good1(i1);
    for i2=i1+1:length(Good1); c2 = Good1(i2);
        DiffFet = MeanFet1(:,c1) - MeanFet1(:,c2);
        Mahal = DiffFet' * inv(CovFet1(:,:,c1)+CovFet1(:,:,c2)) * DiffFet;
        Within10(c1,c2) = Mahal;
        Within10(c2,c1) = Mahal;
    end
end
for i1=1:length(Good2); c1 = Good2(i1);
    for i2=i1+1:length(Good2); c2 = Good2(i2);
        DiffFet = MeanFet2(:,c1) - MeanFet2(:,c2);
        Mahal = DiffFet' * inv(CovFet2(:,:,c1)+CovFet2(:,:,c2)) * DiffFet;
        Within20(c1,c2) = Mahal;
        Within20(c2,c1) = Mahal;
    end
end

% normalizing transformation
TransFn = inline('x.^.25');
TransFn = 'log2';
Between = feval(TransFn, Between0);
Within1 = feval(TransFn, Within10);
Within2 = feval(TransFn, Within20);

% now we want to associate the clusters in pairs who are each other's nearest neighbor
% find nearest neighbors of file 1 cells
[sorted index] = sort(Between(Good1,Good2),2);
Nearest1(Good1) = Good2(index(:,1)); 

% same for file 2 cells
[sorted index] = sort(Between(Good1,Good2),1);
Nearest2(Good2) = Good1(index(1,:)); 

% now match pairs which are each others nearest neighbor
Equiv = [];
for c1=Good1(:)'
    c2 = Nearest1(c1);
    % check we have a nearest neighbor
    if c2==0 continue; end
    if Nearest2(c2)==c1
        
        % calculate Grubbs p-values for each pairing -
        % tests if our match is significantly better than all other possible matches
        p1 = GrubbsTest(Between(c1,Good2));
        p2 = GrubbsTest(Between(Good1, c2));
        
        % we found a pair.  To see if it's good compare to other matches of the same cells
        %Comp = [Within1(c1, setdiff(Good1,c1)) Within2(c2, setdiff(Good2,c2)) ...
        %        Between(c1, setdiff(Good2, c1)), Between(setdiff(Good1, c2), c2)'];
        % now do t test
        %[h p] = ttest2(Between(c1, c2), Comp);
        
        Equiv = [Equiv; c1 c2 Between(c1, c2) p1 p2];
    end
end

figure(1); clf
AllPts = [Between(:);Within1(:);Within2(:)];
Top = max(AllPts(find(isfinite(AllPts))));
Bot = min(AllPts(find(isfinite(AllPts))));
subplot(2,2,1); imagescXY(Between); caxis([Bot Top]); colorbar
subplot(2,2,2); imagescXY(Within2); caxis([Bot Top]); colorbar
subplot(2,2,3); imagescXY(Within1); caxis([Bot Top]); colorbar
subplot(2,2,4); AllBet = Between(Good1, Good2); hist(AllBet(:));
%Equiv

return

% let's do a Grubbs test.
for c1=Good1
    g1(c1) = GrubbsTest(Between(c1,Good2));
end    
for c2=Good2
    g2(c2) = GrubbsTest(Between(Good1,c2));
end    
