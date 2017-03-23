function [spec,rate,f,err] = tfspec_pt(dN, tapers, sampling, ...
	dn, fk, pad, pval,flag);
%TFSPEC_PT  Moving-window time-frequency point process multitaper spectrum.  
%
% [SPEC, RATE, F, ERR] = TFSPEC_PT(dN,TAPERS,SAMPLING,DN,FK,PAD,PVAL,FLAG)  
%
%  Inputs:  dN		=  Point process array in [Space/Trials,Time] form.
%	    TAPERS 	=  Data tapers in [K,TIME], [N,W], or [N,P,K] form.
%			   	Defaults to [N, 5, 9] where N is NT/10. 
%	    SAMPLING 	=  Sampling rate of point process, dN, in Hz. 
%				Defaults to 1.
%	    DN		=  Overlap in time of neighbouring windows.
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
%	    PVAL	=  P-value to calculate error bars for.
%				Defaults to 0.05 i.e. 95% confidence.
%
%	   FLAG = 0:	calculate SPEC seperately for each channel/trial.
%	   FLAG = 1:	calculate SPEC by pooling across channels/trials. 
%
%  Outputs: SPEC	=  Spectrum of dN in [Space/Trials, Time, Freq] form.
%	    RATE	=  Rate of point process. 
%	    F		=  Units of Frequency axis for SPEC.
%	    ERR 	=  Error bars in[Hi/Lo, Space, Time, Freq]  
%			   form given by the Jacknife-t interval for PVAL.
% 

%   Author: Bijan Pesaran, version date 15/10/98.

sdN = size(dN);
nt  = sdN(2);              % calculate the number of points
ntr = sdN(1);              % calculate the number of trials
nch = ntr;

n = floor(nt./10);
if nargin < 2 tapers = dpsschk([n, 5, 9]); end
if nargin < 3 sampling = 1.; end
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
   n = tapers(1);
   tapers(1) = tapers(1).*sampling;  
   tapers = dpsschk(tapers);
end
if nargin < 4 dn = n./10; end
if nargin < 5 fk = [0,sampling./2.]; end
if length(fk) == 1
    fk = [0,fk];
end
if nargin < 6 pad = 2; end
if nargin < 7 pval = 0.05; end
if nargin < 8 flag = 0; end

errorchk = 0;
if nargout > 3 errorchk = 1; end

n = n.*sampling;
dn = dn.*sampling;
nf = max(256, pad*2^nextpow2(n+1)); 
nfk = floor(fk./sampling.*nf);
nwin = floor((nt-n)./dn);           % calculate the number of windows
f = linspace(fk(1),fk(2),diff(nfk));

if ~flag				% No pooling across trials
    spec = zeros(nch,nwin,diff(nfk));
    rate = zeros(nch,nwin);
    for ch = 1:nch
	for win = 1:nwin
   	tmp = dN(ch,win*dn+1:win*dn+n);
if ~errorchk				%  Don't estimate error bars
   	[ftmp, rate_tmp] = ...
		dmtspec_pt(tmp, tapers, sampling, fk, pad);
	spec(ch,win,:) = ftmp;
	rate(ch,win) = rate_tmp;
else 					%  Estimate error bars
   	[ftmp, rate_tmp, dum, err_tmp] = ...
		dmtspec_pt(tmp,tapers,sampling,fk,pad,pval);  
	spec(ch,win,:) = ftmp;
	rate(ch,win) = rate_tmp;
	err(1,ch,win,:) = err_tmp(1,:);
	err(2,ch,win,:) = err_tmp(2,:);
end
	end
     end
end

if flag					% Pooling across trials
    spec = zeros(nwin,diff(nfk));
    rate = zeros(nwin);
    for win = 1:nwin
   	tmp = X(:,win*dn+1:win*dn+n);
if ~errorchk				%  Don't estimate error bars
   	[ftmp,rate_tmp] = ...
		dmtspec_pt(tmp, tapers, sampling, fk, pad, pval,flag);    	
	spec(win,:) = ftmp;
	rate(win,:) = rate_tmp;
else					%  Estimate error bars
   [ftmp, rate_tmp, dum, err_tmp] = ...
		dmtspec_pt(tmp, tapers, sampling, fk, pad,pval,flag); 	      
   	spec(win,:) = ftmp;
	rate(win,:) = rate_tmp;
        err(1,win,:) = err_tmp(1,:);
	err(2,win,:) = err_tmp(2,:);
end
     end
end
