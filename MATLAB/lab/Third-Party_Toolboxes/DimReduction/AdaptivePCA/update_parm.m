% Script to fit model parameters to the data
% requires following variables:
% M = number of components
% ip = input data array (no_ip x ip_dim)
% post = posterior probabilities (no_ip x M)
% dim = maximum local dimension

% updates following variables:
% p = priors (1 x M)
% m = means (M x ip_dim)
% V = variances (M x ip_dim)
% W = transforms (ip_dim x ip_dim x M)
% d = local dimensions (1 x M)


%%
%%   Copyright 2002 Oregon Health and Science University
%%   Author: Cynthia Archer 
%%

p = sum(post)/no_ip;

for i=1:M
       % get and weight data in this region
       j = (post(:,i)>0);
       numj = sum(j);
       w = post(j,i);
       nf = sum(w)/numj;
 
       % region mean
       X = w*ones(1,ip_dim) .* ip(j,:);
       m(i,:) = mean(X/nf);

       % covariance matrix
       S = zeros(ip_dim, ip_dim);
       Y = ip(j,:) - ones(numj,1)*m(i,:);
       for k=1:numj
           S = S + w(k) * Y(k,:)'*Y(k,:);
       end;
       S = S/sum(w);

       % region transform
       wr = sqrt(w)*ones(1,ip_dim);
       Y = wr .* (ip(j,:) - ones(numj,1)*m(i,:));
       [u,s,v] = svd(Y/sqrt(nf),0);

       D = v'*S*v;
       lambda = diag(D);
       V(i,:) = lambda';

       W(:,:,i) = v;

       % region dimension 
       if (dfit)
          dd = V(i,:) - noise*ones(1,ip_dim);
          d(i) = min([find(dd<=0),ip_dim+1])-1;
       else
          dd = V(i,:) - 0.000001*ones(1,ip_dim);
          ddi = dd<=0;
          V(i, :) = 0.000001*ones(1,ip_dim) + V(i,:);
          d(i) = dim;
       end;
       
end; 
   
