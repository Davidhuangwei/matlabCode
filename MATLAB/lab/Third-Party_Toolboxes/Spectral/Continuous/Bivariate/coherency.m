function [coh,f,S_X,S_Y,coh_err,SX_err,SY_err]=...
	coherency(X,Y,tapers,sampling,fk,pad,flag,pval)  
% COHERENCY calculates the coherency between two time series, X and Y 
%
% [COH, F, S_X, S_Y,, COH_ERR, SX_ERR, SY_ERR] = ...
%	COHERENCY(X, Y, TAPERS, SAMPLING, FK, PAD, FLAG, PVAL)
%
%  Inputs:  X		=  Time series array in [Space/Trials,Time] form.
%	    Y		=  Time series array in [Space/Trials,Time] form.
%	    TAPERS 	=  Data tapers in [K,TIME], [N,P,K] or [N, W] form.
%			   	Defaults to [N,5,9] where N is the duration 
%				of X and Y.
%	    SAMPLING 	=  Sampling rate of time series X, in Hz. 
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
%	    FLAG = 0:	calculate COH seperately for each channel/trial.
%	    FLAG = 1:	calculate COH by pooling across channels/trials. 
%	    FLAG = 11 	calculation is done as for FLAG = 1 
%		but the error bars cannot be calculated to save memory.
%	   	Defaults to FLAG = 11.
%
%  Outputs: COH		=  Coherency between X and Y in [Space/Trials,Freq].
%                  F                              =  Units of Frequency axis for COH
%	    S_X		=  Spectrum of X in [Space/Trials, Freq] form.
%	    S_Y		=  Spectrum of Y in [Space/Trials, Freq] form.
%	    COH_ERR 	=  Error bars for COH in [Hi/Lo, Space, Freq]
%			   form given by the Jacknife-t interval for PVAL.
% 	    SX_ERR 	=  Error bars for S_X.
% 	    SY_ERR 	=  Error bars for S_Y.
%

% Written by:  Bijan Pesaran Caltech 1998
%

sX=size(X);
nt1=sX(2);
nch1=sX(1);

sY=size(Y);
nt2=sY(2);
nch2=sY(1);

if nt1 ~= nt2 error('Error: Time series are not the same length'); end 
if nch1 ~= nch2 error('Error: Time series are incompatible'); end 
nt = nt1;
nch = nch1;

if nargin < 4 sampling = 1; end 
nt = nt./sampling;
if nargin < 3 tapers = [nt, 5, 9]; end 
if length(tapers) == 2
   n = tapers(1);
   w = tapers(2);
   p = n*w;
   k = floor(2*p-1);
   tapers = [n,p,k];
   disp(['Using ' num2str(k) ' tapers.']);
end
if length(tapers) == 3  
   tapers(1) = tapers(1).*sampling;  
   tapers = dpsschk(tapers); 
end
if nargin < 5 fk = [0,sampling./2]; end
if length(fk) == 1
    fk = [0,fk];
end
if nargin < 6 pad = 2; end
if nargin < 7 flag = 11; end 
if nargin < 8 pval = 0.05;  end

N = length(tapers(:,1));
if N ~= nt*sampling 
	error('Error: Tapers and time series are not the same length'); 
end

K = length(tapers(1,:));
nf = max(256,pad*2.^(nextpow2(N+1)));
nfk = floor(fk./sampling.*nf);

% Determine outputs
f = linspace(fk(1),fk(2),diff(nfk));
errorchk = 0;
if nargout > 4 errorchk = 1; end

if flag == 0
   coh = zeros(nch, diff(nfk));
   S_X = zeros(nch, diff(nfk));
   S_Y = zeros(nch, diff(nfk));
 
   if errorchk
  	coh_err = zeros(2, nch, diff(nfk));
  	SX_err = zeros(2, nch, diff(nfk));
  	SY_err = zeros(2, nch, diff(nfk));
   end

   for ch = 1:nch
	tmp1 = detrend(X(ch,:))';
	Xk = fft(tapers(:,1:K).*tmp1(:,ones(1,K)),nf)';
     	Xk = Xk(:,nfk(1)+1:nfk(2));
	tmp2 = detrend(Y(ch,:))';
	Yk = fft(tapers(:,1:K).*tmp2(:,ones(1,K)),nf)';
     	Yk = Yk(:,nfk(1)+1:nfk(2));
        SXk = abs(Xk).^2;
        S_X(ch,:) = mean(SXk);
        SYk = abs(Yk).^2;
        S_Y(ch,:) = mean(SYk);
        coh(ch,:) = mean(Xk.*conj(Yk))./sqrt(S_X(ch,:).*S_Y(ch,:));

        if errorchk	%  Estimate error bars using Jacknife
          for ik = 1:K
            indices = setdiff([1:K],[ik]);
            Xj = Xk(indices,:);
            Yj = Yk(indices,:);
	    jcoh(ik,:)=mean(Xj.*conj(Yj))./...
		sqrt(mean(abs(Xj).^2).*mean(abs(Yj).^2));
	    jXlsp(ik,:) = log(mean(abs(Xj).^2,1));              	    
	    jYlsp(ik,:) = log(mean(abs(Yj).^2,1));            	  
	  end
