%Mitload(Fname, nChannels, nTapers)
%
% Load file fname.mit to produce a 3D complex array with indices:
% 1: Channel
% 2: Taper
% 3: Time

function Out = Mitload(Fname, nChannels, nTapers, nSamples)

RawFile =bload(Fname, [nChannels*nTapers*2, nSamples], 'short') - 2048;

nSamples = size(RawFile, 2);

ReshapedFile =reshape(RawFile, [nChannels, nTapers, 2, nSamples]);

Out = squeeze(ReshapedFile(:, :, 1, :) + i*ReshapedFile(:, :, 2, :));

