function [post, ll, delist] = soft_part(data, mn, W, V, p, d, nos)
%% function post = soft_part(data, mn, W, V, p, d, L)
%% partition data to maximize mixture likelihood
%%   data      - input data matrix (num inp x dimension)
%%   mn        - region means (num reg x dimension)
%%   W         - region transform (num reg x dimension x dimension)
%%   V         - region variances (num reg x dimension)
%%   p         - region priors (num reg)
%%   d         - region dimensions (num reg)
%%   nos       - noise variance (num reg)
%%
%%   post      - posterior probabilities (num inp x num reg)
%%   ll        - log likelihood
%%   delist    - list of regions to delete

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

%% loop through all regions, finding posterior probability
%% for all data items
ecst = get_cost(data, mn, W, V, p, d, nos);
el = -0.5*ecst - 0.5*id*log(2*pi)*ones(M,N);
tpost = exp(el');

if (M>1)      
    px = sum(tpost');
    i = px<=0;
    if (sum(i)>0)
       px(i) = 0.5/N*ones(1,sum(i));
    end;
    post = tpost ./ (px'*ones(1,M));
else
    px = tpost';
    i = px<=0;
    if (sum(i)>0)
       px(i) = 0.5/N*ones(1,sum(i));
    end;
    post = ones(N,1);
end;
   
%% calculate likelihood
ll =  -1 * sum(log(px)); 

%% loop through regions, delete any that are not
%% responsible for any data
delist = [];
if (M>1)

   for i=M:-1:1
     foo = post(:,i);
     if (sum(foo) == 0)
         delist = [delist, i];
     end;
   end;
   
   if (~isempty(delist))
      for j=1:length(delist)
         post(:,delist(j)) = [];
      end;
   end;
   
end;   




