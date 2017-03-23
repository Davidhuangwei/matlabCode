function [E, tau] = condexp(dN, dM, T)
%CONDEXP estimates the conditional expectation of a point process given another
%
%  [E, TAU] = CONDEXP(dN, dM, T) returns the conditional expectation in E for 
%  dN given dM over the range [T(1),T(2)] with sampling rate T(3) 
%
%  Defaults:	T = [-N/10,N/10,1]
%

%  Written by: Bijan Pesaran, Bell Labs, July 2000

ntr1 = size(dN,1);
ntr2 = size(dM,1);
if ntr1 ~= ntr2 error('Number of trials in each process must be the same'); end
ntr = ntr1;

nt1 = size(dN,2);
nt2 = size(dM,2);
if nt1 ~= nt2 error('Length of each process must be the same'); end
nt = nt1;

if nargin < 3 T = [-nt/10:nt/10,1]; end

sampling = T(3);
tau = [T(1):1./sampling:T(2)];
range = T(1:2).*sampling;
E = zeros(1,diff(range)+1);

for itr = 1:ntr
   inds = find(dM(itr,:));
   ne = length(inds);
   for in = 1:ne
      ind = inds(in);
      if ind > -range(1)+1 & ind < nt - range(2)-1
         tmp = dN(itr,ind+range(1):ind+range(2));
         E = E + tmp;
      end
   end
end

