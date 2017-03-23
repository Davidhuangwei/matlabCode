function [Power, Freq] = ARSpec(A, Sigma, SampleRate, MaxFreq, FreqResolution)

if nargin<3 | isempty(SampleRate)   SampleRate = 1250; end
Nfr = round(SampleRate/2);
if nargin<4 | isempty(MaxFreq)    
   MaxFreq=Nfr; 
end
if nargin <5 | isempty(FreqResolution) FreqResolution = 256; end

Freq = [MaxFreq/FreqResolution: MaxFreq/FreqResolution: MaxFreq]';
Order = length(A);
fsize = length(Freq);
MaxRadian = pi * MaxFreq / Nfr;
w = [MaxRadian/FreqResolution: MaxRadian/FreqResolution: MaxRadian]';
z=exp(-i*w);
Power = ones(fsize,1);
%lazy to vectorize
for p=1:Order
    Power = Power + A(p)*z.^p;
end

Power = abs(Power).^2;
Power = Sigma ./ Power /2/pi;


