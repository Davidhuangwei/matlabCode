% pcexpand() - expand data using Principal Component Analysis (PCA)
%              returns data expanded from a principal component subspace 
%                              [compare pcsquash()]
% Usage: 
%        After  >> [eigenvectors,eigenvalues,projections] = pcsquash(data,ncomps);
%        then   >> [expanded_data] = pcexpand(projections,eigenvectors,mean(data'));
% Inputs:
%    projections  = (comps,frames) each row is a component, each column a time point
%    eigenvectors = square matrix of (column) eigenvectors 
%    datameans    = vector of original data channel means
%
% Outputs: 
%    projections  = data projected back into the original data space
%                   size (chans=eigenvector_rows,frames)

% Scott Makeig CNL / Salk Institute, La Jolla CA 6-97
% debugged 4-15-98 -sm & t-pj

function [expanded_data]=pcexpand(PCAproj,EigenVectors,Datameans)

if nargin < 2
   help pcexpand
end

[ncomps,frames]=size(PCAproj);
[j,k]=size(EigenVectors);

if j < ncomps | nargin < 2 | j ~= k 
   help pcexpand
end

if size(Datameans,1) == 1,
    Datameans = Datameans';   % make a column vector
end
expanded_data = EigenVectors(:,1:ncomps)*PCAproj; + Datameans*ones(1,frames);

