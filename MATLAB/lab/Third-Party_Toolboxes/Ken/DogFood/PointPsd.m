function [out, mu, sd] = PointPsd(t,FreqRange, BinSize, Epochs)
%function [p,mu,sd] = PointPsd(t, FreqRange, BinSize, Epochs)
%
% Estimates power spectrum for a point process
%
% t is the input time series, a vector of event times
%
% FreqRange is the range of frequencies to evaluate at.
%
% data is divided into chunks of length BinSize, as in 
% Welch's method
%
% Epochs optionally gives a set of max and min times - 
% bins will only fall fully inside of these.
%
% optional outputs give the mean and s.d. expected for a
% Poisson process

FreqRange = FreqRange(:);
nFreqs = length(FreqRange);
t = t(:);

if nargin<4
    Epochs = [min(t) max(t)];
end

[BinStarts, Assignments] = FitEvenlySpacedBins(BinSize,Epochs, t);
% for e=1:size(Epochs,1)
%     MyStarts = Epochs(e,1):BinSize:Epochs(e,2);
%     BinStarts = [BinStarts, MyStarts(1:length(MyStarts)-1)];
% end    
% 	Bin = ceil((t-MinTime) / BinSize);
% 	
% 	Bin(1) = 1;
nBins = length(BinStarts);

Transform = zeros(nBins, nFreqs);

Mul = sqrt(2/3);

% compute subtraction amount by fourier transform of taper
% DOESN'T WORK YET!!!
fRate = sum(Assignments~=0)/nBins;
Subtraction = fRate * Mul * i*(exp(2*pi*i*BinSize*FreqRange')-1) ...
    ./ (2*pi*FreqRange'.*(FreqRange'.^2*BinSize^2 - 1));

for b = 1:nBins
	Times = t(find(Assignments==b));
    if length(Times)==0, continue; end;
	TimeSinceBinStart = Times-BinStarts(b);
	Exponent = exp(2*pi*i * Times * FreqRange');
	Taper = Mul*(1 - cos(2*pi*TimeSinceBinStart/BinSize));
	TaperMat = repmat(Taper, 1, nFreqs);
 	Transform(b,:) = sum(Exponent .* TaperMat, 1);
%	Transform(b,:) = sum(Exponent .* TaperMat, 1) - Subtraction;
end;

p = sum(abs(Transform).^2,1) / (nBins*BinSize);

if nargout<1
	newplot;
	plot(FreqRange,10*log10(abs(p))), grid on
	xlabel('Frequency'), ylabel('Power Spectrum Magnitude (dB)');
else
	out = p;
    mu = sum(WithinRanges(t,Epochs))/nBins/BinSize;
    sd = mu/sqrt(nBins);
end


return
% to test
test = sort(rand(1e4,1));
fr = 1e2:1e1:1e4;
[p mu sig] = PointPsd(test,fr,.01,[0 1]); semilogy(fr,p);
