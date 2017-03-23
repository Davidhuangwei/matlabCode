function [spec, f, lsd, ne]=dmtspec_ptx(X, tapers, N, nf)
%DMTSPEC_PTX  Hybrid process spectrum using the multitaper techniques
%
% [SPEC, F, LSD, NE] = DMTSPEC_PTX(X, TAPERS, NF) calculates the
% direct multitaper  estimate of X.
%

% Modification History: Written by Bijan Pesaran 07/06/00


ntr=size(X,2);

ne = [];
for tr = 1:ntr  ne = [ne,length(X{tr})]; end
n = max(ne);

errorchk=0;
if nargin < 3 nf=max(256,2^nextpow2(n)); end
if nargout > 2 errorchk=1; end

if tapers

K=tapers(2);
ind=find(ne > N);
ne = ne(ind);

ntr = length(ind);
dtapers = dpsschk([N tapers]);
xk = zeros(ntr*K,nf/2);

for it=1:ntr,
  tmp = detrend(X{ind(it)}); 
  tmp = tmp(1:N);
  for ik=1:K,
      tt=fft([tmp'.*dtapers(:,ik)' zeros(1,nf-N)]);
      xk((it-1).*K+ik,1:nf/2) = tt(1:nf/2);
   end 
end

spec=abs(xk).^2;


if errorchk
  
% compute delete one estimates : 

jlsp=zeros(ntr*K,nf/2); 
xj_res=zeros(ntr*K-1,nf/2);

for j=1:ntr*K, 
	indices=setdiff([1:ntr*K],[j]);
        xj=xk(indices,:);
        Sjx=sum(abs(xj).^2,1);
	jlsp(j,:)=log(1/(ntr*K-1).*Sjx);
end

lsp=sum(jlsp,1)./K./ntr;
lvar=(ntr*K-1)*std(jlsp,1).^2; 	
lsd=sqrt(lvar);

end


end

if isempty(tapers)

ind=find(ne > N);
ne = ne(ind);	
ntr = length(ind);

for it=1:ntr,
  tmp = detrend(X{ind(it)}); 
  tt=abs(fft([tmp' zeros(1,nf-N)])).^2;
  spec(it,1:nf/2) = abs(tt(1:nf/2)).^2;
end


end



f = [1:nf/2]./nf;





