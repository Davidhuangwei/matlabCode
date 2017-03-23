% y = FilterOnACircle(b, x)
%
% filters x zero phase with circular boundary conditions
%
% see also Filt0


function y = FilterOnACircle(b, x)

if size(x,1) == 1
	x = x(:);
    flip = 1;
else
    flip = 0;
end

n = size(x,1);

if mod(length(b),2)~=1
	error('filter order should be odd');
end

shift = (length(b)-1)/2;

[y0 z] = filter(b,1,x);

y = [y0(shift+1:n,:) ; z(1:shift,:)];
y(1:shift,:) = y(1:shift,:) + z(shift+1:end,:);
y(n-shift+1:n,:) = y(n-shift+1:n,:) + y0(1:shift,:);
% keyboard

if flip
    y = y.';
end