function plot_nmf2d_in_One_fig(W,H,Tau,Phi,Rec);

% plot_SNMF2D_in_One_Fig
% SPARSE NONNEGATIVE MATRIX FACTOR DOUBLE DECONVOLUTION Plotting Function
% Written by Morten Mørup and Mikkel N. Schmidt
%
% Plots W, H and Rec in one figure.
% 
% Usage:
%     plot_SNMF2D_in_One_Fig(V,W,H,Tau,Phi,R);
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



h = gcf;
clf;
set(h, 'Color', [1 1 1]);
colormap(1-gray);
set(h, 'PaperUnits', 'centimeters');
set(h, 'PaperType', '<custom>');
set(h, 'PaperPosition', [0 0 12 20]);

d=size(W,2);
prair=0.15; % percent air between plots;
vt=(d*size(H,3)+size(Rec,1));
ht=(d*size(W,3)+size(Rec,2));
y_H = size(H,3)/vt*(1-prair);
y_H2 = size(H,2)/ht*(1-prair);
y_W = size(W,3)/ht*(1-prair);
y_W1 = size(W,1)/vt*(1-prair);
y_R1 =size(Rec,1)/vt*(1-prair);
y_R2 =size(Rec,2)/ht*(1-prair);
air2=prair/(d+3); % Vertical air space
air1=prair/(d+3); % Horizontal air space

h = axes('position', [0 0 1 1]);
set(h, 'Visible', 'off');

for k=1:d
    h = axes('position', [(d+1)*air1+d*y_W y_R1+(3+d-k)*air2+(d-k)*y_H  y_H2 y_H]);
    imagesc(squeeze(H(k,:,:))');
    axis xy;
    set(h, 'XTick', []);
    set(h, 'yTick', []);
    ylabel('\phi');
end

for k=1:d
    h = axes('position', [k*air1+(k-1)*y_W 2*air2 y_W y_W1]);
    imagesc(squeeze(W(:,k,:))); 
    axis xy;
    set(h, 'XTick', []);
    set(h, 'yTick', []);
    set(h, 'XAxisLocation', 'top');
    xlabel('\tau');
end


h = axes('position', [(d+1)*air1+d*y_W 2*air2 y_R2 y_R1]);
imagesc(Rec);
axis xy;
set(h, 'XTick', []);
set(h, 'yTick', []);

pause(0.000001) % insure processing time for plot