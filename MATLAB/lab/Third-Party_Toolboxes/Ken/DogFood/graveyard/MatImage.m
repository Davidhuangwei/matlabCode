% MatImage(m)
%
% Like image(m), but does scaling and stuff

function MatImage(m)

minval = min(m(:));
maxval = max(m(:));

imagesc(m, [minval, maxval]);
colorbar;