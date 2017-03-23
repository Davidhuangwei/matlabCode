%function PeakStats = PowerPeakStats(pow, f, FreqRange)
%
% computes some peak value measures of spectra matrix pow
%
% output: number_of_FreqRanges x length_of_Spectra x number_of_Measures
% measures are: PeakFreq, PeakDif,  IntDiff, PeakDifRel, Int
%
function PeakStats = myPowerPeakStats(pow, f, FreqRange)
if size(pow,2) ==length(f)
    pow = pow';
end
nSeg = size(pow,2);
%pow = log10(pow);
%get the  interpolation segments
% take 10% wider FreqRange for the 
nf = size(FreqRange,1);
FreqRangeInt = FreqRange+0.1*repmat([-1 1],nf,1).*repmat(range(FreqRange')',1,2);
interpIn =find(WithinRanges(f,FreqRangeInt));
interpOut = setdiff(find(f),interpIn);

%interpolate all regions of interest to get baseline
interppow = [];
interppow(interpIn,:) = interp1(f(interpOut),pow(interpOut,:),f(interpIn));
interppow(interpOut,:) = pow(interpOut,:);
powdiff = pow-interppow;
for i=1:size(FreqRange,1)
  
  % peaks detection
  % peaks = LocalMinima(-pow, range(FreqRange(i,:))/2);
  % peaks = intersect(peaks, find(WithinRanges(f,FreqRange(i,:))));
  findex = find(WithinRanges(f,FreqRange(i,:)));
  % clip 60 Hz noise just in case
  noiseind = find(WithinRanges(f,[57 63]));
  if ~isempty(noiseind)
    findex = setdiff(findex,noiseind);
  end
    
  [maxpow peak] = max(pow(findex,:)); %% max power and frequency index
  PeakFreq(i,:) = f(findex(peak))';   
  ind = sub2ind(size(pow), findex(peak), [1:nSeg]'); %% matrix indices of peaks
  PeakDif(i,:) = powdiff(ind)';  %% power above base line
  PeakDifRel(i,:) =PeakDif(i,:) ./ maxpow(:)'; %% relative power
  IntDiff(i,:)= mean(pow(findex,:)) - mean(interppow(findex,:)); %% integral difference
  Int(i,:) = mean(pow(findex,:));  %% integral 
  MaxPow(i,:) = maxpow;
end


PeakStats = cat(3, PeakFreq, PeakDif,  IntDiff, PeakDifRel, Int, MaxPow);



