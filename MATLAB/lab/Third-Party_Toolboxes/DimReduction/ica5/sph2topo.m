% sph2topo() - Convert from a 3-column headplot file in spherical coordinates
%             to a 3-column topoplot file in polar (not cylindrical) coords.
%             Used for topoplot() and other 2-d topographic plotting programs.
%             Assumes a spherical coordinate system in which horizontal angles 
%             has a range [-180,180] with zero pointing to the right ear. 
%             In the output polar coordinate system, zero points to the nose.
% Usage:
%          >> [chan_num,angle,radius] = sph2topo(input,shrink_factor);
%   where                       input = [chan_num,az,horiz];
%
% Inputs:
%   input = [channo,az,horiz] = chan_number, azumith (deg), horiz. angle (deg)
%             When az>0, horiz=0 -> right ear, 90 -> nose 
%             When az<0, horiz=0 -> left ear, -90 -> nose
% shrink_factor = radial scaling factor>=1 (Note: 1 -> plot edge 90 deg az
%             1.5 -> plot edge is +/-135 deg az {default 1}
% Outputs:
%   channo  = channel number (as in input)
%   angle   = horizontal angle (0 -> nose; 90 -> right ear; -90 -> left ear)
%   radius  = arc radius from vertex (Note: 90 deg az -> 0.5/shrink_factor);
%             By convention, radius=0.5 is the outer edge of topoplot().
%             Use shrink_factor>1 to plot chans with abs(az)>90.
%
% See also: cart2topo(), topo2sph()

% Scott Makeig, CNL / Salk Institute, La Jolla 6/12/98
% corrected left/right orientation mismatch, Blair Hicks 6/20/98
% changed name sph2pol() -> sph2topo() for compatibility -sm

function [channo,angle,radius] = sph2topo(input,factor)

chans = size(input,1);
angle = zeros(chans,1);
radius = zeros(chans,1);

if nargin < 1
   help sph2topo
   return
end
   
if nargin< 2
  factor = 0;
end
if factor==0
  factor = 1;
end
if factor < 1
  help sph2topo
  return
end

if size(input,2) ~= 3
   help sph2topo
   return
end

channo = input(:,1);
az = input(:,2);
horiz = input(:,3);
radius = abs(az/180)/factor;

i = find(az>=0);
angle(i) = 90-horiz(i);
i = find(az<0);
angle(i) = -90-horiz(i);
