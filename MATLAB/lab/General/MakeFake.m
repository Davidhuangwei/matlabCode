% 100 seconds of pink noise, @20kHz
%
% 3000 spikes at random times
function Pnoise =MakePink(DataLen,Fs)
% DatLen = 2e4*100;
nSpikes = 300;
SpkLen = 7;
GammaFreq = 2*pi*80/Fs;

Noise = filter(1, [1 -.999], randn(DatLen,1));
bsave('nospikes.dat', (Noise-min(Noise))*2^12/(max(Noise)-min(Noise)));

SpkWave = 3*sin(0:2*pi/SpkLen:2*pi).*(-SpkLen:0);

SpkTime = 1+floor(rand(nSpikes,1)*(DatLen-SpkLen-2));

Dat = Noise;
for i=1:length(SpkTime)
    Dat(SpkTime(i) + (0:SpkLen)) = Dat(SpkTime(i) + (0:SpkLen))+SpkWave';
end

MinDat = min(Dat);
MaxDat = max(Dat);

ReScaled = (Dat-MinDat)*2^12/(MaxDat-MinDat);
bsave('noise.dat', ReScaled);

FirstSpike = min(SpkTime);
plot(ReScaled(FirstSpike + [-100:100]));

% ditto + gamma
Gamma = ReScaled + 100*cos(GammaFreq*(1:DatLen))';
bsave('gamma.dat', Gamma);
