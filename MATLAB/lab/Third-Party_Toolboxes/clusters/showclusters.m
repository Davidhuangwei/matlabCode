function showclusters(x,c);
% SHOWCLUSTERS: project data matrix on first eigenvectors (if necessary)
%               and show different clusters with different symbols
% showclusters(x,c)
%	x - data
%	c - classification

% Copyright (c) 1995 Frank Dellaert
% All rights Reserved

%----------------------------------------------------------------------
% first, coerce the data into displayable space, i.e. <= 3D, using PCA
%----------------------------------------------------------------------
[d,n] = size(x);
if (d==1)
  pr(1,:) = 1:n;
  pr(2,:) = x;
  d = 2;
elseif (d<=3)
  pr = x;
else
  pr = projectpca(x,3);
  d = 3;
end;

%----------------------------------------------------------------------
% now, plot the data, using different colors/symbols for the clusters
%----------------------------------------------------------------------
hold off
nc = max(c);
for theCluster=1:max(nc)
  % find the cluster
  cl = cluster(pr,c,theCluster);
  [d,nr] = size(cl);

  if (nr>0)

    % get the color/symbol (will work best for <6 clusters, of course)
    s = rem(theCluster,5);
    if     s==0, sym = 'c.';
    elseif s==1, sym = 'g*';
    elseif s==2, sym = 'r+';
    elseif s==3, sym = 'bo';
    elseif s==4, sym = 'yx';
    end

    % plot the data in 2d or 3d
    if (d==2)
      plot(cl(1,:), cl(2,:), sym);
    else
      plot3(cl(1,:), cl(2,:), cl(3,:), sym);
    end

  end % if
  hold on
end % for
hold off
