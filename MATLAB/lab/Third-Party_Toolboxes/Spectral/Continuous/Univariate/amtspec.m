function [spec,dof,f,lvar]=amtspec(X,tapers,nf,fk,sampling)
% AMTSPEC calculates the adaptive multitaper spectral estimate
%
% SPEC = AMTSPEC(X, TAPERS, NF) calculates the adaptive multitaper estimate
% of X using prolates specified in tapers and pads to NF points.
% TAPERS defaults to NW = 3 with K tapers.  NF defaults to the
% largest power of 2 greater than the length of X.
%
% [SPEC,F] = AMTSPEC(X, TAPERS, NF, FK, SAMPLING) returns the frequency 
% axis for SPEC.  SAMPLING defaults to 1Hz.
% 
% [SPEC,F,LVAR] = AMTSPEC(X, TAPERS, NF, FK, SAMPLING) returns the 
% error bars for SPEC in LVAR.
%
% [SPEC,F,LVAR] = AMTSPEC(X, TAPERS, NF, FK, SAMPLING,FLAG) does the 
% calculation pooling across trials.

% Modification History:  
%           Written by:  Bijan Pesaran, 03/00

[Y,dims]=reduce(X);
sY=size(Y);
n=sY(2);
nch=sY(1);
errorchk=0;

if nargin < 3 nf=max(256,2^nextpow2(n)); end
if nargin < 4 fk=nf./2; end
if nargin < 5 sampling=1; end
if nargin == 5 fk=floor(fk./sampling.*nf); 
               tapers(1)=tapers(1).*sampling;
end
if nargout > 3 errorchk=1; end

[tapers,lambda]=dpsschk(tapers);
k=length(tapers(1,:));
spec=zeros(fk,nch);
lvar=[];

for ch=1:nch
     tmp=detrend(Y(ch,:))';
     xk=fft(tapers(:,1:k).*tmp(:,ones(1,k)),nf);
     xk=xk(1:fk,:);
     Sk=abs(xk).^2;
%  direct estimate
     stmp=mean(Sk,2);

%  adaptive estimate
     sigma=tmp'*tmp./n;
     S=(Sk(:,1)+Sk(:,2))/2;    % Initial estimate
     Stemp=zeros(fk,1);
     S1=zeros(fk,1);

     tol=.0005*sigma/nf;
     i=0;
     a=sigma*(1-lambda);

while sum(abs(S-S1)/fk) > tol
      i=i+1;
      % calculate weights
      b=(S*ones(1,k))./(S*lambda'+ones(fk,1)*a'); 
      % calculate new spectral estimate
      wk=(b.^2).*(ones(fk,1)*lambda');
      S1=sum(wk'.*Sk')./ sum(wk');
      S1=S1';
      Stemp=S1; S1=S; S=Stemp;  % swap S and S1
end

wk=(b.^2)*lambda;
wk2=(b.^4)*(lambda.^2);
dof=2.*wk./wk2;

%if errorchk
%       for ik=1:k
%         indices=setdiff([1:k],[ik]);
%         Sj=Sk(indices,1:fk);
%         jlsp(ik,:)=log(1./(k-1).*sum(Sj),1));
%       end
%       lsp(ch,:)=sum(jlsp,1)./k;
%       lvar(ch,:)=(k-1)*std(jlsp,1).^2;
%end
spec(:,ch)=S;
end

lsd=sqrt(lvar);
if nargout > 1 f=[1:fk].*sampling./nf; end

spec=spec';

spec=restore(spec,dims);

%if errorchk lvar=restore(lvar,dims); end








