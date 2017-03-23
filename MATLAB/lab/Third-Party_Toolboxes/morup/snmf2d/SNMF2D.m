function [W,H] = SNMF2D(V, d, varargin)
% SNMF2D: SPARSE NON-NEGATIVE MATRIX FACTOR 2-D DECONVOLUTION
%
% Authors:
%   Morten Mørup and Mikkel N. Schmidt 
%   Technical University of Denmark, 
%   Institute for Matematical Modelling
%
% Reference:
%   M. Mørup and M. N. Schmidt. Sparse non-negative matrix factor 2-D 
%   deconvolution. Technical University of Denmark, 2006.
% 
% Usage:
%   [W,H] = SNMF2D(V,d,[options])
%
% Input:
%   V                 M x N data matrix
%   d                 Number of factors
%   options
%     .Tau            Shifts of H (default 0)
%     .Phi            Shifts of W (default 0)
%     .costfcn        Cost function to optimize
%                       'ls': Least squares (default)
%                       'kl': Kullback Leibler
%     .W              Initial W, array of size M x d x length(Tau)
%     .H              Initial H, array of size d x N x length(Phi)
%     .tau_align      Align the geometric mean of the third dimension of
%                     W to the value tau_align. (Default [] giving no
%                     alignment)
%     .phi_align      Align the geometric mean of the third dimension of
%                     H to the value phi_align. (Default [] giving no
%                     alignment)
%     .const_WorH       0: Update both W and H (default)
%                       1: Update only H
%                       2: update only W
%     .lambda         Sparsity weight on H sparsity 
%                       (sparsity function used is the 1-norm)
%                        0: NMF2D optimization
%                       >0: SNMF2D optimization
%     .maxiter        Maximum number of iterations (default 100)
%     .conv_criteria  Function exits when cost/delta_cost exceeds this
%     .plotfcn        Function handle for plot function
%                       i.e. @plot_nmf2d
%     .plotiter       Plot only every i'th iteration
%     .accel          Wild driver accelleration parameter (default 1.3)
%     .displaylevel   Level of display: [off | final | iter]
% 
% Output:
%   W                 M x d x length(Tau) array
%   H                 d x N x length(Phi) array



% -------------------------------------------------------------------------
% Parse input arguments
if nargin>=3, opts = varargin{1}; else opts = struct; end
costfcn = mgetopt(opts, 'costfcn', 'ls', 'instrset', {'ls','kl'});
Tau=mgetopt(opts,'Tau',0);
Phi=mgetopt(opts,'Phi',0);
const_WorH=mgetopt(opts,'const_WorH',0);
tau_align=mgetopt(opts,'tau_align',[]);
phi_align=mgetopt(opts,'phi_align',[]);
W = mgetopt(opts, 'W', rand(size(V,1),d,length(Tau)));
H = mgetopt(opts, 'H', rand(d,size(V,2),length(Phi)));
W = normalizeW(W);
nuH = mgetopt(opts, 'nuH', 1);
nuW = mgetopt(opts, 'nuW', 1);
lambda = mgetopt(opts, 'lambda', 0);
maxiter = mgetopt(opts, 'maxiter', 100);
conv_criteria = mgetopt(opts, 'conv_criteria', 1e-6);
accel = mgetopt(opts, 'accel', 1.3);
plotfcn = mgetopt(opts, 'plotfcn', []);
plotiter = mgetopt(opts, 'plotiter', 1);
displaylevel = mgetopt(opts, 'displaylevel', 'iter', 'instrset', ...
    {'off','iter','final'});



% -------------------------------------------------------------------------
% Initialization
sst = sum(sum((V-mean(mean(V(:)))).^2));
Rec = nmf2d_rec(W,H,Tau,Phi,1:d); 
switch costfcn
    case 'ls'
        sse = norm(V-Rec,'fro')^2;
        cost_old = .5*sse + lambda*(sum(abs(H(:))));
    case 'kl'
        ckl = sum(sum(V.*log((V+eps)./(Rec+eps))-V+Rec));
        cost_old = ckl + lambda*(sum(abs(H(:))));
