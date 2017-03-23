function W=svdica(mode)

% svdica.m
%
% e.g. W=uica('s');
%
% This code extracts N independent components from M>=N mixtures.
%
% The data matrix is decomposed into K<=M principle components using SVD,
% and these PCs are used as input to ICA.
% In order to prevent loss of ICs in subspaces of low power PCs,
% we recommend setting K=M.
% A paper describing the method is available from: http://www.shef.ac.uk/~pc1jvs/ 
% (Porrill J and Stone JV, "Independent Components Analysis for Signal Separation
% and Dimension Reduction").
%
% ICA is implemented using the fminu matlab function.
%
% Performs spatial or temporal ICA, via SVD, on a block of synthetic images;
% datas or datat is used to generate the test images.
%
% Number of ICs == nic.
% Number of PCs used in ICA = neig.
%
% Operating mode is specified as a character argument:
% spatial 's', temporal 't' and spatiotemporal 'st'.
%
% Developed by John Porrill and Jim Stone (1997).
% Modified by Jim Ivins (1998).
% Documented by Jim Stone April 1998.
% Code corrected to extract any number of ICs by JVS.

global ncall hmin wmin pcs pct sval nr nc;

if(nargin < 1)
	fprintf(1, 'Specify spatial or temporal\n');
	return;
end

% SET RAND NUM SEEDS.
jrand_set_seed(999);

% Set globals to track minimum found by fminu
ncall = 0;	% counts calls to heval
hmin = 1e10;

% SET NUM EIG VECS USED AS INPUT TO ICA, AND NUM OF REQUIRED ICS.
neig = 4; 	% number of eigenvectors used for ICA.
nic = 4; % number of ICs to extract.

% Set default values:
if mode=='s' % Needs large num of pixels.
% W = nt*nt matrix.
nr = 32; 	% image rows	(32)
nc = 32; 	% image columns	(32)
nt = 256; 	% time steps = num images (use 200 for ICAt)
end;

if mode=='t' 
% ICA would use (nr*nc)x(nr*nc) unmixing matrix W.
% Needs large num of images (time steps)
% W = (nr*nc)^2 matrix.
nr = 16;
nc = 16;
nt = 256; % 1024;
end;

% makes time series from synthetic images: one time step per columns of mixt

if (mode == 'st')
	fprintf(1, 'Not implemented yet.\n');
	return;
elseif (mode == 's')
	mixt = datas(nr, nc, nt);
elseif (mode == 't')
	% ALTERED FROM DATAT TO DATAS COS CAN USE SINGLE
	% DATA SET FOR S AND T IF SET NUM ICS=2, OR IF
	% KEEP ICS INDEPENDENT IN TIME AND SPACE.
	mixt = datat(nr, nc, nt); % 1024(32x32) x 100 time steps
else
	fprintf(1, 'Specify spatial (s), temporal (t), or both (b)\n');
	return;
end

jsize(mixt,'mixtures');
% CLUDGE to ensure that nic<M directions have data.
% mixt=mixt+randn(size(mixt))*1e-12;

jsize(mixt,'mixt');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 	SVD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Force data to zero mean
mixt = stripmean(mixt, 'st'); % s, t, st

% SVD - each col of pcs is an image, each col of pct is a time course.
fprintf('Doing SVD ...');
[pcs, sval, pct] = svd(mixt, 0);
fprintf('... SVD done\n');

% Select number of eig vecs sufficient to account for 0.99 of data variance.
tot_sval = sum(sval(:));
evals = diag(sval);
num_evals = length(evals);
sub_tot = 0;
for i=1:num_evals
	sub_tot = sub_tot + evals(i);
	prop = sub_tot/tot_sval;
	if prop>=0.99 break; end;
end;


fprintf('Number of evecs required to account for 0.99 of data variance = %d\n',neig);
pcs = pcs(:, 1:neig);
pct = pct(:, 1:neig); 
sval = sval(1:neig, 1:neig);

fprintf('%d PCs account for %.3f of data variance\n',neig,sum(sval(:))/tot_sval);

jsize(pcs,'pcs');
jsize(pct,'pct');

% PLOT RESULTS OF PCA.

% For plotting eigvecs ...
nr_plots = floor(sqrt(neig));	% num plots in row.
nc_plots = floor(sqrt(neig));	% num plots in column.

% LIMIT NUMBER OF PLOTS.
if nr_plots>4 nr_plots=4; end;
if nc_plots>4 nc_plots=4; end;

% Note: pnshow displays positive as green-scale, negative as red-scale;
% gamma factor can be used to emphasise detail (help pnshow for details)

% PLOT SPATIAL PC == each col of pcs. 
plot_pc=0;
if plot_pc
jfig(1); clf;
jsize(pcs(:,1),'pcs(:,1)');
for k = 1:neig
	subplot(nr_plots, nc_plots, k);
	pnshow( reshape(pcs(:, k), nr, nc) );
	title( ['Eigen Image #', int2str(k)] );
	axis off; axis square
end


% PLOT TEMPORAL PC == EACH COL OF pct.
jfig(2); clf;
for k = 1:neig
	subplot(nr_plots, nc_plots, k);
	plot( pct(:, k) );
	title( ['Eigen Sequence #', int2str(k)] );
end

fprintf('Figures 1 and 2 are spatial and temporal eigenvectors\n');
end; % plot_pc

fprintf('svdica: neig = %d\nnic = %d\n',neig,nic);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% ICA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Specify number and type of ics to recover via a and b.

% Spatial and temporal example data have sin and cos ICs so use low kurtosis.

% For low kurtosis
a = ones(1,nic)'*1.5;
b = ones(1,nic)'*(-0.5);

% For high kurtosis.
% a = zeros(1,nic)';
% b = ones(1,nic)';

% Initialise weight matrix.
% W0 = eye(neig);
% W0 = eye(nic,neig)/10;
W0 = randn(nic,neig)/10;
jsize(W0,'W0');

% MAXMIMISE ENTROPY.
if (mode == 'st')
	;
elseif (mode == 's')
	W = hminu(pcs, neig, a, b, 'hplos_demo', W0); % spatial
elseif (mode == 't')
	W = hminu(pct, neig, a, b, 'hplot_demo', W0); % temporal
end

% W = reshape(wmin, nic, neig); % nic=required num ICs.

% FIND CORRESPONDING DUAL COMPONENT (COLUMN OF A=W^-1) FOR EACH IC.
if(mode == 'st')
	;
elseif(mode == 's')
	% ics are spatially indep images.
	ics = pcs*W'; 
	% dual ics are unconstrained temporal sequences.
	dict = pct*sval*pinv(W); % JVS inv-->pinv for non-square matrix.
	% jsize(dict,'dict');
	merror = max(max( abs(mixt-ics*dict') )) / length(mixt(:));
elseif(mode == 't')
	% ics are temporally indep sequences.
	ict = pct*W';
	% dual ics are unconstrained spatial images.
	dics = pcs*sval*pinv(W);
	% jsize(dics,'dics');
	merror = max(max( abs(mixt-dics*ict') )) / length(mixt(:));
end

% jsize(pcs,'pcs');jsize(pct,'pct');jsize(W','W_transpose'); jsize(sval,'sval');jsize(pinv(W),'inv(W)');

% WRONG FOR UICA BECAUSE NOT ALL COMPONENTS ARE RECOVERED!
% fprintf('Mean reconstruction error = %.3e\n',merror);
