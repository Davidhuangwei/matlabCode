function hplot_demo(K, M, w, h, x)

% Name altered to demo cos are 2 versions in dirs.

% Temporal ICA
% Generates graphics and tracks minimum

global ncall nr nc
global hmin wmin
global pcs sval

% heval calls hplot every ndrw calls 
ndrw = 10;

ncall = ncall+1;

% remember minimum
if hmin > h
	wmin = w;
	hmin = h;
end

if ndrw == 1 | ncall == 1 | rem(ncall, ndrw) == 1
	fprintf('%6d | %12.6f %12.6f\n', ncall, hmin, h);
	W = reshape(wmin, K, size(x, 1));
	y = W*x; % unmix!

%	get and plot dual images
	jfig(3); %clf;
	dics = pcs*sval*pinv(W);
	for k = 1:K
		subplot(2, K/2, k);
		pnshow( reshape(dics(:, k), nr, nc) );
		title( ['Dual Image For TIC #', int2str(k)] );
		axis off; axis square
	end

%	plot temporal ICs
	jfig(4);
	for k = 1:K
		subplot(2, K/2, k);
		plot(y(k, :));
		title( ['Temporal IC #', int2str(k)] );
	end

	jfig(5);
	for k = 1:K
		subplot(2, K/2, k);
		hist(y(k, :), 50);
		title( ['Histogram For TIC #' int2str(k)] );
	end
end
