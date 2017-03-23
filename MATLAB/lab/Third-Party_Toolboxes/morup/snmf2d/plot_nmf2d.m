function plot_nmf2d(W,H,Tau,Phi, Rec)

% plot_nmf2d
% SPARSE NONNEGATIVE MATRIX FACTOR DOUBLE DECONVOLUTION Plotting Function
% 
% Plots the reconstruction of each factor as well as W, H and Rec in
% separate figures.
%
% Usage:
%     plot_SNMF2D(V,W,H,Tau,Phi,R);
%     
% Input:
%     V                 M x N data matrix
%     W                 M x d x length(Tau) data matrix
%     H                 d x N x length(Phi) data matrix
%     Tau               Tau(k) shifts the matrix H Tau(k) elements to the
%                       right. Notice k is also an index in W.
%     Phi               Phi(k) shifts the matrix W Phi(k) elements down. Notice
%                       k is also an index in H
%     Rec               Reconstructed data matrix


d=size(W,2);
for idx = 1:d
     mfig(sprintf('Rec.Source #%d',idx)); 
     rec = nmf2d_rec(W,H,Tau,Phi,idx); 
     imagesc((eps+rec)); 
     axis image;  
     colormap(1-gray);
end
mfig('Rec.Spectrogram'); 
imagesc((eps+Rec)); axis image; 
colormap(1-gray);

    
mfig('(W)'); 
for idx = 1:d
    subplot(1,d,idx); 
    if size(W,3)==1
        plot(1:size(W,1),W(:,idx)); 
    else
        imagesc(squeeze(W(:,idx,:))); 
    end
    colormap(1-gray)
end

mfig('(H)'); 
for idx = 1:d
    subplot(d,1,idx);
    if size(H,3)==1
        plot(1:size(H,2),H(idx,:)); 
    else
        imagesc(squeeze(H(idx,:,:))');
    end
    colormap(1-gray)
end

drawnow;

