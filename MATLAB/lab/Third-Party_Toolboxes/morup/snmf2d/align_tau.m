function [W,H, shift]=align_tau(W,H,tau_align)
% align_tau
% SPARSE NONNEGATIVE MATRIX FACTOR DOUBLE DECONVOLUTION function for alignment of tau-shifts
% 
% Align the geometric mean of the third dimension of W to the value tau_align.
%
% Usage:
%    [W,H]=align_tau(W,H,phi_align)
%     
% Input:
%     W                 M x d x length(Tau) data matrix   
%     H                 d x N x length(Phi) data matrix
%     tau_align         Center of the geometric mean on third dimension of
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
    wmean = mean(squeeze(W(:,idx,:)));
    tpos = round(sum(wmean./(sum(wmean)+eps).*(1:length(wmean))));
    if tpos<tau_align
        H(idx,1:end-(tau_align-tpos),:) = H(idx,(tau_align-tpos)+1:end,:);
        H(idx,end-(tau_align-tpos)+1:end,:) = 1e-5;
        W(:,idx,(tau_align-tpos)+1:end) = W(:,idx,1:end-(tau_align-tpos));
        W(:,idx,1:(tau_align-tpos)) =1e-5;
        fprintf('tau-shift\n');
        shift = 1;
    elseif tpos>tau_align
        H(idx,(tpos-tau_align)+1:end,:) = H(idx,1:end-(tpos-tau_align),:);
        H(idx,1:(tpos-tau_align),:) = 1e-5;
        W(:,idx,1:end-(tpos-tau_align)) = W(:,idx,(tpos-tau_align)+1:end);
        W(:,idx,end-(tpos-tau_align)+1:end) = 1e-5;
        fprintf('tau-shift\n');
        shift = 1;
    end
end