% Generative Topographic Mapping (GTM) Toolbox.
%
% Functions for setting up initial GTM models:
%   Automated set-up:
%     gtm_stp1	setup 1D - generates the components of a GTM with a
%		1-dimensional latent space
%     gtm_stp2	setup 2D - generates the components of a GTM with a
%		2-dimensional latent space
%   Latent variables and basis functions:
%     gtm_hxg	hexagonal grid - produces a 2D grid with points arranged 
%		in a hexagonal lattice
%     gtm_rctg	rectangular grid - produces a 2D grid with points arranged 
%	  	in a rectangular lattice
%     gtm_m2r	mesh to rows - converts from a mesh-matrix to vector
%		representation
%     gtm_gbf	Gaussian basis functions - calculates the output of Gaussian 
%		basis functions for a given set of input
%     gtm_lbf	linear basis functions - calculates the output of linear 
%		basis functions for a given set of input
%   Initial weights and beta:
%     gtm_pci	principal components initialisation - returns a weight 
%		matrix initialised using principal components
%     gtm_ri	random initialisation - returns an initial random weight matrix
%     gtm_bi	beta initialisation - calculate an initial value for beta
%   Auxiliary functions for set-up:
%     gtm_pca	principal components analysis - calculates the principal 
%		components of a data set
%
% Functions for training:
%   Automated training:
%     gtm_trn	train - optimize (train) the parameters of a GTM model, 
%		using an EM algorithm
%   Auxiliary functions for training:
%     gtm_dist	distances - calculate the squared distances between 
%		two sets of data points
%     gtm_dstg	distances - calculate the squared distances between 
%		two sets of data points; uses global variables
%     gtm_resp	responsabilities - calculate log-likelihood and component 
%		responsabilities over a Gaussian mixture
%     gtm_rspg	responsabilities - calculate log-likelihood and component re-
%		sponsabilities over a Gaussian mixture; uses global variables
%     gtm_sort	sorts the columns of argument matrix R in increasing order
%
% Functions for visualisation and demonstration:
%   Posterior latent distribution:
%     gtm_ppd	posterior probability distribution - posterior distribution 
%		over the latent space posterior for a given data point
%   Posterior mean projection:
%     gtm_pmn	posterior mean - calculates the posterior mean projection of 
%		data into the latent space.
%   Posterior mode projection:
%     gtm_pmd	posterior mean - calculates the posterior mode projection of 
%		data into the latent space.
%   Auxiliary functions for visualisation:
%     gtm_r2m	rows to mesh - converts data from column vector to 
%		mesh-matrix representation
%   Demo:
%     gtm_demo	demo - demonstrates the GTM with a 2D target space and 
%		a 1D latent space



