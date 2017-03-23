% Cloudze(N,l,p)
% 
% produces a NxN image with a exp(-(l*f)^p) amplitude spectrum

function out = Cloudze(N,l,p)

if (nargin<1) N = 512; end;
if (nargin<2) l = 0.1; end;
if (nargin<3) p = 1; end;

y = randn(N) + i*randn(N);

f1 = ([0:(N/2) , (N/2 - 1):-1:1]).^2;

f2 = repmat(f1, N, 1) + repmat(f1', 1, N);

f = sqrt(f2);

im = real(fft2(y.*exp(-(l*f).^p)));

top = max(im(:));
bot = min(im(:));

im = 1+floor((im-bot)/(top-bot)*255);

if nargout>=1
	out = im;
else
	image(im);
	colormap(sky(256));
	imwrite(im, sky(256), '/u5/b/ken/bitz/clouds.jpg', 'jpg')   
end