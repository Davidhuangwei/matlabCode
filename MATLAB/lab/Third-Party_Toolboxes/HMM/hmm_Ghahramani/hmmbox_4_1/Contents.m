% HMMBOX, version 4.1, I. Rezek, University of Oxford, July 2001
% Matlab toolbox for Variational estimation of Hidden Markov Models
%
% hmminit         initialise  HMM
% obsinit         initialise HMM observation models
% hmmtrain        train  HMM
% hmmdecode       make classifications using HMM
%
% obsinit          initialise observation model 
% obslike          calculate likelihood of data given observation model
% obsupdate        update parameters of observation model
%
% evalfreeenergy   computation of free energy
%
% Auxiliary routines
%
% rsum        - row sum of matrix
% rprod       - row product of matrix and vector
% rdiv        - row division of matrix by vector
%
% gauss_kl     - KL divergence for MV-Normal densities
% dirichlet_kl - KL divergence for Dirichlet densities
% wishart_kl   - KL divergence for Wishart densities
%
% digamma.m    - digamma function
% digamma.mexsol - MEX digamma function
%
% Other routines
%
% wgmmem      - weighted EM algorithm for training Gaussian Mixture Models
%
% Demonstrations
% 
% demgausshmm - Gaussian observation HMM trained on synthetic time series
% dempoissonhmm - Poisson observation HMM trained on synthetic time series
