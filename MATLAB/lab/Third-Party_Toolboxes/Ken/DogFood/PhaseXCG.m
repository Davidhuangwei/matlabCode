% PhaseXGC(TotPh1, TotPh2, MaxPh, mode)
%
% computes a "separated cross-correlogram" of spikes.
% 
% Every dot is a pair of spikes separated by no more than MaxPh
% Phase of spike 1 is on the y-axis. 
%
% in mode 1, phase of spike 2 relative to 1 is on x-axis
% in mode 2, absolute phase of spike 2 is on the x-axis. 
%
% it's hard 2 explain.  just try it.
%

function PhaseXCG(TotPh1, TotPh2, MaxPh, mode)

TotPh1 = TotPh1(:);
TotPh2 = TotPh2(:);

AllPh = [TotPh1; TotPh2];
Gp = [ones(size(TotPh1)); ones(size(TotPh2))*2];

[ccg t Pairs] = CCG(AllPh, Gp, MaxPh*2, 0, 1, 1:2);

p1 = Pairs(:,1);
p2 = Pairs(:,2);
Ph1 = mod(AllPh(p1), 2*pi);
PhDiff = AllPh(p2) - AllPh(p1); %Ph1;

if mode==1
    plot(PhDiff, Ph1, '.', 'markersize', 1);
    axis([-MaxPh MaxPh 0 2*pi]);
elseif mode==2
    plot(PhDiff+Ph1, Ph1, '.', 'markersize', 1);
    axis([-MaxPh MaxPh+2*pi 0 2*pi]);
else
    error('unknown mode');
end
return

PhaseDiff = TotPh(p2)-Revs(p1);

subplot(4,1,1)
hold off
plot(PhaseDiff+Rev1(p1), Rev1(p1), '.', 'markersize', 1);
hold on
for i=-n:n
    plot([i i], [0 1], 'k--');
    plot([i i+1], [0 1], 'm--');
end
xlim([-n n]);

subplot(4,1,2)
hold off
plot(PhaseDiff, Rev1(p1), '.', 'markersize', 1);
hold on
for i=-n:n
    plot([i i-1], [0 1], 'k--');
    plot([i i], [0 1], 'm--');
end
xlim([-n n]);

PhBins = 10;
subplot(4,1,3)
[h XBins YBins] = hist2([PhaseDiff, Rev1(p1)], -n-1:n+1, PhBins);
PhaseHist = histc(Rev1, 0:1/PhBins:1);
%contour(XBins, YBins, h');
xr = 2:2*n+1;
imagesc(XBins(xr), YBins(1:PhBins), h(xr,1:PhBins)'.*repmat(1./(PhaseHist(1:PhBins)), 1, 2*n));
set(gca, 'ydir', 'normal');

% do some computations
% find ratio of left to right
n2 = 3;
LeftBins = n-n2+1:n;
RightBins = n+3:n+2+n2;

LeftSum = sum(h(LeftBins,1:PhBins),1);
RightSum = sum(h(RightBins,1:PhBins),1);
Rat1 = (RightSum-LeftSum)./(RightSum+LeftSum); % before to after ratio
Advance = sum(PhaseDiff>.5 & PhaseDiff<1);
Retreat = sum(PhaseDiff>1 & PhaseDiff<1.5);
Rat2 = (Advance-Retreat)/(Advance+Retreat)

subplot(4,1,4)
%plot(RightSum-LeftSum, YBins(1:PhBins), [0 0], [YBins(1) YBins(end)], 'k--');
plot(Rat1, YBins(1:PhBins), [0 0], [YBins(1) YBins(end)], 'k--');
xlim([-1 1]);

pause
return

subplot(2,2,2)
hold off
plot(Revs(p2)-Revs(p1)+Rev1(p1), Rev1(p1), '.', 'markersize', 1);
hold on
for i=-n:n
    plot([i i+1], [0 1], 'k--');
end
xlim([-n-1 n]);

subplot(2,2,4)
[h XBins, YBins] = hist2([Revs(p2)-Revs(p1)+Rev1(p1), Rev1(p1)], -n-1:n+1, 15);
%contour(XBins, YBins, h');
imagesc(XBins, YBins, h(:,1)');
set(gca, 'ydir', 'normal');

pause
