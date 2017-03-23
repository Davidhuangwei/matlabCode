% PointCorrel(T1, T2, BinSize, HalfBins)
%
% Plots a cross-correlogram of 2 series
% The output has 2*HalfBins+1 bins

function PointCorrel(T1, T2, BinSize, HalfBins)

% Make T1 and T2 into column vectors
T1 = T1(:);
T2 = T2(:);
Size1 = size(T1, 1);
Size2 = size(T2, 1);

% HalfSize is the size of half the histogram

HalfSize = BinSize*HalfBins;
Histo = zeros(2*HalfBins + 1, 1);

% Sp1 is center point, Sp2 is secondary point
% t1 is time of Sp1
% RangeStart and RangeEnd give the range between
% within histo size of Sp1.

RangeStart = 1;
RangeEnd = 1;

for Sp1 = 1:Size1

	t1 = T1(Sp1);
	
	% Update range
	
	while(RangeStart<Size2 & T2(RangeStart)<t1-HalfSize)
		RangeStart = RangeStart+1;
	end;
	
	while(RangeEnd<Size2 & T2(RangeEnd+1)<t1+HalfSize)
		RangeEnd = RangeEnd+1;
	end;
	
	% Add stuff to Histo
	Times = (T2(RangeStart:RangeEnd) - t1);
	Bins = HalfBins + 1 + round(Times/BinSize);
	Histo(Bins) = Histo(Bins) + 1;
end;	

Histo(HalfBins+1) = 0;

bar(-HalfBins:HalfBins, Histo);
	