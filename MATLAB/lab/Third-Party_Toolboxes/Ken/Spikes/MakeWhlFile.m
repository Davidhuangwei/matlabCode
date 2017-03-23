% MakeWhlFile(FileBase, SquareWaveCh)
% takes a .spots file and a .eeg file and makes a .whl file
%
% you need to select the sync led area
% view diagnostic plots
% and decide if everything's OK.

function MakeWhlFile(FileBase, SquareWaveCh)
%FileBase = '/u10/ken/j360802/j360802'; SquareWaveCh = 23;
if nargin<2
    fprintf('Usage MakeWhlFile(FileBase, SquareWaveCh)\n');
    return;
end

Thresh = 3; % to avoid triggers caused by 1 or 2 spurious pixels

Par = LoadPar([FileBase '.par']);
nCh = Par.nChannels;

if 1
fprintf('Loading data ... ');    
spots = load([FileBase '.spots']);
nFrames = max(spots(:,1))+1;
eegAll = bload([FileBase '.eeg'], [nCh inf]);
eeg = eegAll(SquareWaveCh,:);
fprintf('Done\n');
end

figure(1); 
clf; 
plot(spots(:,3), spots(:,4), '.', 'markersize', 1);
zoom on
input('In the figure window, select the area of the sync spot so it fills the axes.\nThen press return in this window\n', 's');
xr = xlim;
yr = ylim;

IsSyncSpot = spots(:,3)>=xr(1) & spots(:,3)<=xr(2) & spots(:,4)>=yr(1) & spots(:,4)<=yr(2);
SyncSpots = find(IsSyncSpot); % entries in spots.txt for our LED
PixCnt = Accumulate(spots(SyncSpots,1)+1, spots(SyncSpots,2), nFrames); % number of pixels in detected LED

% now we get down to synchronization
% - find flash points using "Schmitt trigger" 
% i.e. when it goes from 0 to above threshold
FlashFrames = SchmittTrigger(PixCnt,Thresh,0);

% find upstrokes of eeg square wave - use mean+-half s.d. as trigger points
MeanEeg = mean(eeg); StdEeg = std(eeg);
FlashSamples = SchmittTrigger(eeg, MeanEeg+StdEeg/2, MeanEeg-StdEeg/2);

%plot diagnostics
subplot(2,2,1)
plot(diff(FlashFrames), '.-')
ylabel('# frames between flashes');
xlabel('flash #');

subplot(2,2,2)
plot(diff(FlashSamples), '.-')
ylabel('# samples between flashes');
xlabel('flash #');

if length(FlashFrames)~=length(FlashSamples)
    fprintf('NUMBER OF FLASHES MISMATCH!\n');
    fprintf('There are %d video flashes and %d square wave pulses.\n', length(FlashFrames), length(FlashSamples));
    fprintf('are you SURE you want to continue? - you better be sure\n');
    i = input('If you''re sure you''re sure, say yes.', 's');
    if ~strcmp(i, 'yes')
        return;
    end
    nFlashes = min(length(FlashFrames), length(FlashSamples));    
    FlashFrames = FlashFrames(1:nFlashes);
    FlashSamples = FlashSamples(1:nFlashes);
end

nFlashes = min(length(FlashFrames), length(FlashSamples));
    
subplot(2,2,3);
[b bint r] = regress(FlashSamples, [FlashFrames, ones(size(FlashFrames))]);
plot(r/1.25, '.')
xlabel('Flash #'); ylabel('deviation from linear fit (ms)');

subplot(2,2,4);
hold off;
plot(diff(FlashFrames)./diff(FlashSamples)*1250, '.');
FilterLen = 10;
f = filter(ones(FilterLen,1)/FilterLen, 1, diff(FlashFrames)./diff(FlashSamples)*1250);
hold on
plot(FilterLen:length(f), f(FilterLen:end), 'r');
ylabel('Frame rate (red is smoothed)');
xlabel('Flash #');

% now align them - any outside sync range become NaN
FrameSamples = interp1(FlashFrames, FlashSamples, 1:nFrames, 'linear', NaN);

% THE FOLLOWING ONLY WORKS IF YOU HAVE 1 LED ONLY (I.E. NO HEAD DIRECTION)

% find non-sync spots
NonSyncSpots = find(~IsSyncSpot);
% find those with only 1 non-sync spot per frame
NonSyncCnt = Accumulate(1+spots(NonSyncSpots,1),1);
GoodSpots = NonSyncSpots(find(NonSyncCnt(1+spots(NonSyncSpots,1))==1));
% now make trajectory
HeadPos = -1*ones(nFrames,2);
HeadPos(1+spots(GoodSpots,1),:) = spots(GoodSpots,3:4);
% interpolate missing stretches up to 10 frames long
cHeadPos = CleanWhl(HeadPos, 10, inf);
cHeadPos(find(cHeadPos==-1))=NaN; % so it doesn't interpolate between 100 and -1 and get 50.

% now make wheel file by interpolating
TargetSamples = 0:32:length(eeg);
GoodFrames = find(isfinite(FrameSamples));
Whl(:,1:2) = interp1(FrameSamples(GoodFrames), cHeadPos(GoodFrames,:), TargetSamples, 'linear', -1);
Whl(find(~isfinite(Whl)))=-1;

figure(2); clf;
plot(Whl);
title('Trajectory');

i = input('Does this all seem OK?', 's');
if length(i>=1) & i(1)=='y'
    fprintf('Saving %s\n', [FileBase '.whl']);
    msave([FileBase '.whl'], Whl);
end
