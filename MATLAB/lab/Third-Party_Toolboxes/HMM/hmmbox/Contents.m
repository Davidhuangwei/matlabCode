% HMMBOX, version 3.2, William Penny, Imperial College, October 1998
% Matlab toolbox for Hidden Markov Models
%
% (Adapted from Machine Learning Toolbox
% Version 1.0  01-Apr-96
% Copyright (c) by Zoubin Ghahramani, University of Toronto)
%
% hmminit          initialise Gaussian observation HMM
% hmmtrain         train HMM
% hmmdecode        make classifications using HMM
%
% obsinit          initialise observation model
% obslike          calculate likelihood of data given observation model
% obsupdate        update parameters of observation model
%
% Auxiliary routines
%
% rsum        - row sum of matrix
% rprod       - row product of matrix and vector
% rdiv        - row division of matrix by vector
%
% Other routines
%
% init_ar     - initialisation of AR models in HMM-AR model using
%		Penny and Roberts method (Comp. Biom. Res. 1999)
% init_trans  - initialise a state transition matrix
% wgmmem      - weighted EM algorithm for training Gaussuan Mixture Models
% plotseg     - data plotting routine used by demar
%
% embed       - time series embedding
% arembed     - time series embedding using embed or toeplitz routine
% arwls	      - weighted least squares training of AR models
%
% Demonstrations
% 
% demlike     - Likelihood HMM trained on synthetic time series
% demgausshmm - Gaussian observation HMM trained on synthetic time series
% demar       - AR observation HMM trained on sleep data
% demar2      - AR observation HMM trained on sinewave data
