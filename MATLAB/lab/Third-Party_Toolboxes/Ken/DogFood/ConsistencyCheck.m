% ConsistencyCheck(FileBase)
%
% checks the .eeg and .whl files to see if they are the same length, and roughly
% the same length as the spikes in the .res file.
%
% also checks number of spikes in .res.n .clu.n .spk.n and .fet.n are the same
%
% and finally checks that .res.n and .clu.n were merged sucessfully into .res and .clu

function ConsistencyCheck(FileBase)

Par = LoadPar([FileBase '.par']);

nCh = Par.nChannels;
nGp = Par.nElecGps;

if FileExists([FileBase '.whl']);
	Whl = load([FileBase '.whl']);
	WhlLen = size(Whl,1);
	if size(Whl,2)~=3
		warning('.whl file doesn''t have 3 columns!');
	end
else
	warning('no .whl file');
	WhlLen = 0;
end

if FileExists([FileBase '.eeg']);
	EegBytes = FileLength([FileBase '.eeg']);
	EegSamples = EegBytes/(2*nCh);

	if EegSamples ~= floor(EegSamples)
		warning('Eeg file does not divide number of channels!');
    end
else
	warning('no .eeg file');
	EegLen = 0;
end

BigRes = load([FileBase '.res']); % .res file
BigClu = LoadClu([FileBase '.clu']);

MinRes = min(BigRes);
MaxRes = max(BigRes);

if MinRes<0 | MinRes > 10000
	warning(sprint('Res file starts at unusual value %d\n', MinRes));
end

fprintf('converting to .res units:\n')
fprintf('whl len %d\n', WhlLen*25600/Par.SampleTime);
fprintf('eeg len %d\n', EegSamples*800/Par.SampleTime);
fprintf('res max %d\n', MaxRes);

DiffSamps = floor(abs(WhlLen - EegSamples/32));
if DiffSamps>=1
	warning(sprintf('.whl and .eeg differ by more than %d .whl samples (%d)', DiffSamps, 25600/Par.SampleTime));
end

% check .des file
if FileExists([FileBase '.des']);
	Des = textread([FileBase '.des'], '%s', 'whitespace', '\n');
	if length(Des)~=max(BigClu)-1
		warning('.des doesn''t match .clu');
    end
end

% now check .res file against .res.n etc

% loop thru trodes
CluBase = 0; % clu # offset in big file for this trode
for i=1:Par.nElecGps
	% load .res.n and .clu.n files
	SmallRes = load([FileBase '.res.' num2str(i)]);
	SmallClu = LoadClu([FileBase '.clu.' num2str(i)]);

	for c=2:max(SmallClu)
		SmallSpikes = find(SmallClu==c);
		BigSpikes = find(BigClu==c+CluBase);

		if ~isequal(BigRes(BigSpikes), SmallRes(SmallSpikes))
			warning(sprintf('Mismatch of .res.n on trode %d clu %d', i, c));
       end
    end
	CluBase = CluBase+max(SmallClu)-1;
end
