function [coh_pt,S_dN,S_dM,rate_dN,rate_dM,f,coh_err,SdN_err,SdM_err]=... 
	coherency_pt(dN, dM, tapers, sampling, fk, pad, pval, flag)
% COHERENCY_PT calculates the coherency between two point processes.
%
% [COH_PT, S_dN, S_dM, RATE_DN, RATE_DM, F, COH_ERR. SdN_ERR, SdM_ERR] = ...
%		COHERENCY_PT(dN, dM, TAPERS, SAMPLING, FK, PAD, PVAL, FLAG)
%
%  Inputs:  dN		=  Point process array in [Space/Trials,Time] form.
%	    dM		=  Point process array in [Space/Trials,Time] form.
%	    TAPERS 	=  Data tapers in [K,TIME] form or [N,P,K] form.
%			   	Defaults to [N, 3, 5] where N is the duration 
%				of dN and dM.
%	    SAMPLING 	=  Sampling rate of point process, dN, in Hz. 
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
%	   FLAG = 0:	calculate COH_PT seperately for each channel/trial.
%	   FLAG = 1:	calculate COH_PT by pooling across channels/trials.
%	   FLAG = 11 	calcuation is done as for FLAG = 1 
%		but the error bars cannot be calculated to save memory.
%	   	Defaults to FLAG = 11.
%
%  Outputs: COH_PT	=  Coherency between dN and dM in [Space/Trials,Freq] form.
%	    S_dN	=  Spectrum of dN in [Space/Trials, Freq] form. 
%	    S_dM	=  Spectrum of dM in [Space/Trials, Freq] form. 
%	    RATE_dN	=  Rate of point process dN. 
%	    RATE_dM	=  Rate of point process dM. 
%	    F		=  Units of Frequency axis for COH_PT.
%	    COH_ERR 	=  Error bars for COH_PT in [Hi/Lo, Space, Freq]  
%			   form given by the Jacknife-t interval for PVAL.
% 	    SdN_ERR 	=  Error bars for S_dN.
% 	    SdM_ERR 	=  Error bars for S_dM.
%

% Written by:  Bijan Pesaran, Caltech, 1998
%

sN = size(dN);
nt1 = sN(2);
nch1 = sN(1);

sM = size(dM);
nt2 = sM(2);
nch2 = sM(1);


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
if nargin < 7 pval = 0.05;  end
if nargin < 8 flag = 11; end 

ntapers = tapers.*sqrt(sampling);
K = length(ntapers(1,:));
N = length(ntapers(:,1));

if N ~= nt error('Length of time series and tapers must be equal'); end
K = length(tapers(1,:));
nf = max(256,pad*2.^(nextpow2(N+1)));
nfk = floor(fk./sampling.*nf);

% Determine outputs
f = linspace(fk(1),fk(2),diff(nfk));
errorchk = 0;
if nargout > 5 errorchk = 1; end

%  Calculate the Slepian transforms.
H = fft(ntapers(:,1:K),nf)';

if ~flag		% No pooling across channels/trials
   S_dN = zeros(nch, diff(nfk));
   rate_dN = zeros(nch);
   S_dM = zeros(nch, diff(nfk));
   rate_dM = zeros(nch);
 
   if errorchk
  	coh_err = zeros(2, nch, diff(nfk));
  	SdN_err = zeros(2, nch, diff(nfk));
  	SdM_err = zeros(2, nch, diff(nfk));
   end

   for ch = 1:nch
	tmp1 = dN(ch,:)';
	dNk = fft(ntapers(:,1:K).*tmp1(:,ones(1,K)),nf)'...
		- mean(tmp1).*H;
     	dNk = dNk(:,nfk(1)+1:nfk(2));
	tmp2 = dM(ch,:)';
	dMk = fft(ntapers(:,1:K).*tmp2(:,ones(1,K)),nf)'...
		- mean(tmp2).*H;
     	dMk = dMk(:,nfk(1)+1:nfk(2));
        SNk = abs(dNk).^2;
        S_dN(ch,:) = mean(SNk,1);
  	rate_dN(ch) = mean(sum((ntapers(:,1:K).*tmp1(:,ones(1,K))).^2,1));
        SMk = abs(dMk).^2;
        S_dM(ch,:) = mean(SMk,1);
  	rate_dM(ch) = mean(sum((ntapers(:,1:K).*tmp2(:,ones(1,K))).^2,1));
        coh_pt(ch,:) = mean(dMk.*conj(dNk))./sqrt(S_dN(ch,:).*S_dM(ch,:));

        if errorchk	%  Estimate error bars using Jacknife
          for ik = 1:K
            indices = setdiff([1:K],[ik]);
            dNj = dNk(indices,:);
            dMj = dMk(indices,:);
	    jcoh(ik,:) =dNj.*conj(dMj)./sqrt(mean(abs(dNj).^2).*mean(abs(dMj).^2));
	    jNlsp(ik,:) = log(mean(abs(dNj).^2,1));             
	    jMlsp(ik,:) =log(mean(abs(dMj).^2,1));           
	  end
