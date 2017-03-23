function [spec,rate,f,err]=dmtspec_pt(dN,tapers,sampling,fk,pad,pval,flag) 
%DMTSPEC_PT  Point process spectrum using multitaper techniques
%
%  [SPEC,RATE,F,ERR]=DMTSPEC_PT(dN,TAPERS,SAMPLING,FK,PAD,PVAL,FLAG)  
%
%  Inputs:  dN		=  Point process array in [Space/Trials,Time] form.
%	    TAPERS 	=  Data tapers in [K,TIME], [N,W], or [N,P,K] form.
%			   	Defaults to [N, 5, 9] where N is duration of X.
%	    SAMPLING 	=  Sampling rate of point process dN in Hz. 
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
%  Outputs: SPEC	=  Spectrum of dN in [Space/Trials, Freq] form.
%	    RATE	=  Mean rate of dN in Hz.
%	    F		=  Units of Frequency axis for SPEC.
%	    ERR 	=  Error bars for SPEC in [Hi/Lo, Space/Trials, Freq]
%			   form given by a Jacknife-t interval for PVAL.
%

% Modification History: Rewritten by Bijan Pesaran 02/04/00

nch = size(dN,1);
nt = size(dN,2);

if nargin < 2 tapers = dpsschk([nt, 5, 9]); end 
if nargin < 3 sampling = 1; end 
if length(tapers) == 2
   n = tapers(1); 
   w = tapers(2);
   p = n*w;
   k = floor(2*p-1);
   if k < 1 error('Must choose N and W so that K > 1'); end
   if k < 3 disp('Warning:  Less than three tapers being used'); end
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

if N ~= nt error('Length of time series and tapers must be equal'); end
K = length(tapers(1,:));
nf = max(256,pad*2.^(nextpow2(N+1)));
nfk = floor(fk./sampling.*nf);
dof = 2.*K.*nch;

% Determine outputs
f = linspace(fk(1),fk(2),diff(nfk));
errorchk = 0;
if nargout > 3 errorchk = 1; end

ntapers = tapers.*sqrt(sampling);

%  Calculate the Slepian transforms.
H = fft(ntapers(:,1:K),nf)';

if ~flag		% No pooling across channels/trials
  spec = zeros(nch, diff(nfk));
  rate = zeros(1,nch);
  err = zeros(2, nch, diff(nfk));
%
%	This is the fourier transform loop
%	The difference between spectral analysis for
%	continuous and point processes is here.
%	We take the tapered fourier transform and 
%	subtract the mean number of spikes multiplied 
%	by |H|^2 which is the projection of DC into the frequency 
%	domain.
%
   for ch = 1:nch
	tmp = dN(ch,:)';
	dNk = fft(ntapers(:,1:K).*tmp(:,ones(1,K)),nf)'...
		- mean(tmp).*H;
     	dNk = dNk(:,nfk(1)+1:nfk(2));
        Sk = abs(dNk).^2;
        spec(ch,:) = mean(Sk,1);
  	rate(ch) = mean(sum((ntapers(:,1:K).*tmp(:,ones(1,K))).^2,1));
        
        if errorchk	%  Estimate error bars using Jacknife
          for ik = 1:K
            indices = setdiff([1:K],[ik]);
            dNj = dNk(indices,:);
            jlsp(ik,:) = log(mean(abs(dNj).^2,1));
          end
          lsig = sqrt(K-1).*std(jlsp,1);
          crit = tinv(1-pval./2,dof-1);	%   Determine the critical factor
          err(1,ch,:) = exp(log(spec(ch,:))+crit.*lsig);
          err(2,ch,:) = exp(log(spec(ch,:))-crit.*lsig);
         end
    end
end

if flag			% Pooling across trials
   spec = zeros(1, diff(nfk));
   err = zeros(2, diff(nfk));
   rate = 0;

   dNk = zeros(nch*K, diff(nfk));
   for ch=1:nch
     tmp = dN(ch,:)';
     xk = fft(ntapers(:,1:K).*tmp(:,ones(1,K)),nf)'...
		- mean(tmp).*H;
     rate = rate + mean(sum((ntapers(:,1:K).*tmp(:,ones(1,K))).^2,1));
     dNk((ch-1)*K+1:ch*K,:) = xk(:,nfk(1)+1:nfk(2));
   end
   spec = mean(abs(dNk).^2,1);
   rate = rate./nch;

   if errorchk		%  Estimate error bars using Jacknife
	for ik = 1:nch*K
	   indices = setdiff([1:K*nch],[ik]);
	   dNj = dNk(indices,:);
	   jlsp(ik,:) = log(mean(abs(dNj).^2,1));
	end
        lsig = sqrt(nch*K-1).*std(jlsp,1);
	crit = tinv(1-pval./2,dof-1);	%   Determine the scaling factor
      	err(1,:) = exp(log(spec)+crit.*lsig);
        err(2,:) = exp(log(spec)-crit.*lsig);
   end
end
