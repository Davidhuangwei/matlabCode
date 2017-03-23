% MitAnal1(InFile, OutFile, WhiteningFilterFile)
%
% Does the first stage of the analysis suggested by Partha Mitra.
% It makes a set of data tapers with f0 = 1kHz N=64 and  NW = 1.6
% It goes through file InFile, getting chunks of 64 samples
% convolving them with 4 tapers and doing an FFT.
% The output file format is:
%
% Chan1Taper1Real,  ..., Chan4Taper1Real,
% ...
% Chan1Taper4Real, ..., Chan4Taper4Real,
% Chan1Taper1Imag, ..., Chan4Taper1Imag
% ...
% Chan1Taper4Imag, ..., Chan4Taper4Imag
%
% for each sample.
%
%WhiteningFilterFile should give the FIR of the whitening filter in ascii format.

function MitAnal(InFile, OutFile, WhiteningFilterFile)

% PARAMETERS

nChannels = 4;
N = 64;
NW = 1.6;
f0 =1/20; % times the sampling frequency - so 1kHz.
f0Int = 4; % f0 read off the FFT - so 937.5 Hz
BufferSize = 20000;
nTapers = 5;
Offset = 2048;
MultOut = 1000;

wf = load(WhiteningFilterFile);
wfSize = max(size(wf));
BufferExtra = N +wfSize; % read in this much more into every buffer so you don't have to worry about overlaps etc.

% Here we go....

InFp = fopen(InFile, 'r');
OutFp = fopen(OutFile, 'w');

% calculate dpss sequences
w = dpss(N, NW, nTapers);

% Now make TapMat for convolving the segments on all channels together
TapMat = zeros(N, nChannels, nTapers);
TapMat = permute(w(:, :, ones(nChannels, 1)), [1 3 2]);

% for Taper=1:nTapers
%	TapMat(:,:,Taper) = squeeze(w(:, Taper, ones(nChannels,1)));
% end

Buf = zeros(BufferSize + BufferExtra, 1);
Seg = zeros(N, nChannels, nTapers);
SegFFT =zeros(N, nChannels, nTapers);
OutBuf =zeros(nChannels, nTapers);

% Now the main loop....
BufNum = 0;
while 1
	% load in 1 buffer of data
	fseek(InFp, BufNum*BufferSize*nChannels*2, 'bof');
	[Buf, count] =fread(InFp, [nChannels, BufferSize + BufferExtra], 'short');
	
	% subtract 2048 offset and filter it
	Buf = filter(wf, 1, Buf' - Offset)';
	
	% now do the transform for blocks of N starting at every point in the buffer
	% we start after 1 impulse response of the filter
	for i=wfSize:(count/nChannels - N)
	
		% Seg holds the data segment in a 3D array.
		% index 1: sample number 1:N
		% index 2: channel number 1:nChannels
		% index 3: taper number 1:nTapers
		Seg = permute(Buf(:, i:i+N-1, ones(nTapers, 1)), [2 1 3]) .* TapMat;
		
		% Do the FFT
		SegFFT = fft(Seg);
		
		% Now get the output buffer together
		OutBuf = squeeze(SegFFT(f0Int, :, :));
		
		% Write it
		fwrite(OutFp, MultOut*real(OutBuf) + Offset, 'short');
		fwrite(OutFp, MultOut*imag(OutBuf) + Offset, 'short');
	end
	
	% If file has ended, quit
	
	if (count < nChannels*BufferSize)
		break;
	end
	
	BufNum = BufNum+1;
end
		