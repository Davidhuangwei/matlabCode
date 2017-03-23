function X = mtfilt2(N,band,sampling)
%  MTFILT Generates a bandpass filter using the multitaper method
%
%  X = MTFILT2(N, BAND, SAMPLING)
%
% Inputs:   N                = Length of filter in units of samples
%               BAND         =  [Lo,Hi] band pass parameters in units of SAMPLING
%               SAMPLING  = Sampling rate in Hz.
%                               Defaults to 1.

%  Author:  Bijan Pesaran 04/15/98
%

f0 = sum(band)./2;
W = diff(band)./sampling./2;
p = N*W; k = floor(2*p-1);
tapers = [N,p,k];

%disp(['Filter is ' num2str(N) ' points long using ' num2str(k) ' tapers']);
pr_op = dp_proj(tapers, 1, f0./sampling);
N = size(pr_op,1);
X = zeros(1,2.*N);
pr = pr_op*pr_op';
for t = 0:N-1 
	X(t+1:t+N) = X(t+1:N+t)+pr(:,N-t)'; 
end

X = real(X)./2;