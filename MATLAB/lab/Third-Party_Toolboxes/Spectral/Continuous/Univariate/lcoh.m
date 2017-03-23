function [lc, sp, f, err]= lcoh(X, tapers, sampling, fk, pad, pval, flag)
% LCOH estimates the Loeve coherency for time series

% [LC, SP, F, ERR] = LCOH(X, TAPERS, SAMPLING, FK, PAD, PVAL, FLAG)
%
%  Inputs:  X		=  Time series array in [Space/Trials,Time] form.
%	    TAPERS 	=  Data tapers in [K,TIME], [N,P,K] or [N,W] form.
%			   	Defaults to [N,5,9] where N is duration of X.
%	    SAMPLING 	=  Sampling rate of time series X in Hz. 
%				Defaults to 1.
%	    FK 	 	=  Frequency range to return in Hz in
%                               either [F1,F2] or [F2] form.  
%                               In [F2] form, F1 is set to 0.
%			   	Defaults to [0,SAMPLING/2]
%	    PAD		=  Padding factor for the FFT.  
%			      	i.e. For N = 500, if PAD = 2, we pad the FFT 
%			      	to 1024 points; if PAD = 4, we pad the FFT
%			      	to 2048 points.
%				Defaults to 2.
%	    PVAL	=  P-value to calculate error bars for.
%				Defaults to 0.05 i.e. 95% confidence.
%
%	    FLAG = 0:	calculate LC seperately for each channel/trial.
%	    FLAG = 1:	calculate LC by pooling across channels/trials. 
%	    FLAG = 11 	calcuation is done as for FLAG = 1 but the 
%                       error bars aren't calculated to save memory.
%	    	Defaults to 11.
%
%
%  Outputs: LC	        =  Loeve coherency of X in [Space/Trials, Freq] form.
%	    S_X		=  Spectrum of X in [Space/Trials, Freq] form. 
%	    F		=  Units of Frequency axis for LC.
%	    COH_ERR 	=  Error bars for LC in [Hi/Lo, Space/Trials, Freq]
%			   form given by a Jacknife-t interval for PVAL.
% 	    SX_ERR 	=  Error bars for S_X.
%

% Written by:  Bijan Pesaran Caltech 1999
%

sX = size(X);
nt = sX(2);
nch = sX(1);

%  Set the defaults

if nargin < 3 sampling = 1; end
nt = nt./sampling;
if nargin < 2 tapers = [nt,5,9]; end
if length(tapers) == 2
   n = tapers(1);
   w = tapers(2);
   p = n*w;
   k = floor(2*p-1);
   tapers = [n,p,k];
   disp('Using ' num2str(k) ' tapers.');
end
if length(tapers) == 3 
   tapers(1) = tapers(1).*sampling; 
   tapers = dpsschk(tapers);
end
if nargin < 4 fk = [0,sampling./2]; end
if length(fk) == 1
    fk = [0,fk];
end
if nargin < 5 pad = 2; end
if nargin < 6 pval = 0.05;  end
if nargin < 7 flag = 11; end 

N = length(tapers(:,1));
nt = nt.*sampling;
if N ~= nt error('Error:  Length of time series and tapers must be equal'); end

K = length(tapers(1,:));
nf = max(256,pad*2.^(nextpow2(N+1)));
nfk = floor(fk./sampling.*nf);

% Determine outputs
f = linspace(fk(1),fk(2),diff(nfk));
errorchk = 0;
if nargout > 3 errorchk = 1; end

if flag	== 0		%  No pooling across trials
  lc = zeros(nch, diff(nfk), diff(nfk));
  sp = zeros(nch, diff(nfk));
  for ch = 1:nch
    tmp = detrend(X(ch, :));
    Xk = fft(tapers(:,1:K).*tmp(:,ones(1,K)),nf)';
    Xk = Xk(:, nfk(1)+1:nfk(2));
    sp(ch, :) = mean(abs(Xk).^2);
    lc(ch, :, :) = 1./K.*(Xk.'*conj(Xk))./...
	sqrt(sp(ch, :)'*sp(ch, :));
    
%    if errorchk    %  Estimate error bars using Jacknife
%  	lsp = zeros(K, fk, fk);
%	for j = 1:K
%	  indices = setdiff([1:K], [j]);
%	  yj = yk(indices, 1:fk);
%	  spj = mean(abs(yj).^2);
%	  lsp(j,:,:) = 1./(K-1).*(yj.'*conj(yj))./sqrt(spj'*spj);
%	end
%  	lvar(tr, :, :) = (K-1)*std(lsp).^2;
%    end
    
end

if flag	== 1		%  Pooling across trials
   Xk = zeros(K.*nch, diff(nfk));
   for ch = 1:nch
      tmp = detrend(X(ch, :))';
      Xk_tmp = fft(tapers(:,1:K).*tmp(:,ones(1,K)),nf)';
      Xk((ch-1)*K+1:ch*K,:) = Xk_tmp(:,nfk(1)+1:nfk(2));

%  		lsp = zeros(ntr.*K, fk, fk);
%		for j = 1:K
%        	indices = setdiff([1:K],[j]);
%     		yj = yk(indices+K*tr, 1:fk);
%        	spj = mean(abs(yj).^2, 1);
%        lsp(j+K.*tr, :, :) = 1./(K-1).*(yj.'*conj(yj))./sqrt(spj'*spj);
%		end
%  		lvar = (K-1)*std(lsp).^2;
%	end

   end
   sp = mean(abs(Xk).^2);
   lc = 1./(K.*nch).*(Xk.'*conj(Xk))./sqrt(sp'*sp);
end

if flag == 11		%  Pooling across trials to save memory
   sp = zeros(1, diff(nfk));
   lc = zeros(diff(nfk), diff(nfk));
   for tr = 1:nch
      tmp = detrend(X(ch, :))';
      Xk = fft(tapers(:,1:K).*tmp(:,ones(1,K)),nf)';
      Xk = Xk(:,nfk(1)+1:nfk(2));
      sp = sp + sum(abs(Xk).^2)./(K.*nch);
      lc = lc + Xk.'*conj(Xk)./(K.*nch);
   end
   lc = lc./sqrt(sp'*sp);
end
