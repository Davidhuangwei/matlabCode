function Equiv = CluCorrespond(FileBase1, FileBase2, Tet1, Tet2)

if nargin<4
    Tet2 = Tet1;
end

% FileBase1 = '/u15/xaj/Awake/l23-02/n1'; Tet1 = 2;
% FileBase2 = '/u15/xaj/Awake/l23-02/n2'; Tet2 = 2;

N = 5e5; % max number of spikes to load

%load stuff
Spk1 = LoadSpk([FileBase1 '.spk.' num2str(Tet1)],4,32,N);
Clu1 = LoadClu([FileBase1 '.clu.' num2str(Tet1)]);
Spk2 = LoadSpk([FileBase2 '.spk.' num2str(Tet2)],4,32,N);
Clu2 = LoadClu([FileBase2 '.clu.' num2str(Tet2)]);

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
nClu1 = max(Clu1);
nClu2 = max(Clu2);
nSamp = size(Spk1,2);


% OLD VERSION THAT WORKED IN FEATURE SPACE
AllSpk = cat(3, Spk1, Spk2);
AllFet = Feature(AllSpk);
AllClu = [Clu1 ; Clu2];
Fet1 = AllFet(1:nSpk1,:);
Fet2 = AllFet((1:nSpk2)+nSpk1, :);

figure(3)
subplot(1,2,1)
p1 = MGProbs(Fet1, Fet2, Clu2);
% get rid of cluster 1 probs and normalize
p1(:,1) = 0; p1 = p1./repmat(sum(p1,2),1,size(p1,2));
ErrMat1 = zeros(max(Clu1), max(Clu2));
for c=2:max(Clu1)
    ErrMat1(c,:) = mean(p1(find(Clu1==c),:));
end
imagescXY(ErrMat1); xlabel('From file 1'); ylabel('To file 2');
caxis([0 1]); colorbar

subplot(1,2,2)
ErrMat2 = zeros(max(Clu2), max(Clu1));
p2 = MGProbs(Fet2, Fet1, Clu1);
p2(:,1) = 0; p2 = p2./repmat(sum(p2,2),1,size(p2,2));
for c=2:max(Clu2)
    ErrMat2(c,:) = mean(p2(find(Clu2==c),:));
end
imagescXY(ErrMat2); xlabel('From file 2'); ylabel('To file 1');
caxis([0 1]); colorbar

% compute equivalences as when there is precisely 1 link in each direction
Thresh = 0.5;
Link1 = ErrMat1>Thresh;
Link2 = ErrMat2>Thresh;

Equiv = [];
% loop through cells of file 1
for c1=2:max(Clu1);
    % does this cell link to 1 cell, and only 1 cell link to this cell
    if sum(Link1(c1,:))==1 & sum(Link2(:,c1))==1
        % find the cell it links to
        c2 = find(Link1(c1,:));
        % does c2 only link to 1 and have 1 link to it, and does it link back to c1?
        if sum(Link1(:,c2))==1 & sum(Link2(c2,:))==1 & Link2(c2,c1)
            % yes, so add them to the list
            Equiv = [Equiv; c1 c2];
        end
    end
end

figure(3)
% compute mean spikes
for c=2:max(Clu1)
    MeanSpk1(:,:,c) = mean(Spk1(:,:,find(Clu1==c)),3);
end
for c=2:max(Clu2)
    MeanSpk2(:,:,c) = mean(Spk2(:,:,find(Clu2==c)),3);
end

top = max([MeanSpk1(:) ; MeanSpk2(:)]);
bot = min([MeanSpk1(:) ; MeanSpk2(:)]);



for e=1:4
    subplot(2,2,e)
    hold off; plot(sq(MeanSpk1(e,:,2:end)));
    hold on; plot(sq(MeanSpk2(e,:,2:end)), '--');
    xlim([1 size(MeanSpk1,2)]); ylim([bot top]);
end

