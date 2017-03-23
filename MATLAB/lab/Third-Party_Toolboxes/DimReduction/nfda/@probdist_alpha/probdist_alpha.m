function a = probdist_alpha(varargin)
% PROBDIST_ALPHA Create a new probability distribution with coefficients
% for damped adaptation of values
%

% Copyright (C) 2002 Harri Valpola and Antti Honkela.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

% Prefer mathematical operations of alpha_probdist over those of probdist
inferiorto('mprobdist')
superiorto('probdist')

% Do our best depending on the number of input arguments
switch nargin
 case 0
  b = probdist(0, 1);
  a.malpha = 1;
  a.valpha = 1;
  a.msign = 0;
  a.vsign = 0;
  a = class(a, 'probdist_alpha', b);
 case 1
  if (isa(varargin{1}, 'probdist_alpha'))
    a = varargin{1};
  else
    b = probdist(varargin{1});
    a.malpha = ones(size(b));
    a.valpha = ones(size(b));
    a.msign = zeros(size(b));
    a.vsign = zeros(size(b));
    a = class(a, 'probdist_alpha', b);
  end
 case 2
  b = probdist(varargin{1}, varargin{2});
  a.malpha = ones(size(b));
  a.valpha = ones(size(b));
  a.msign = zeros(size(b));
  a.vsign = zeros(size(b));
  a = class(a, 'probdist_alpha', b);
 case 3
  error('probdist_alpha: Bad number of arguments for initialization')
 case 4
  b = probdist(varargin{1}, varargin{2});
  a.malpha = varargin{3};
  a.valpha = varargin{4};
  a.msign = zeros(size(b));
  a.vsign = zeros(size(b));
  a = class(a, 'probdist_alpha', b);
 case 5
  b = probdist(varargin{1});
  a.malpha = varargin{2};
  a.valpha = varargin{3};
  a.msign = varargin{4};
  a.vsign = varargin{5};
  a = class(a, 'probdist_alpha', b);
 case 6
  b = probdist(varargin{1}, varargin{2});
  a.malpha = varargin{3};
  a.valpha = varargin{4};
  a.msign = varargin{5};
  a.vsign = varargin{6};
  a = class(a, 'probdist_alpha', b);
end
