function Peaks = RipplesPeaks(Eeg,T,Itv)

lowband = 100;
highband = 250;
sampl = 1250;
forder = 100;
avgfilorder = 21;

%keyboard

%% Filter Eeg and detect local minima
firfiltb =  fir1(forder,[lowband/sampl*2,highband/sampl*2]);
avgfiltb = ones(avgfilorder,1)/avgfilorder;
filtered_data = filter(firfiltb,1,Eeg);

filtered_data2(1:length(Eeg)-forder/2) = filtered_data(forder/2+1:end);

Mins = LocalMinima(filtered_data2,5);

nItv = NoOverlapRanges(Itv);
goodMin = WithinRanges(Mins,nItv,[1:size(Itv,1)],'vector');

Peaks.min = Mins(find(goodMin));
Peaks.bursts = goodMin(find(goodMin));

%% minima closest to the mid peak
for n=1:length(T)
  [Sorted Indx] = sort(abs(Peaks.min-T(n)));
  Peaks.ctr(n) = Peaks.min(Indx(1));
end

return;