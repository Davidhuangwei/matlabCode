function multitonegenwavnoise(fq)



sr = 44100;
lg = 30;
ts = [0:1/sr:lg]';

noise_amplitude = 0.9

noise = noise_amplitude .* 2 .* rand(round(sr/fq/2),1)-noise_amplitude;
zeroMat = zeros(size(noise));
pulse = [noise; zeroMat];
pulse = repmat(pulse,lg*fq,1);

toneA = pulse;

toneB = zeros(size(toneA));
sf = [toneB,toneA];
wavwrite(sf,sr,16,['right_' num2str(fq) 'Hz.wav']);
sf = [toneA,toneB];
wavwrite(sf,sr,16,['left_' num2str(fq) 'Hz.wav']);