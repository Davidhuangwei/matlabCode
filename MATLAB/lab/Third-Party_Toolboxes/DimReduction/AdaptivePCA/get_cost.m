function nll = get_cost(data, mn, W, V, p, d, nos)
%% function el = get_cost(data, mn, W, V, p, d, nos)
%% calculate constrained cost
%%   data      - input data matrix (num inp x dimension)
%%   mn        - region means (num reg x dimension)
%%   W         - region transform (num reg x dimension x dimension)
%%   V         - region variances (num reg x dimension)
%%   p         - region priors (num reg)
%%   d         - region dimensions (num reg)
%%   nos       - noise variance (num reg)
%%
%%   nll       - cost for each data item (numreg x num inp)

%%
%%   Copyright 2002 Oregon Health and Science University
%%   Author: Cynthia Archer 
%%

M = length(d);
[N,id] = size(data);
I = eye(id);

nll = zeros(M,N);
elrd = zeros(M,N);
elh = zeros(M,N);
elp = zeros(M,N);

%% loop through regions, finding likelihood
%% for all data items. Regions with full or zero dimension
%% require special handling.
for i=1:M
    if (d(i) == 0)
       % normalization factor
       if (nos(i) > 0)
          nf = nos(i) * ( -2.0*log(p(i)) + id*log(nos(i)) );
       else
          nf = 0.0;
       end;

       % reconstruction distance part (Euclidean distance)    
       X = data - ones(N,1)*mn(i,:);
       rd = sum((X.*X)');

       % Mahalanobis distance part
       md = 0;

    elseif (d(i) == id)
       % normalization factor
       j = (V(i,:) <= 0);
       if (sum(j) > 0)
           %disp(['zero or negative variance']);
           V(i,j) = 0.0000001*ones(1, length(j));
       end;
       if (nos(i) > 0)
          nf = nos(i) * (-2*log(p(i)) + sum(log(V(i,:))));
       else
          nf = -2*log(p(i)) + sum(log(V(i,:)));
       end;
          
       % reconstruction distance part    
       rd = 0;

       % Mahalanobis distance part
       U = W(:,:,i);
       X = data - ones(N,1)*mn(i,:);
       Y = X*U;
       Z = Y .* (ones(N,1)*(1./V(i,:))) .* Y;
       if (nos(i) > 0)
          md = nos(i) * sum(Z');
       else
          md = sum(Z');
       end; 
    else
       %% calculate normalization factor
       j = (V(i,1:d(i)) <= 0);
       if (sum(j) > 0)
           %disp(['zero or negative variance']);
           V(i,j) = 0.0000001*ones(1,sum(j));
       end;
       if (nos(i) > 0)
          nf = nos(i) * (-2*log(p(i)) + (id-d(i))*log(nos(i)) + sum(log(V(i,1:d(i)))));
      else;
          nf = 0.0;
      end;

       %% extract transform and remove mean from data
       U = W(:,1:d(i),i);
       X = data - ones(N,1)*mn(i,:);

       %% reconstruction distance part
       P = I - U*U';
       Z = (X*P).*X;
       rd = sum(Z');

       %% Mahalanobis distance part
       Y = X*U;
       Z = Y .* (ones(N,1)*(1./V(i,1:d(i)))) .* Y;
       if (d(i) > 1)
          md = nos(i) * sum(Z');
       else
          md = nos(i) * Z';
       end;
    end;
   
    nll(i,:) = nf*ones(1,N) + rd + md;    
    if (nos(i)>0) nll(i,:) = nll(i,:)/nos(i); end;
end;


