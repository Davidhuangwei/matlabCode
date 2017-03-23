function SpwClusterability(FileBase, IntraRippleFile)
% loads a .net file and several .wtout files to produce an
% estimate of errors during ripples

IntraClu = LoadClu(IntraRippleFile);

% load net file
fprintf('loading .net file ...');
NetFname = sprintf('%s.net', FileBase);
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
OutFname = sprintf('%s.spwerror-all', FileBase);
OutFp = fopen(OutFname, 'w');

for Conservatism = 0.1:0.1:0.9
	
	WtFname = sprintf('%s.wtout-%.3f', FileBase, Conservatism);
	% load weights file and lose unwanted values
	Wts = load(WtFname);
	n = size(Wts, 2);
	Wts = Wts(:,3:3:n-1);
	nCrossVal = size(Wts, 1);
	
	% Calculate scores
	Score = Wts*Input;
	
	% threshold them
	Class = (Score>0);
	
	SpwSpikes = find(IntraClu>3);
	
	for i=1:nCrossVal
		CasesToConsider = i:nCrossVal:nPatterns;
		
		nDetected = sum(Class(i,CasesToConsider));
		nTrue = sum(Answer(CasesToConsider));
		nFalsePos = sum(Class(i,CasesToConsider) & ~Answer(CasesToConsider));
		nFalseNeg = sum(~Class(i,CasesToConsider) & Answer(CasesToConsider));
		fprintf('false pos %f false neg %f\t', 100*nFalsePos/nDetected, 100*nFalseNeg/nTrue);
	
		CasesToConsider = intersect(CasesToConsider, SpwSpikes);
		nDetected = sum(Class(i,CasesToConsider));
		nTrue = sum(Answer(CasesToConsider));
		nFalsePos = sum(Class(i,CasesToConsider) & ~Answer(CasesToConsider));
		nFalseNeg = sum(~Class(i,CasesToConsider) & Answer(CasesToConsider));
		fprintf('SPW: false pos %f false neg %f\n', 100*nFalsePos/nDetected, 100*nFalseNeg/nTrue);
		fprintf(OutFp, '%f %f\n', 100*nFalsePos/nDetected, 100*nFalseNeg/nTrue);
	end;		
end;

fclose(OutFp);
