function [V, W,H, Tau, Phi, d]=generate_ambiguity_dataset

% generate_dataset
% SPARSE NONNEGATIVE MATRIX FACTOR DOUBLE DECONVOLUTION dataset example 1
% Written by Morten Mørup and Mikkel N. Schmidt
%
% Generates the dataset with ambiguity between the factors
% 
% Usage:
%    [W,H, Tau, Phi, d]=generate_ambiquity_dataset()
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

HH = FSPECIAL('disk',length(Tau)/2-1);
HH=HH/max(max(HH));
HH2=FSPECIAL('disk',length(Tau)/2-3);
HH(3:end-2,3:end-2) = HH(3:end-2,3:end-2)-FSPECIAL('disk',length(Tau)/2-3)-HH2/max(max(HH2));
HH(HH<0)=0;
W1(1*P+round(P/2):1*P+round(P/2)+Tau(end)-2,2:end-1)=HH;


for k=2:length(Tau)-2
    W2(P+round(P/2)+k,k)=1;
    W2(P+round(P/2)+length(Tau)-k,k)=1;
  
    H1(P,Phi(end)-2)=1;
    if mod(k,2)==0
        H1(5*P+round(P/2)-(k-1)*pp:-1:5*P+round(P/2)-k*pp+1,k)=ones(pp,1);
    end
    H1(P,3)=1;
    H1(2*P,mean(Phi))=1;
    H1(round(1.7*P),Phi(3):2:Phi(end-3))=1;
    H1(round(2.9*P),round(mean(Phi)+4))=1;
    H1(round(4.3*P),round(mean(Phi)-5))=1;
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
[W,H, shift]=align_tau(W,H,tau_align);
[W,H, shift]=align_phi(W,H,phi_align);


V=zeros(size(W,1),size(H,2));
V = nmf2d_rec(W,H,Tau,Phi,1:d); 