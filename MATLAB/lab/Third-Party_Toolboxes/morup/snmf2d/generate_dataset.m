function  [V, W,H, Tau, Phi, d]=generate_dataset
% generate_dataset
% SPARSE NONNEGATIVE MATRIX FACTOR DOUBLE DECONVOLUTION dataset example 2
% Written by Morten Mørup and Mikkel N. Schmidt
%
% Generates the dataset with little ambiguity between the factors
% 
% Usage:
%    [W,H, Tau, Phi, d]=generate_dataset()
%     
% Output:
%     W                 M x d x length(Tau) data matrix
%     H                 d x N x length(Phi) data matrix
%     Tau               Tau(k) shifts the matrix H Tau(k) elements to the
%                       right. Notice k is also an index in W.
%     Phi               Phi(k) shifts the matrix W Phi(k) elements down. Notice
%                       k is also an index in H
%     d                 The number of factors





clear all;
d=2;
Tau=0:16;
Phi=Tau;
W1=zeros(100,length(Tau));
W2=W1;
H1=zeros(200,length(Tau));
H2=zeros(200,length(Tau));

P=round(size(W1,1)/4);
pp=round(size(W1,1)/(2*4*length(Tau)));

HH = FSPECIAL('disk',7.5);
HH=HH/max(max(HH));
HHH=zeros(size(HH));
HHHH=HHH;
HH2=FSPECIAL('disk',5.5);
HH2=HH2/max(max(HH2));
HH(3:end-2,3:end-2) = HH(3:end-2,3:end-2)-HH2;
HH3=FSPECIAL('disk',3.5);
HH3=HH3/max(max(HH3));
HHH(3:end-2,3:end-2)=HH2;
HHH(5:end-4,5:end-4)=HH2(3:end-2,3:end-2)-HH3;
HH4=FSPECIAL('disk',1.5);
HH4=HH4/max(max(HH4));
HHHH(7:9,7:9)=HH4;

HH(HH<0)=0;
W1(round(0.5*P)+round(P/2):round(0.5*P)+round(P/2)+Tau(end)-2,2:end-1)=HH;
W1(round(1.5*P)+round(P/2):round(1.5*P)+round(P/2)+Tau(end)-2,2:end-1)=HHH;
W1(round(2.5*P)+round(P/2):round(2.5*P)+round(P/2)+Tau(end)-2,2:end-1)=HHHH;
for k=2:length(Tau)-2
    W2(round(0.5*P)+round(P/2)+k,k)=1;
    W2(round(0.5*P)+round(P/2)+length(Tau)-k,k)=1;
    if k>4 & k<length(Tau)-4
        W2(round(1.5*P)+round(P/2)+k,k)=1;
        W2(round(1.5*P)+round(P/2)+length(Tau)-k,k)=1;
    end

   if k>6 & k<length(Tau)-6
        W2(round(2.5*P)+round(P/2)+k,k)=1;
        W2(round(2.5*P)+round(P/2)+length(Tau)-k,k)=1;
    end

    
    H1(P,Phi(end)-2)=1;
    if mod(k,2)==0
        H1(5*P+round(P/2)-(k-1)*pp:-1:5*P+round(P/2)-k*pp+1,k)=ones(pp,1);
    end
    H1(P,3)=1;
    H1(2*P,mean(Phi))=1;
    H1(round(1.7*P),Phi(3):2:Phi(end-3))=1;
    H1(round(2.9*P),round(mean(Phi)+4))=1;
    H1(round(4.3*P),round(mean(Phi)-5))=1;
%    H1(round(4.6*P),round(mean(Phi)+6))=1;
    H1(round(6.5*P),[Phi(end)-3, Phi(2)])=1;
    H1(round(7*P),Phi(end)-1)=1;
    H2(round(0.2*P),Phi(3):2:Phi(end-3))=1;
    H2(3*P:2:3*P+8*pp,round(1.5*mean(Tau)))=1;
    H2(P,round(mean(Tau)-6))=1;
    H2(round(5.8*P),[3,Phi(end)-2])=1;
    H2(round(1.1*P),mean(Phi)+2)=1;
    H2(round(2*P),round(mean(Tau)+3))=1;
    H2(round(2.5*P),round(mean(Tau)-4))=1;
    H2(round(4.3*P),round(mean(Tau)+5))=1;
    H2(5*P,round(mean(Tau)+6))=1;
    H2(round(6.2*P),[Tau(end)-3, Tau(2)])=1;
    H2(round(6.9*P),Tau(end)-1)=1;   
end
W(:,1,:)=W1;
W(:,2,:)=W2;
H(1,:,:)=H1;
H(2,:,:)=H2;
tau_align=round(size(W,3)/2);
phi_align=round(size(H,3)/2);
[W,H, shift1]=align_tau(W,H,tau_align);
[W,H, shift2]=align_phi(W,H,phi_align);
V=zeros(size(W,1),size(H,2));
V = nmf2d_rec(W,H,Tau,Phi,1:d); 