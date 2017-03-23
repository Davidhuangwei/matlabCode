function hplos_demo(K, M, w, h, x)

% Name altered to demo cos are 2 versions in dirs.

% Spatial ICA
% Generates graphics and tracks minimum

global ncall nr nc
global hmin wmin
global pct sval

% heval calls hplos every ndrw calls 
ndrw = 10;

ncall = ncall+1;

% remember minimum
if hmin > h
	wmin = w;
	hmin = h;
end

% return;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ndrw == 1 | ncall == 1 | rem(ncall, ndrw) == 1
	fprintf('%6d | %12.6f %12.6f\n', ncall, hmin, h);
	W = reshape(wmin, K, size(x, 1));
	y = W*x; % unmix!

%	plot spatial IC's
	figure(3);
	for k = 1:K
		subplot(2, K/2, k);
		pnshow( reshape(y(k, :), nr, nc) );
		title( ['Spatial IC #', int2str(k)] );
		axis off; axis square
	end

%	get and plot dual time sequence
	figure(4);
	dict = pct*sval*pinv(W); % JVS inv-->pinv 18/4/98
	for k = 1:K
		subplot(2, K/2, k);
		plot( dict(:, k) );
		title( ['Dual Time Sequence For SIC #', int2str(k)] );
	end

	figure(5);
	for k = 1:K
		subplot(2, K/2, k);
		hist(y(k, :), 50);
		title( ['Histogram For SIC #' int2str(k)] );
	end
end
