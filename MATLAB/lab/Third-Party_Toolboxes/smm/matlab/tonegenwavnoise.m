function tongenwav(fq)

sr = 44100;
lg = 30;
ts = [0:1/sr:lg]';

fq
noise_amplitude = 0.2
noise = noise_amplitude * 2 * rand(length(ts),1)-noise_amplitude;
%noise = repmat(noise_amplitude * 2 * rand(length(ts),1)-noise_amplitude ,1,2);
max(sin(pi * 2 * fq * ts)+noise)
min(sin(pi * 2 * fq * ts)+noise)
toneA = (sin(pi * 2 * fq * ts)+noise)/max([-min(sin(pi * 2 * fq * ts)+noise) max(sin(pi * 2 * fq * ts)+noise)]);
max(toneA)
min(toneA)
toneB = zeros(size(toneA));
sf = [toneB,toneA];
wavwrite(sf,sr,16,['right_' num2str(fq) 'Hz.wav']);
sf = [toneA,toneB];
wavwrite(sf,sr,16,['left_' num2str(fq) 'Hz.wav']);