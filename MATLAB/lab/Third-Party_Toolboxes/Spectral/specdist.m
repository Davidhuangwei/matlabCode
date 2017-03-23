function [spec,f,lvar]=specdist(X,tapers,nfft,fk,sampling)
% DMTSPEC calculates the direct multitaper spectral estimate
%
% SPEC = DMTSPEC(X, TAPERS, NF) calculates the direct multitaper estimate
% of X using prolates specified in tapers and pads to NF points.
% TAPERS defaults to NW = 3 with K tapers.  NF defaults to the
% largest power of 2 greater than the length of X.
%
% [SPEC,F] = DMTSPEC(X, TAPERS, NF, FK, SAMPLING) returns the frequency 
% axis for SPEC.  SAMPLING defaults to 1Hz.
% 
% [SPEC,F,LVAR] = DMTSPEC(X, TAPERS, NF, FK, SAMPLING) returns the 
% error bars for SPEC in LVAR.
%
% [SPEC,F,LVAR] = DMTSPEC(X, TAPERS, NF, FK, SAMPLING,FLAG) does the 
% calculation pooling across trials.

% Modification History:  
%           Written by:  Bijan Pesaran, 08/97
%           Modified:    Added error bars BP 08/27/98

[Y,dims]=reduce(X);
sY=size(Y);
n=sY(2);
nch=sY(1);
errorchk=0;

if nargin < 3 nfft=max(256,2^nextpow2(n)); end
if nargin < 4 fk=nfft./2; end
if nargin < 5 sampling=1; end
if nargin == 5 fk=floor(fk./sampling.*nfft); 
               tapers(1)=tapers(1).*sampling;
end
if nargout > 2 errorchk=1; end

tapers=dpsschk(tapers);
k=length(tapers(1,:));
spec=zeros(nch,fk);
wtmp=zeros(1,nfft);
lvar=[];

for ch=1:nch
     tmp=detrend(Y(ch,:));
for ik=1:k
     wtmp(1:n)=tmp'.*tapers(:,ik);
     xk(ik,:)=fft(wtmp);
end
     stmp=sum(abs(xk).^2,1)./k;
     spec(ch,:)=stmp(1:fk);
     if errorchk
       for ik=1:k
         indices=setdiff([1:k],[ik]);
         xj=xk(indices,1:fk);
         jlsp(ik,:)=log(1./(k-1).*sum(abs(xj.^2),1));
       end
       lsp(ch,:)=sum(jlsp,1)./k;
       lvar(ch,:)=(k-1)*std(jlsp,1).^2;
     end
end

lsd=sqrt(lvar);

if nargout > 1 f=[1:fk].*sampling./nfft; end

spec=restore(spec,dims);

%if errorchk lvar=restore(lvar,dims); end









