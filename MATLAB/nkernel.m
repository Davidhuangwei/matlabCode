function Kx=nkernel(x,y,par)
% function Kx=nkernel(x,y,par)
% to define my kernels.
% here I have exp kernel. 

Kx=exp(bsxfun(@minus,x,y')/par);
Kx(Kx>(1+10^-5))=0;