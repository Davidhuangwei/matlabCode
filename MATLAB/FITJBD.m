function [W_est W_est0 crit]=FITJBD(M,LL,maxit,W_est)
%
% Joint Block-Diagonalization Algorithm minimizing the fitting criterion (krit003)
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
sLL=sum(LL.^2);
iter=0;
eps=1e-7;
crgr=10;
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
   maxit=5000;
end   
W_est0=W_est;
A=inv(W_est);
crit=krit003(A,M,LL);
F=zeros(d,d);
while iter<maxit && crgr>eps
  iter=iter+1;
  G=zeros(d^2,sLL);
  G(:,1:LL(1)^2)=kron(A(:,1:LL(1)),A(:,1:LL(1)));
  ind=LL(1)^2;
  for ik=2:nb
      j0=LLs(ik-1)+1:LLs(ik);
      G(:,ind+1:ind+LL(ik)^2)=kron(A(:,j0),A(:,j0));
      ind=ind+LL(ik)^2;
  end
  iH=inv(G'*G);
  H2=zeros(d,d); 
  h2=zeros(d,d); 
  for k=1:nm
      R=M(:,(k-1)*d+1:k*d);
      m=iH*(G'*R(:));
      F(1:LL(1),1:LL(1))=reshape(m(1:LL(1)^2),LL(1),LL(1));
      ind=LL(1)^2;
      for ik=2:nb
          j0=LLs(ik-1)+1:LLs(ik);
          F(j0,j0)=reshape(m(ind+1:ind+LL(ik)^2),LL(ik),LL(ik));
          ind=ind+LL(ik)^2;
      end
      AF=A*F;
      H2=H2+AF'*AF;
      h2=h2+R*AF;
  end
  A1=h2/H2;
  val1=krit003(A1,M,LL);
  if val1<crit(end)    
     crit=[crit val1];
     crgr=norm(A(:)-A1(:));
     A=A1;
  else   
     crgr=0;
     'abnormal exit'
  end    
end  
crit
W_est=inv(A);
end   %% of FITJBD
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
end %%%%%%%%%%%%%   of UWEDGE2 
%%%%%%
function val=krit003(A,M,LL)
%
[d Md]=size(M);
L=floor(Md/d);
G=zeros(d^2,sum(LL.^2));
ind=0; in2=0;
for n=1:length(LL)
    G(:,ind+1:ind+LL(n)^2)=kron(A(:,in2+1:in2+LL(n)),A(:,in2+1:in2+LL(n)));
    in2=in2+LL(n);
    ind=ind+LL(n)^2;
end
GG=inv(G'*G);
val=sum(sum(M.^2));
for l=1:L
    aux=G'*reshape(M(:,(l-1)*d+1:l*d),d^2,1);
    val=val-aux'*GG*aux;
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