function RasterView(Eeg, Crossings, Whl, Res, Clu, MyClu, TimeSeg, Colors)
% RasterView(Eeg0, Crossings, Whl, Res, Clu, MyClu, TimeSeg, Colors)
% plots eeg and a raster of spikes in time windown
% TimeSeg is [Start End] in .res units

if nargin<8
    Colors = repmat('b', length(MyClu));
end

if isstr(Colors)
    Colors = Colors(:);
end

ResInRange = (Res>=TimeSeg(1) & Res<=TimeSeg(2));

clf; hold on;
for c=1:length(MyClu)
    MyRes = Res(find(ResInRange & Clu==MyClu(c)));
    plot(repmat(MyRes(:)',2,1)/20000, repmat(c+[0;.9],1,length(MyRes)), 'color', Colors(c,:));
end    

set(gca, 'ytick', 1.45:length(MyClu)+.45);
set(gca, 'yticklabel', MyClu);

er = TimeSeg(1)/16:TimeSeg(2)/16;
plot(er/1250, Eeg(1+er)/5000);

wr = 1+floor(TimeSeg(1)/512):1+floor(TimeSeg(2)/512);
plot(wr*512/20000, -2+Whl(wr,:)/300);

ylim([-3 length(MyClu)+1]);
xlim(TimeSeg/20000);

MyCrossings = find(Crossings>=TimeSeg(1) & Crossings<=TimeSeg(2));
plot(repmat(Crossings(MyCrossings)/20000,1,2), ylim, 'k--');