end
delta_cost = 1;
iter = 0;
keepgoing = 1;



% -------------------------------------------------------------------------
% Display information
dheader = sprintf('%12s | %12s | %12s | %12s | %12s | %12s','Iteration','Expl. var.','NuW','NuH','Cost func.','Delta costf.');
dline = sprintf('-------------+--------------+--------------+--------------+--------------+--------------');
if any(strcmp(displaylevel, {'final','iter'}))
    disp('Sparse Non-negative Matrix Factor 2-D Deconvolution');
    disp(['To stop algorithm press ctrl-C'])
    disp('');
end



% -------------------------------------------------------------------------
% Optimization loop
while keepgoing
    pause(0.001);
    
    if mod(iter,10)==0
        if any(strcmp(displaylevel, {'iter'}))
            disp(dline); disp(dheader); disp(dline);
        end
    end
    
    % Call plotfunction if specified
    if ~isempty(plotfcn) && mod(iter,plotiter)==0
        plotfcn(W,H,Tau,Phi, Rec); 
    end

    % Align the shifts if specified
    shift1=0;
    shift2=0;
    if ~isempty(tau_align) 
        [W,H, shift1]=align_tau(W,H,tau_align);
    end
    if ~isempty(phi_align)
        [W,H, shift2]=align_phi(W,H,phi_align);
    end
    if shift1 | shift2
        if lambda==0
            [W,H] = scaleWH(W,H);
        else
            W = normalizeW(W);
        end
        Rec=nmf2d_rec(W,H,Tau,Phi,1:d); 
        switch costfcn
            case 'ls'
                cost_old=0.5*norm(V-Rec,'fro')^2+lambda*sum(H(:));
            case 'kl'
                cost_old=sum(sum(V.*log((V+eps)./(Rec+eps))-V+Rec))+lambda*sum(H(:));
        end
    end
  
    % Update W and H
    switch costfcn
        case 'ls'
            if lambda==0    %NMF2D optimization
            [W,H,nuH,nuW,cost,sse,Rec] = ...
               ls_update(V,W,H,Tau,Phi,d,nuH,nuW,cost_old,accel,lambda,Rec,const_WorH);
            else            %SNMF2D optimization
            [W,H,nuH,nuW,cost,sse,Rec] = ...
                sls_update(V,W,H,Tau,Phi,d,nuH,nuW,cost_old,accel,lambda,Rec,const_WorH);
            end
        case 'kl'
            if lambda==0    %NMF2D optimization
            [W,H,nuH,nuW,cost,sse,Rec] = ...
                kl_update(V,W,H,Tau,Phi,d,nuH,nuW,cost_old,accel,lambda,Rec,const_WorH);
            else            %SNMF2D optimization
            [W,H,nuH,nuW,cost,sse,Rec] = ...
                skl_update(V,W,H,Tau,Phi,d,nuH,nuW,cost_old,accel,lambda,Rec,const_WorH);
            end
    end

    delta_cost = cost_old - cost;
    cost_old=cost;
    iter=iter+1;

    % Display information
    if any(strcmp(displaylevel, {'iter'}))
        disp(sprintf('%12.0f | %12.4f | %12.6f | %12.6f |  %11.2f | %11.2f', ...
            iter,(sst-sse)/sst,nuW/accel,nuH/accel,cost,delta_cost));
    end
    
    % Check if we should stop
    if delta_cost<cost*conv_criteria 
        % Small improvement with small step-size
        if nuH<=accel & nuW<=accel
            if any(strcmp(displaylevel, {'iter','final'}))
                disp('SNMF2D has converged');
            end
            keepgoing = 0;
        % Small improvement - maybe because of too large step-size?
        else
            nuH = 1; nuW = 1;
        end
    end
    % Reached maximum number of iterations
    if iter>=maxiter
        if any(strcmp(displaylevel, {'iter','final'}))
            disp('Maximum number of iterations reached');
        end
        keepgoing=0; 
    end
