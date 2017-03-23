function lfp=CSD2lfp(csd,r)
% lfp=CSD2lfp(csd,r) using linear operator D s.t. lfp=D*csd
% find similar operation in iCSD 2006 paper.
% here mainly for 1d, we can make 2d later...
% I assume the inter-electrode distance is 1. you adjust your own r. 
%
% see also CSD2lfp.m
% YY
[nsite,nd]=size(csd);
if nsite<nd
    csd=csd';
    [nsite,nd]=size(csd);
end
if length(r)<2
    r=[r,0,2*pi];
elseif length(r)<3
    r=[r,2*pi];
end
if nd==1
d=bsxfun(@minus,[1:nsite]',1:nsite).^2;
d=(sqrt(d+r(1)^2)-sqrt(d+r(2)^2))*r(3)/2/pi;
lfp=d*csd/((r(1)^2-r(2)^2)*r(3)/2);
end
