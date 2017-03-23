function b = subsref(a,index)
% SUBSREF implement subscripted reference for mprobdists

% Copyright (C) 2002 Harri Valpola and Antti Honkela.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

switch index(1).type
 case '.'
  switch index(1).subs
   case 'e'
    b = get(a.probdist, 'E');
   case 'var'
    b = get(a.probdist, 'Var');
   case 'multivar'
    b = a.multivar;
   case 'extravar'
    b = a.extravar;
  end
 case '()'
  ex = get(a.probdist, 'E');
  var = get(a.probdist, 'Var');
  thissubs = index(1).subs;

  % The usual case of indexing the array as a matrix.
  % As multivar array has an extra dimension as second one, we must
  % just remember to always include it as is.
  if size(thissubs, 2) == 2
    mvsubs = thissubs;
    mvsubs{3} = thissubs{2};
    mvsubs{2} = ':';
    mv = a.multivar(mvsubs{:});
  else
    mv = a.multivar(thissubs{:});
  end
  b = mprobdist(ex(thissubs{:}), var(thissubs{:}), ...
		mv, a.extravar(thissubs{:}));
 otherwise
  error('Unsupported function')
end

% Handle other references recursively
if length(index) > 1
  b = subsref(b, index(2:end));
end