end

% -------------------------------------------------------------------------
% Least squares update function
function [W,H,nuH,nuW,cost,sse,Rec] = ...
    ls_update(V,W,H,Tau,Phi,d,nuH,nuW,cost_old,accel,lambda,Rec,const_WorH)

H_old=H;
W_old=W;


% Update H
if const_WorH~=2
    Hx = zeros(size(H));
    Hy = zeros(size(H));
    for tau = 1:length(Tau)   
        for phi = 1:length(Phi)
            Hx(:, 1:end-Tau(tau), phi) = Hx(:, 1:end-Tau(tau), phi) + ...
                W(1:end-Phi(phi), :, tau)'*V(1+Phi(phi):end,1+Tau(tau):end);
            Hy(:,1:end-Tau(tau),phi) = Hy(:,1:end-Tau(tau),phi) + ...
                W(1:end-Phi(phi), :, tau)'*Rec(1+Phi(phi):end,1+Tau(tau):end);          
        end
    end
    grad = Hx./(Hy+eps);
    while 1
        H = H_old.*(grad.^nuH);
        Rec = nmf2d_rec(W,H,Tau,Phi,1:d); 
        sse = norm(V-Rec,'fro')^2;
        cost = .5*sse;
        if cost>cost_old, nuH = max(nuH/2,1);
        else nuH = nuH*accel; break; end
        pause(0);
    end
    cost_old = cost;
end

% Update W
if const_WorH~=1
    Wx = zeros(size(W));
    Wy = zeros(size(W));
    for phi = 1:length(Phi)
        for tau = 1:length(Tau)   
            Wx(1:end-Phi(phi), : , tau) = Wx(1:end-Phi(phi), : , tau) + ...
                V(1+Phi(phi):end, 1+Tau(tau):end)*H(:, 1:end-Tau(tau), phi)';
            Wy(1:end-Phi(phi), : , tau) = Wy(1:end-Phi(phi), : , tau) + ...
                Rec(1+Phi(phi):end, 1+Tau(tau):end)*H(:, 1:end-Tau(tau), phi)';     
        end
    end
    grad = Wx./(Wy+eps);
    while 1
        W=W_old.*(grad.^nuW);
        Rec = nmf2d_rec(W,H,Tau,Phi,1:d); 
        sse = norm(V-Rec,'fro')^2;
        cost = .5*sse+lambda*sum(H(:));
        if cost>cost_old, nuW = max(nuW/2,1);
        else nuW = nuW*accel; break; end
        pause(0);
    end
end
[W,H] = scaleWH(W,H);


% -------------------------------------------------------------------------
% Sparse Least squares update function
function [W,H,nuH,nuW,cost,sse,Rec] = ...
    sls_update(V,W,H,Tau,Phi,d,nuH,nuW,cost_old,accel,lambda,Rec,const_WorH)

H_old=H;
W_old=W;

% Update H
if const_WorH~=2
    Hx = zeros(size(H));
    Hy = zeros(size(H));
    for tau = 1:length(Tau)   
        for phi = 1:length(Phi)
            Hx(:, 1:end-Tau(tau), phi) = Hx(:, 1:end-Tau(tau), phi) + ...
                W(1:end-Phi(phi), :, tau)'*V(1+Phi(phi):end,1+Tau(tau):end);
            Hy(:,1:end-Tau(tau),phi) = Hy(:,1:end-Tau(tau),phi) + ...
                W(1:end-Phi(phi), :, tau)'*Rec(1+Phi(phi):end,1+Tau(tau):end);          
        end
    end
    grad = Hx./(Hy+eps+lambda);
    while 1
        H = H_old.*(grad.^nuH);
        Rec = nmf2d_rec(W,H,Tau,Phi,1:d); 
        sse = norm(V-Rec,'fro')^2;
        cost = .5*sse+lambda*sum(H(:));
        if cost>cost_old, nuH = max(nuH/2,1);
        else nuH = nuH*accel; break; end
        pause(0);
    end
    cost_old = cost;
