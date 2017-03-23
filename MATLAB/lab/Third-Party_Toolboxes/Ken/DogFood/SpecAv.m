% Spec = SpecAv(x)
%
% Quick and dirty function to compute average spectrum of
% a load of traces.
% x is a matrix, with time down the columns, and trace number up the sides

function Spec = SpecAv(x)

f = fft(x);
Spec = mean(abs(f).^2, 2);

nSamples = size(x, 1);
Spec = Spec(1:ceil(nSamples/2), :);
