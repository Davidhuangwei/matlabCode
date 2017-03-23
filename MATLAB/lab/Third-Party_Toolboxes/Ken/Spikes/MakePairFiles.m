% MakePairFiles(Description, db, Overwrite)
%
% summarizes the results of the cross-validation analysis into
% a FileBase.pairs file for each file, which contains one line
% for each pair of cells (excluding cluster 1 and those on the
% same tetrode), with the following columns:
%
%
% 1:  Clu1 - cluster # of cell 1 of the pair
% 2:  Clu2 - cluster # of cell 2 of the pair (must be > cell 1, and on a different tetrode)
% 3:  Wt12 - Prediction weight of cell 1 to 2, at 25ms smoothing, without space prediction
% 4:  WtErr12 - std error of this estimate
% 5:  Wt21 - same but cell to 2 cell 1
% 6:  WtErr21 - std error of estimate
% 7:  Wt12Sp - Prediction weight of cell 1 to 2, at 25ms smoothing, over space prediction
% 8:  WtErr12Sp - std error of this estimate
% 9:  Wt21Sp - same but cell to 2 cell 1
% 10: WtErr21Sp - std error of estimate
% 11: CCG - CCG center bin count (width = 60 degrees of theta, i.e. 20ms = 10ms each side ... too short?)
% 12: CCGMean - Mean of this under shuffling
% 13: CCGStd - Std dev of this under shuffling
% 14: PFOverlap - amount of place field overlap (dot product)
% 15: PFDist - distance between place field centers in .pout units
% 16: CoinMeanThPh1 - Mean phase of cell 1 when cell 2 fires within 360 degrees
% 17: CoinrThPh1 - Circular concentration of above
% 18: CoinMeanThPh2 - same for cell 2
% 19: CoinrThPh2 - same for cell 2
%
% p.s. all weight-related things are means over cv iterations


function MakeInfoFiles(Description, db, Overwrite)

if nargin<2, db = []; end
if nargin<3, Overwrite = 0; end

OutDir = '/home/ken/data/pout/no_spw';

% get all cells
FileBases = RetrieveFileBases(Description, db);

% FileBases = {'/u15/xaj/Awake/l23-01/n1'};

