function [Xint, lvar, fr]=Xint_pt(X1, X2, tbin1, tbin2)
%Computing and plotting the Brillinger cross intensity function
%Set up the u (lags) and h (half the binwidth)
% Input the spike train


sX1=size(X1);
ntr1=min(sX1);

sX2=size(X2);
ntr2=min(sX2);

tmax1=tbin1(:,2); tmin1=tbin1(:,1); 
tmax2=tbin2(:,2); tmin2=tbin2(:,1); 
sampling=tbin1(1,3);

T1=tmax1-tmin1;
T2=tmax2-tmin2;

N1=max(sX1);
N2=max(sX2);

umin=T/100.;
umax=T/4.;
du=umin;
u=umin:du:umax;
h=du./2;

nu=length(u);

Xint=zeros(1,nu);
Lvar=zeros(1,nu);
La=zeros(1,nu);
Lab=zeros(1,nu);

% Compute the simple intensities.

L1= N1/T1;
L2= N2/T2;


% Compute the cross-intensity function of spike train 1, 
% given spike train 2.

for k=1:nu
    Jab=0;
for j=1:N2
    lmin = u(k) + X2(j)  - h; 
    lmax = u(k) + X2(j)  + h;		
    n= length(find(X1 <= lmax & X1 >= lmin));    
    Jab=Jab+n;	
end
Xint(k)=Jab;
end


Xint=Xint/(N2.*2.*h);

%Compute the variance stabilizing transformation;

Lab= sqrt(Lab);
CIlb = CIlb*sqrt(La) - 1./sqrt(2.*h*N2);
CIub = CIlb*sqrt(La) + 1./sqrt(2.*h*N2);


 


 
