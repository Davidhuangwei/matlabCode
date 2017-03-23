function [parmfile, bestnoise, bestM] = train_apca_ec(filename, validname, mode, numcomp, alpha, rseed)
%% function train_apca_ec(filename, validname, mode, numcomp, alpha, rseed)
%%   train entropy-constrained adaptive pca model 
%%   inputs:
%%   filename  - file that contains data format: size, dim, vectors
%%   vaildname - validation file name
%%   mode      - apca (ppca for soft) or ecvq (sgmm for soft)
%%   numcomp   - maximum number of components
%%   alpha     - decay rate for noise variance
%%   rseed     - seed for random number generator
%%
%%   outputs:
%%   parmfile  - list of parameter file names
%%   bestnoise - noise variance with lowest cost on validation set
%%   bestM     - size of model at best noist variance

%%
%%   Copyright 2002 Oregon Health and Science University
%%   Author: Cynthia Archer 
%%

%intialize output variables
bestnoise = -1;
bestM = -1;
parmfile = [];

%% open and read data file
dotpos = max([find(filename=='.'), 0]);
if (dotpos > 0) 
    namebase = filename(1:dotpos-1)
else
    disp('Illegal data file name');
end;

fid = fopen(filename, 'r');
if (fid == -1)
   disp('Error opening data file');
   return;
end;

no_ip = fscanf(fid, '%d',1);
ip_dim = fscanf(fid, '%d', 1);
[ip, count] = fscanf(fid, '%g', [ip_dim, no_ip]);
ip = ip';
fclose(fid);
if (count ~= no_ip*ip_dim)
    disp('Error reading data file');
    return;
end;

% open validation file
fid = fopen(validname, 'r');
if (fid == -1)
   disp('Error opening data file');
   return;
end;

vni = fscanf(fid, '%d',1);
vd = fscanf(fid, '%d', 1);
[vip, count] = fscanf(fid, '%g', [vd, vni]);
vip = vip';
fclose(fid);
if (count ~= vni*vd)
    disp('Error reading validation file');
    return;
end;


%% find global statistics and set initial noise level
gm = mean(ip);
B = cov(ip);
[u,gV,gW] = svd(B,0);
disp(gV(1,1));


if (strcmp(mode, 'apca'))
    ptype = 0;
    dfit = 1;
elseif (strcmp(mode, 'ecvq')) 
    ptype = 0;
    dfit = 0;
    dim = 0;
elseif (strcmp(mode, 'ppca'))
    ptype = 1;
    dfit = 1;
elseif (strcmp(mode, 'sgmm')) 
    ptype = 1;
    dfit = 0;
    dim = 0;
else
    disp('Invalid mode. Use apca, ppca, sgmm, or ecvq');
    return;
end;

noise = ceil(gV(1,1));
if (dfit)
    noiselim = max([0.01, floor(noise / 1000.0)/100.0]);
else
    noiselim = max([0.01, floor(noise / 100.0)/100.0]);
end;
numns = ceil(log(noiselim/noise)/log(alpha));

nfit = 0;

rand('seed', rseed);
y = randperm(no_ip);

