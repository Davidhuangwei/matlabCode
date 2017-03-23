function [W_est W_est0 crit]=LSJBD(M,LL,maxit,W_est)
%
% Joint Block-Diagonalization Algorithm minimizing the "Boff" criterion (krit001 bellow)
% 
% Input: M ... set of squared real-valued symmetric matrices (2D or 3D array)
%           LL ....  vector of sizes of desired blocks
%           d = sum (LL)... dimension of the matrices in the set M
%           LL(k) ...... dimension of the k-th diagonal block
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
sLL=sum(LL.^2);
mask=ones(d,d);
ind=0;
for k=1:length(LL)
    mask(ind+1:ind+LL(k),ind+1:ind+LL(k))=zeros(LL(k),LL(k));
    ind=ind+LL(k);
end  
iter=0;
eps=1e-7;
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
W_est=diag(1./sqrt(sum(W_est.^2,2)))*W_est;
W_est0=W_est;
crit=krit001(W_est,M0,mask);
for k=1:nm
    M(:,(k-1)*d+1:k*d)=W_est*M0(:,(k-1)*d+1:k*d)*W_est';
end
while iter<maxit && crgr>eps
  iter=iter+1;
  A=eye(d);
  crgr=0;
  for ii2=2:nb
    i2=LLs(ii2-1)+1:LLs(ii2);
    j2=LL(ii2);
  for ii1=1:ii2-1
    j1=LL(ii1);   j12=j1*j2;
    if ii1>1
      i1poc=LLs(ii1-1)+1;
    else
       i1poc=1;
    end    
    i1=i1poc:LLs(ii1);
    ind1=reshape(1:j12,j1,j2)';
    J1=zeros(j1,j2); J2=zeros(j2,j1); KBC=zeros(j12,j12); 
    J6=zeros(j2,j2); J10=zeros(j1,j1);
    for k=1:nm
        R=M(:,(k-1)*d+1:k*d);
        R11=R(i1,i1); R12=R(i1,i2); R22=R(i2,i2);
        J1=J1+R12*R22; J2=J2+R12'*R11; J10=J10+R11^2; J6=J6+R22^2;
        KBC=KBC+kron(R22,R11);
    end
    h=[J1(:); J2(:)];
    KBB=kron(J6,eye(j1));
    KCC=kron(J10,eye(j2));
    KBC=KBC(:,ind1);
    K=[KBB KBC; KBC' KCC];
    vys=-K\h;
    B=reshape(vys(1:j12),j1,j2);
    C=reshape(vys(j12+1:end),j2,j1);
    E=eye(d);
    E(i1,i2)=B; E(i2,i1)=C;   
  W_est1=E*W_est;
  W_est1=diag(1./sqrt(sum(W_est1.^2,2)))*W_est1;
  crit1=krit001(W_est1,M0,mask);
  if crit1>crit(end)
       A=eye(d)+(A-eye(d))/2;
       W_est1=A*W_est;
       W_est1=diag(1./sqrt(sum(W_est1.^2,2)))*W_est1;
       crit1=krit001(W_est1,M0,mask);
       if crit1>crit(end)
           A=2*eye(d)-A;
          W_est1=A*W_est;
          W_est1=diag(1./sqrt(sum(W_est1.^2,2)))*W_est1;
          crit1=krit001(W_est1,M0,mask);
       end   
  end
  W_est=W_est1; 
  for k=1:nm
      M(:,(k-1)*d+1:k*d)=W_est1*M0(:,(k-1)*d+1:k*d)*W_est1';
  end
    crgr=crgr+sum(B(:).^2+C(:).^2);
    crit=[crit crit1];
  end
  end
end
% crit
end   %% of LSJBD
%xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
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
%xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
function val=krit001(W,M,mask)
%
[d Md]=size(M);
L=floor(Md/d);
val=0;
for l=1:L
    M0=W*M(:,(l-1)*d+1:l*d)*W';
    val=val+sum(sum((mask.*M0).^2));
end
end  % of krit001
%xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
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
end %%%%%%%%%%%%%   of UWEDGE2 
