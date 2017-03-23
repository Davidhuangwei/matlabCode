% Equiv = KlustaTrak(Files, p)
%
% Decides which cells within a set of files correspond to each other
%
% needs .canshape files giving the shape of the clusters in 
% Canonical Cluster Space (see MakeCanFetFiles and MakeCanShapeFiles)
% 
% Works like this for each pair of clusters, it 

function Equiv = KlustaTrak(Files, p)

if ~exist('CluInf');
	% get file bases
	Files = mysql('SELECT FileBase FROM Files WHERE Description LIKE ''%Sleep%''', 'extra', '%s');
%	Files = mysql('SELECT FileBase FROM Files WHERE Description LIKE ''%George%''', 'extra', '%s');
	nFiles = length(Files);
	
	% now load cluster shapes for each cell in each file
	n=0;
	CluInf = [];
	for f=1:nFiles
%	    if findstr(Files{f}, 'l19'); continue; end
%       if ~findstr(Files{f}, 'l23'); continue; end
        Par = LoadPar([Files{f} '.par']);
        for e=1:Par.nElecGps
            if ~FileExists([Files{f} '.canshape.' num2str(e)]); continue; end
             Par1 = LoadPar1([Files{f} '.par.' num2str(e)]);
             d = Par1.nSelectedChannels*3;
            if d~=12 continue; end;
             Shapes = load([Files{f} '.canshape.' num2str(e)]);
             Good = find(Shapes(2:end,1)>20)+1;
             
             for c=Good(:)'
                 n=n+1;
                 CluInf(n).FileBase = Files{f};
                 CluInf(n).Directory = Files{f}(1:max(findstr(Files{f},'/'))-1);
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
 end
 % do pair-wise comparison
if ~exist('Mahal');
     
	Mahal = NaN*ones(n);
	Match = NaN*ones(n);
	% match takes the following values:
	% NaN: different number of channels or duplicate entry
	% 0: different tetrodes or different sessions
	% 1: same tetrode, same directory but different file
	% 2: same tetrode, same directory same file (different cluster number)
	for c1=1:n
        for c2=c1+1:n
            if CluInf(c1).nDim==CluInf(c2).nDim
                DiffFet = CluInf(c1).Mean - CluInf(c2).Mean;
                Mahal(c1,c2) = DiffFet' * inv((CluInf(c1).Cov+CluInf(c2).Cov)/2) * DiffFet;
                Mahal(c2,c1) = Mahal(c1, c2);
                if isequal(CluInf(c1).Directory, CluInf(c2).Directory) & CluInf(c1).Gp==CluInf(c2).Gp
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
end

% now, for each cell, find those for which match is impossible and those where it is.
if ~exist('tpMat')
    Corresp = zeros(n); z1Mat = NaN*ones(n); z2Mat = z1Mat; tpMat = z1Mat;
	for c1=1:n
        Imposs = find(Match(c1,:)==0);
        Poss = find(Match(c1,:)==1);
	
        ImpossV = (Mahal(c1, Imposs)).^.25;
        PossV = (Mahal(c1, Poss)).^.25;
        
        % find bonferroni p-value
	%     p = 1-0.95^(1/length(Poss));
        
        % z score for each possible match
        z1 = (PossV - mean(ImpossV))/std(ImpossV); % z1 is score compared to impossibles
        z2 = zscore(PossV); % z2 is score compared to possibles.
        z1Mat(c1,Poss) = z1;
        z2Mat(c1,Poss) = z2(:)';
        
        % t test
        if length(Poss)>2
            for i=1:length(Poss)
                [dummy tpMat(c1, Poss(i))] = ttest2(PossV(i), PossV(setdiff(1:length(Poss), i)),.05,-1);
            end
        end
        
	%    [Quantile(ImpossV, PossV); normcdf(z)]
	
        % find matches
        if 0
            Bingo = Poss(find(normcdf(z2)<p));
            Corresp(c1,Bingo)=1;    
	
            fprintf('\n%s.%d.%d matches:\n', CluInf(c1).FileBase, CluInf(c1).Gp, CluInf(c1).CluNo);
            for i=Bingo
                fprintf('%s.%d.%d\n', CluInf(i).FileBase, CluInf(i).Gp, CluInf(i).CluNo);
            end
		
		    [Mahal(c1, Poss); Quantile(ImpossV, PossV); normcdf(z)]
		    pause
        end
	end
end
% make directory numbers
[FileName dummy CellFile] = unique({CluInf.FileBase});
% sort pairs
%[sorted index] = sort(z2Mat(:));
[sorted index] = sort(tpMat(:));
Chain = zeros(n,1); % labels which Chain a cell belongs to
nChain = 0;
%for i=find(sorted(:)'<norminv(.01));
for i=find(sorted(:)'<.05);
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

% display stuff
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

return
   
































% find mean distance of those that can't match
clear MeanMahal MeanPowMahal MeanLogMahal
for c1=1:length(CluInf)
    for g=0:2
        My = Mahal(c1, find(Match(c1,:)==g));
        MeanMahal(c1,g+1) = mean(My);
        MeanPowMahal(c1,g+1) = mean(My.^.25);
        MeanLogMahal(c1,g+1) = mean(log2(My));
    end
end
    
%     My = [Mahal(c1, find(Match(c1,:)==0)) Mahal(find(Match(:,c1)==0), c1)'];
%     MeanMahal(c1) = mean(My);
%     MeanPowMahal(c1) = mean(My.^.25);
%     MeanLogMahal(c1) = mean(log2(My));
%end

plot([CluInf.Norm], MeanMahal, '.');


Norm1 = repmat([CluInf.Norm], n, 1);
Norm2 = repmat([CluInf.Norm]', 1, n);


return


for i=1:n
    Directory{i,1} = fb{i}(1:max(findstr(fb{i},'/'))-1);
end

% now go through pairs
for i=3:n
    if strcmp(Directory{i}, Directory{i+1})
        % we have a pair of files in the same directory
        Par1 = LoadPar([fb{i} '.par']);
        Par2 = LoadPar([fb{i+1} '.par']);        
        
        for e=1:Par1.nElecGps
            fprintf('%s -> %s tet %d\n', fb{i}, fb{i+1}, e);
            Equivs{i, e} = KlustaTrak(fb{i}, fb{i+1}, e);
            Equivs{i, e}
            %drawnow
            pause
            
            save TrakTest
        end
    end
end
        