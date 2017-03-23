function [sv,space,coh,time,f_axis] = fsvd_tr(varargin)
%FSVD_TR  Space-frequency calculation using multitaper methods with
%      trial averaging over the first index.
% 
%  SV = FSVD(X)  computes the singular value spectrum, SV, of the input 
%  time series array, X, as a function of frequency on the nyquist interval 
%  [0,0.5] with spacing in frequency 0.05 using tapers the length 
%  of the time series with NW=5 and K=9.
%
%  [SV, SPACE] = FSVD(X) computes the space modes associated with
%  the singular value spectrum for the input time series, TS.
%
%  [SV, SPACE] = FSVD(X, MASK) computes the fsvd on selected channels 
%  in the time series array, X, given by the array, MASK.  MASK has the
%  same spatial dimensions as X with 1s for elements that are to be 
%  used and 0s for those that aren't.
%
%  [SV, SPACE] = FSVD(X, MASK, TAPERS] computes the space modes and singular
%  value spectrum using prolates given in TAPERS.  TAPERS can give the
%  parameters of the prolates in a vector of the format [N, NW, K] where
%  N is the length of the sequence, NW is the time-bandwidth product of
%  the sequences and K is the number of sequences to be used.  Alternatively
%  TAPERS can include the eigenvectors themselves in the format 
%  E(N,K) as produced by DPSS. If the length of the tapers is less than
%  the length of the time series then the tapers are stepped along the 
%  data by DN=N/10 points
%
%  [SV, SPACE] = FSVD(X, MASK, TAPERS, DN) computes the space modes and
%  singular value spectrum stepping the tapers along by DN points.
%
%  [SV, SPACE] = FSVD(X, MASK, TAPERS, DN,  F_RANGE) computes the space modes
%  and singular value spectrum on the frequency range given by the vector 
%  F_RANGE in the format [F_DOWN, DF, F_UP].  The units of F_RANGE are
%  given by the SAMPLING input which defaults to 1.
%
%  [SV, SPACE] = FSVD(X, MASK, TAPERS, DN, F_RANGE, SAMPLING) computes the 
%  space modes and singular value spectrum on the frequency range given
%  by F_RANGE in units where the sampling frequency is SAMPLING.
%
%  [SV, SPACE] = FSVD(X, MASK, TAPERS, DN, F_RANGE, SAMPLING, NUM) 
%  computes the space modes and singular value spectrum keeping NUM 
%  space modes.  Defaults to 5.
%
%  [SV, SPACE, F_AXIS] = FSVD(X) returns to F_AXIS the centre frequencies 
%  at which the svd was carried out in units of SAMPLING.
%  
%  See also 

%   Author: Bijan Pesaran, version date 3/12/98.

% parameters/defaults:

error(nargchk(1,7,nargin))
tp=' ';
[msg, X, mask, tapers, dn, f_range, sampling, num]=fsvdchk_tr(varargin);
if msg ~= tp; error(msg); end

if length(tapers) == 2
   n = tapers(1);
   w = tapers(2);
   p = n*w;
   k = floor(2*p-1);
   tapers = [n,p,k];
%   disp(['Using ' num2str(k) ' tapers.']);
end
if length(tapers) == 3
   tapers(1) = tapers(1).*sampling;  
   tapers = dpsschk(tapers);
end

dn = dn*sampling;

szX=size(X);  ntr = szX(1); % ntr is the number of trials
szX = szX(2:end);
nt=szX(length(szX));        % nt is the number of time points.
ind=find(szX ~= nt);
dims=szX(ind);              % dims is the space dimensions
N=size(tapers,1);           % N is the window size determined by the tapers
K=size(tapers,2);           % K is the number of tapers
t=0;

if nt > N t =1; end         % set time processing flag
if t nwin=floor((nt-N)./dn); end   % nwin is the number of time windows
f_axis=[f_range(1):f_range(2):f_range(3)];
nf=max(size(f_axis));

