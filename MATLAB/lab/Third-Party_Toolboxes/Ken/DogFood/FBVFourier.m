% g = FBVFourier(f)
% x is a 1d array of dimension 2^n, which is interpreted as a function
% of a binary vector.  This function does a "fourier transform" on x
% i.e. g(v) = Sum_x (-1)^(v.x) f(x).
%
% This is what underlies ANOVA and log-linear models

function g = FBVFourier(f)

f = f(:);
l = length(f);
n = log2(l);

if n~=round(n)
	error('dimension of input variable must be a power of 2');
end

% Make fourier matrix

ind = 0:(l-1);
xmat = repmat(ind, l, 1);
ymat = repmat(ind', 1, l);

b = bitand(xmat, ymat);

% now all we have to do is count bits ...

bn = reshape(sum(dec2bin(b(:))-'0', 2), [l l]);

fMat = (-1).^bn;

g = reshape(fMat*f, 2*ones(1,n));