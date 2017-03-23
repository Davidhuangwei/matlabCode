% MakeInfoFiles(Description, db)
%
% summarizes the results of the cross-validation analysis into
% a FileBase.info file for each file, which contains one line
% for each cell (excluding cluster 1), with the following lines:
%
% bSpace - bit per second from space only
% bPop25 - bits per second from population, 25ms smoothing
% bBoth25 - bits per second from population + space, 25ms smoothing
% bPeakPop - bits per second from pop only at optimum time smoothing
% tPeakPop - corresponding smoothing time (ms)
% bPeakBoth - bits per second from population + space, optimum smoothing
% tPeakBoth - corresponding smoothing time (ms)

function MakeInfoFiles(Description, db)

OutDir = '/home/ken/data/pout/theta_only';

% get all cells
FileBases = RetrieveFileBases(Description, db)
% if isempty(Description)
%     FileBases = mysql(['SELECT FileBase FROM Files'], db, '%s');
% elseif ischar(Description)
%     FileBases = mysql(['SELECT FileBase FROM Files WHERE Description LIKE "' ...
%         Description '"'], db, '%s');
% elseif iscell(Description)
% 	DescriptionList = ['"' Description{1} '"'];
% 	for i=2:length(Description)
% 		DescriptionList = sprintf('%s, "%s"', DescriptionList, Description{i});
% 	end
%     FileBases = mysql(['SELECT FileBase FROM Files WHERE Description IN (' ...
%         DescriptionList ')'], db, '%s');
% else
%     error('Description must be empty (for any description), string, or cell array of strings');
% end

for f=1:length(FileBases)
    
    FileBase = FileBases{f};
    FileBase_ = FileBase;
    FileBase_(find(FileBase=='/')) = '_';

%     info = mysql(['select BigCluNo, fRate, eDist, Type FROM View WHERE FileBase="' FileBases{i} '"'], 'extra');
    Files = dir([OutDir '/' FileBase_ '*out']);
    
    % try all files, take the first one that loads
    Loaded = 0;
    for f2=1:length(Files)
        try
            fprintf('Loading file %s\n', Files(f2).name);
            [Out Par] = ReadPoutFile([OutDir '/' Files(f2).name]);
            Loaded = 1;
            break;
        catch
            fprintf('Error reading file\n', FileBase);
        end
    end
    
    if Loaded
        TimeScale = 1000/Par.InternalFreq;
        [dummy t25] = min(abs(Par.TimeSm*TimeScale - 25)); % 25 ms point

        % now here we go ....
        clear Info
        Info(:,1) = Out.TotBitsSec(2:end,2,1); % space only
        Info(:,2) = Out.TotBitsSec(2:end,1,t25); % pop @ 25 ms only
        Info(:,3) = Out.TotBitsSec(2:end,2,t25); % pop @ 25 ms + space
        
        % interpolate pop only
        IntRange = Par.TimeSm(2)*TimeScale:.1:max(Par.TimeSm)*TimeScale;
		intpop = interp1(Par.TimeSm(2:end)*TimeScale, permute(Out.TotBitsSec(2:end,1,2:end), [3 1 2]), IntRange, 'spline', NaN);
        [Info(:,4), pospop] = max(intpop',[],2);
        Info(:,5) = IntRange(pospop)';
        
        % now pop + space
  		intboth = interp1(Par.TimeSm(2:end)*TimeScale, permute(Out.TotBitsSec(2:end,2,2:end), [3 1 2]), IntRange, 'spline', NaN);
        [Info(:,6), posboth] = max(intboth',[],2);
        Info(:,7) = IntRange(posboth)';
  
        msave([FileBase '.info'], Info);
    else
        fprintf('Could not load file for filebase %s!\n', FileBase);
    
    end
end

