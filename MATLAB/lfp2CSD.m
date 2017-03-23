function csd=lfp2CSD(lfp,r)
% csd=lfp2CSD(lfp,r) using linear operator D s.t. lfp=D*csd
% r=[rl rs];
% find similar operation in iCSD 2006 paper.
% used when you have nice lfp component extracted already. 
% here mainly for 1d, we can make 2d later...
% I might make a GP regression -> csd reconstruction code... we
% will see... using GP is you assume each point have a  unique distance-dependent
% influence to the other points. 
%
% see also CSD2lfp.m
% YY
[nsite,nd]=size(lfp);
if nsite<nd
    lfp=lfp';
    [nsite,nd]=size(lfp);
end
if length(r)<2
    r=[r,0,2*pi];
elseif length(r)<3
    r=[r,2*pi];
end
if nd==1
    d=bsxfun(@minus,[1:nsite]',1:nsite).^2;
    d=(sqrt(d+r(1)^2)-sqrt(d+r(2)^2))*r(3)/2/pi;
    csd=d\lfp/((r(1)^2-r(2)^2)*r(3)/2);
else
    d=bsxfun(@minus,[1:nsite]',1:nsite).^2;
    d=(sqrt(d+r(1)^2)-sqrt(d+r(2)^2))*r(3)/2/pi;
    csd=zeros(size(lfp));
    for k=1:nd
        csd(:,k)=d\lfp(:,k)/((r(1)^2-r(2)^2)*r(3)/2);
    end
end
