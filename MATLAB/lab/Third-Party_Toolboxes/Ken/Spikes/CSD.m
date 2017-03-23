function Out = CSD(In, color)
% performs a current source density analysis on a set of traces
% In is a nSamples x nChannels matrix
%
% Out returns the CSD - if no output then it makes a plot
% usage: Out = CSD(In, color)

[nSamples nChannels] = size(In);

In = In - mean(In(:));

D2 = diff(In,2,2);

if (nargout >=1)
	Out = D2;
else
	Spacing1 = max(In(:)) - min(In(:));
	Spacing2 = max(D2(:)) - min(D2(:));
	Spacing = max(Spacing1, Spacing2)*1.1;
	
%	Spacing = 5000;
	
	h = ishold;
	plot(1:nSamples, In + repmat(1:nChannels, nSamples, 1)*Spacing, color);
	hold on
	plot(nSamples*1.1 + (1:nSamples), D2 + repmat(2:nChannels-1, nSamples, 1)*Spacing, color);
	plot(nSamples*1.1 + (1:nSamples), repmat(2:nChannels-1, nSamples, 1)*Spacing, 'g');
	if (h==0) hold off; end;
end;
	