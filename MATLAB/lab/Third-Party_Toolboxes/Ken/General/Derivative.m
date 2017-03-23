% Out = Derivative(In, Smooth)
%
% computes the smoothed derivative of a time series
% by convolving with a hanning window and [-1 1].
% Input is padded with top and bottom values to reduce edge effects
%
% If In is a matrix, it works down the columns
% Smooth is hanning window width, which should be EVEN (default 16)

function Out = Derivative(In, Smooth)

if nargin<2
	Smooth = 8;
end

if size(In, 1) == 1	
	In = In(:);
end

Filter = conv(Shanning(Smooth), [1 -1])/sum(Shanning(Smooth));

% pad top and bottom of input array to reduce edge effects

TopPad = repmat(In(1,:), Smooth, 1);
BottomPad = repmat(In(end,:), Smooth, 1);

Padded = [TopPad ; In ; BottomPad];

Filtered = conv2(Filter, 1, Padded, 's');

Out = Filtered(Smooth+1:Smooth+size(In,1),:);