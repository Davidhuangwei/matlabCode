SampleRate = 1250;
nSamples = 100000;

Noise1 = randn(nSamples,1);
Noise2 = randn(nSamples,1);

b = fir1(50, [90 110]/(SampleRate/2));

NoiseFilt1 = filter(b, 1, Noise1);
NoiseFilt2 = filter(b, 1, Noise2);

UnderlyingVar = filter(fir1(100, 1/SampleRate), 1, randn(nSamples,1));
UnderlyingVar = 2*UnderlyingVar./std(UnderlyingVar);

UnderlyingVar2 = filter(fir1(100, 1/SampleRate), 1, randn(nSamples,1));
UnderlyingVar2 = 2*UnderlyingVar2./std(UnderlyingVar2);


Sig1 = filter([1 1], 1, randn(nSamples,1)) + UnderlyingVar .* NoiseFilt1;
Sig2 = filter([1 1], 1, randn(nSamples,1)) + UnderlyingVar .* NoiseFilt2;
Sig3 = filter([1 1], 1, randn(nSamples,1)) + UnderlyingVar .* NoiseFilt1;
Sig4 = filter([1 1], 1, randn(nSamples,1)) + UnderlyingVar2 .* NoiseFilt2;

Comodugram([Sig1'; Sig2'; Sig3'], 1024, 1250, [0 300]);
