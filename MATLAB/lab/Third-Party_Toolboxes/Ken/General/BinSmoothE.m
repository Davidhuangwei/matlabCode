% [m l u Bins MedX Resid] = BinSmoothE(x,y,func,Bins)
% splits x into bins, and calculates the a smooth of y in each bin.
% the smoothing function is given by func.  BinSmoothE also gives
% error estimates: confidence interval is y-l:y+u. func should return
% two arguments: the mean, and the confidence interval. This allows
% you to use poissfit, binofit, etc. Also try MedianConf, CircConf
%
% Bins may be a vector in which case the nth bin is all those points
% greater than or equal to x(n) but less than x(n+1), and the last
% one is all those >= x(end).  Or it may be a number in
% which case bins are assigned automatically so that each bin has
% that many points in it.
%
% optional output MedX gives median x value for each bin
% optional output Resid gives residuals for each point
%
% see also MeanSmooth, MedianSmooth, msline, bsline
% BinSmoothE, bseline.

function [m, l, u, Bins, MedX, Resid] = BinSmoothE(x,y,func,Bins)

if (length(Bins) == 1)
	PointsPerBin = Bins;
	sorted = sort(x);
	Bins = sorted(1:PointsPerBin:end);
end
nBins = length(Bins);

m = zeros(nBins,1);
PointsInBin = cell(nBins, 1);

for n=1:nBins
	if n<nBins
        PointsInBin{n} = find(x>=Bins(n) & x<Bins(n+1));
    else
        PointsInBin{nBins} = find(x>=Bins(nBins));
    end
    
    if ~isempty(PointsInBin{n})
		[Center Range] = feval(func, y(PointsInBin{n}));
        m(n) = Center;
        l(n) = Center-Range(1);
        u(n) = Range(2)-Center;
        MedX(n) = median(x(PointsInBin{n}));
    else
        m(n) = NaN;
        l(n) = NaN;
        u(n) = NaN;
        MedX(n) = NaN;
    end
end

% Calculate residuals
if nargout >=4
	Resid = zeros(size(x));
	for n=1:nBins
		Resid(PointsInBin{n}) = y(PointsInBin{n}) - m(n);
	end
end