%  For each trial turn X into 2-D array
for i = 1:ntr
  X_tmp = sq(X(i,:,:));
  [X_proc_tmp, index]=procarray(X_tmp);
  indices=find(mask > 0);
  X_proc(i,:,:) = X_proc_tmp(indices,:);
end

d=length(X_proc(1,:,1));

if ~t                       % process the single window case 

% Allocate the various matrices
sv=zeros(nf,min(K*ntr,d));
space = zeros(nf,num,d);
freq = zeros(nf,num,K);
time=zeros(nf,N);
ftapers=zeros(K,N); 


for ii=1:nf
    tt=exp(j.*2.*pi.*f_axis(ii).*[1:N]./sampling);
    pr_op=dp_proj(tapers,sampling,f_axis(ii));
    PROJ = [];
    for itr = 1:ntr
      X_proc_tr = sq(X_proc(itr,:,:));
      PROJ(:,(itr-1)*K+1:itr*K) = X_proc_tr*pr_op;
    end    
    [u,s,v]=svdfix(PROJ);
    sv(ii,:)=s';
    space(ii,:,:)=u(:,1:num)';
%    freq(ii,:,:)=v(1:num,:);
%for jj=1:K ftapers(jj,:)=tapers(:,jj)'.*tt; end
%    time(ii,:)=(ftapers'*squeeze(freq(ii,1,:)))';
end

space=permute(space,[3 1 2]);
%time=permute(time, [2 1]);

end

if t                       % process the moving-window case

% Allocate the various matrices
sv=zeros(nwin,nf,min(K*ntr,d));
space_proc=zeros(nwin,nf,d,num);

for win=1:nwin
    disp(num2str(win));
  for ii=1:nf
    PROJ = [];
    pr_op=dp_proj(tapers,sampling,f_axis(ii));
    for itr = 1:ntr
      X_proc_tr = sq(X_proc(itr,:,:));
      PROJ(:,(itr-1)*K+1:itr*K)=X_proc_tr(:,win*dn+1:win*dn+N)*pr_op;
    end
    [u,s,v]=svdfix(PROJ);
    sv(win,ii,:)=s;
    coh(win,ii) = s(1).^2./sum(s.^2);
    space_proc(win,ii,:,:)=u(:,1:num);
end
end



space = space_proc;

end

function [msg, X, mask, tapers, dn, f_range, sampling, num] = fsvdchk_tr(P)
%FSVDCHK_TR Helper function for FSVD_TR.
%   FSVDCHK_TR(P) takes the cell array P and uses each cell as 
%   an input argument.  Assumes P has between 1 and 7 elements.

msg = ' ';
X = P{1}; 
szX=size(X);  szX = szX(2:end);
nt=max(szX);
ind=find(szX ~= nt);
dims=szX(ind);


if (length(P) > 1) & ~isempty(P{2})
    mask=P{2};
else
    mask=zeros(dims)+1;
end

if (length(P) > 2) & ~isempty(P{3})
     [tapers,v]=dpsschk(P{3});
     N=length(tapers(:,1));
end

if length(P) > 3 & ~isempty(P{4})
    dn=P{4};
else
    dn=N./10.;
end

if length(P) > 4 & ~isempty(P{5})
    f_range=P{5};
else
    f_range=[0,0.05,0.5];
end

if length(P) > 5 & ~isempty(P{6})
    sampling=P{6};
else
    sampling=1.;
end

if length(P) > 6 & ~isempty(P{7})
    num=P{7};
else
    num=5.;
end

% NOW do error checking
K=length(tapers(1,:));
if f_range(1) < 0. or f_range(2) > f_range(3)-f_range(1) or f_range(3)/sampling > 0.5 
    msg = 'F_RANGE must have valid ranges.';
end

if size(size(X)) == 2 & min(size(X)) == 1 
    msg = 'X must be an array.';
end

if sampling < 0.
    msg = 'Sampling rate must be greater than zero.'
end

if num > min([prod(dims),K]) 
    msg = 'Number of modes to keep must be less than the dimension of the space and the number of data tapers used.';
end

if size(mask) ~= dims
    msg = 'Mask must have the same dimension as the data.';
end



