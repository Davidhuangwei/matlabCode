function [post, cc, delist] = hard_part(data, mn, W, V, p, d, nos)
%% function post = hard_part(data, mn, W, V, p, d, L)
%% partition data using constrained reconstruction distance
%%   data      - input data matrix (num inp x dimension)
%%   mn        - region means (num reg x dimension)
%%   W         - region transforms (num reg x dimension x dimension)
%%   V         - region variances (num reg x dimension)
%%   p         - region priors (num reg)
%%   d         - region dimensions (num reg)
%%   nos       - noise variance (num reg)
%%
%%   post      - partition matrix 1=in region (num inp x num reg)
%%   cc        - constrained cost
%%   delist    - list of regions to delete

%%
%%   Copyright 2002 Oregon Health and Science University
%%   Author: Cynthia Archer 
%%


M = length(d);
[N,id] = size(data);
I = eye(id);

%% intialize cost vector
C = zeros(M, N);

%% loop through regions, finding distortion
%% for all data items
C = get_cost(data, mn, W, V, p, d, nos);

if (M>1)
   [lowc, hci] = min(C);
else
   hci = ones(1,N);
   lowc = C;
end;

%% loop through all regions, setting entries in posterior probability array
%% find empty regions and mark for deletion
post = zeros(N,M);
delist = [];
for i=M:-1:1
    foo = (hci == i);
    if (sum(foo) == 0) 
       delist = [delist, i]; 
       post(:,i) = [];
    else
       post(:,i) = foo';
    end;
end;

%% calculate cost of this partition
cc = sum(lowc)/N;





