% [m Bins MedX Resid] = BinSmooth(x,y,func,Bins)
% splits x into bins, and calculates the a smooth of y in each bin.
% the smoothing function is given by func.
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

function [m, Bins, MedX, Resid] = BinSmooth(x,y,func,Bins)

if (length(Bins) == 1)
	PointsPerBin = Bins;
	sorted = sort(x);
	Bins = sorted(1:PointsPerBin:end);
end
nBins = length(Bins);

m = zeros(nBins,1);
%iq = zeros(nBins,1);
PointsInBin = cell(nBins, 1);

for n=1:nBins
	if n<nBins
        PointsInBin{n} = find(x>=Bins(n) & x<Bins(n+1));
    else
        PointsInBin{nBins} = find(x>=Bins(nBins));
    end
    
    if ~isempty(PointsInBin{n})
		m(n) = feval(func, y(PointsInBin{n}));
        MedX(n) = median(x(PointsInBin{n}));
    else
        m(n) = NaN;
        MedX(n) = NaN;
    end
end

% for n=1:nBins-1
% 	PointsInBin{n} = find(x>=Bins(n) & x<Bins(n+1));
% 	if ~isempty(PointsInBin{n})
% 		m(n) = feval(func, y(PointsInBin{n}));
% 	end
% end
% 
% % do last bin
% PointsInBin{nBins} = find(x>=Bins(nBins));
% if ~isempty(PointsInBin{nBins})
% 	m(nBins) = feval(func,y(PointsInBin{nBins}));
% 	iq(nBins) = iqr(y(PointsInBin{nBins}));
% end

% Calculate residuals
if nargout >=3
	Resid = zeros(size(x));
	for n=1:nBins
		Resid(PointsInBin{n}) = y(PointsInBin{n}) - m(n);
	end
end
