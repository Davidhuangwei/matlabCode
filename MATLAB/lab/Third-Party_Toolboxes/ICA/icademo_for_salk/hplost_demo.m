function [ys, yt] = hplost_demo(K, M, w, h, x, override)

% Name altered to demo cos are 2 versions in dirs.

% x == pcs or U.

% Spatial ICA
% Generates graphics and tracks minimum

global ncall nr nc;
global hmin wmin;
global pct sval;

if nargin==5 override=0; end;

% heval calls hplos every ndrw calls 
ndrw = 10;

ncall = ncall+1;

% remember minimum
if hmin > h
	wmin = w;
	hmin = h;
end

Wt = reshape(wmin, K, size(x, 1));
Ws=Wt';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if override==1 | ndrw == 1 | ncall == 1 | rem(ncall, ndrw) == 1
	fprintf('%6d | %12.6f %12.6f\n', ncall, hmin, h);
	y = Ws*x; % unmix!
	ys = y; 
%	plot spatial IC's
	jfig(3);
	for k = 1:K
		subplot(2, K/2, k);
		pnshow( reshape(y(k, :), nr, nc) );
		title( ['Spatial IC #', int2str(k)] );
		axis off; axis square; 
	end

%	get and plot dual time sequence
	jfig(4);
	% dict = pct*sval*Wt; % JVS inv-->pinv 18/4/98
	dict = pct*Wt;
	yt=dict; 
	for k = 1:K
		subplot(2, K/2, k);
		plot( dict(:, k) );
		title( ['Dual Time Sequence For SIC #', int2str(k)] );
	end

	jfig(5);
	for k = 1:K
		subplot(2, K/2, k);
		hist(y(k, :), 50);
		title( ['Histogram For SIC #' int2str(k)] );
	end
end
