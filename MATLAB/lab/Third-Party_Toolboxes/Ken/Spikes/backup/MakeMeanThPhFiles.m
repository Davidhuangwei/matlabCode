% MakeMeanThPhFiles(Description, db)
%
% for each cell (including mua cell 1), computes the following for all
% spikes in theta:
%
% MeanThPh (mean phase in radians)
% R (radius parameter of circular distribution)
% NThSpikes (number of spikes of this cluster in theta
% k (Von Mises concentration parameter by maximum likelihood) 
% p (p-val for non-uniformity, Rayleigh test)
%
% these are saved as a .meanthph file, with one line per clu (inc clu 1)

function MakeMeanThFiles(Description, db)

% get all cells
if isempty(Description)
    FileBases = mysql(['SELECT FileBase FROM Files'], db, '%s');
elseif ischar(Description)
    FileBases = mysql(['SELECT FileBase FROM Files WHERE Description LIKE "' ...
        Description '"'], db, '%s');
elseif iscell(Description)
	DescriptionList = ['"' Description{1} '"'];
	for i=2:length(Description)
		DescriptionList = sprintf('%s, "%s"', DescriptionList, Description{i});
	end
    FileBases = mysql(['SELECT FileBase FROM Files WHERE Description IN (' ...
        DescriptionList ')'], db, '%s');
else
    error('Description must be empty (for any description), string, or cell array of strings');
end

for f=1:length(FileBases)
    fprintf('Doing %s\n', FileBases{f});
    BigSpkPh = load([FileBases{f} '.spkph']);
    BigClu = LoadClu([FileBases{f} '.clu']);

    clear Out
	for c=1:max(BigClu)
        MySpikes = find(BigClu==c & isfinite(BigSpkPh));
        MyPh = BigSpkPh(MySpikes);
        
        [Out(c,1), Out(c,2)] = circmean(MyPh);
        Out(c,3) = length(MyPh);
        [dummy, Out(c,4)] = VonMisesFit(MyPh);
        Out(c,5) = RayleighTest(MyPh);
	end
	
% 	Out
    FileName = [FileBases{f} '.meanthph'];
% 	FileName
    msave(FileName, Out);
% 	pause
end