end

% Update W
if const_WorH~=1
    Wx = zeros(size(W));
    Wy = zeros(size(W));
    for phi = 1:length(Phi)
        for tau = 1:length(Tau)   
            Wx(1:end-Phi(phi), : , tau) = Wx(1:end-Phi(phi), : , tau) + ...
                V(1+Phi(phi):end, 1+Tau(tau):end)*H(:, 1:end-Tau(tau), phi)';
            Wy(1:end-Phi(phi), : , tau) = Wy(1:end-Phi(phi), : , tau) + ...
                Rec(1+Phi(phi):end, 1+Tau(tau):end)*H(:, 1:end-Tau(tau), phi)';     
        end
    end
    tx = sum(sum(Wy.*W,1),3);
    ty = sum(sum(Wx.*W,1),3);
    Wx = Wx + repmat(tx,[size(W,1),1,size(W,3)]).*W;
    Wy = Wy + repmat(ty,[size(W,1),1,size(W,3)]).*W;

    grad = Wx./(Wy+eps);
    while 1
        W = normalizeW(W_old.*(grad.^nuW));
        Rec = nmf2d_rec(W,H,Tau,Phi,1:d); 
        sse = norm(V-Rec,'fro')^2;
        cost = .5*sse+lambda*sum(H(:));
        if cost>cost_old, nuW = max(nuW/2,1);
        else nuW = nuW*accel; break; end
        pause(0);
    end
end

% -------------------------------------------------------------------------
% Kullback Leibler update function
function [W,H,nuH,nuW,cost,sse,Rec] = ...
    kl_update(V,W,H,Tau,Phi,d,nuH,nuW,cost_old,accel,lambda,Rec,const_WorH)

H_old=H;
W_old=W;
VR = V./(Rec+eps);
O = ones(size(V));

% Update H
if const_WorH~=2
    Hx = zeros(size(H));
    Hy = zeros(size(H));
    for tau = 1:length(Tau)   
        for phi = 1:length(Phi)
            Hx(:, 1:end-Tau(tau), phi) = Hx(:, 1:end-Tau(tau), phi) + ...
                W(1:end-Phi(phi), :, tau)'*VR(1+Phi(phi):end,1+Tau(tau):end);
            Hy(:,1:end-Tau(tau),phi) = Hy(:,1:end-Tau(tau),phi) + ...
                W(1:end-Phi(phi), :, tau)'*O(1+Phi(phi):end,1+Tau(tau):end);          
        end
    end
    grad = Hx./(Hy+eps);
    while 1
        H = H_old.*(grad.^nuH);
        Rec = nmf2d_rec(W,H,Tau,Phi,1:d); 
        cost = sum(sum(V.*log((V+eps)./(Rec+eps))-V+Rec));
        if cost>cost_old, nuH = max(nuH/2,1);
        else nuH = nuH*accel; break; end
        pause(0);
    end
    cost_old = cost;
end

% Update W
if const_WorH~=1
    VR = V./(Rec+eps);
    Wx = zeros(size(W));
    Wy = zeros(size(W));
    for phi = 1:length(Phi)
        for tau = 1:length(Tau)   
            Wx(1:end-Phi(phi), : , tau) = Wx(1:end-Phi(phi), : , tau) + ...
                VR(1+Phi(phi):end, 1+Tau(tau):end)*H(:, 1:end-Tau(tau), phi)';
            Wy(1:end-Phi(phi), : , tau) = Wy(1:end-Phi(phi), : , tau) + ...
                O(1+Phi(phi):end, 1+Tau(tau):end)*H(:, 1:end-Tau(tau), phi)';     
        end
    end
    grad = Wx./(Wy+eps);
    while 1
        W=W_old.*(grad.^nuW);
        Rec = nmf2d_rec(W,H,Tau,Phi,1:d); 
        cost = sum(sum(V.*log((V+eps)./(Rec+eps))-V+Rec));
        if cost>cost_old, nuW = max(nuW/2,1);
        else nuW = nuW*accel; break; end
        pause(0);
    end
