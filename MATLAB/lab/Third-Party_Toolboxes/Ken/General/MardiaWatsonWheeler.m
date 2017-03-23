% p = MardiaWatsonWheeler(th1, th2)
%
% Performs a Mardia-Watson-Wheeler test to see if two sets of phase angles have
% the same means.  See "100 statistical tests" by Gopal K. Kanji, test 99.

function p = MardiaWatsonWheeler(th1, th2)

th1 = mod(th1, 2*pi);
th2 = mod(th2, 2*pi);

unsorted = [th1(:) ; th2(:)];
gp = [ones(length(th1),1) ; 2*ones(length(th2),1)];

[sorted index] = sort(unsorted);

if any(diff(sorted)==0)
	warning(sprintf('Data should not contain ties.  There are %d\nCorrected by small random noise', sum(diff(sorted)==0)));
	unsorted = unsorted + 1e-7*rand(size(unsorted));
	[sorted index] = sort(unsorted);
end

N = length(sorted);
n = length(th1);
m = length(th2);

x = exp(2*pi*i*(1:N)/N);

x1 = x(find(gp(index)==1));

B = abs(sum(x1)).^2;

if N>17
	chi2 = 2*(N-1)*B/(n*m);
	p = 1-chi2cdf(chi2, 2);
else
	warning('N not large enough')
	p = 1;
end

