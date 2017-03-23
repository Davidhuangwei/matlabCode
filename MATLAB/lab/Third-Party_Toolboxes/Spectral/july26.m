%
%	Quadratic spectral inverse spectral estimators
%
%
%	Stationary case:  B_l(f)

N = 128; P = 2; K = 3;
[tapers, lambda] = dpsschk([N,P,K]);
W = p./N;  df = W./N;  %  = N*df;

%  W = 1./64 so pad out to 128*64 to get 128 good points.

V = [];
for k = 1:K	V(k,:) = fftshift(fft(tapers(:,k),64*128))'; end
V = V(:,4097-128:4097+128);	%  Select W and check the phase
for k = 1:K V(k,:) = V(k,:)./sqrt(lambda(k)); end  % normalize

%	Check orthogonality on +/- W
%sum(V(:,:).*conj(V(:,:)),2)./8192;
%sum(V(:,:).*conj(V([3:-1:1],:)),2)./8192;

PK = zeros(257,257);
for k = 1:K PK = PK + V(k,:)'*V(k,:); end

aPK = abs(PK).^2.*df;
[u, s, v] = svd(aPK);

for i = 1:2*K gl(i) = s(i,i); end
gl = gl.*(2.*W);
B = u(:,1:2*K)'.*sqrt(256);	%	The expansion sequences
											%  Normalized by 1/2W 
Bl = zeros(3,3,6);
for l = 1:2*K
   for j = 1:K
      for k = 1:K
         Bl(j,k,l) = sum(V(j,:).*conj(V(k,:)).*B(l,:)).*df;
      end
   end
end

trace(squeeze(Bl(:,:,1))*squeeze(Bl(:,:,2)));

%
%	Quadratic spectral inverse spectral estimators
%
%
%	Non-stationary case:  A_l(f)

N = 128*64./8; P = 2; K = 3;
[tapers, lambda] = dpsschk([N,P,K]);
W = P./N;  dn = 1./N;  %  = N*df;

%  W = 1./64 so pad out to 128*64 to get 128 good points.

for n = 1:N
   for m = 1:n-1
      PK(n,m) = sin(2.*pi.*W.*(n-m))./pi./(n-m);
   end
	PK(n,n) = W;
end

PK = PK + PK';
aPK = PK.^2;
[u, s, v] = svd(aPK);

for i = 1:2*K hl(i) = s(i,i); end
hl = hl.*(2.*W.*N);
A = u(:,1:2*K)';	%	The expansion sequences
											%  Normalized by 1/2W 
Al = zeros(3,3,6);
for l = 1:2*K
   for j = 1:K
      for k = 1:K
         Al(j,k,l) = sqrt(lambda(j).*lambda(k)).*...
            sum(tapers(:,j).*tapers(:,k).*A(l,:)');
      end
   end
end

trace(squeeze(Al(:,:,3))*squeeze(Al(:,:,3)))

Al(:,:,1) = Al(:,:,1).*sqrt(1.1378e3);
Al(:,:,2) = Al(:,:,2).*sqrt(1./0.0023.*hl(2));
Al(:,:,3) = Al(:,:,3).*sqrt(1./0.0017.*hl(3));
