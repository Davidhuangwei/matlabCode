function Rec = nmf2d_rec(W, H, Phi, Tau, comp)

% Reconstructs the data from the factors found in the SNMF2D model
%
% Usage 
%   Rec = nmf2d_rec(W, H, Phi, Tau, comp)
%

Rec = zeros(size(W,1),size(H,2));
for tau = 1:length(Tau)
    for phi = 1:length(Phi)
         WW = [zeros(Tau(tau),length(comp)); W(1:end-Tau(tau),comp,phi)];
         HH = [zeros(length(comp),Phi(phi)), H(comp,1:end-Phi(phi),tau)];
         Rec = Rec+WW*HH;
    end
end
