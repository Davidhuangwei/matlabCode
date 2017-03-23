function [asgn, C, D, H, Hpur, Hcsc, nmi] = test_apca(filename, parmname)
%% function [asgn, C, D, H, Hpur, Hcsc, nmi] = test_apca(filename, parmname)
%% cluster data in test file according to the model in parmname file
%% outputs:
%%    asgn      hard assignment of test data items to model components
%%    C         cost
%%    D         distortion portion of cost
%%    H         entropy portion of cost
%%    Hpur      conditional entropy of class given component (impurity)
%%    Hcsc      conditioinal entropy of component given class (conciseness)
%%    nmi       normalized mutual information

%%
%%   Copyright 2002 Oregon Health and Science University
%%   Author: Cynthia Archer 
%%

%%
%% initialize output variables
asgn = [];
Hpur = -1;
Hcsc = -1;
C = -1;
D = -1;
H = -1;
nmi = -1;

%% input data and generating component assignment files
%% filename.dat and filenamegc.ras
datname = sprintf('%s.dat', filename);
ip = read_data(datname);
if (isempty(ip)) return; end;
[no_ip, ip_dim] = size(ip);

noras = 0;
rasname = sprintf('%sgc.ras', filename);
fid = fopen(rasname, 'r');
if (fid == -1)
    disp(['No assignment file ', rasname]);
    noras = 1;
else    
    ni = fscanf(fid, '%d',1);
    if (ni ~= no_ip)
       disp(['Mismatch between data and assignment files']);
       disp([ni, no_ip]);
       fclose(fid);
       return;
    end;
    no_gc = fscanf(fid, '%d', 1);
    [ras, count] = fscanf(fid, '%d', no_ip);   
    fclose(fid);
end;
 
 %% input parameter values from parameter file
parfile = sprintf('%s.par', parmname);
fid = fopen(parfile, 'r');
if (fid == -1)
    disp(['Error opening parameter file ', parmname]);
    return;
end;
M = fscanf(fid, '%d', 1);
ptype = fscanf(fid, '%d', 1);
nfit = fscanf(fid, '%d', 1);
dfit = fscanf(fid, '%d', 1);
rseed = fscanf(fid, '%d', 1);
id = fscanf(fid, '%d', 1);
if (id ~= ip_dim)
     disp(['Mismatch between data and parameter files']);
     return;
end; 
[nv, count] = fscanf(fid, '%g', M);
[d, count] = fscanf(fid, '%d', M);
[p, count] = fscanf(fid, '%g', M);
[mr, count] = fscanf(fid, '%g', [ip_dim, M]);
m = mr';
[Vr, count] = fscanf(fid, '%g', [ip_dim, M]);
V = Vr';
W = zeros(ip_dim*ip_dim, M);
W = reshape(W, ip_dim, ip_dim, M);
for i=1:M
  [W0, count] = fscanf(fid, '%g', [ip_dim, ip_dim]);
  W(:,:,i) = W0;
end;
fclose(fid);

dshpos = min(find(parmname == '_'));
basefile = sprintf('%s_%s', filename, parmname(dshpos+1:end));

%keyboard;

%% partition data according to model
if (ptype==1)
    [post, C, delist] = soft_part(ip, m, W, V, p, d, nv);
else
    [post, C, delist] = hard_part(ip, m, W, V, p, d, nv);
end;
if (~isempty(delist))
    % if any regions unused, put zero posteriors in the right place
   delist
   for i=length(delist):-1:1
       j = delist(i);
       post = [post(:, 1:j-1), zeros(no_ip, 1), post(:, j:end)];
   end;
end;
ns = mean(nv);

%calculate distortion and entropy portions of cost
if (M>1) 
    vp = (sum(post)/no_ip)';
else
    vp = 1;
end;
qh = -1*log(p')*vp;
mhd = 0.5 * d' *vp;
Lam = V;
rdtmp = zeros(1,M);
for i=1:M
    if ((nv(i)>0) & (d(i) < ip_dim))
        if (d(i)>0) Lam(i,1:d(i)) = V(i,1:d(i))/nv(i); end;
        Lam(i, d(i)+1:ip_dim) = ones(1, ip_dim-d(i));
    end;
    
    j = post(:,i)==1;
    numi = sum(j);
    if (numi == 0) 
        rdtmp(i) = 0;
    else
        difi = ip(j,:) - ones(numi, 1)*m(i,:);
        if (d(i)==0)
            rdtmp(i) = sum(sum(difi .* difi))/numi;
        elseif (d(i)<ip_dim)
            U = W(:, d(i)+1:ip_dim, i);
            tdif = difi *U;
            rdtmp(i) = sum(sum(tdif .* tdif))/numi;
        else
            rdtmp(i) = 0.0;
        end;
    end;
end;
%keyboard;
vh = 0.5 * sum(log(Lam')) * vp;
H = qh + vh + mhd;
D = rdtmp * vp;
        
%disp([C, D, H]);


if (noras == 0)
   %% calculate entropy of the true classes conditioned on the component labels
   %% H(gc|asgn) is measure of component purity
   if (M>1)
    [mp, hci] = max(post');
   else
    hci = ones(1,no_ip); 
   end;
   pgca = zeros(1, no_gc); 
   hg = zeros(1, M);
   Ha = 0;
   for i=1:M
       j = (hci==i);
       Na = sum(j);
       if (Na > 0)
          for k=1:no_gc
            pgca(k) = sum(ras(j)==k)/Na;
          end;
          k = pgca > 0;
          hg(i) = sum(pgca(k) .* log2(pgca(k)))*Na;
          Ha = Ha - Na/no_ip * log2(Na/no_ip);
       end;
   end;
   Hpur = -sum(hg)/no_ip;

   %% calculate entropy of component labels conditioned on the true class
   %% H(asgn|gc) is measure of model conciseness
   ha = zeros(1,no_gc);
   Hg = 0;
   for k=1:no_gc
       j = (ras==k);
       Ng = sum(j);
       if (Ng > 0)
          pacg = sum(post(j,:))/Ng;
          i = pacg > 0;
          ha(k) = sum(pacg(i) .* log2(pacg(i)))*Ng;
          Hg = Hg - Ng/no_ip * log2(Ng/no_ip);
       end;
   end;
   Hcsc = -sum(ha)/no_ip;
   
   nmi = 1 - (Hpur+Hcsc)/(Hg+Ha);
end;

%% output assignments
if (M>1)
   [mp, asgn] = max(post');
else
    asgn = ones(no_ip,1);
end;

