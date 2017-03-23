% SpwClusterability(Directory, FileBase)
% loads a .net file and several .wtout files to produce an
% estimate of errors during ripples.
%
% Input files used are: 
%	Directory/SpwInfo			- to give info about spw times
%	Directory/IntraSpikes.res 	- to determine correct #spikes
%	Directory/tetrode.res.1 	- to see which spikes are during spws
%   Directory/tetrode.par		- to get sample rate
%	Directory/IntraSpikes.clu	- to get correct clustering of detected spikes
%	Directory/FileBase.net		- to get feature info
%	Directory/FileBase.wtout-X	- weights produced by QuickProp program
% Output file:
%	Directory/FileBase.spwerror-all						

function SpwClusterability(Directory, FileBase)

SpwThresh = 0;

% get sharp waves
SpwInfo = LoadHeadedArray([Directory, '/SpwInfo']);
SigSpws = SpwInfo(find(SpwInfo(:,3)>SpwThresh), 1:2);

% compute correct number of spikes as determined by intracellular file
IntraRes = load([Directory, '/IntraSpikes.res']);
Par = LoadPar([Directory, '/tetrode.par']);
SpwIntraSpikes = find(WithinRanges(IntraRes, SigSpws*1e6/Par.SampleTime));
nSpwIntraSpikes = length(SpwIntraSpikes);

% load extracellular detected spikes with correct clustering
Clu = load([Directory, '/IntraSpikes.clu']);
Res = load([Directory, '/tetrode.res.1']);

% find spikes during sharp waves
SpwSpikes = find(WithinRanges(Res, SigSpws*1e6/Par.SampleTime));
nSpwSpikes = length(SpwSpikes);

% load net file
fprintf('loading .net file ...');
NetFname = sprintf('%s/%s.net', Directory, FileBase);
NetFp = fopen(NetFname, 'r');
% skip header
while 1
	str = fgets(NetFp);
	if strncmp(str, 'NPatterns', 9) == 1
		break;
	end;
end;
nPatterns = sscanf(str, '%*s %d');

% load main block
Input = fscanf(NetFp, '%f');
fclose(NetFp);

% reshape it
InputDim = length(Input) / nPatterns;
if (InputDim ~= round(InputDim))
	error('Feature file not square!')
end;
Input = reshape(Input, [InputDim, nPatterns]);

% lose last row (classification)
Answer = Input(InputDim,:);
Input(InputDim,:) = [];

% add bias vectors
Input = [ones(1,nPatterns) ; Input];
fprintf(' done.\n');

% open output file
OutFname = sprintf('%s/%s.spwerror-all', Directory, FileBase);
OutFp = fopen(OutFname, 'w');

% main loop
for Conservatism = 0.1:0.1:0.9
	
	WtFname = sprintf('%s/%s.wtout-%.3f', Directory, FileBase, Conservatism);
	% load weights file and lose unwanted values
	Wts = load(WtFname);
	n = size(Wts, 2);
	Wts = Wts(:,3:3:n-1);
	nCrossVal = size(Wts, 1);
	
	% Calculate scores
	Score = Wts*Input;
	
	% threshold them
	Class = (Score>0);
	
	for i=1:nCrossVal
		
		CasesToConsider = intersect(i:nCrossVal:nPatterns, SpwSpikes);
		
		nFalse = sum(Class(i,CasesToConsider) & ~Answer(CasesToConsider));
		nFound = sum(Class(i,CasesToConsider) & Answer(CasesToConsider));

		FalsePos = 100*nFalse / (nFalse+nFound);
		FalseNeg = 100 - 100*nFound/(nSpwIntraSpikes/2);
		% --- nSpwIntraSpikes should be divided by 2 to give correct number of spikes - because you split the data in half.
		
		fprintf(OutFp, '%f %f\n', FalsePos, FalseNeg);
	end;		
end;

fclose(OutFp);
