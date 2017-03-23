% DON'T USE THIS; IT DOESN'T WORK
% use CircAnova instead
% 
% [p, Y] = WatsonTest(Th, Gp)
% or 
% [p, Y] = WatsonTest({Th1, Th2, Th3, ...})
%
% performs a "watson test" for equality of circular means
% 
% see Fisher, Statistical analysis of circular data, p. 117.
%
% in use 1, Gp tells you which angle belongs in which group (1..nGps)
% in use 2, you specify sets of angles directly.

function [p, Y] = WatsonTest(Arg1, Arg2)

% deal with argument form 2
if nargin==1 & iscell(Arg1)
    nGps = length(Arg1);
    
    Th = []; Gp = [];
    for g=1:nGps
        Th = [Th ; Arg1{g}(:)];
        Gp = [Gp ; g*ones(length(Arg1{g}),1)];
    end
else
    Th = Arg1;
    Gp = Arg2;
    nGps = max(Gp);
end

for g=1:nGps
    MyTh = Th(find(Gp==g));
    n(g) = length(MyTh);
    if n(g)<25
        warning(sprintf('Group %d has %d members', g, n(g)));
    end
    [mu(g) r] = circmean(MyTh);
    m2 = mean(cos(2*(MyTh-mu(g)))); % see p. 34
    disp(g) = (1-m2)/(2*r*r);
    se2(g) = disp(g)/n(g); % see p.76
end

C = sum(n.*cos(mu));
S = sum(n.*sin(mu));
R = sqrt(C*C + S*S);

d0 = sum(n.*disp)/sum(n);

Y = 2*(sum(n)-R)/d0;
p = 1-chi2cdf(Y, nGps-1);


%return
C = sum(cos(mu)./se2);
S = sum(sin(mu)./se2);
R = sqrt(C*C + S*S)
sum(1./se2)

Y = 2*sum(1./se2 - R);

p = 1-chi2cdf(Y, nGps-1);
