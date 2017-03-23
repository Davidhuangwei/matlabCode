function csd=gpCSD(lfp, wn, r)
% function csd=gpCSD(lfp, wn, r)
% 
% CSD on Gaussian process regressed lfp.
% 1. Gaussian process regression on lfp
% 2. use lfps2CSDs to reconstruct csd
% input:
%   lfp: nt*nch
%   wn: window size
%   r: kernel width.
% output: 
%   csd: nt*nch
% 
% see also: lfps2CSDs, TimeSequencyProcessing