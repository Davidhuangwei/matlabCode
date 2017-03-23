% This demo analyses the datasets described in 
% M. Mørup and M. N. Schmidt. Sparse non-negative matrix factor 2-D 
%   deconvolution. Technical University of Denmark, 2006.
%
% To start the demo run the script

clear opts;

% To speed up the demo only 50 iterations are included. If you want better
% estimated results simply increase the number below
opts.maxiter = 50;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Generate dataset with possible ambiquity')
[V, W,H, Tau, Phi, d]=generate_ambiguity_dataset();
h=figure;
plot_nmf2d_in_One_fig(W,H,Tau,Phi,V) % Plot the dataset including the real factors of W and H.
set(h,'name','True factors')


% Set parameters for SNMF2D
d = 2;
opts.costfcn = 'kl';    % Set the cost function used to be the Kulback-Leibler Divergence
opts.lambda=0;          % No sparsity
opts.Tau=Tau;           % Defines tau shifts
opts.Phi=Phi;           % Defines phi shifts
opts.plotfcn = @plot_nmf2d_in_One_fig;  % Plot temporary results with specified plotfunction

%Ambiguity Dataset - KL Analysis 
disp('Calculates SNMF2D model using KL-divergence minimization')
h=figure;
set(h,'name','Temporary estimated factors, KL-minimization')
[W,H]=SNMF2D(V,d,opts);
Rec=nmf2d_rec(W,H,Tau,Phi,1:d);  % Reconstruct dataset from the factors found.
plot_nmf2d_in_One_fig(W,H,Tau,Phi, Rec) % Plot the reconstructed dataset including the estimated factors of W and H.
set(h,'name','estimated factors, KL-minimization')
disp('Press a key to continue')
pause;

%Ambiguity dataset - LS Analysis 
opts.costfcn = 'ls';
disp('Calculates SNMF2D model using LS- minimization')
h=figure;
set(h,'name','Temporary estimated factors, LS-minimization')
[W,H]=SNMF2D(V,d,opts);
Rec=nmf2d_rec(W,H,Tau,Phi,1:d);  % Reconstruct dataset from the factors found.
plot_nmf2d_in_One_Fig(W,H,Tau,Phi, Rec) % Plot the reconstructed dataset including the estimated factors of W and H.
set(h,'name','LS-minimization')
disp('Press a key to continue')
pause;

%Ambiguity dataset - Sparse KL Analysis 
disp('KL-minimization with sparseness constraint using 1-norm penalty and allowing alignment of W and H')
opts.lambda=0.001;
opts.tau_align=round(size(W,3)/2);
opts.phi_align=round(size(H,3)/2);
opts.costfcn = 'kl';
disp('Calculates SNMF2D model')
h=figure;
set(h,'name','Temporary estimated factors, Sparse KL-minimization')
[W,H]=SNMF2D(V,d,opts);
Rec=nmf2d_rec(W,H,Tau,Phi,1:d);  % Reconstruct dataset from the factors found.
plot_nmf2d_in_One_fig(W,H,Tau,Phi, Rec) % Plot the reconstructed dataset including the estimated factors of W and H.
set(h,'name','estimated factors, KL-minimization using 1-norm penalty with lambdaH=0.001')
disp('Press a key to continue')
pause;


%Ambiguity dataset - Sparse LS Analysis
disp('LS-minimization with sparseness constraint using 1-norm penalty and allow alignment of W')
opts.lambda=1;
opts.costfcn = 'ls';
disp('Calculates SNMF2D model')
h=figure;
set(h,'name','Temporary estimated factors, Sparse KL-minimization')
[W,H]=SNMF2D(V,d,opts);
Rec=nmf2d_rec(W,H,Tau,Phi,1:d);  % Reconstruct dataset from the factors found.
plot_nmf2d_in_One_fig(W,H,Tau,Phi, Rec) % Plot the reconstructed dataset including the estimated factors of W and H.
set(h,'name','estimaged factors, LS-minimization using 1-norm penalty with lambdaH=0.01')
disp('Press a key to continue')
pause;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Generate new dataset with less ambiquity')
[V,W,H, Tau, Phi, d]=generate_dataset();
V = nmf2d_rec(W,H,Tau,Phi,1:d); 
figure;
plot_nmf2d_in_One_fig(W,H,Tau,Phi,V)%,'The real factors of the new dataset');


% dataset without ambiguity - KL Analysis
% Set parameters for SNMF2D
clear opts;
d = 2;
opts.maxiter = 50;
opts.costfcn = 'kl';
opts.lambda=0;
opts.Tau=Tau;
opts.Phi=Phi;
opts.plotfcn = @plot_nmf2d_in_One_fig;
disp('Calculates SNMF2D model using KL-divergence minimization')
h=figure;
set(h,'name','Temporary estimated factors, KL-minimization')
[W,H]=SNMF2D(V,d,opts);
Rec=nmf2d_rec(W,H,Tau,Phi,1:d);  % Reconstruct dataset from the factors found.
plot_nmf2d_in_One_fig(W,H,Tau,Phi, Rec) % Plot the reconstructed dataset including the estimated factors of W and H.
set(h,'name','estimated factors, KL-minimization Dataset 2')
disp('Press a key to continue')
pause;

% dataset without ambiguity - LS Analysis
% Set parameters for SNMF2D
opts.costfcn = 'ls';
disp('Calculates SNMF2D model using LS- minimization')
h=figure;
set(h,'name','Temporary estimated factors, LS-minimization')
[W,H]=SNMF2D(V,d,opts);
Rec=nmf2d_rec(W,H,Tau,Phi,1:d);  % Reconstruct dataset from the factors found.
plot_nmf2d_in_One_fig(W,H,Tau,Phi, Rec) % Plot the reconstructed dataset including the estimated factors of W and H.
set(h,'name','Estimated factors, LS-minimization dataset 2')
disp('End of demo')