function [W,H, shift]=align_phi(W,H,phi_align)
% align_tau
% SPARSE NONNEGATIVE MATRIX FACTOR DOUBLE DECONVOLUTION function for alignment of tau-shifts
% Written by Morten Mørup and Mikkel N. Schmidt
% 
% Align the geometric mean of the third dimension of H to the value phi_align.
%
% Usage:
%    [W,H]=align_phi(W,H,phi_align)
%     
% Input:
%     W                 M x d x length(Tau) data matrix   
%     H                 d x N x length(Phi) data matrix
%     phi_align         Center of the geometric mean on third dimension of
%                       H
%
% Output:
%     W                 M x d x length(Tau) data matrix   
%     H                 d x N x length(Phi) data matrix
%     shift             0: Data was not shifted
%                       1: data was shifted
                       

d=size(W,2);
shift=0;
for idx = 1:d
    hmean = mean(squeeze(H(idx,:,:)));
    tpos = round(sum(hmean./(sum(hmean)+eps).*(1:length(hmean))));
    if tpos<phi_align
        W(1:end-(phi_align-tpos),idx,:) = W((phi_align-tpos)+1:end,idx,:);
        W(end-(phi_align-tpos)+1:end,idx,:) = 1e-5;
        H(idx,:,(phi_align-tpos)+1:end) = H(idx,:,1:end-(phi_align-tpos));
        H(idx,:,1:(phi_align-tpos)) =1e-5;
        fprintf('Phi-shift\n');
        shift = 1;
    elseif tpos>phi_align
        W((tpos-phi_align)+1:end,idx,:) = W(1:end-(tpos-phi_align),idx,:);
        W(1:(tpos-phi_align),idx,:) = 1e-5;
        H(idx,:,1:end-(tpos-phi_align)) = H(idx,:,(tpos-phi_align)+1:end);
        H(idx,:,end-(tpos-phi_align)+1:end) = 1e-5;
        fprintf('Phi-shift\n');
        shift = 1;
    end
end