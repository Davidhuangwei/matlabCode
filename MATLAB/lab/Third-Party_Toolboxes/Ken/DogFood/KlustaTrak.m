% Equiv = KlustaTrak(Files, p, Display)
%
% Decides which cells within specified set of files correspond to each other
%
% needs .canshape files giving the shape of the clusters in 
% Canonical Cluster Space (see MakeCanFetFiles and MakeCanShapeFiles)
% 
% Works like this for each pair of clusters, it computes mahalanobis
% distance of cluster centers (with mean covariance matrix).
% Then, for each pair of cells, computes a statistic saying whether
% cell 1 is significantly closer to cell 2 than all other cells on
% cell 1's tetrode.
%
% Then it goes through the pairs in order of significance (up to specified
% p value, and joins them together in groups.
%
% input: Files: cell array of FileBases.
% p: p-value to go up to.
% Display: if 1, will display ACGs and mean waveforms for matched groups (slow)
%
% output: Cell array. Each element is a nx3 matrix corresponding to each group
% with 1 line for each cell with cols: File1 Elec1 Clu1

function Equiv = KlustaTrak(Files, p, Display)

if nargin<2; p=0.05; end
if nargin<3; Display=1; end

nFiles = length(Files);
	
% now load cluster shapes for each cell in each file
n=0;
CluInf = [];
for f=1:nFiles
%   if findstr(Files{f}, 'l19'); continue; end
    Par = LoadPar([Files{f} '.par']);
    for e=1:Par.nElecGps
        if ~FileExists([Files{f} '.canshape.' num2str(e)]); continue; end
         Par1 = LoadPar1([Files{f} '.par.' num2str(e)]);
         d = Par1.nSelectedChannels*3;
%        if d~=12 continue; end;
         Shapes = load([Files{f} '.canshape.' num2str(e)]);
         Good = find(Shapes(2:end,1)>20)+1;
         
         for c=Good(:)'
             n=n+1;
             CluInf(n).FileNo = f;
             CluInf(n).FileBase = Files{f};
%             CluInf(n).Directory = Files{f}(1:max(findstr(Files{f},'/'))-1);
             CluInf(n).Gp = e;
             CluInf(n).CluNo = c;
             CluInf(n).nDim = d;
             CluInf(n).nSpk = Shapes(c,1);
             CluInf(n).Mean = Shapes(c,2:1+d)';
             CluInf(n).Norm = norm(CluInf(n).Mean);
             CluInf(n).Cov = reshape(Shapes(c,2+d:end), [d d]);
             CluName{n} = [Files{f} '.' num2str(e) '.' num2str(c)];
         end
     end
 end

% do pair-wise comparison
Mahal = NaN*ones(n);
Match = NaN*ones(n);
% match takes the following values:
% NaN: different number of channels or duplicate entry
% 0: different tetrodes
% 1: same tetrode, but different file
% 2: same tetrode, same file (different cluster number)
for c1=1:n
    for c2=c1+1:n
        if CluInf(c1).nDim==CluInf(c2).nDim
            DiffFet = CluInf(c1).Mean - CluInf(c2).Mean;
            Mahal(c1,c2) = DiffFet' * inv((CluInf(c1).Cov+CluInf(c2).Cov)/2) * DiffFet;
            Mahal(c2,c1) = Mahal(c1, c2);
            if CluInf(c1).Gp==CluInf(c2).Gp
                % same tetrode and directory
                Match(c1,c2) = 1+isequal(CluInf(c1).FileBase, CluInf(c2).FileBase);
            else
                Match(c1,c2) = 0;
            end
            Match(c2, c1) = Match(c1, c2);    
        else
            Mahal(c1,c2)= NaN;
            Match(c1,c2) = NaN;
        end
    end
end

% now, for each cell, find those for which match is impossible and those where it is.
tpMat = NaN*ones(n); % t p-value
for c1=1:n
    Poss = find(Match(c1,:)==1);
    PossV = (Mahal(c1, Poss)).^.25; % normalizing transform
    
    % t test
    if length(Poss)>2
        for i=1:length(Poss)
            [dummy tpMat(c1, Poss(i))] = ttest2(PossV(i), PossV(setdiff(1:length(Poss), i)),.05,-1);
        end
    end
end

% make directory numbers
[FileName dummy CellFile] = unique({CluInf.FileBase});
% sort pairs
[sorted index] = sort(tpMat(:));
Chain = zeros(n,1); % labels which Chain a cell belongs to
nChain = 0;
for i=find(sorted(:)'<p);
    [c1 c2] = ind2sub([n n], index(i));
    fprintf('p=%e: %s.%d.%d -> %s.%d.%d\n', sorted(i), ...
        CluInf(c1).FileBase, CluInf(c1).Gp, CluInf(c1).CluNo, ...
        CluInf(c2).FileBase, CluInf(c2).Gp, CluInf(c2).CluNo);
    
    % are neither in a chain?
    if Chain(c1)==0 & Chain(c2)==0
        % make a new chain
        nChain=nChain+1;
        Chain(c1) = nChain; Chain(c2) = nChain;
        fprintf('Created new chain %d for this pair\n', nChain);
    
    % is just c1 in a chain?
    elseif Chain(c2)==0
        % does it have any members with the same directory as c2?
        if ismember(CellFile(c2), CellFile(find(Chain==Chain(c1))));
            fprintf('Cannot add to Chain %d\n', Chain(c1));
            fprintf('%s\n', CluName{find(Chain==Chain(c1))});
        else
            Chain(c2) = Chain(c1);
            fprintf('Added to Chain %d:\n', Chain(c1))
            fprintf('%s\n', CluName{find(Chain==Chain(c1))});
        end
        
    % is just c2 in a chain
    elseif Chain(c1)==0
        % does it have any members with the same directory as c1?
        if ismember(CellFile(c1), CellFile(find(Chain==Chain(c2))));
            fprintf('Cannot add to Chain %d:\n', Chain(c2));
            fprintf('%s\n', CluName{find(Chain==Chain(c2))});
        else
            Chain(c1) = Chain(c2);
            fprintf('Added to Chain %d\n', Chain(c2))
            fprintf('%s\n', CluName{find(Chain==Chain(c2))});
        end
    
        % then both must be in chains
    else
        if Chain(c1)==Chain(c2)
            fprintf('Already linked!\n');
            fprintf('%s\n', CluName{find(Chain==Chain(c2))});
        elseif ~isempty(intersect(CellFile(find(Chain==Chain(c1))), CellFile(find(Chain==Chain(c2)))))
            fprintf('Cannot link chains %d and %d\n', Chain(c1), Chain(c2));
            fprintf('%s\n', CluName{find(Chain==Chain(c1))});
            fprintf('----and----\n');
            fprintf('%s\n', CluName{find(Chain==Chain(c2))});
        else
            fprintf('Linked chains %d and %d\n', Chain(c1), Chain(c2));
            Chain(find(Chain==Chain(c1)))=Chain(c2);
            fprintf('%s\n', CluName{find(Chain==Chain(c2))});
        end
    end
%    pause
end

for i=1:nChain
    My = find(Chain==i);
    
    Equiv{i} = [CluInf(My).FileNo; CluInf(My).Gp; CluInf(My).CluNo]';
end

% display stuff
if Display
	for i=1:max(Chain)    
        My = find(Chain==i);
        if length(My)==0; continue; end;
        clear ccg MeanSpk
        fprintf('\n');
        for j=1:length(My)
            c=My(j);
            fprintf('%s ', CluName{c});
            Res = load([CluInf(c).FileBase '.res.' num2str(CluInf(c).Gp)]);
            Clu = LoadClu([CluInf(c).FileBase '.clu.' num2str(CluInf(c).Gp)]);
            [ccg(:,j) t] = CCG(Res, Clu, 20, 50, 20000, CluInf(c).CluNo, 'hz');
	
            Spk = LoadSpk([CluInf(c).FileBase '.spk.' num2str(CluInf(c).Gp)]);
            MySpk = find(Clu==CluInf(c).CluNo);
            MeanSpk(:,:,j) = mean(Spk(:,:,MySpk),3)';
            
            fprintf('%.3f Hz\n', length(MySpk)/Res(end)*20000);
            drawnow
        end
	
        figure(1); clf
        plot(t, ccg);
        
        figure(2); clf; hold on
        for e=1:4
            plot(sq(MeanSpk(:,e,:))+e*6000);
        end
        axis([1 32 0 3e4]);
        pause
	end
end

return