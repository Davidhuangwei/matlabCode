function projected = showpca3(data);
% SHOWPCA3 : project data matrix on 3 first eigenvectors and show them
% projected = showpca3(data)
%	data      - the data
%	projected - the resulting projection

% Copyright (c) 1995 Frank Dellaert
% All rights Reserved

projected = projectpca(data,3);
plot3(projected(1,:), projected(2,:), projected(3,:), 'y*');
