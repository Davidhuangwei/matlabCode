function projected = showpca2(data);
% SHOWPCA2 : project data matrix on 2 first eigenvectors and show them
% projected = showpca2(data)
%	data      - the data
%	projected - the resulting projection

% Copyright (c) 1995 Frank Dellaert
% All rights Reserved

projected = projectpca(data,2);
plot(projected(1,:), projected(2,:), 'y*');
