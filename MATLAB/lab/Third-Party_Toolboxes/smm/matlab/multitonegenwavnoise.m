function multitonegenwavnoise(fq1,fq2)

sr = 44100;
lg = 30;
ts = [0:1/sr:lg]';

fq1
fq2
noise_amplitude = 0.2
noise = noise_amplitude * 2 * rand(length(ts),1)-noise_amplitude;
%noise = repmat(noise_amplitude * 2 * rand(length(ts),1)-noise_amplitude ,1,2);
tone1 = sin(pi * 2 * fq1 * ts);
tone2 = sin(pi * 2 * fq2 * ts);
max(tone1+noise)
min(tone1+noise)
toneA = (tone1+noise+tone2)/max([-min(tone1+noise+tone2) max(tone1+noise+tone2)]);
max(toneA)
min(toneA)
toneB = zeros(size(toneA));
sf = [toneB,toneA];
wavwrite(sf,sr,16,['right_' num2str(fq1) '_' num2str(fq2) 'Hz.wav']);
sf = [toneA,toneB];
wavwrite(sf,sr,16,['left_' num2str(fq1) '_' num2str(fq2) 'Hz.wav']);