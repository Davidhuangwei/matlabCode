function a = probdist(varargin)
% PROBDIST Create a new probability distribution
%

% Copyright (C) 2002 Harri Valpola and Antti Honkela.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

switch nargin
 case 0
  a.e = 0;
  a.var = 1;
  a = class(a,'probdist');
 case 1
  if (isa(varargin{1},'probdist'))
    a = varargin{1};
  else
    a.e = varargin{1};
    a.var = zeros(size(a.e));
    a = class(a,'probdist');
  end
 case 2
  a.e = varargin{1};
  a.var = varargin{2};
  a = class(a,'probdist');
end

