function a = acprobdist_alpha(varargin)
% ACPROBDIST_ALPHA Create a new probability distribution with coefficients
% for damped adaptation of values.  The Gaussian posterior distribution is
% characterised by mean, variance and dependence on the previous value.
%

% Copyright (C) 2002 Harri Valpola and Antti Honkela.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

% Prefer mathematical operations of acprobdist_alpha over those of probdist
% or probdist_alpha
inferiorto('mprobdist')
superiorto('probdist_alpha')

% Do our best depending on the number of input arguments
switch nargin
 case 0
  b = probdist_alpha;
  a.ac = 0;
  a.nvar = b.var;
  a = class(a, 'acprobdist_alpha', b);
 case 1
  if (isa(varargin{1}, 'acprobdist_alpha'))
    a = varargin{1};
  else
    b = probdist_alpha(varargin{1});
    a.ac = zeros(size(varargin{1}));
    a.nvar = b.var;
    a = class(a, 'acprobdist_alpha', b);
  end
 case 2
  if (isa(varargin{1}, 'probdist_alpha'))
    b = varargin{1};
    a.ac = varargin{2};
    a.nvar = b.var;
  elseif (isa(varargin{1}, 'probdist'))
    b = probdist_alpha(varargin{1});
    a.ac = varargin{2};
    a.nvar = b.var;
  else
    b = probdist_alpha(varargin{1}, varargin{2});
    a.ac = zeros(size(varargin{1}));
    a.nvar = b.var;
  end
  a = class(a, 'acprobdist_alpha', b);
 case 3
  if (isa(varargin{1}, 'probdist_alpha'))
    b = varargin{1};
    a.ac = varargin{2};
    a.nvar = varargin{3};
  else
    b = probdist_alpha(varargin{1}, varargin{2});
    a.ac = varargin{3};
    a.nvar = b.var;
  end
  a = class(a, 'acprobdist_alpha', b);
 case 4
  b = probdist_alpha(varargin{1}, varargin{2}, varargin{3}, varargin{4});
  a.ac = zeros(size(varargin{1}));
  a.nvar = b.var;
  a = class(a, 'acprobdist_alpha', b);
 case 5
  b = probdist_alpha(varargin{1}, varargin{2}, varargin{4}, varargin{5});
  a.ac = varargin{3};
  a.nvar = b.var;
  a = class(a, 'acprobdist_alpha', b);
 case 6
  b = probdist_alpha(varargin{1}, varargin{2}, varargin{3}, varargin{4}, ...
                     varargin{5}, varargin{6});
  a.ac = zeros(size(varargin{1}));
  a.nvar = b.var;
  a = class(a, 'acprobdist_alpha', b);
 case 7
  b = probdist_alpha(varargin{1}, varargin{2}, varargin{4}, varargin{5}, ...
                     varargin{6}, varargin{7});
  a.ac = varargin{3};
  a.nvar = b.var;
  a = class(a, 'acprobdist_alpha', b);
 case 8
  b = probdist_alpha(varargin{1}, varargin{2}, varargin{5}, varargin{6}, ...
                     varargin{7}, varargin{8});
  a.ac = varargin{3};
  a.nvar = varargin{4};
  a = class(a, 'acprobdist_alpha', b);
end
