% gauss() - return a Gaussian window
%
% Usage:
%   >> outvec = gauss(frames,sds);
%
% Inputs:
%   frames = window length
%   steep  = steepness (~0+ -> flat; >>10 -> spike)

% $Log: gauss.m,v $
% Revision 1.1  2002/04/05 17:36:45  jorn
% Initial revision
%

function outvec = gauss(frames,sds)

outvec = [];
if nargin < 2
  help gauss
  return
end
if sds <=0 | frames < 1
  help gauss
  return
end

incr = 2*sds/(frames-1);
outvec = exp(-(-sds:incr:sds).^2);
