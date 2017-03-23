function [W_est W_est0 crit]=LLJBD(M,LL,maxit,W_est)
%
% Joint Block-Diagonalization Algorithm optimizing the log-likelihood criterion by Lahat
%           et. al, see function krit000 below.
% 
% Input: M ... set of squared real-valued symmetric matrices (2D or 3D array)
%        LL ....  vector of sizes of desired blocks
%        d = sum (LL)... dimension of the matrices in the set M
%        LL(k) ...... dimension of the k-th diagonal block
%                  sorted LL(1)<=LL(2)<=...<= LL(nb)
% 
% Output: W_est .... estimated demixing matrix
%                    such that W_est * M_k * W_est' are roughly block diagonal
%         W_est0 ... initial demixing matrix obtained by U_WEDGE
%         crit ... stores values of the diagonalization criterion at each 
%                      iteration (to monitor convergence)
% 
% Coded by Petr Tichavsky, 2012.
%
% Only for non-profit purposes. Please cite the paper
%
% P. Tichavsky, Z. Koldovsky,  "Algorithms for nonorthogonal approximate 
%       joint block-diagonalization", Proc. EUSIPCO 2012, Bucharest, Romania, August 27-31, 2012.
% 
% whenever you use the code.
%
sm=size(M);
if length(sm)==3
   M=reshape(M,sm(1),sm(2)*sm(3));
end   
[d Md]=size(M);
if ~(d==sum(LL))
    'DIMENSIONS OF BLOCKS DO NOT MATCH THE DIMENSION OF M'
    LL=ones(d,1);
end  
nm=Md/d;
LL=sort(LL);
nb=length(LL);
LLs=cumsum(LL);
mask=zeros(d,d);
ind=0;
for k=1:length(LL)
    mask(ind+1:ind+LL(k),ind+1:ind+LL(k))=ones(LL(k),LL(k));
    ind=ind+LL(k);
