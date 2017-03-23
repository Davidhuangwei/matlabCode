function a = mprobdist(varargin)
% MPROBDIST Create a new probability distribution with some
% extra variances
%

% Copyright (C) 2002 Harri Valpola and Antti Honkela.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

% Prefer mathematical operations of mprobdist over those of probdist
superiorto('probdist')

% Do our best depending on the number of input arguments
switch nargin
 case 0
  a.multivar = 0;
  a.extravar = 0;
  b = probdist(0, 1);
  a = class(a, 'mprobdist', b);
 case 1
  if (isa(varargin{1}, 'mprobdist'))
    a = varargin{1};
  else
    a.multivar = 0;
    a.extravar = 0;
    b = probdist(varargin{1});
    a = class(a, 'mprobdist', b);
  end
 case 2
  a.multivar = 0;
  a.extravar = 0;
  b = probdist(varargin{1}, varargin{2});
  a = class(a, 'mprobdist', b);
 case 3
  mv = varargin{3};
  if (ndims(mv) < 2)
    a.multivar(1,:) = mv;
  else
    a.multivar = mv;
  end
  a.extravar = zeros(size(varargin{1}));
  b = probdist(varargin{1}, varargin{2});
  a = class(a, 'mprobdist', b);
 case 4
  mv = varargin{3};
  if (ndims(mv) < 2)
    a.multivar(1,:) = mv;
  else
    a.multivar = mv;
  end
  a.extravar = varargin{4};
  b = probdist(varargin{1}, varargin{2});
  a = class(a, 'mprobdist', b);
end

