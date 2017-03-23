function [lxc, sp1, sp2, f, lvar]= lxcoh(X1, X2, tapers, nf, fk, sampling, flag)
% LXCOH estimates the Loeve cross-coherency
%
% LXC = LXCOH(X1, X2, TAPERS, NF, FK, SAMPLING) calculates 
% the Loeve cross-coherency between X1 and X2 using prolates specified 
% in TAPERS.  NF defaults to the next power of 2 greater than N.  FK defaults
% to NF./2 and SAMPLING defaults to 1.
%
% [LXC, F] = LXCOH(X1, X2, TAPERS, NF, FK, SAMPLING) returns the
% frequency axis for LXC in F.
%
% [LXC, F, SP1, SP2, LVAR] = LXCOH(X1, X2, TAPERS, NF, FK, SAMPLING)  
% returns the error bars for LXC in LVAR.
%
% [LXC, F, LVAR] = LXCOH(X1, X2, TAPERS, NF, FK, SAMPLING, FLAG) allows
% the specification for the calculation of the Loeve coherency.  
% If flag is 0 the calculation is done row by row with one coherency per row.  
% If flag is 1 the calculation is done pooling across rows giving one
% coherence over all.  If flag is 11 then the calcuation is done as for
% FLAG = 1 but the error bars cannot be calculated to save memory.

% Written by:  Bijan Pesaran Caltech 1999
%

[Y1, dims1] = reduce(X1);
sY1 = size(Y1);
n1 = sY1(2);
ntr1 = sY1(1);

[Y2, dims2] = reduce(X2);
sY2 = size(Y2);
n2 = sY2(2);
ntr2 = sY2(1);

errorchk = 0;

if nargin < 6 sampling = 1; end
if n1 ~= n2 or ntr1 ~= ntr2 error('Input arrays not compatible'); end
if dims1 ~= dims2 error('Input arrays not compatible'); end

n = n1;

if nargin < 3 tapers = [n, 10, 19]; end
if length(tapers) == 3
   tapers(1) = tapers(1).*sampling;
   tapers = dpsschk(tapers);
end
if nargin < 4 nf = max(256,2^(nextpow2(n+1))); end
if nargin < 5 fk = nf./2; end
if nargin > 4 fk = floor(fk./sampling.*nf); end
if nargin < 7 flag = 0; end
if nargout > 4 errorchk = 1; end

ntr = ntr1;
dims = dims1;
K = length(tapers(1, :));

f = [1:fk]*sampling./nf;
tmpts1 = zeros(1, nf);
tmpts2 = zeros(1, nf);
N = length(tapers(:, 1));

if errorchk
if flag == 0
	lxc = zeros(ntr, fk, fk);
	for tr = 1:ntr
  		tmp1 = detrend(Y1(tr, :));
  		tmp2 = detrend(Y2(tr, :));
  		y1k = zeros(K, nf);
  		y2k = zeros(K, nf);
		for ik = 1:K 
  			tmpts1(1:N) = tmp1'.*tapers(:, ik);
  			tmpts2(1:N) = tmp2'.*tapers(:, ik);
  			y1k(ik, :) = fft(tmpts1); 
  			y2k(ik, :) = fft(tmpts2); 
		end
  		y1k = y1k(:, 1:fk);
  		y2k = y2k(:, 1:fk);
  		sp1(tr, :) = mean(abs(y1k).^2);
  		sp2(tr, :) = mean(abs(y2k).^2);
  		lxc(tr, :, :) = 1./K.*(y1k.'*conj(y2k))./...
                        (sqrt(sp1(tr, :))'*sqrt(sp2(tr, :)));            
  		lsp = zeros(K, fk, fk);
		for j = 1:K
       	indices = setdiff([1:K], [j]);
        	y1j = y1k(indices, 1:fk);
        	y2j = y2k(indices, 1:fk);
        	sp1j = mean(abs(y1j).^2, 1);
        	sp2j = mean(abs(y2j).^2, 1);
         lsp(j,:,:) = (1./(K-1).*(y1j.'*conj(y2j))...
                 ./(sqrt(sp1j)'*sqrt(sp2j)));
		end
  		lvar(tr, :, :) = (K-1)*std(lsp).^2;
	end
	lvar = restore(lvar, dims); 
	lxc = restore(lxc, dims);
	sp1 = restore(sp1, dims);
	sp2 = restore(sp2, dims);
end

if flag
	y1k = zeros(K.*ntr, fk);
	y2k = zeros(K.*ntr, fk);
	lxc = zeros(fk, fk);
	for tr = 1:ntr
  		tmp1 = detrend(Y1(tr, :));
  		tmp2 = detrend(Y2(tr, :));
		for ik = 1:K 
  			tmpts1(1:N) = tmp1'.*tapers(:, ik);
  			tmpts2(1:N) = tmp2'.*tapers(:, ik);
  			f1 = fft(tmpts1); 
  			f2 = fft(tmpts2);
  			y1k(ik+K.*tr, :) = f1(1:fk); 
			y2k(ik+K.*tr, :) = f2(1:fk);
		end
  		lsp = zeros(ntr.*K, fk, fk);
		for j = 1:K
       	indices = setdiff([1:K],[j]);
     		y1j = y1k(indices+K*tr, 1:fk);
        	y2j = y2k(indices+K*tr, 1:fk);
        	sp1j = mean(abs(y1j).^2, 1);
        	sp2j = mean(abs(y2j).^2, 1);
         lsp(j+K.*tr, :, :) = 1./(K-1).*(y1j.'*conj(y2j))...
                    ./(sqrt(sp1j)'*sqrt(sp2j));
		end
  		lvar = (K-1)*std(lsp).^2;
	end
	sp1 = mean(abs(y1k).^2, 1);
	sp2 = mean(abs(y2k).^2, 1);
	lxc = 1./(K.*ntr).*(y1k.'*conj(y2k))./(sqrt(sp1)'*sqrt(sp2));
end
end

if ~errorchk
	sp1 = zeros(1, fk);
	sp2 = zeros(1, fk);
	y1k = zeros(1, fk);
	y2k = zeros(1, fk);
	lxc = zeros(fk, fk);
	for tr = 1:ntr
  		tmp1 = detrend(Y1(tr, :));
  		tmp2 = detrend(Y2(tr, :));
		for ik = 1:K 
  			tmpts1(1:N) = tmp1'.*tapers(:, ik);
  			tmpts2(1:N) = tmp2'.*tapers(:, ik);
  			f1 = fft(tmpts1); 
  			f2 = fft(tmpts2); 
  			y1k = f1(1:fk);
  			y2k = f2(1:fk);
  			sp1 = sp1 + abs(y1k).^2./(K.*ntr);
  			sp2 = sp2 + abs(y2k).^2./(K.*ntr);
  			lxc = lxc + y1k.'*conj(y2k)./(K.*ntr);
		end
	end
	lxc = lxc./(sqrt(sp1)'*sqrt(sp2));
end