%% noise variance adjustment loop
noiscnt = 0;
while ( (noise > noiselim) & (noiscnt < numns) )
    noiscnt = noiscnt + 1;
    noise = alpha*noise;
    if (noise > 10) 
        noise = floor(noise); 
    else
        noise = floor(100*noise)/100.0;
    end;
    
    %% Initialize model parameters
    M = numcomp;

    m = ip(y(1:M),:);                    % region centers (means)

    W0 = zeros(ip_dim*ip_dim, M);
    W = reshape(W0, ip_dim, ip_dim, M);  % region transforms
    V = zeros(M,ip_dim);                 % region variances
    for i=1:M
        W(:,:,i) = gW;
        V(i,:) = diag(gV)';
    end;
    d = zeros(1,M);

    p = 1/M * ones(1,M);                 % region prior probability
    post = zeros(no_ip, M);              % posterior probablilities (partition)

    %% find initial partition and cost
    if (ptype==1)
       [post, C, delist] = soft_part(ip, m, W, V, p, d, noise*ones(1,M));
    else
       [post, C, delist] = hard_part(ip, m, W, V, p, d, noise*ones(1,M));
    end;
    if (~isempty(delist))
       %delist
       for i=1:length(delist)
           j = delist(i);
           m(j,:) = [];
           W(:,:,j) = [];
           V(j,:) = [];
           d(j) = [];
           p(j) = [];
       end;
       M = M - length(delist);
    end;
    %disp([0, 0, 1, noise, M, 0, C]);

    %% Number of Component Adjustment Loop
    compcnt = 0;
    oldM = M+1;
    while ( M >= 1)
       compcnt = compcnt + 1;
   
       %% Training Loop
       delC = 1;
       oldM = M;
       Ct = C;
       loopcnt = 0;
       tol = 0.00001;
       while ( (delC > tol) & (loopcnt < 50) )
           loopcnt = loopcnt + 1;
           oldC = C;
       
           update_parm;
       
           if (ptype==1)
              [post, C, delist] = soft_part(ip, m, W, V, p, d, noise*ones(1,M));
           else
              [post, C, delist] = hard_part(ip, m, W, V, p, d, noise*ones(1,M));
           end;
           if (~isempty(delist))
              %delist
              %disp(p);
              for i=1:length(delist)
                  j = delist(i);
                  m(j,:) = [];
                  W(:,:,j) = [];
                  V(j,:) = [];
                  d(j) = [];
                  p(j) = [];
              end;
              M = M - length(delist);
              %disp(p);
           end;

           if (C ~= 0)
              delC = (oldC - C)/C;
           else
              delC = 0;
           end;
           if (loopcnt == 1) delC = 1; end;
       
           %disp([loopcnt, oldC, C, delC, M]);
       end; %training loop
       
       % save model with lowest cost on validation data
       if (ptype==1)
          [vpost, Lh, delist] = soft_part(vip, m, W, V, p, d, noise*ones(1,M));
       else
          [vpost, Lh, delist] = hard_part(vip, m, W, V, p, d, noise*ones(1,M));
       end;
          
       if ( (compcnt == 1) | (Lh <= minC) )
           mm = m;
           mW = W;
           mV = V;
           mp = p;
           md = d;
           minC = Lh;
           mM = M;
       end;

       %delete a component and re-cluster
       delist = get_leastlike(vip, m, W, V, p, d, noise*ones(1,M)); 
       delist = fliplr(delist);
       if (~isempty(delist))
          for i=1:length(delist)
              j = delist(i);
              m(j,:) = [];
              W(:,:,j) = [];
              V(j,:) = [];
              d(j) = [];
              p(j) = [];
              post(:,j) = [];
          end;
          M = M - length(delist);
       end;
                 
       % new partition with smaller number of regions
       if (M>0)
        if (ptype==1)
           [post, C, delist] = soft_part(ip, m, W, V, p, d, noise*ones(1,M));
        else
           [post, C, delist] = hard_part(ip, m, W, V, p, d, noise*ones(1,M));
        end;
        if (~isempty(delist))
          for i=1:length(delist)
              j = delist(i);
              m(j,:) = [];
              W(:,:,j) = [];
              V(j,:) = [];
              d(j) = [];
              p(j) = [];
          end;
          M = M - length(delist);
        end;
       end;

    end; %number of components adjustment
      
    %% Output parameter file for best number of components
    if (ptype==1)
       [post, C, delist] = soft_part(ip, mm, mW, mV, mp, md, noise*ones(1,mM));
    else
       [post, C, delist] = hard_part(ip, mm, mW, mV, mp, md, noise*ones(1,mM));
    end;
    [mpost, asgn] = max(post');
    
    %write parameter output file
    write_bestparm;
    parmfile = [parmfile, '?', initfile];

    % find noise with lowest cost on validation set
    if (ptype==1)
       [vpost, minC, delist] = soft_part(vip, mm, mW, mV, mp, md, noise*ones(1,mM));
    else
       [vpost, minC, delist] = hard_part(vip, mm, mW, mV, mp, md, noise*ones(1,mM));
    end;
    if (~isempty(delist))
        for i=length(delist):-1:1
            j=delist(i);
            [nr, nc] = size(vpost);
            if (j > nc)
               vpost = [vpost, zeros(vni,1)];
            else
               vpost = [vpost(:,1:j-1), zeros(vni,1), vpost(:,j:end)];
            end;
        end;
    end;
    maxL = minC;
    adim = mp * md';
    disp([noise, mM, adim, maxL]);
    
    if ( (noiscnt == 1) | (maxL < nsL) )
        nsL = maxL;
        bestnoise = noise;
        bestM = mM;
        avgdim = mp * md';
    end;
        
end; %noise adjustment

disp([bestnoise, bestM, avgdim, nsL]);
