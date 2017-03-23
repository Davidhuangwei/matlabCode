function D=CompDist(LA, SA,ka)
% function D=CompDist(LA, SA,ka)
% to compute the distance between components
% LA: reference nvar*ncomp
% SA: to be compared... 
% ka: constant to weight dirivatives... 
% D: distence matrix. 

% LA=bsxfun(@rdivide,LA,sqrt(sum(LA.^2,1)));
% SA=bsxfun(@rdivide,SA,sqrt(sum(SA.^2,1)));
% LA=zscore(LA);
% SA=zscore(SA);
% LA=bsxfun(@minus,LA,mean(LA,1));
% SA=bsxfun(@minus,SA,mean(SA,1));
f=LA'*SA;
d=diff(LA,1,1)'*diff(SA,1,1);
dd=diff(LA,2,1)'*diff(SA,2,1);
fLA=sum(LA.^2,1);
dLA=sum(diff(LA,1,1).^2,1);
ddLA=sum(diff(LA,2,1).^2,1);
fSA=sum(SA.^2,1);
dSA=sum(diff(SA,1,1).^2,1);
ddSA=sum(diff(SA,2,1).^2,1);
a=sqrt((fLA+ka*dLA+ka^2*ddLA)'*(fSA+ka*dSA+ka^2*ddSA));
if a<10^-5
    a=1;
end
D=abs((f+ka*d+ka^2*dd))./a;