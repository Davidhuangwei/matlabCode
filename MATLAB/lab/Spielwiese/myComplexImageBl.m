% ComplexImage(C [,gamma]) or ComplexImage(X,Y,C [,gamma])
%
% does an hsv colormap of a complex array
% gamma is a power for the brightness - like on your monitor
function myComplexImageBl(varargin)

switch nargin
	case 1 
		AxesSpecified = 0;
		C = varargin{1};
		gamma = 1;
	case 2
		AxesSpecified = 0;
		C = varargin{1};
		gamma = varargin{2};		
	case 3
		AxesSpecified = 1;
		X = varargin{1};
		Y = varargin{2};
		C = varargin{3};
		gamma = 1;
	case 4
		AxesSpecified = 1;
		X = varargin{1};
		Y = varargin{2};
		C = varargin{3};
		gamma = varargin{4};
	otherwise	
		error('number of arguments needs to be 1 to 4');
end

Amp = abs(C);
AmpMin = min(Amp(:));
AmpMax = max(Amp(:));
Phase = angle(C);

Hsv = zeros([size(C) 1]);

%keyboard;

% Hsv(:,:,1) = (Phase+pi)/(2*pi); % old version - don't know why it added pi
Hsv(:,:,1) = mod(Phase/(2*pi), 1);
Hsv(:,:,2) = 1;

if abs(AmpMax - AmpMin) < 1e-5 * max(abs(AmpMax), abs(AmpMin));
	%Hsv(:,:,3) = 0.1;
	Hsv(:,:,3) = 1;
else
	Hsv(:,:,3) = ((Amp-AmpMin)/(AmpMax-AmpMin)).^gamma;
end

if (AxesSpecified)
	%image(X, Y, 1-hsv2rgb(Hsv));
	image(X, Y, hsv2rgb(Hsv));
else
	%image(1-hsv2rgb(Hsv));
	image(hsv2rgb(Hsv));
end

tit = sprintf('Amplitude range %f to %f', AmpMin, AmpMax);
title(tit)

