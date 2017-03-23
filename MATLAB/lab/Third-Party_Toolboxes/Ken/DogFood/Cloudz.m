% Cloudz(N,p,q, tint)
% 
% produces a NxN image with a f^-p amplitude spectrum
% then passed through x^q
%
% tint sets the tint from 0 (blue) to 1 (red)

function out = Cloudz(N,p,q, tint)

if (nargin<1) N = 512; end;
if (nargin<2) p = 1; end;
if (nargin<3) q = 1; end;
if (nargin<4) tint = 0; end;

y = randn(N) + i*randn(N);

f1 = ([0:(N/2) , (N/2 - 1):-1:1]).^2;

f2 = repmat(f1, N, 1) + repmat(f1', 1, N);

y2 = y./(eps + f2.^p);
y2(1,1) = 0;

im = real(fft2(y2));

im = (im - min(im(:))).^q;

top = max(im(:));
bot = min(im(:));

nColors = 1024;

im = 1+floor((im-bot)/(top-bot)*(nColors-1));

cmap = sky(nColors)*[1-tint 0 tint ; 0 1 0 ; tint 0 1-tint];

if nargout>=1
	out = im;
else
	image(im);
	colormap(cmap);
	imwrite(im, cmap, '/u5/b/ken/bitz/clouds.jpg', 'jpg')
end