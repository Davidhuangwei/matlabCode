% CalcWhitening
% does its best to calculate a whitening filter using the model power ~ f^-1.9

function acf = CalcWhitening(nfft, SampleFreq, Exponent)

% default values:
if nargin<1
	nfft = 1024;
end
if nargin<2
	SampleFreq = 20000;
end
if nargin<3
	Exponent = -1.9;
end


% make array f to hold absolute values of frequencies
f(1:1+nfft/2) = ((1:1+nfft/2) - 1) * SampleFreq/nfft;
f((2+nfft/2):nfft) =f(2+nfft - ((2+nfft/2):nfft));

% calculate power function
pxx = 1000*f.^Exponent;


% set all frequencies below 100 Hz to 0


% do inverse fft and take real part (imag part will be 0 anyway)
acf = real(ifft(pxx));

% plot it!
figure(1);
plot(1:nfft, acf);