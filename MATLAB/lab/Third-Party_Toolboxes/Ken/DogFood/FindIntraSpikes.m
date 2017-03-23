function [t, vPk, vFt, tPk, tFt] = FindIntraSpikes(iv, Thresh, SegLen, NotCloserThan);
% [t, vPk, vFt, tPk, tFt] = FindIntraSpikes(iv, Thresh, SegLen, NotCloserThan)
% Detects spikes in an intracellular voltage trace using a threshold
% on first derivative (Thresh, default = 10)
% Looks for foot and peak to the left and right up to SegLen
% t is time of maximum derivative.  tPk is time of peak voltage
% tFt is time of maximum 2nd derivative.  *V is corresponding
% voltage.  

%dat = bload('AA-34-14.DAT', [4 inf]);       
% iv = dat(2,:)';

if nargin<2 | isempty(Thresh)
    Thresh = 10;
end
if nargin<3 | isempty(SegLen)
    SegLen = 20;
end
if nargin<4 | isempty(NotCloserThan)
    NotCloserThan = 10;
end

div = diff(iv);
ddiv = diff(div);

% find spike times (not interpolated)
LocMax = LocalMinima(-div, NotCloserThan, -Thresh);
t0 = LocMax(find(div(LocMax)>Thresh));
nSpikes = length(t0);

subplot(2,1,1)
hist(div(LocMax),300)
sl = div(LocMax);
fprintf('mean %f median %f sd %f iqr %f\n', mean(sl), median(sl), std(sl), iqr(sl));
%pause

% ExtractSegments
IndMat = repmat((-SegLen:SegLen)', 1, nSpikes) + repmat(t0(:)',2*SegLen+1,1);
IndMat(find(IndMat<1)) = 1;
IndMat(find(IndMat>length(iv))) = length(iv);

Segs = iv(IndMat);

% find peaks etc.
[vPk PeakPos] = max(Segs);
tPk = t0 + (PeakPos'-SegLen-1);

t = t0;

[dummy ddPeakPos] = max(diff(Segs,2));
tFt = t0 + (ddPeakPos'-SegLen-1);
vFt = Segs(sub2ind(size(Segs),ddPeakPos,1:nSpikes));%+1);

return