%          lsigX = sqrt(K-1).*std(jXlsp,1);
%          lsigY = sqrt(K-1).*std(jYlsp,1);
%          lsigXY = sqrt(K-1).*std(jcoh,1);
%          p = 		%   Determine the scaling factor
%          coh_err(1,ch,:) = exp(log(coh(ch,:))+p.*lsigXY);
%          coh_err(2,ch,:) = exp(log(coh(ch,:))-p.*lsigXY);
%          SX_err(1,ch,:) = exp(log(S_X(ch,:))+p.*lsigX);
%          SX_err(2,ch,:) = exp(log(S_X(ch,:))-p.*lsigX);
%          SY_err(1,ch,:) = exp(log(S_Y(ch,:))+p.*lsigY);
%          SY_err(2,ch,:) = exp(log(S_Y(ch,:))-p.*lsigY);
         end
    end
end 


if flag			% Pooling across trials
   coh = zeros(1, diff(nfk));
   S_X = zeros(1, diff(nfk));
   S_Y = zeros(1, diff(nfk));

   coh_err = zeros(2, diff(nfk));
   SX_err = zeros(2, diff(nfk));
   SY_err = zeros(2, diff(nfk));

   Xk = zeros(nch*K, diff(nfk));
   Yk = zeros(nch*K, diff(nfk));
   for ch=1:nch
     tmp1 = detrend(X(ch,:))';
     xk = fft(tapers(:,1:K).*tmp1(:,ones(1,K)),nf)';
     Xk((ch-1)*K+1:ch*K,:) = xk(:,nfk(1)+1:nfk(2));
     tmp2 = detrend(Y(ch,:))';
     yk = fft(tapers(:,1:K).*tmp2(:,ones(1,K)),nf)';
     Yk((ch-1)*K+1:ch*K,:) = yk(:,nfk(1)+1:nfk(2));
   end
   S_X = mean(abs(Xk).^2);
   S_Y = mean(abs(Yk).^2);
   coh = mean(Xk.*conj(Yk))./sqrt(S_X.*S_Y);
   if errorchk			%  Estimate error bars using Jacknife
          for ik = 1:nch*K
              indices = setdiff([1:nch*K],[ik]);
              Xj = Xk(indices,:);
              Yj = Yk(indices,:);
  jcoh(ik,:)=Xj.*conj(Yj)./sqrt(mean(abs(Xj).^2).*mean(abs(Yj).^2));
	      jXlsp(ik,:) = log(mean(abs(Xj).^2,1));
              jYlsp(ik,:) = log(mean(abs(Yj).^2,1));
           end
%          lsigX = sqrt(nch*K-1).*std(jXlsp,1);
%          lsigY = sqrt(nch*K-1).*std(jYlsp,1);
%          lsigXY = sqrt(nch*K-1).*std(jcoh,1);
%          p = 		%   Determine the scaling factor
%          coh_err(1,:) = exp(log(coh)+p.*lsigXY);
%          coh_err(2,:) = exp(log(coh)-p.*lsigXY);
%          SX_err(1,:) = exp(log(S_X)+p.*lsigX);
%          SX_err(2,:) = exp(log(S_X)-p.*lsigX);
%          SY_err(1,:) = exp(log(S_Y)+p.*lsigY);
%          SY_err(2,:) = exp(log(S_Y)-p.*lsigY);
   end
end


if flag == 11	%  Pooling across trials saving memory
   S_X = zeros(1,diff(nfk));  
   S_Y = zeros(1,diff(nfk));
   coh = zeros(1,diff(nfk))+i.*zeros(1,diff(nfk));

   for ch = 1:nch
      tmp1 = detrend(X(ch,:))';
      tmp2 = detrend(Y(ch,:))';
      Xk = fft(tapers(:,1:K).*tmp1(:,ones(1,K)),nf)';
      Xk = Xk(:,nfk(1)+1:nfk(2));
      S_X = S_X + mean(abs(Xk).^2)./nch;
      Yk = fft(tapers(:,1:K).*tmp2(:,ones(1,K)),nf)';
      Yk = Yk(:,nfk(1)+1:nfk(2));
      S_Y = S_Y + mean(abs(Yk).^2)./nch;
      coh = coh + mean(Xk.*conj(Yk))./nch;
   end
   coh = coh./(sqrt(S_X.*S_Y));
end
