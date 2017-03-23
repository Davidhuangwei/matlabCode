function [eVts, eVls] = gtm_pca(T)
% Calculates the principal components of a data set.
%
% 		The principal components equals the eigenvectors of
%		the covariance matrix of the data..
%
% Synopsis:	[eVts, eVls] = gtm_pca(T)
%
% Arguments:	T - 	the data set for which the principal components	
%			are to be calculated. Every row is assumed to 
%			be a data point; N-by-D
%
% Return:	eVts -	an D-by-D matrix in which each column is a
%			unit length eigenvector of the covariance matrix 
%			of the data, sorted in descending order w.r.t. 
%			the corresponding eigenvalues
%
%		eVls -	a D-dimensional vector holding the eigen-
%			values of the covariance matrix of the data, 
%			sorted in descending order
%
			
% Version:	The GTM Toolbox v1.0 beta
%
% Copyright:	The GTM Toolbox is distributed under the GNU General Public 
%		Licence (version 2 or later); please refer to the file 
%		licence.txt, included with the GTM Toolbox, for details.
%
%		(C) Copyright Markus Svensen, 1996


[eigenVectors eigenValues] = eig(cov(T));

% sorting eigenvalues in ASCENDING order, keeping track of the
% re-ordering permutations
[eigenValues perm] = sort(diag(eigenValues));

[rowsEig colsEig] = size(eigenVectors);

% (re-)sort eigenvalues and eigenvectors in DESCENDING order w.r.t.
% the eigenvalues
for i=1:colsEig
  eVts(:,i) = eigenVectors(:,perm(colsEig+1-i)); % sorting "backwards"
  eVls(i) = eigenValues(colsEig+1-i); % eigenValues is now sorted
end




