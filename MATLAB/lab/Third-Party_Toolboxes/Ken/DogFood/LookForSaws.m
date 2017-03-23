% LookForSaws(x, Width)
%
% tests to look for sawtooth-style asymmetry in a time series by
% convolving with a _- function and see if there is more time
% plus than minus.
%
% Width is width of the _- function.

function LookForSaws(x, Widths)

for i=1:length(Widths)

	Width = Widths(i);
	Filt = [-ones(1,Width), ones(1,Width)];

	Conved = conv(Filt, x);
	Conved = Conved(Width:length(Conved)-Width);

	subplot(3,1,1)
	hist(Conved, 100);

%	fprintf('median %f mean %f signtest %f\n', median(Conved), mean(Conved) ...
%		, signtest(Conved, 0));
%

	mu(i) = mean(Conved);
	med(i) = median(Conved);
	p(i) = signtest(Conved-mu(i),0);
	fprintf('Width %f mean %f median %f signtest %f\n', Width, mu(i), med(i), p(i));

end

subplot(3,1,2)
plot(Widths, med-mu, Widths, 0, 'r--');

subplot(3,1,3)
plot(Widths, p, Widths, 0.05, 'r--');