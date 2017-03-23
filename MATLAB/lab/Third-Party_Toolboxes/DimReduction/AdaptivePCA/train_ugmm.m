function [parmfile, mM] = train_ugmm(filename, validname, mode, numcomp, mlst, rseed)
%% function train_ugmm(filename, validname, numcomp, mlst, rseed)
%%   train hard-clustering gaussian mixture model with unconstrained covariance model 
%%   inputs:
%%   filename  - file that contains data format: size, dim, vectors
%%   validname - validation file name
%%   mode      - hard or soft clustering
%%   numcomp   - maximum number of components
%%   mlst      - list of numbers of components to save and plot
%%   rseed     - seed for random number generator
%%
%%   outputs:
%%   parmfile  - list of parameter file names
%%   bestM     - size of model with lowest validation set cost

%%
%%   Copyright 2002 Oregon Health and Science University
%%   Author: Cynthia Archer 
%%

%% initialize outputs
parmfile = [];
mM = -1;

if (strcmp(mode, 'hard'))
    ptype = 0;
    modtyp = 'hgmm';
elseif (strcmp(mode, 'soft')) 
    ptype = 1;
    modtyp = 'ugmm'
else
    disp('Invalid mode. Use hard or soft');
    return;
end;

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

noise = 0;
dim = ip_dim;
dfit = 0;
nfit = 0;

rand('seed', rseed);
y = randperm(no_ip);



%% Initialize adaptive pca model parameters
M = numcomp;

m = ip(y(1:M),:);                    % region centers (means)

W0 = zeros(ip_dim*ip_dim, M);
W = reshape(W0, ip_dim, ip_dim, M);  % region transforms
V = zeros(M,ip_dim);                 % region variances
for i=1:M
    W(:,:,i) = gW;
    V(i,:) = diag(gV)';
end;
d = ip_dim*ones(1,M);

p = 1/M * ones(1,M);                 % region prior probability
post = zeros(no_ip, M);              % posterior probablilities (partition)

%% find initial partition and cost
if (ptype == 1)
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

%% Number of Component Adjustment Loop
compcnt = 0;
while ( (M >= 1) )
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
       
           if (ptype ==1)
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

           if (C ~= 0)
              delC = (oldC - C)/C;
           else
              delC = 0;
           end;
           if (loopcnt == 1) delC = 1; end;
       
       end; %training loop
       avgd = p*d';

       % save model with lowest cost on validation data
       if (ptype == 1)
          [vpost, Lh, delist] = soft_part(vip, m, W, V, p, d, noise*ones(1,M)); 
       else
          [vpost, Lh, delist] = hard_part(vip, m, W, V, p, d, noise*ones(1,M)); 
       end;
       
       if ( (compcnt == 1) | (Lh < maxL) )
           mm = m;
           mW = W;
           mV = V;
           mp = p;
           md = d;
           maxL = Lh;
           mM = M;
       end;
       

       midx = find(mlst==M);
       if (~isempty(midx))
           [mpost, asgn] = max(post');
           write_curparm;
           parmfile = [parmfile, '?', initfile];
       end;

       %keyboard;

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
              j = delist(1);
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
       [vpost, minC, delist] = soft_part(vip, mm, mW, mV, mp, md, noise*ones(1,mM));
else
       [post, C, delist] = hard_part(ip, mm, mW, mV, mp, md, noise*ones(1,mM));
       [vpost, minC, delist] = hard_part(vip, mm, mW, mV, mp, md, noise*ones(1,mM));
end;
[mpost, asgn] = max(post');
disp([mM, minC]);

%write parameter output file
write_bestparm;
parmfile = [parmfile, '?', initfile];

    
avgdim = mp*md';
disp([mM, avgdim, maxL]);

