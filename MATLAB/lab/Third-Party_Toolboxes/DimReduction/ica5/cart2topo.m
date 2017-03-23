% cart2topo - convert xyz-cartesian channel coordinates 
%             to polar topoplot coordinates. Input data
%             are points on a sphere around a given
%             [x y z] center or around (0,0,0) {default}.
%
%         NB: topoplot() does not plot channels with radius>0.5
%             Shrink radii to within this range to interpolate 
%             all channels
%
% Usage:        >> [th r] = cart2topo(xyz);   % 3-column data
%               >> [th r] = cart2topo(x,y,z); % separate x,y,z vectors
%               >> [th r] = cart2topo(x,y,z,center); % known non-0 center
%
% Example:      >> [th r] = cart2topo(xyz,[1 0 4]);
%
% Important!: The completed chan.locs file must have four colums:
%                                 channums th r chanlabels
%              and the chanlabels must all be 4-char strings (with . for spaces)
%              See >> topoplot('example')
%
% See also: topo2sph(), sph2topo()

function [th,r] = cart2topo(x,y,z,center)

% Scott Makeig, CNL / Salk Institute 11/99
% 3-16-00 improved help message -sm

if nargin<4
   center = [0 0 0];
end
if size(x,2)==3 % separate 3-column data
   if nargin>1
     center = y;
   end
   z = x(:,3);
   y = x(:,2);
   x = x(:,1);
end
if size(center,2) ~= 3
  fprintf('Center must be [x y z].\n');
  return
end

if size(x,2)>1 % convert to columns
   x = x'
end

if nargin>1
  if size(y,2)>1
    x = x'
 end
end

if nargin>2
  if size(z,2)>1
   x = x'
  end
end


options = [];
if ~exist('center')
%
% Find center
%
  center = fmins('spherror',[0 0 0],options,[],x,y,z);
  fprintf('Best center is [%g,%g,%g].\n',center(1),center(2),center(3));
end
x = x - center(1);
y = y - center(2);
z = z - center(3);
radius = (sqrt(x.^2+y.^2+z.^2)); % assume xyz values are on a sphere
wobble = std(mean(radius)); % test if xyz values are on a sphere

fprintf('radius values: %g +/- %g\n',mean(radius),wobble);
if wobble/mean(radius) > 0.01
  fprintf('Wobble too high (%3.2g%%)! Re-centering data on (%g,%g,%g)\n',...
              100*wobble/mean(radius),center(1),center(2),center(3))
  return
else
  fprintf('Wobble (%3.2g%%) after centering data on (%g,%g,%g)\n',...
              100*wobble/mean(radius),center(1),center(2),center(3))
end

x = x./radius; % make radius 1
y = y./radius;
z = z./radius;

r = x; th=x;

for n=1:size(x,1)
  if x(n)==0 & y(n)==0
    r(n) = 0;
  else
    r(n)  = pi/2-atan(z(n)./sqrt(x(n).^2+y(n).^2));
  end
end
r =  r/pi; % scale to max 0.500

for n=1:size(x,1)
  if abs(y(n))<1e-6
    if x(n)>0
      th(n) = -90;
    else % x(n) <= 0
      th(n) = 90;
    end
  else
    th(n) = atan(x(n)./y(n))*180/pi+90;
    if y(n)<0
      th(n) = th(n)+180;
    end
  end
  if th(n)>180 
     th(n) = th(n)-360;
  end
  if th(n)<-180 
     th(n) = th(n)+360;
  end
end
