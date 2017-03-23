% MitDet(InFile, OutFile)
%
% Takes a .mit file and uses VTwiddleKStar to produce a .det file
%

function MitDet(InFile, OutFile)

% PARAMETERS

BufferSize = 20000;
nChannels = 4;
nTapers = 5;
Offset = 2048;

% Set up stuff
load VTwiddleKStar

InFp = fopen(InFile, 'r');
OutFp = fopen(OutFile, 'w');

Buf = zeros(nChannels, nTapers, BufferSize);
ReorgBuf = zeros(nChannels*BufferSize, nTapers);

% The main loop
while(1)

	% load up buffer

	RawFile =fread(InFp, [nChannels*nTapers*2, BufferSize], 'short') - Offset;
	nSamples = size(RawFile, 2)
	ReshapedFile =reshape(RawFile, [nChannels, nTapers, 2, nSamples]);
	Buf = squeeze(ReshapedFile(:, :, 1, :) + i*ReshapedFile(:, :, 2, :));

	% now do the multiplications
%	for i=1:nSamples
%		OutBuf = squeeze(Buf(:,:,i)) * VTwiddleKStar;
%		fwrite(OutFp, abs(OutBuf + Offset), 'short');
%	end

	% super vectorized version
	ReorgBuf = reshape(permute(Buf, [1 3 2]), [nChannels*nSamples, nTapers]);
	fwrite(OutFp, Offset + abs(ReorgBuf*VTwiddleKStar), 'short');
	
	if (nSamples<BufferSize) break; end
end

fclose(InFp);
fclose(OutFp);