for f=1:length(FileBases)
    
    FileBase = FileBases{f};    
    
    if FileExists([FileBase '.pairs']) & Overwrite~=1
        warning([FileBase '.pairs already exists!']);
        continue;
    end
    
    % replace / by _ for .out files
    FileBase_ = FileBase;
    FileBase_(find(FileBase=='/')) = '_';

    
    OutFiles = dir([OutDir '/' FileBase_ '*out']);

    % try all pout or bpout files, take the first one that loads
    Loaded = 0;
    for f2=1:length(OutFiles)
        try
            fprintf('Loading file %s\n', OutFiles(f2).name);
            [Out Par] = ReadPoutFile([OutDir '/' OutFiles(f2).name]);
            Loaded = 1;
            break;
        catch
            fprintf('Error reading file\n', FileBase);
        end
    end

    if Loaded & max(Par.TetNo)>1
        
        %%%%%%%%%%%%%%%
        %% make CCGs %%
        %%%%%%%%%%%%%%%
    	SpkPhAll = load([FileBase '.spkph']);
		CluAll = LoadClu([FileBase '.clu']);
		InTh = find(isfinite(SpkPhAll));
        SpkPh = SpkPhAll(InTh);
        Clu = CluAll(InTh);
        
        % unshuffled CCG
    	BinWidth = 2*pi/3; % 60 degrees on each side
		[ccg t] = CCG(SpkPh, Clu, BinWidth, 0, 1, 2:max(Clu), 'count');
        
        % shuffled CCGs
        nRands = 20;
        SSpkPh = ShufflePhase(SpkPh,Clu,2:max(Clu),nRands);    
        % get pairs only on first one
        clear Sccg
		for i=1:nRands
            Sccg(:,:,:,i) = CCG(SSpkPh(:,i), Clu, BinWidth, 0, 1, 2:max(Clu), 'count');
        end
        ccgMean = mean(Sccg,4);
        ccgStd = std(Sccg,0,4);
        
        % find pairs within 1 cycle on either side
        [dummy dummy2 SpkPairs] = CCG(SpkPh, Clu, 4*pi, 0, 1, 2:max(Clu), 'count');
        CluSpkPairs = Clu(SpkPairs);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%
        %% PROCESS .pout file %%%
        %%%%%%%%%%%%%%%%%%%%%%%%%
        
		% find 25ms time scale
        TimeScale = 1000/Par.InternalFreq;
        [dummy t25] = min(abs(Par.TimeSm*TimeScale - 25)); % 25 ms point
        
        % make mean weights
        Wt = mean(Out.Weight(:,:,:,1,t25),3);
        WtSp = mean(Out.Weight(:,:,:,2,t25),3);
        
        % to estimate sd's, must compute inverse hessian for each target cell
        clear CovMat CovMatSp
        for c2 = 1:Par.nCells
            if Par.TetNo(c2)>0
                CovMat(:,:,c2) = inv(mean(Out.Hess(:,:,c2,:,1,t25),4));
                CovMatSp(:,:,c2) = inv(mean(Out.Hess(:,:,c2,:,2,t25),4));
            end
        end
        SdMat = mean(Out.Hess(:,:,:,:,1,t25).^-0.5, 4); % 
        SdMatSp = mean(Out.Hess(:,:,:,:,2,t25).^-0.5, 4);
        StdErr = mean(Out.Hess(:,:,:,1,t25),3);

        % make mean place fields
        PlaceField = mean(Out.PlaceField(:,:,:,:,2),4);
        PlaceVec = reshape(PlaceField, ... % a vector 4 each place field
            [size(PlaceField,1)*size(PlaceField,2), size(PlaceField,3)]);
        
        % compute place field center of mass
        [xg yg] = meshgrid(1:size(PlaceField,1), 1:size(PlaceField,2));
        CenterX = PlaceVec'*xg(:) ./ sum(PlaceVec)';
        CenterY = PlaceVec'*yg(:) ./ sum(PlaceVec)';

        
        % now here we go ....
        Pairs = [];
        i = 0; % index to line number

		for c1=2:max(Clu)
			for c2=c1+1:max(Clu)
                
                % don't bother with cells on the same trode, or non-predictees
				if Par.TetNo(c1)==Par.TetNo(c2), continue, end;
				if Par.TetNo(c1)<=0 | Par.TetNo(c2)<=0, continue, end;
                
                i=i+1;
                % 
                Pairs(i,1) = c1;
                Pairs(i,2) = c2;
                Pairs(i,3) = Wt(c1,c2);
                Pairs(i,4) = sqrt(CovMat(c1,c1,c2));
                Pairs(i,5) = Wt(c2,c1);
                Pairs(i,6) = sqrt(CovMat(c2,c2,c1));
                Pairs(i,7) = WtSp(c1,c2);
                Pairs(i,8) = sqrt(CovMatSp(c1,c1,c2));
                Pairs(i,9) = WtSp(c2,c1);
                Pairs(i,10) = sqrt(CovMatSp(c2,c2,c1));
                Pairs(i,11) = ccg(1,c1-1,c2-1);
                Pairs(i,12) = ccgMean(1,c1-1,c2-1);
                Pairs(i,13) = ccgStd(1,c1-1,c2-1);
                
                % make dot product of place fields
                Pairs(i,14) = PlaceVec(:,c1)'*PlaceVec(:,c2) ...
                    / norm(PlaceVec(:,c1)) / norm(PlaceVec(:,c2));
                
                % distance between PF centers 
                Pairs(i,15) = norm([CenterX(c1)-CenterX(c2), CenterY(c1)-CenterY(c2)]);
                
                % mean phase and modulation depth of coincident spikes
                MyPairs = find(CluSpkPairs(:,1)==c1 & CluSpkPairs(:,2)==c2);
                
                [Pairs(i,16), Pairs(i,17)] = circmean(SpkPh(SpkPairs(MyPairs,1)));
                [Pairs(i,18), Pairs(i,19)] = circmean(SpkPh(SpkPairs(MyPairs,2)));
            end
        end
        
%         keyboard
        msave([FileBase '.pairs'], Pairs);
    else
        fprintf('Could not load file for filebase %s!\n', FileBase);
    
    end
end

