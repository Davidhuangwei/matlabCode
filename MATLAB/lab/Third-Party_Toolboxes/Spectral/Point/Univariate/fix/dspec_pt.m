function [dsp_df, dsp_dt, sp, hf, f] = dspec_pt(dN, tapers, sampling, fk,
... 		nf, flag) 
%DSPEC_PT Time and Frequency spectral second derivatives 
% 
%  [DSP_DF, DSP_DT,SP] = DSPEC_PT(dN) computes the time and 
%  frequency derivative spectral estimates.   
%
%  [DSP_DF, DSP_DT, SP, C, F] = DSPEC_PT(dN, TAPERS, NF, FK, ...
%                                        SAMPLING, FLAG) 
%
%   C:	Vector returning the scaling factors, [C_F, C_T] for 
%	log derivative estiates
%	
%   Defaults:	TAPERS = [N, 5, 9]
%		NF = Next power of 2 > N
%		FK = SAMPLING/2
%		SAMPLING = 1
%		FLAG = 1

%  Author:  Bijan Pesaran July 2000, Bell Labs
%

%[Y, dims] = reduce(X);
sdN = size(dN);
N = sdN(2);
ntr = sdN(1);

p = [];
if nargin < 5 sampling=1; end
if nargin < 2 tapers = [N, 5, 9]; end
if length(tapers) == 3
   tapers(1) = tapers(1).*sampling;
   p = tapers(2);
   tapers = dpsschk(tapers);
end
if nargin < 3 nf = 2.^(nextpow2(N+1)+1); end
if nargin < 4 fk = nf./2; end
if nargin > 3 fk = floor(fk./sampling.*nf);  end
if nargin < 6 flag = 1; end

K=length(tapers(1,:));
N=length(tapers(:,1));

T = N./sampling;
if isempty(p) p = (K + 1)./2; end

dz = zeros(K,K);
for ik = 1:K-1	dz(ik,ik+1) = 1;  end

f = [1:fk]*sampling./nf;

if flag == 1
   dsp = zeros(1, fk);
   sp = zeros(1, fk);
   tmp = zeros(1, fk);
   [V, hf] = spproj_pt(dN, tapers, nf, fk./nf.*sampling, sampling);
   for tr = 1:ntr
      pr = squeeze(V(tr, :, :));
      sp = sp + mean(abs(pr).^2,1)./ntr;
      pr = pr./sqrt(hf);
      for ik = 1:K-1
         tmp(ik,:) = squeeze(V(tr,ik,1:fk).*conj(V(tr,ik+1,1:fk)))';
      end      
      dsp = dsp + mean(tmp);
   end
   dsp = dsp./ntr;
   dsp_df = 2*imag(dsp);
   dsp_dt = -real(dsp)./2;
end


if flag == 0
  	dsp_df = zeros(ntr, fk);
  	dsp_dt = zeros(ntr, fk);
  	sp = zeros(ntr, fk);
  	tmp = zeros(1, nf);
  	V = zeros(K,nf)+complex(0,1)*zeros(K,nf);
  	for tr=1:ntr
  		tmp1 = detrend(Y(tr,:));
   	for j = 1:K 
      	tmp(1:N) = tmp1'.*tapers(:,j);
      	V(j,:) = fft(tmp2); 
   	end
  		sp(tr, :) = mean(abs(V(:,1:fk)).^2,1);
  		dsp = mean(V(1:K-1,1:fk).*conj(V(2:K,1:fk)),1);
  		dsp_df(tr, :) = 2.*imag(dsp);
  		dsp_dt(tr, :) = -2.*real(dsp);
  	end
end

W = p./T.*sampling;
C_F = pi./2./W;
C_T = pi./T./sqrt(2).*sampling;

C = [C_F, C_T];
