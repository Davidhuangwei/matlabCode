function [FACT,varexpl]=nmwf(X,noc,varargin)

% Non-Negative Multi Way Factorization (NMWF) with optional sparseness
% constraint
%
% Written by Morten Mørup
%
% The algorithm is described in: 
% M. Mørup, L. K. Hansen, S. M. Arnfred (2005) "Decomposing the inter trial phase
% coherence of EEG in time-frequency plots using non-negative matrix and
% multi-way factorization" presently extended to encorporate sparseness
%
% The algorithm is a generalization of Lee and Seung's NMF algorithm:
%       Lee DD, Seung HS. (2001) "Algorithms for non-negative matrix
%       factorization" Advances in Neural information processing 13
% to multi-way arrays.
% The algorithm imposed sparseness using the L-1 norm as suggested by:
%       Julian Eggert, Edgar Körner, "Sparse coding and NMF", Proceedings.
%       2004 IEEE International Joint Conference on Neural Networks, 2004.,
%       pp. 2529-2533, 2004
% Consequently, the algorithm
% decomposes the data according to the PARAFAC model with non-negativity
% constraints on all modalities.
%
% X_{i1,i2,...,in}=\sum_k a_{i1,k}*a_{i2,k}*...*a_{in,k}
%
% The algorithm has been accelerated using overrelaxed bound optimization
%
% Usage:
% [FACT varexpl]=nmwf(X,noc,opts)
%
% Input:
% X             n-way array to decompose
% noc           number of components
% opts.         Struct containing:
%       lambda       1xnoc vector where lambda(i) is the sparseness strength
%                    imposed on the FACT{i} given by the cost
%                    lambda(i)*sum(FACT{i}(:)) (default: lambda(i)=0)
%       costfcn      the method used (optional): 
%                    'ls' = least square minimization (default)
%                    'kl' = Kullback-Leibler-divergence minimization
%       FACT         initial solution (optional) (see also output)
%       constFACT    constFACT(i)=0  FACT{i} updated, else FACT{i} not updated
%                    but kept constant
%       maxiter      maximum number of iterations
%       minRAM       1: minimize ram usage 0: keep as many variable in
%       normmeth     0: normalize componentwise, 1: normalize by frobenius norm of full
%                    factor.
%                    memory to improve algorithm speed
%       alpha        Acceleration parameter of overrelaxed bound
%       beta         Decelleration parameter for overrelaxed bound
%       conv_crit    The convergence criteria (defauld 10^-6 relative change in costfcn)
%
% Output:
% FACT          cell array: FACT{i} is the factors found for the i'th
%               modality
% varexpl       Percent variation explained by the model compared to a
%               model attaining the mean of the data
%
% Copyright (C) Morten Mørup and Technical University of Denmark, 
% September 2006
%                                          
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

warning('off','MATLAB:dispatcher:InexactMatch')
le=ndims(X);
if nargin>=3, opts = varargin{1}; else opts = struct; end
conv_crit=mgetopt(opts,'conv_crit',10^-6);
maxiter=mgetopt(opts,'maxiter',2500);
ny=mgetopt(opts,'ny',1);        % initial value of adaptive parameter
alpha=mgetopt(opts,'alpha',1.1);   % acceleration of adaptive parameter, i.e.    ny=ny*alpha
beta=mgetopt(opts,'beta',2);      % decelleration of adaptive parameter, i.e.   ny=ny/beta
costfcn=mgetopt(opts,'costfcn','ls', 'instrset', {'ls','kl'});
normmeth=mgetopt(opts,'normmeth',0);
minRAM=mgetopt(opts,'minRAM',0);
lambda=mgetopt(opts,'lambda',zeros(noc,1));
constFACT=mgetopt(opts,'constFACT',zeros(le,1));
FACT=mgetopt(opts,'FACT',[]);
% minimize computational burden by defining matriziced versions of X

for i=1:ndims(X)    
    N(i)=size(X,i);
    if ~minRAM
        Xi{i}=matrizicing(X,i);
    end
end

if isempty(FACT)
    %random initialisation
    for i=1:ndims(X)
            FACT{i}=rand(N(i),noc);
            % Normalize factor just in case sparsity is imposed
            mX=max(X(:));
            if sum(lambda)==0 | lambda(i)~=0
                FACT{i}=FACT{i}*mX;
            elseif normmeth==0
                FACT{i}=FACT{i}/(sqrt(sum(FACT{i}(:).^2))+eps); 
            else
                FACT{i}=FACT{i}.*repmat(1./(sqrt(sum(FACT{i}.^2,1))+eps),[size(FACT{i},1),1]); 
            end
    end
end
I=find(lambda>0);
 
