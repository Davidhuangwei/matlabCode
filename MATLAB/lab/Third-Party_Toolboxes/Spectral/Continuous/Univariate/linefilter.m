function [y, fs, cs, f0] = linefilter(X, tapers, sampling, fk, pad);
%  LINEFILTER filters a harmonic line from input univariate time
%  series.
%
%  [Y, FS, CS, F0] = LINEFILTER(X, TAPERS, SAMPLING, FK)
%
%  Inputs:  X = Univariate time series
%           TAPERS = 
%           SAMPLING
%           FK  = Frequency range
%
%  Outputs: Y  = Univariate time series
%           FS = F-spectrum for harmonic analysis
%           CS = Complex amplitude spectrum for harmonic analysis
%           F0 = Line frequency removed
%

%  Written by:  Bijan Pesaran
%

N = size(X,2);
tapers(1) = tapers(1).*sampling;
tapers = dpsschk(tapers);
K = size(tapers,2);

[fs, cs, f] = ftest(X, tapers, sampling, fk, pad);

[f_val,ind] = max(fs);
f0 = f(ind);
pdf = fdist(f_val,2,2*K-2);

if pdf < 1./N
  disp(['Significant line (' num2str(pdf) ') found at ' ...
	num2str(f0) ' and removed.']);
X_fit = 2.*real(cs(ind).*exp(-2.*pi.*complex(0,1).*f0.*[0:N-1]./sampling));
end

y = X-X_fit;