end
sse = norm(V-Rec,'fro')^2;
[W,H] = scaleWH(W,H);

% -------------------------------------------------------------------------
% Sparse Kullback Leibler update function
function [W,H,nuH,nuW,cost,sse,Rec] = ...
    skl_update(V,W,H,Tau,Phi,d,nuH,nuW,cost_old,accel,lambda,Rec,const_WorH)

H_old=H;
W_old=W;
O = ones(size(V));

% Update H
if const_WorH~=2
    VR = V./(Rec+eps);
    Hx = zeros(size(H));
    Hy = zeros(size(H));
    for tau = 1:length(Tau)   
        for phi = 1:length(Phi)
            Hx(:, 1:end-Tau(tau), phi) = Hx(:, 1:end-Tau(tau), phi) + ...
                W(1:end-Phi(phi), :, tau)'*VR(1+Phi(phi):end,1+Tau(tau):end);
            Hy(:,1:end-Tau(tau),phi) = Hy(:,1:end-Tau(tau),phi) + ...
                W(1:end-Phi(phi), :, tau)'*O(1+Phi(phi):end,1+Tau(tau):end);          
        end
    end
    grad = Hx./(Hy+eps+lambda);
    while 1
        H = H_old.*(grad.^nuH);
        Rec = nmf2d_rec(W,H,Tau,Phi,1:d); 
        ckl = sum(sum(V.*log((V+eps)./(Rec+eps))-V+Rec));
        cost = ckl + lambda*sum(H(:));
        if cost>cost_old, nuH = max(nuH/2,1);
        else nuH = nuH*accel; break; end
        pause(0);
    end
    cost_old = cost;
end

% Update W
if const_WorH~=1
    VR = V./(Rec+eps);
    Wx = zeros(size(W));
    Wy = zeros(size(W));
    for phi = 1:length(Phi)
        for tau = 1:length(Tau)   
            Wx(1:end-Phi(phi), : , tau) = Wx(1:end-Phi(phi), : , tau) + ...
                VR(1+Phi(phi):end, 1+Tau(tau):end)*H(:, 1:end-Tau(tau), phi)';
            Wy(1:end-Phi(phi), : , tau) = Wy(1:end-Phi(phi), : , tau) + ...
                O(1+Phi(phi):end, 1+Tau(tau):end)*H(:, 1:end-Tau(tau), phi)';     
        end
    end
    tx = sum(sum(Wy.*W,1),3);
    ty = sum(sum(Wx.*W,1),3);
    Wx = Wx + repmat(tx,[size(W,1),1,size(W,3)]).*W;
    Wy = Wy + repmat(ty,[size(W,1),1,size(W,3)]).*W;

    grad = Wx./(Wy+eps);
    while 1
        W = normalizeW(W_old.*(grad.^nuW));
        Rec = nmf2d_rec(W,H,Tau,Phi,1:d); 
        ckl = sum(sum(V.*log((V+eps)./(Rec+eps))-V+Rec));
        cost = ckl + lambda*sum(H(:));
        if cost>cost_old, nuW = max(nuW/2,1);
        else nuW = nuW*accel; break; end
        pause(0);
    end
end
sse = norm(V-Rec,'fro')^2;


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


% -------------------------------------------------------------------------
% Normalize W
function W = normalizeW(W)
Q(1,:,1) = sqrt(sum(sum(W.^2,1),3));
W = W./repmat(Q+eps,[size(W,1),1,size(W,3)]);


% -------------------------------------------------------------------------
% Scale W and H to ensure W and H keep within reasonable value range
function [W,H] = scaleWH(W,H)
Q(1,:,1) = sqrt(sum(sum(W.^2,1),3));
W = W./repmat(Q+eps,[size(W,1),1,size(W,3)]);
H=H.*repmat(Q',[1, size(H,2) size(H,3)]);
