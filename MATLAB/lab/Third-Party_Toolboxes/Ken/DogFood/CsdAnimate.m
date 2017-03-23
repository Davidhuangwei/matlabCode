% CsdAnimate(Csd, f)
%
% does an animated color square plot of Csd as a function of frequency

function CsdAnimate(Csd, f)

nFreqs = length(f);

for i=1:nFreqs
	ComplexImage(squeeze(Csd(i,:,:)));
	colorbar
	fprintf('Freq = %f\n', f(i));
	pause;
end