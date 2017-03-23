function [d2sp_df, d2sp_dt, d2sp_dfdt, sp, f] = d2spec(X, tapers, ...
   	nf, fk, sampling, flag)
%D2SPEC Time and Frequency spectral second derivatives
%
%  [D2SP_DF, D2SP_DT, D2SP_DFDT, SP]=D2SPEC(X) computes the time and
%  frequency derivative spectral estimates.  
%
%  [D2SP_DF, D2SP_DT, D2SP_DFDT, SP, C, F] = D2SPEC(X, TAPERS, NF, FK, ...
%                                        SAMPLING, FLAG) 
%
%	C:Vector returning the scaling factors, [C_F, C_T] for log derivative
%	  estimates.
%	
%	Defaults:	TAPERS = [N, 5, 9]
%			NF = Next power of 2 > N
%			FK = SAMPLING/2
%			SAMPLING = 1
%			FLAG = 1

%  Author:  Bijan Pesaran July 2000, Bell Labs
%

[Y, dims] = reduce(X);
sY = size(Y);
N = sY(2);
ntr = sY(1);

p = [];
if nargin < 5 sampling = 1; end
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

K = length(tapers(1,:));
N = length(tapers(:,1));

T = N./sampling;
if isempty(p) p = (K + 1)./2; end

order = 1;
phi = zeros(1,order);	%  Introduce phi in equations, but set to zero
R = exp(i*phi);			%  The associated rotation 

dz = zeros(K,K);
for ik = 1:K-1	dz(ik,ik+1) = 1;  end	%  Elementary derivative

%	Construct derivative operator
%for p = 1:order
%	Dz_r  = R(p)*(dt + i*df);  				%  rotated derivatives
%	Dz 	= Dz_r'*Dz;								%  [not active]
%end   

df = (dz - dz')./sqrt(2);	
dt = (dz + dz')./sqrt(2); 						
Dz = dt - i*df;
Dz2 = Dz'*Dz;										% Go to 2nd derivative

dt2 = dt*dt - (1.+1./K).*eye(K);	
	a = -trace(dt2)./2;
	dt2(1) = a; dt2(end) = dt2(1);			%	Real part
df2 = dt*dt - Dz2./2;;							

dfdt = -i.*(df*dt + dt*df);					%	Imaginary part

f = [1:fk]*sampling./nf;

if flag == 1
   d2sp_df  = zeros(1, fk);
   d2sp_dt  = zeros(1, fk);
   d2sp_dfdt = zeros(1, fk);
   V = sp_proj(Y, tapers, nf, fk./nf.*sampling, sampling);
   sp = squeeze(mean(mean(abs(V).^2,1),2));
   for tr = 1:ntr
      pr = squeeze(V(tr, :, 1:fk));
    	d2sp_dt = d2sp_dt + real(diag(pr'*dt2*pr))'./ntr;
      d2sp_df = d2sp_df + real(diag(pr'*df2*pr))'./ntr;
      d2sp_dfdt = d2sp_dfdt + real(diag(pr'*dfdt*pr))'./ntr;
		%d2test = diag(pr'*test*pr)'./ntr;
   end 
end

%W = p./T.*sampling;
%C_F = pi./2./W;
%C_T = pi./T./sqrt(2).*sampling;
%
%C = [C_F, C_T];
