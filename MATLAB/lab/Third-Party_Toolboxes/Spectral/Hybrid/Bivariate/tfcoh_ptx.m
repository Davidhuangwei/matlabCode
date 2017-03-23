function [coh_ptx, tfsp_X, tfsp_dN, rate, f] = ...
   tfcoh_ptx(X, dN, tapers, sampling, dn, fk, pad, flag);
%TFCOH_PTX  Moving window time-frequency hybrid process coherency.
%
%  [COH_PTX, TFSP_X, TFSP_DN, RATE, F] = ...
%		TFCOH_PTX(X, dN, TAPERS, SAMPLING, DN, FK, PAD, FLAG) 

%
%  Inputs:  X		=  Time series array in [Space/Trials,Time] form.
%	    dN		=  Point process array in [Space/Trials,Time] form.
%	    TAPERS 	=  Data tapers in [K,TIME], [N,P,K] or [N, W] form.
%			   	Defaults to [N,5,9] where N is the duration 
%				of X and Y.
%	    SAMPLING 	=  Sampling rate of time series X, in Hz. 
%				Defaults to 1.
%	    DN		=  Overlap in time between neighbouring windows.
%			       	Defaults to N./10;
%	    FK 	 	=  Frequency range to return in Hz in
%                               either [F1,F2] or [F2] form.  
%                               In [F2] form, F1 is set to 0.
%			   	Defaults to [0,SAMPLING/2]
%	    PAD		=  Padding factor for the FFT.  
%			      	i.e. For N = 500, if PAD = 2, we pad the FFT 
%			      	to 1024 points; if PAD = 4, we pad the FFT
%			      	to 2048 points.
%				Defaults to 2.
%
%	   FLAG = 0:	calculate COH seperately for each channel/trial.
%	   FLAG = 1:	calculate COH by pooling across channels/trials. 
%
%  Outputs: COH	        =  Coherency between X and Y in [Space/Trials,Freq].
%	    S_X		=  Spectrum of X in [Space/Trials, Freq] form. 
%	    S_Y		=  Spectrum of Y in [Space/Trials, Freq] form. 
%	    F		=  Units of Frequency axis for COH.
%

%  Written by:  Bijan Pesaran Caltech 1998
%

sX = size(X);
nt1 = sX(2);
nch1 = sX(1);

sdN = size(dN);
nt2 = sdN(2);
nch2 = sdN(1);

if nt1 ~= nt2 error('Error: Time series are not the same length'); end 
if nch1 ~= nch2 error('Error: Time series are incompatible'); end 
nt = nt1;
nch = nch1;

if nargin < 4 sampling = 1; end 
t = nt./sampling;
if nargin < 3 tapers = [t,5,9]; end 
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
if nargin < 5 dn = n./10; end
if nargin < 6 fk = [0,sampling./2]; end
if length(fk) == 1
    fk = [0,fk];
end
if nargin < 7 pad = 2; end
if nargin < 8 pval = 0.05;  end
if nargin < 9 flag = 0; end 

K = length(tapers(1,:)); 
N = length(tapers(:,1));
if N > nt error('Error: Tapers are longer than time series'); end

dn = dn.*sampling;
nf = max(256, pad*2^nextpow2(N+1)); 
nfk = floor(fk./sampling.*nf);
nwin = floor((nt-N)./dn);           % calculate the number of windows
f = linspace(fk(1),fk(2),diff(nfk));

if ~flag			%  No pooling across trials
   coh_ptx = zeros(nwin,nch,diff(nfk)); 
   tfsp_X = zeros(nwin,nch,diff(nfk));  
   tfsp_dN = zeros(nwin,nch,diff(nfk));
   for win = 1:nwin
	X_tmp = X(:,win*dn+1:win*dn+n);
	dN_tmp = dN(:,win*dn+1:win*dn+n); 
	[coh_tmp, S_X, S_dN, rate_tmp] = coherency_ptx(X_tmp, dN_tmp,...
	   tapers, sampling, fk, pad, pval, flag);    
        coh_ptx(win,:,:) = coh_tmp;     
        tfsp_X(win,:,:) = S_X; 
        tfsp_dN(win,:,:) = S_dN;
        rate(:,win) = rate_tmp';
   end
   tfsp_X = permute(tfsp_X,2,1,3);
   tfsp_dN = permute(tfsp_dN,2,1,3);
   coh_ptx = permute(coh_ptx,2,1,3);
end

if flag			%  Pooling across trials
   coh_ptx = zeros(nwin,diff(nfk));
   tfsp_X = zeros(nwin,diff(nfk));  
   tfsp_dN = zeros(nwin,diff(nfk));
   for win = 1:nwin
	X_tmp = X(:,win*dn+1:win*dn+n);
	dN_tmp = dN(:,win*dn+1:win*dn+n);
	[coh_tmp, S_X, S_dN, rate_tmp] = coherency_ptx(X_tmp, dN_tmp,...
	   tapers, sampling, fk, pad, pval, flag);    
        coh_ptx(win,:) = coh_tmp;    
        tfsp_X(win,:) = S_X;
        tfsp_dN(win,:) = S_dN;
        rate(win) = rate_tmp;
end
