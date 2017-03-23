function [C_list, f] = ...
    cohlist(X, list, tapers, sampling, fk, pad, flag) 
% COHLIST calculates the coherency for a list of time series.
%
% [C_LIST, F] = ...
%	COHLIST(X, LIST, TAPERS, SAMPLING, FK, PAD, FLAG)
%
%  Inputs:  X		=  Time series array in [Trials,Channel,Time] or
%				[Channels,Time] form.
%           LIST    =  List of channel pairs to calculate coherency for.
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
%
%	   FLAG = 0:	calculate C_MAT seperately for each channel/trial.
%	   FLAG = 1:	calculate C_MAT by pooling across channels/trials. 
%	   	Defaults to FLAG = 1.
%
%  Outputs: C_LIST        =  Coherency of X in [Chan,Chan,Freq] form.
%	     F	       =  Units of Frequency axis.
%

%  Written by:  Bijan Pesaran Caltech 1998
%

sX = size(X);
if length(sX) == 3
	nt = sX(3);
	nch = sX(2);
	ntrials = sX(1);
end
if length(sX) == 2
	nt = sX(2);
	nch = sX(1);
end

if nch < 2 error('X must have at least two channels'); end

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
if nargin < 7 flag = 1; end 

K = length(tapers(1,:)); 
N = length(tapers(:,1));
if N ~= nt.*sampling
  error('Error: Tapers and time series not the same length'); 
end

nf = max(256, pad*2^nextpow2(N+1)); 
nfk = floor(fk./sampling.*nf);
f = linspace(fk(1),fk(2),diff(nfk));

nlist = size(list,1)

if length(sX) == 2	%  Single trial
  C_list = zeros(nlist,diff(nfk));
  for n = 1:nlist
    ch1 = list(n,1);
    ch2 = list(n,2);
    [coh] = coherency(X(ch1,:), X(ch2,:), tapers, sampling, fk, pad, flag);
    C_list(n,:) = coh;
  end
end

if length(sX) == 3		%  Multiple trials
  if flag			%  Pooling across trials
    C_mat = zeros(nlist,diff(nfk));
    S_mat = zeros(nlist,diff(nfk));
    for ch1 = 1:nch
      ch1
      X1 = squeeze(X(:,ch1,:));
      for ch2 = 1:ch1
        X2 = squeeze(X(:,ch2,:));
        [coh,f,s_x] = coherency(X1, X2, tapers, sampling, fk, pad, 11);
        C_mat(ch1,ch2,:) = coh;  C_mat(ch2,ch1,:) = conj(coh);
        S_mat(ch1,:) = s_x;
      end
    end
  end
  if ~flag			%  No pooling across trials
    C_mat = zeros(nch,nch,ntrials,diff(nfk));
    S_mat = zeros(nch,ntrials,diff(nfk));
    for ch1 = 1:nch
      X1 = squeeze(X(:,ch1,:));
      for ch2 = 1:ch1
        X2 = squeeze(X(:,ch2,:));
        [coh,f,s_x] = coherency(X1, X2, tapers, sampling, fk, pad, flag);
        C_mat(ch1,ch2,:,:) = coh; C_mat(ch2,ch1,:,:) = conj(coh);
        S_mat(ch1,:,:) = s_x;
      end
    end
  end
end