end    
iter=0;
eps=1e-5;
crgr=10;
M0=M;
if nargin<4
   W_est=uwedge(M);
   D=zeros(d,d);
   for k=1:nm
     D=D+abs(W_est*M(:,(k-1)*d+1:k*d)*W_est');
   end
   ord=srovnej(D,LL);
   W_est=W_est(ord,:);
end
if nargin<3
   maxit=50;
end   
W_est0=W_est;
crit=krit000(W_est,M0,mask);
for k=1:nm
    M(:,(k-1)*d+1:k*d)=W_est*M0(:,(k-1)*d+1:k*d)*W_est';
end
%I1=reshape(1:dm^2,dm,dm)';
%ind=I1(:);
%H=kron(dm^2*(I1-1),ones(dm,dm))+repmat(I1,dm,dm);
%iny=H(:);
while iter<maxit && crgr>eps
  iter=iter+1;
  crgr=0;
  for i2=2:nb
  for i1=1:i2-1
  j1=LL(i1); j2=LL(i2);  j12=j1*j2;
  Bkl=zeros(j2,j1);
  Blk=zeros(j1,j2); %Aux=Bkl;
  M1=zeros(j1*j2,j1*j2); M2=M1; %M1x=M1;
  M1y=zeros(j1*j1,j2*j2); M2y=zeros(j2*j2,j1*j1);
%  P=eye(j1*j2,j1*j2);
  ind1=reshape(1:j1*j2,j1,j2)';
  ind2=reshape(1:j1*j2,j2,j1)';
%  P=P(ind(:),:);
  k2=LLs(i2-1);
  if i1>1
     k1=LLs(i1-1); 
  else
     k1=0;
  end   
  for k=1:nm;
    T=M(k1+1:k1+j1,(k-1)*d+k2+1:(k-1)*d+k2+j2);
    S=M(k1+1:k1+j1,(k-1)*d+k1+1:(k-1)*d+k1+j1);
    U=M(k2+1:k2+j2,(k-1)*d+k2+1:(k-1)*d+k2+j2);
    TS=T'/S;
    TST=TS*T;
    iS=inv(S);
    iU=inv(U); TU=T/U; TUT=TU*T';
    Bkl=Bkl+TS;
    Blk=Blk+TU;
 %   M1x=M1x+kron(iU,TUT+S);
 %   M1=M1+kron(TS',TS)+kron(iS,U-TST)*P;
 %   M2=M2+kron(TU',TU)+kron(iU,S-TUT)*P;
 %   M2=M2+kron(M(dm+1:d,(k-1)*d+dm+1:(k-1)*d+d),inv(M(1:dm,(k-1)*d+1:(k-1)*d+dm)));
    M1=M1+reshape(TS',j1*j2,1)*TS(:)';
    M1y=M1y+iS(:)*reshape(-TST+U,1,j2*j2);
    M2=M2+reshape(TU',j1*j2,1)*TU(:)';
    M2y=M2y+iU(:)*reshape(-TUT+S,1,j1*j1);
  end
  M1=reshape(permute(reshape(M1.',[j2,j1,j1,j2]),[1 3 2 4]),[j12,j12]);
  M1y=reshape(permute(reshape(M1y.',[j2,j2,j1,j1]),[1 3 2 4]),[j12,j12]);
  M2=reshape(permute(reshape(M2.',[j1,j2,j2,j1]),[1 3 2 4]),[j12,j12]);
  M2y=reshape(permute(reshape(M2y.',[j1,j1,j2,j2]),[1 3 2 4]),[j12,j12]);
  M1=M1+M1y(:,ind2);
  M2=M2+M2y(:,ind1);
  %aux=zeros(dm^4,1); aux(iny)=M1x(:); M1=reshape(aux,dm^2,dm^2);
  %aux(iny)=M1y(:); Mw=reshape(aux,dm^2,dm^2); M1=M1+Mw(:,ind);
  %aux(iny)=M2x(:); M2=reshape(aux,dm^2,dm^2);
  %aux(iny)=M2y(:); Mw=reshape(aux,dm^2,dm^2); M2=M2+Mw(:,ind);
%  vys=[M1 nm*eye(dm^2); nm*eye(dm^2) M2]\[Bkl(:); Blk(:)];
  vys1b=(nm^2*eye(j12)-M1*M2)\(Bkl(:)*nm-M1*Blk(:));
  vys1a=(Blk(:)-M2*vys1b)/nm;
%  Bkl2=Bkl'; Blk2=Blk'; vys2=[M1 nm*eye(dm^2); nm*eye(dm^2) M2]\[Bkl2(:); Blk2(:)];
%  B21=reshape(vys(1:dm^2),dm,dm);
%  B12=reshape(vys(dm^2+1:2*dm^2),dm,dm);
  B21=reshape(vys1a,j1,j2);
  B12=reshape(vys1b,j2,j1);
  A=eye(d); A(k1+1:k1+j1,k2+1:k2+j2)=-B21; A(k2+1:k2+j2,k1+1:k1+j1)=-B12; 
  W_est1=A*W_est;
  crit1=krit000(W_est1,M0,mask);
  if crit1>crit(end)
     W_est1=W_est;
     crit1=crit(end);
  end
  W_est=W_est1; 
  for k=1:nm
      M(:,(k-1)*d+1:k*d)=W_est*M0(:,(k-1)*d+1:k*d)*W_est';
  end
  crit=[crit crit1];
  crgr=crgr+norm(B21(:))+norm(B12(:));
  end
  end
end
%crit
end   %% of LLJBD
%xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
function [W Rs]=uwedge(M)
%
% an approximate joint diagonalization with uniform weights
%
% Input: M .... the matrices to be diagonalized, stored as [M1 M2 ... ML]
%        M0 ... represents diagonalization constraint: 
%                W_est * M0 * W_est' has to have diagonal elements equal to 1.
%        W0 ... initial estimate of the demixing matrix, if available
% 
% Output: W  .... estimated demixing matrix
%                    such that W * M_k * W' are roughly diagonal
%         Ms .... diagonalized matrices composed of W*M_k*W'
%         crit ... stores values of the diagonalization criterion at each 
%                  iteration
% 
[d Md]=size(M);
L=floor(Md/d);
Md=L*d;
iter=0;
eps=1e-4;
improve=10;
M0=zeros(d,d);
for k=1:L
   ini=(k-1)*d;
   M0=M0+M(:,ini+1:ini+d);
end 
M0=M0/L;
[H E]=eig(M0);
W=diag(1./sqrt(abs(diag(E))))*H';  
Ms=M;  
Rs=zeros(d,L);
for k=1:L
      ini=(k-1)*d;
      M(:,ini+1:ini+d)=0.5*(M(:,ini+1:ini+d)+M(:,ini+1:ini+d)');
      Ms(:,ini+1:ini+d)=W*M(:,ini+1:ini+d)*W';
      Rs(:,k)=diag(Ms(:,ini+1:ini+d));
end 
crit=sum(Ms(:).^2)-sum(Rs(:).^2);  
C1=zeros(d,d);
while improve>eps && iter<100
  B=Rs*Rs';
  for id=1:d
      C1(:,id)=sum(Ms(:,id:d:Md).*Rs,2);
  end
  D0=B.*B'-diag(B)*diag(B)';
  A0=eye(d)+(C1.*B-diag(diag(B))*C1')./(D0+eye(d));
  W=A0\W;
  Raux=W*M0*W';
  aux=1./sqrt(abs(diag(Raux)));
  W=diag(aux)*W;  % normalize the result
  Ms=W*M;
  for k=1:L
     ini=(k-1)*d;
     Ms(:,ini+1:ini+d) = Ms(:,ini+1:ini+d)*W';
     Rs(:,k)=diag(Ms(:,ini+1:ini+d));
  end
  critic=sum(Ms(:).^2)-sum(Rs(:).^2);
  improve=abs(critic-crit(end));
  crit=[crit critic]; 
  iter=iter+1;
end 
end %%%%%%%%%%%%%   of UWEDGE 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function val=krit000(W,M,mask)
%
[d Md]=size(M);
L=floor(Md/d);
val=0;
for l=1:L
    M0=W*M(:,(l-1)*d+1:l*d)*W';
    val=val+max([0 log(det(mask.*M0))-log(det(M0))]); 
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ord=srovnej(D,LL)
%
d=size(D,1);
nb=length(LL);
ord=1:d;
D0=D;
ind=0;
for k=1:nb-1
    sb=LL(k);
    [h m]=sort(-D);
    [h2 imd2]=sort(-h(sb+1,:));
    iny=imd2(ind+sb);
    im=m(1:sb,iny);
    ord(ind+1:ind+sb)=im;
    D(im,:)=-ones(sb,d);
    D(:,im)=-ones(d,sb);
    ind=ind+sb;
end 
aux=1:d;
aux(ord(1:ind))=[];
ord(ind+1:d)=aux;
end