function [Xspec,Fs] = tfxspec(X1, X2, tapers, dn, nf, fk, sampling, flag);
%TFXSPEC  Moving window time-frequency cross-spectrum using multitaper methods.
%
%   XSPEC = TFXSPEC(X1, X2, TAPERS) is the moving window time frequency 
%   spectral estimate of time series (array) X using the MTM (multitaper
%   method) using tapers defined by TAPERS=[N,P,K].
%
%   XSPEC = TFXSPEC(X1, X2, TAPERS, DN) moves by step size DN between 
%   estimates.  DN defaults to N./10;
%
%   XSPEC = TFXSPEC(X1, X2, TAPERS, DN, NF) defines the frequency grid NF. 
%   When X is real, SPEC is length (NF/2+1) for NF even or (NF+1)/2
%   for NF odd;  when either X is complex, SPEC is length NF.  NF is
%   optional; it defaults to the greater of 256 and the next power of 2
%   greater than the length of X.
%
%   [XSPEC, F] = TFSPEC(X1, X2, TAPERS, DN, NF, SAMPLING) returns a vector of 
%   frequencies at which the spectrum is estimated, where SAMPLING 
%   is the sampling frequency.  SAMPLING defaults to 1 Hz.
%   
%   See also DPSS, PSD, SPECGRAM, TFSPEC

%   Author: Bijan Pesaran, version date 15/10/98.


%[X1,dims]=reduce(ts1);
sX1 = size(X1);
nt1 = sX1(2);              % calculate the number of points
nch1 = sX1(1);               % calculate the number of channels

%[X2,dims]=reduce(ts2);
sX2 = size(X2);
nt2 = sX2(2);              % calculate the number of points
nch2 = sX2(1);               % calculate the number of channels

if nt1 ~= nt2 error('Lengths of time series are incompatible');end
if nargin < 4 dn = N./10; end
if nargin < 5 nf = max(256,2^(nextpow2(N)+1)); end
if nargin < 7 sampling = 1.; end
if nargin < 6 fk = nf./2.; end
if nargin > 5 fk = round(fk./sampling.*nf); end
if length(tapers) == 3 tapers(1) = tapers(1)*sampling; end
if nargin < 8 flag = 0; end

tapers = dpsschk(tapers);
N = length(tapers(:,1));
K = length(tapers(1,:));

nt = nt1;
dn = dn.*sampling;
nwin = (nt-N)./dn;           % calculate the number of windows

if flag == 0
Xspec = zeros(nwin,nch1,nch2,fk)+i.*zeros(nwin,nch1,nch2,fk);

for win = 0:nwin-1
   tmp1 = X1(:,win*dn+1:win*dn+N);
   tmp2 = X2(:,win*dn+1:win*dn+N);
   ftmp = xspec(tmp1, tmp2, tapers, nf);
   Xspec(win,:,:,:) = ftmp(:,:,1:fk);
end

end

if flag == 1
Xspec = zeros(nwin,fk)+i.*zeros(nwin,fk);

for win = 0:nwin-1
   tmp1 = X1(:,win*dn+1:win*dn+N);
   tmp2 = X2(:,win*dn+1:win*dn+N);
   ftmp = xspec(tmp1, tmp2, tapers, nf, fk./nf, 1, 1);
   Xspec(win,:) = ftmp(1:fk);
end

end
