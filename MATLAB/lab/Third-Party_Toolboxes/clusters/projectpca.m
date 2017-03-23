function projected = projectpca(data,nr);
% PROJECTPCA : project data matrix on first nr eigenvectors
% projected = projectpca(data,nr)
%	data - data
%	nr   - on how many eigenvectors will we project ?
%	projected - the resulting projection

% Copyright (c) 1995 Frank Dellaert
% All rights Reserved

[vc,vl] = pca(data',nr);
vcnr = vl(:,1:nr)';
projected = vcnr * data;