%          lsigN = sqrt(K-1).*std(jNlsp,1);
%          lsigM = sqrt(K-1).*std(jMlsp,1);
%          lsigNM = sqrt(K-1).*std(jcoh,1);
%          p = 		%   Determine the scaling factor
%          coh_err(1,ch,:) = exp(log(coh_pt(ch,:))+p.*lsigNM);
%          coh_err(2,ch,:) = exp(log(coh_pt(ch,:))-p.*lsigNM);
%          SdN_err(1,ch,:) = exp(log(S_dN(ch,:))+p.*lsigN);
%          SdN_err(2,ch,:) = exp(log(S_dN(ch,:))-p.*lsigN);
%          SdM_err(1,ch,:) = exp(log(S_dM(ch,:))+p.*lsigM);
%          SdM_err(2,ch,:) = exp(log(S_dM(ch,:))-p.*lsigM);
         end
    end
end 
 
if flag			% Pooling across trials
   coh_pt = zeros(1, diff(nfk));
   S_dN = zeros(1, diff(nfk));
   S_dM = zeros(1, diff(nfk));

   coh_err = zeros(2, diff(nfk));
   SdN_err = zeros(2, diff(nfk));
   SdM_err = zeros(2, diff(nfk));
   rate_dN = 0;  rate_dM = 0;

   dNk = zeros(nch*K, diff(nfk));
   dMk = zeros(nch*K, diff(nfk));
   for ch = 1:nch
     tmp1 = dN(ch,:)';
     xk = fft(ntapers(:,1:K).*tmp1(:,ones(1,K)),nf)'...
		- mean(tmp1).*H;
     rate_dN = rate_dN + mean(sum((ntapers(:,1:K).*tmp1(:,ones(1,K))).^2,1));
     dNk((ch-1)*K+1:ch*K,:) = xk(:,nfk(1)+1:nfk(2));
     tmp2 = dM(ch,:)';
     yk = fft(ntapers(:,1:K).*tmp2(:,ones(1,K)),nf)'...
		- mean(tmp2).*H;
     rate_dM = rate_dM + mean(sum((ntapers(:,1:K).*tmp2(:,ones(1,K))).^2,1));
     dMk((ch-1)*K+1:ch*K,:) = yk(:,nfk(1)+1:nfk(2));
   end
   S_dN = mean(abs(dNk).^2);
   S_dM = mean(abs(dMk).^2);
   rate_dN = rate_dN./nch;
   rate_dM = rate_dM./nch;
   coh_pt = mean(dNk.*conj(dMk))./sqrt(S_dN.*S_dM);
   if errorchk			%  Estimate error bars using Jacknife
          for ik = 1:nch*K
            indices = setdiff([1:nch*K],[ik]);
            dNj = dNk(indices,:);
            dMj = dMk(indices,:);
	    jcoh(ik,:) =mean(dNj.*conj(dMj))./sqrt(mean(abs(dNj).^2).*mean(abs(dMj).^2));
	    jNlsp(ik,:) = log(mean(abs(dNj).^2,1));             
	    jMlsp(ik,:) =log(mean(abs(dMj).^2,1));           
          end
%          lsigN = sqrt(nch*K-1).*std(jNlsp,1);
%          lsigM = sqrt(nch*K-1).*std(jMlsp,1);
%          lsigNM = sqrt(nch*K-1).*std(jcoh,1);
%          p = 		%   Determine the scaling factor
%          coh_err(1,:) = exp(log(coh_pt)+p.*lsigNM);
%          coh_err(2,:) = exp(log(coh_pt)-p.*lsigNM);
%          SdN_err(1,:) = exp(log(S_dN)+p.*lsigN);
%          SdN_err(2,:) = exp(log(S_dN)-p.*lsigN);
%          SdM_err(1,:) = exp(log(S_dM)+p.*lsigM);
%          SdM_err(2,:) = exp(log(S_dM)-p.*lsigM);
   end
end


if flag == 11	%  Pooling across trials saving memory
   S_dN = zeros(1,diff(nfk));  
   S_dM = zeros(1,diff(nfk));
   coh = zeros(1,diff(nfk))+i.*zeros(1,diff(nfk));

   for ch = 1:nch
      tmp1 = dN(ch,:)';
      tmp2 = dM(ch,:)';
      dNk = fft(ntapers(:,1:K).*tmp1(:,ones(1,K)),nf)'...
		- mean(tmp1).*H;
      dNk = dNk(:,nfk(1)+1:nfk(2));
      S_dN = S_dN + mean(abs(dNk).^2)./nch;
      dMk = fft(ntapers(:,1:K).*tmp2(:,ones(1,K)),nf)'...
		- mean(tmp2).*H;
      dMk = dMk(:,nfk(1)+1:nfk(2));
      S_dM = S_dM + mean(abs(dMk).^2)./nch;
      coh = coh + mean(dNk.*conj(dMk))./nch;
   end
   coh = coh./sqrt(S_dN.*S_dM);
end

