function a = probdist(varargin)
% PROBDIST Create a new probability distribution
%

% Copyright (C) 1999-2000 Xavier Giannakopoulus, Antti Honkela,
% and Harri Valpola.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

switch nargin
 case 0
  a.expection = 0;
  a.variance = 1;
  a = class(a,'probdist');
 case 1
  if (isa(varargin{1},'probdist'))
    a = varargin{1};
  else
    a.expection = varargin{1};
    a.variance = zeros(size(a.expection));
    a = class(a,'probdist');
  end
 case 2
  a.expection = varargin{1};
  a.variance = varargin{2};
  a = class(a,'probdist');
end

