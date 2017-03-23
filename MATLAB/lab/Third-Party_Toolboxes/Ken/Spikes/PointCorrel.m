% PointCorrel(T1, T2, BinSize, HalfBins, isauto, SampleRate, Normalization)
%
% Plots a cross-correlogram of 2 series
% The output has 2*HalfBins+1 bins
%
% Input time series may be in any units and don't need to be sorted
% BinSize gives the size of a bin in input units
% if isauto is set, the central bin will be zeroed
% SampleRate is for y scaling only, and gives the conversion between input units and Hz
% Normalization indicates the type of y-axis normalization to be used.  
% 'count' indicates that the y axis should show the raw spike count in each bin.
% 'hz' will normalize to give the conditional intensity of cell 2 given that cell 1 fired a spike (default)
% 'hz2' will give the joint intensity, measured in hz^2.
% 'scale' will scale by both firing rates so the asymptotic value is 1
%
% [Out t] = PointCorrel(...) will return 2 arguments: the height of the correlogram
% and the x axis label.

function [Out, t] = PointCorrel(T1, T2, BinSize, HalfBins, isauto, SampleRate, Normalization);

if (nargin<7) Normalization = 'hz'; end;

% Make T1 and T2 into column vectors, and sort them
T1 = sort(T1(:));
T2 = sort(T2(:));
Size1 = size(T1, 1);
Size2 = size(T2, 1);

% HalfSize is the size of half the histogram

HalfSize = BinSize*HalfBins;
nBins = 2*HalfBins + 1;
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

  % RangeStart becomes first spike in train 2 that is no more
  % than HalfSize before current spike
  while(RangeStart<Size2 & T2(RangeStart)<t1-HalfSize)
    RangeStart = RangeStart+1;
  end;
  
  % RangeEnd becomes last spike in train 2 that is no more
  % than HalfSize after current spike
  while(RangeEnd<Size2 & T2(RangeEnd+1)<t1+HalfSize)
    RangeEnd = RangeEnd+1;
  end;
  
  if (RangeStart==RangeEnd & abs(T2(RangeEnd)-T1(Sp1))>=HalfSize)
    % do nothing
  else 	      
    % Add stuff to Histo

    Times = (T2(RangeStart:RangeEnd) - t1);
	
    Bins = HalfBins + 1 + round(Times/BinSize);

    % Its possible that more than one spike falls in a particular
    % bin - so we need to keep count of how many spikes are in which
    % bins
	PartialHisto = hist(Bins, 1:nBins);
			
    Histo = Histo + PartialHisto';
  end
end;	

if isauto
  Histo(HalfBins+1) = 0;
end

% scale y axis
Trange = max(T1(end), T2(end)) - min(T1(1), T2(1)); % total time
switch Normalization
	case 'hz'
		Histo = Histo * SampleRate / (BinSize * length(T1));
		AxisUnit = '(Hz)';
	case 'hz2'
		Histo = Histo *SampleRate * SampleRate / (Trange*BinSize);
		AxisUnit = '(Hz^2)';
	case 'count';
		AxisUnit = '(Spikes)';
	case 'scale'
		Histo = Histo * Trange / (BinSize * length(T1) * length(T2));
		AxisUnit = '(Scaled)';
	otherwise
		warning(['Unknown Normalization method ', Normalization]);
end;

if (nargout <1)

	% plot graph
	bar(1000*(-HalfBins:HalfBins)*BinSize/SampleRate, Histo);
	xlabel('ms');

	% label y axis
	if isauto
		ylabel(['ACG ', AxisUnit])
	else
		ylabel(['CCG ', AxisUnit])
	end

	axis tight
else
	Out = Histo;
	t = 1000*(-HalfBins:HalfBins)*BinSize/SampleRate;
end;