disp([' '])
disp(['Adaptive Non-negative Multiway Factorization'])
disp(['using ' costfcn '-minimization'])
disp(['Sparsity imposed on modality ' num2str(I) ' with strength(s) ' num2str(lambda(I))])
disp(['A ' num2str(noc) ' component model will be fitted']);
disp([' '])
disp(['To stop algorithm press control C'])
disp([' ']);
dheader = sprintf('%12s | %12s | %12s | %12s | %12s | %12s','Iteration','Expl. var.','Cost func.','Delta costf.','Acc.par. ny',' Time(s)   ');
dline = sprintf('-------------+--------------+--------------+--------------+--------------+--------------+');
  

iter=0;
dcost=inf;
cost=inf;
if minRAM
   Xi=matrizicing(X,1);
   SST=norm(Xi-mean(mean(Xi)),'fro')^2;
   clear Xi;
else
   SST=norm(Xi{1}-mean(Xi{1}(:)),'fro')^2;
end
t1=cputime;

if strcmp(costfcn,'ls')
       
    % ls-minimization
    while dcost>=conv_crit*cost & iter<maxiter
        if mod(iter,100)==0
             disp(dline); disp(dheader); disp(dline);
        end
        pause(0.00001); %Enables to break algorithm by pushing "Control C".
        told=t1;
        iter=iter+1;
        cont=0;
        cost_old=cost;
        while cont==0
            sparse_C=0;
            for i=1:le
                if ~constFACT(i)
                    ind=1:le;
                    ind(i:end-1)=ind((i+1):end);
                    ind=ind(1:(end-1));
                    kr=FACT{ind(1)};
                    krkr=FACT{ind(1)}'*FACT{ind(1)};
                    if minRAM
                        clear Xi;
                        Xi{i}=matrizicing(X,i);
                    end
                        
                    for z=ind(2:end)
                        kr=krprod(FACT{z}, kr);     
                        krkr=krkr.*(FACT{z}'*FACT{z});
                    end
                    if sum(lambda)==0
                        T=(Xi{i}*kr)./(FACT{i}*krkr+eps);
                        FACT{i}=FACT{i}.*(T.^ny);
                    elseif lambda(i)==0
                        Wx=Xi{i}*kr;
                        Wy=FACT{i}*krkr;     
                        if normmeth==0                           
                           tx = sum(Wy.*FACT{i},1);
                           ty = sum(Wx.*FACT{i},1);
                           Wx = Wx + repmat(tx,[N(i),1]).*FACT{i};
                           Wy = Wy + repmat(ty,[N(i),1]).*FACT{i};
                           T=Wx./(Wy+eps);
                           FACT{i}=FACT{i}.*(T.^ny);
                           FACT{i}=FACT{i}.*repmat(1./(sqrt(sum(FACT{i}.^2,1))+eps),[size(FACT{i},1),1]); 
                        else
                           tx = sum(sum(Wy.*FACT{i},1));
                           ty = sum(sum(Wx.*FACT{i},1));
                           Wx = Wx + tx*FACT{i};
                           Wy = Wy + ty*FACT{i};
                           T=Wx./(Wy+eps);
                           FACT{i}=FACT{i}.*(T.^ny);
                           FACT{i}=FACT{i}/(sqrt(sum(FACT{i}(:).^2))+eps); 
                        end
                    else
                        T=(Xi{i}*kr)./(FACT{i}*krkr+lambda(i)+eps);
                        FACT{i}=FACT{i}.*(T.^ny);
                        sparse_C=sparse_C+lambda(i)*sum(FACT{i}(:));
                    end 
                    t=i;
                end
            end
            cost1=norm((Xi{t}-FACT{t}*kr'),'fro')^2;
            cost=0.5*cost1+sparse_C;
            dcost=cost_old-cost;
            if dcost>0 & dcost<conv_crit*cost & ny~=1 %insure adaptive parameter is not responsible for convergence
                ny=1;
                cont=0;
            elseif dcost>0
                ny=alpha*ny;
                cont=1;
                FACTold=FACT;
            else
                cont=0;
                ny=ny/beta;    
                if ny<1 
                     ny=1;
                end  
                FACT=FACTold;
            end
        end
        t1=cputime;
        if rem(iter,5)==0
            disp(sprintf('%12.0f | %12.4f | %12.4f | %12.4f | %12.4f | %12.4f',iter, (SST-cost1)/SST,cost,dcost, ny,t1-told));
        end
    end
else
    xlogxx=X.*log(X+eps)-X;
    xlogx_x=sum(xlogxx(:));
    clear xlogxx;
    % kl-minimization
    while dcost>=conv_crit*cost & iter<maxiter
        if mod(iter,100)==0
             disp(dline); disp(dheader); disp(dline);
        end
        pause(0.00001); %Enables to break algorithm by pushing "Control C".
        told=t1;
        iter=iter+1;
        cont=0;
        cost_old=cost;
        while cont==0
            sparse_C=0;
            for i=1:le
                if ~constFACT(i)
                    ind=1:le;
                    ind(i:end-1)=ind((i+1):end);
                    ind=ind(1:(end-1));
                    kr=FACT{ind(1)};
                    if minRAM
                        clear Xi;
                        Xi{i}=matrizicing(X,i);
                    end
                    for z=ind(2:end)
                        kr=krprod(FACT{z}, kr);           
                    end
                    F2=repmat(sum(kr,1),size(Xi{i},1),1);
                    if sum(lambda)==0
                        T=((Xi{i}./(FACT{i}*kr'+eps))*kr)./(F2+eps);
                        FACT{i}=FACT{i}.*T.^ny;
                    elseif lambda(i)==0
                        Wx=(Xi{i}./(FACT{i}*kr'+eps))*kr;
                        Wy=F2;                                
                        if normmeth==0
                           tx = sum(Wy.*FACT{i},1);
                           ty = sum(Wx.*FACT{i},1);
                           Wx = Wx + repmat(tx,[N(i),1]).*FACT{i};
                           Wy = Wy + repmat(ty,[N(i),1]).*FACT{i};
                           T=Wx./(Wy+eps);
                           FACT{i}=FACT{i}.*(T.^ny);
                           FACT{i}=FACT{i}.*repmat(1./(sqrt(sum(FACT{i}.^2,1))+eps),[size(FACT{i},1),1]); 
                        else
                           tx = sum(sum(Wy.*FACT{i},1));
                           ty = sum(sum(Wx.*FACT{i},1));
                           Wx = Wx + tx*FACT{i};
                           Wy = Wy + ty*FACT{i};
                           T=Wx./(Wy+eps);
                           FACT{i}=FACT{i}.*(T.^ny);
                           FACT{i}=FACT{i}/(sqrt(sum(FACT{i}(:).^2))+eps); 
                        end
                    else
                        T=((Xi{i}./(FACT{i}*kr'+eps))*kr)./(F2+lambda(i)+eps);
                        FACT{i}=FACT{i}.*T.^ny;
                        sparse_C=sparse_C+lambda(i)*sum(FACT{i}(:));
                    end
                    t=i;
                end
            end
            Xe=FACT{t}*kr';    
            cost=sum(sum(-Xi{t}.*log(FACT{i}*kr'+eps)+Xe))+xlogx_x+sparse_C;
            dcost=cost_old-cost;
            if dcost>0 & dcost<conv_crit*cost & ny~=1 %insure adaptive parameter is not responsible for convergence
                ny=1;
                cont=0;
            elseif dcost>0
                ny=alpha*ny;
                cont=1;
                FACTold=FACT;
            else
                cont=0;
                ny=ny/beta;    
                if ny<1 
                     ny=1;
                end  
                FACT=FACTold;
            end
        end
        t1=cputime;
        if rem(iter,5)==0
            cost1=norm((Xi{t}-Xe),'fro')^2;
            disp(sprintf('%12.0f | %12.4f | %12.4f | %12.4f | %12.4f | %12.4f',iter, (SST-cost1)/SST,cost,dcost, ny,t1-told));
        end
    end   
end


% sort factors according to their norm
sss=0;
for h=1:noc
    for k=1:le
        F{k}=FACT{k}(:,h);
    end
    oF=outerprod(F);
    sss=sss+oF;
    nrm(h)=norm(matrizicing(oF,1),'fro')^2;
end
[i,j]=sort(nrm);
j=flipud(j);
for k=1:le
    FACT{k}=FACT{k}(:,j);
end
ssse=norm(matrizicing(X-sss,1),'fro')^2;
varexpl=(SST-ssse)/SST;
if rem(iter,5)~=0
    disp(sprintf('%12.0f | %12.4f | %12.4f | %12.4f | %12.4f',iter, varexpl,cost,dcost, ny));
end


% -------------------------------------------------------------------------
% Parser for optional arguments
function var = mgetopt(opts, varname, default, varargin)
if isfield(opts, varname)
    var = getfield(opts, varname); 
else
    var = default;
end
for narg = 1:2:nargin-4
    cmd = varargin{narg};
    arg = varargin{narg+1};
    switch cmd
        case 'instrset',
            if ~any(strcmp(arg, var))
                fprintf(['Wrong argument %s = ''%s'' - ', ...
                    'Using default : %s = ''%s''\n'], ...
                    varname, var, varname, default);
                var = default;
            end
        otherwise,
            error('Wrong option: %s.', cmd);
    end
end


