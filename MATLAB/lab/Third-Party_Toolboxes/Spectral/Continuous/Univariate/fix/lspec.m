function [lsp, f, lvar]= lspec(X, tapers, nf, fk, sampling, flag)
% LSPEC estimates the Loeve spectrum S(f1,f2)
%
% LSP = LSPEC(X, TAPERS, NF, FK, SAMPLING) calculates 
% the Loeve spectrum S(f1,f2) for an input series X prolates specified 
% in TAPERS.  NF defaults to the next power of 2 greater than N.  FK defaults
% to NF./2 and SAMPLING defaults to 1.
%
% [LSP, F] = LSPEC(X, TAPERS, NF, FK, SAMPLING) returns the
% frequency axis for LSP in F.
%
% [LSP, F, LVAR] = LSPEC(X, TAPERS, NF, FK, SAMPLING)  returns the
% error bars for LSP in LVAR.
%
% [LSP, F, LVAR] = LSPEC(X, TAPERS, NF, FK, SAMPLING, FLAG) allows
% the specification for the calculation of the Loeve coherency.  
% If flag is 0 the calculation is done row by row with one coherency per row.  
% If flag is 1 the calculation is done pooling across rows giving one
% coherence over all.  If flag is 11 then the calcuation is done as for
% FLAG = 1 but the error bars cannot be calculated to save memory.

% Written by:  Bijan Pesaran Caltech 1999
%

[Y, dims] = reduce(X);
sY = size(Y);
n = sY(2);
ntr = sY(1);

errorchk = 0;

if nargin < 6 sampling = 1; end
if nargin < 2 tapers = [n, 10, 19]; end
if length(tapers) == 3
   tapers(1) = tapers(1).*sampling;
   tapers = dpsschk(tapers);
end
if nargin < 4 nf = max(256,2^(nextpow2(n+1)+1)); end
if nargin < 5 fk = nf./2; end
if nargin > 4 fk = floor(fk./sampling.*nf); end
if nargin < 7 flag = 0; end
if nargout > 4 errorchk = 1; end

K = length(tapers(1, :));
f = [1:fk]*sampling./nf;
tmpts = zeros(1, nf);
N = length(tapers(:, 1));
if n ~= N error('Tapers and X are not compatible'); end

if errorchk
if flag == 0
	lsp = zeros(ntr, fk, fk);
	for tr = 1:ntr
  		tmp = detrend(Y(tr, :));
  		yk = zeros(K, nf);
		for ik = 1:K 
  			tmpts(1:N) = tmp'.*tapers(:, ik);
  			yk(ik, :) = fft(tmpts); 
		end
  		yk = yk(:, 1:fk);
  		lsp(tr, :, :) = 1./K.*(yk.'*conj(yk));
  		lspj = zeros(K, fk, fk);
		for j = 1:K
       	indices = setdiff([1:K], [j]);
        	yj = yk(indices, :);
         lspj(j, :, :) = 1./(K-1).*(yj.'*conj(yj));
		end
  		lvar(tr, :, :) = (K-1)*std(lspj).^2;
	end
	lvar = restore(lvar, dims); 
	lsp = restore(lsp, dims);
end

if flag
	yk = zeros(K.*ntr, fk);
	lsp = zeros(fk, fk);
	for tr = 1:ntr
  		tmp = detrend(Y(tr, :));
		for ik = 1:K 
  			tmpts(1:N) = tmp'.*tapers(:, ik);
  			f1 = fft(tmpts); 
  			yk(ik+K.*tr, :) = f1(1:fk); 
		end
  		lspj = zeros(ntr.*K, fk, fk);
		for j = 1:K
       	indices = setdiff([1:K],[j]);
     		yj = y1k(indices+K*tr, 1:fk);
        	spj = mean(abs(yj).^2, 1);
         lspj(j+K.*tr, :, :) = 1./(K-1).*(yj.'*conj(yj));
		end
  		lvar = (K-1)*std(lspj).^2;
	end
	lsp = 1./(K.*ntr).*(yk.'*conj(yk));
end
end

if ~errorchk
	yk = zeros(1, fk);
	lsp = zeros(fk, fk);
	for tr = 1:ntr
  		tmp = detrend(Y(tr, :));
		for ik = 1:K 
  			tmpts(1:N) = tmp'.*tapers(:, ik);
  			f1 = fft(tmpts); 
  			yk = f1(1:fk);
  			lsp = lsp + yk.'*conj(yk)./(K.*ntr);
		end
	end
end