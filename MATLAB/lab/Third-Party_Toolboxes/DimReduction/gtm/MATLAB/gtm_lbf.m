function FI = gtm_lbf(MU)
% Calculates the output of linear basis functions for a given set of inputs
%
% 		This simply amounts to returning the set of inputs with an 
%		extra bias column of ones after the last column in the  
%		input set matrix.
%
% Synopsis:	FI = gtm_lbf(X)
%
% Arguments:	X -	the latent variable sample forming the set of
%			inputs; K-by-L
%	
% Return:	FI -	the matrix of basis functions output values;
%			K-by-(L+1), "+1" for the bias basis function
%
% See also:	gtm_gbf
%

% Version:	The GTM Toolbox v1.0 beta
%
% Copyright:	The GTM Toolbox is distributed under the GNU General Public 
%		Licence (version 2 or later); please refer to the file 
%		licence.txt, included with the GTM Toolbox, for details.
%
%		(C) Copyright Markus Svensen, 1996

FI = [X, ones(size(X,:))];
