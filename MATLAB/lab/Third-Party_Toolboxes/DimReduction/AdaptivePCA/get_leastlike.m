function [delist] = get_leastlike(data, mn, W, V, p, d, nos)
%% function delist = get_leastlik(data, mn, W, V, p, d, nos)
%% find least likely component
%%   data      - input data matrix (num inp x dimension)
%%   mn        - region means (num reg x dimension)
%%   W         - region transform (num reg x dimension x dimension)
%%   V         - region variances (num reg x dimension)
%%   p         - region priors (num reg)
%%   d         - region dimensions (num reg)
%%   nos       - noise variance (num reg)
%%
%%   delist    - list of lowest likelihood regions to delete

%%
%%   Copyright 2002 Oregon Health and Science University
%%   Author: Cynthia Archer 
%%


M = length(d);
[N,id] = size(data);
I = eye(id);

el = zeros(M,N);
tpost = zeros(N, M);
post = zeros(N, M);

%% loop through all regions, finding likelihood
%% for all data items
ecst = get_cost(data, mn, W, V, p, d, nos);
   
el = -0.5*ecst - 0.5*id*log(2*pi)*ones(M,N);
tpost = exp(el');

if (M>1)      
    px = sum(tpost');
    j = px<=0;
    if (sum(j)>0)  px(j) = 1.0/(2.0*N)*ones(1,sum(j)); end;
    post = tpost ./ (px'*ones(1,M));
else
    px = tpost';
    j = px<=0;
    if (sum(j)>0)  px(j) = 1.0/(2.0*N)*ones(1,sum(j)); end;
    post = ones(N,1);
end;
   
%% calculate likelihood
logpx = log(px);
cll = -1 * logpx * post;

%% find lowest likelihood region(s) and mark for potential deletion
delist = [];
[minll, imin] = min(cll);
delist = find(cll==minll);
