function [dsp_df, dsp_dt, sp, f, err_df, err_dt, err_sp] = ...
	dspec(X, tapers, sampling, fk, pad, pval, flag) 
%DSPEC calculates time and frequency first-order spectral derivatives 
% 
%  [DSP_DF, DSP_DT, SP, F, ERR_DF, ERR_DT, ERR_SP] = 
%		DSPEC(X, TAPERS, SAMPLING, FK, PAD, FLAG)
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
%	   PVAL		=  P-value to calculate error bars for.
%				Defaults to 0.05 i.e. 95% confidence.
%
%	   FLAG = 0:	calculate SPEC seperately for each channel/trial.
%	   FLAG = 1:	calculate SPEC by pooling across channels/trials. 
%
%  Outputs: DSP_DF	=  Freq-deriv spectrum of X in [Space/Trials,Freq]form.
%	    DSP_DT	=  Time-deriv spectrum of X in [Space/Trials,Freq]form.
%	    SP		=  Spectrum of X in [Space/Trials,Freq] form.
%	    F		=  Units of Frequency axis for SPEC.
%	    ERR_DF	=  Error bars for DSP_DF in [Hi/Lo, Space/Trials, Freq]
%			   form given by a Jacknife-t interval for PVAL.
%	    ERR_DT	=  Error bars for DSP_DT in [Hi/Lo, Space/Trials, Freq]
%			   form given by a Jacknife-t interval for PVAL.
%	    ERR_SP	=  Error bars for SP in [Hi/Lo, Space/Trials, Freq]
%			   form given by a Jacknife-t interval for PVAL.
%

%  Author:  Bijan Pesaran July 1999, Bell Labs
%

sX = size(X);
nt = sX(2);
nch = sX(1);

%  Set the defaults

if nargin < 3 sampling = 1; end
nt = nt./sampling;
if nargin < 2 tapers = [nt,3,5]; end
if length(tapers) == 2
   n = tapers(1);
   w = tapers(2);
   p = n*w;
   k = floor(2*p-1);
   tapers = [n,p,k];
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
if nargin < 7 flag = 0; end 

N = length(tapers(:,1));
nt = nt.*sampling;
if N ~= nt error('Error:  Length of time series and tapers must be equal'); end

K = length(tapers(1,:));
nf = max(256,pad*2.^(nextpow2(N+1)));
nfk = floor(fk./sampling.*nf);

% Determine outputs
f = linspace(fk(1),fk(2),diff(nfk));
errorchk = 0;
if nargout > 2 errorchk = 1; end

if isempty(p) p = (K + 1)./2; end

dz = zeros(K,K);
for ik = 1:K-1	dz(ik,ik+1) = 1;  end

if flag == 1
   dsp = zeros(1, nfk);
   sp = zeros(1, nfk);
   tmp = zeros(1, nfk);
   V = sp_proj(X, tapers, nf, fk./nf.*sampling, sampling);
   for ch = 1:nch
      pr = squeeze(V(ch, :, :));
      sp = sp + mean(abs(pr).^2,1)./nch;
      for ik = 1:K-1
         tmp(ik,:) = squeeze(V(ch,ik,nfk(1)+1:nfk(2)).*...
		conj(V(ch,ik+1,nfk(1)+1:nfk(2))))';       
      end      
      dsp = dsp + mean(tmp);
   end
   dsp = dsp./nch;
   dsp_df = 2*imag(dsp);
   dsp_dt = -real(dsp)./2;
end


if flag == 0
  	dsp_df = zeros(nch, nfk);
  	dsp_dt = zeros(nch, nfk);
  	sp = zeros(nch, nfk);
  	for ch = 1:nch
  		tmp = detrend(X(ch,:));
     		V = fft(tapers(:,1:K).*tmp(:,ones(1,K)),nf)';
		V = V(:,nfk(1)+1:nfk(2));
  		dsp = mean(V(1:K-1,:).*conj(V(2:K,:)),1);
  		dsp_df(ch, :) = 2.*imag(dsp);
  		dsp_dt(ch, :) = -2.*real(dsp);
  		sp(ch, :) = mean(abs(V).^2,1);
  	end
end

W = p./T.*sampling;
C_F = pi./2./W;
C_T = pi./T./sqrt(2).*sampling;

C = [C_F, C_T];
