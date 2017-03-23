
% MakeWhlFile_3spots(fileBase,nSamplesPerScreen)
%
% Synchronize electrophysiological data, video streams and behavioral events
%
% Inputs
%  A .led file, a .spots file, and a .maz file
%
% Outputs
%  A .whl file and a .evt file
%
% Required parameters
%  fileBase: the (common) base name for the three input files
%
% Optional parameters
%  nSamplesPerScreen: the number of samples to display at once (default = 100)
%
% Note: this is an interactive function; follow the instructions on the main window

function MakeWhlFile_3spots(fileBase,nSamplesPerScreen)
if nargin<1
    fprintf('Usage: MakeWhlFile_3spots(fileBase[,nSamplesPerScreen])\n');
    return;
end
if nargin < 2,
  nSamplesPerScreen = 100;
end

Thresh = 3; % to avoid triggers caused by 1 or 2 spurious pixels

% Load .spots, .led and .maz files

fprintf('Loading data ... ');
spots = [];
if exist([fileBase '.spots']),
  spots = load([fileBase '.spots']);
  nFrames = max(spots(:,1))+1;
end
eegAll = bload([fileBase '.led' ], [1 inf]);
eeg = -eegAll(1,:);
if exist([fileBase '.maz']),
  events = load([fileBase '.maz']);
end
fprintf('Done\n');

% find upstrokes of eeg square wave - use mean+-half s.d. as trigger points
MeanEeg = mean(eeg); StdEeg = std(eeg);
syncEEG = SchmittTrigger(eeg,MeanEeg+StdEeg/2,MeanEeg+StdEeg/4);
keyboard

if ~isempty(spots),
  figure(1);
  clf;
  plot(spots(:,3),spots(:,4),'.','markersize',1);
  zoom on

  remove_more=1;
  while(remove_more==1)
     keyin = input('\n\n Do you want to remove some spots from analysis (yes/no)? ', 's');
     if strcmp(keyin,'yes'),
        input('In the figure window, select the area you want to delete.\n   Then click back in this window and hit ENTER...','s');
        xr = xlim;
        yr = ylim;
        [m, n] = size(spots);
 	SpotsToKeep = find(~(spots(:,3)>=xr(1) & spots(:,3)<=xr(2) & spots(:,4)>=yr(1) & spots(:,4)<=yr(2)));
 	spots = spots(SpotsToKeep,:);
	plot(spots(:,3),spots(:,4),'.','markersize',1);
      else if strcmp(keyin,'no'),
	remove_more=0;
        end
      end
  end

  fprintf('\nDetection of synchronizing LED\n------------------------------\n');
  input('   In the figure window, select the area of the sync spot so it fills the axes.\n   Then click back in this window and hit ENTER...','s');
  xr = xlim;
  yr = ylim;

  IsSyncSpot = spots(:,3)>=xr(1) & spots(:,3)<=xr(2) & spots(:,4)>=yr(1) & spots(:,4)<=yr(2);
  SyncSpots = find(IsSyncSpot); % entries in spots.txt for our LED
  PixCnt = Accumulate(spots(SyncSpots,1)+1,spots(SyncSpots,2),nFrames); % number of pixels in detected LED

  % now we get down to synchronization
  % - find flash points using "Schmitt trigger"
  % i.e. when it goes from 0 to above threshold
  syncVideo = SchmittTrigger(PixCnt,Thresh,0);

  % Before manual correction:
  %  syncEEG contains the timestamps of the SYNC upstrokes detected in the EEG
  %  syncVideo contains the timestamps of the LED onsets detected in the video
  % After manual correction:
  %  syncEEG and syncVideo will contain the corrected timestamps
  %  syncVideo will be truncated if it is longer than syncEEG, but not the other way around
  %  Therefore, length(syncVideo) <= length(syncEEG)
  fprintf('\nSynchronization of video and EEG \n--------------------------------\n');
  while 1,
      fprintf('   There are %d video flashes and %d square wave pulses.\n',length(syncVideo),length(syncEEG));
      if length(syncVideo)~=length(syncEEG),
        fprintf('   ***** MISMATCH! *****\n');
        i = input('   To manually correct this, hit ENTER; to drop flashes in excess and continue, type ''done''+ENTER - but you''d better be sure...','s');
      else
        i = input('   To manually edit this, hit ENTER; to continue, type ''done''+ENTER...','s');
      end
      if strcmp(i,'done'),
          if length(syncVideo) > length(syncEEG),
              syncVideo = syncVideo(1:length(syncEEG));
          end
          break;
      else
        [syncVideo,syncEEG] = DisplaySYNC(syncVideo,syncEEG,nSamplesPerScreen);
      end
  end
end

% Before manual correction:
%  syncEEG contains the timestamps of the SYNC upstrokes detected in the EEG
%  syncEvents contains the timestamps of the SYNC events in the .maz file
% After manual correction:
%  syncEEG and syncEvents will contain the corrected timestamps
%  syncEvents will be truncated if it is longer than syncEEG, but not the other way around
%  Therefore, length(syncEvents) <= length(syncEEG)
if ~isempty(events),
  fprintf('\nSynchronization of events and EEG\n---------------------------------\n');
  syncEvents = events(find(events(:,2) == 83 & events(:,3) == 89));
  while 1,
      fprintf('   There are %d SYNC events and %d square wave pulses.\n',length(syncEvents),length(syncEEG));
      if length(syncEvents)~=length(syncEEG),
        fprintf('   ***** MISMATCH! *****\n');
        i = input('   To manually correct this, hit ENTER; to drop flashes in excess and continue, type ''done''+ENTER - but you''d better be sure...','s');
      else
        i = input('   To manually edit this, hit ENTER; to continue, type ''done''+ENTER...','s');
      end
      if strcmp(i,'done'),
          if length(syncEvents) > length(syncEEG),
              syncEvents = syncEvents(1:length(syncEEG));
          end
          break;
      else
        [syncEvents,syncEEG] = DisplaySYNC(syncEvents,syncEEG,nSamplesPerScreen);
      end
  end
end

if ~isempty(spots),
  figure(1);
  subplot(2,2,1);
  plot(diff(syncVideo),'.-')
  ylabel('# video frames between flashes');
  xlabel('flash #');

  subplot(2,2,2)
  plot(diff(syncEEG), '.-')
  ylabel('# EEG samples between flashes');
  xlabel('flash #');

  subplot(2,2,3);
  [b bint r] = regress(syncEEG(1:length(syncVideo)),[syncVideo,ones(size(syncVideo))]);
  plot(r/1.25,'.')
  xlabel('Flash #');
  ylabel('deviation from linear fit (ms)');

  subplot(2,2,4);
  hold off;
  plot(diff(syncVideo)./diff(syncEEG(1:length(syncVideo)))*1250,'.');
  FilterLen = 10;
  f = filter(ones(FilterLen,1)/FilterLen, 1,diff(syncVideo)./diff(syncEEG(1:length(syncVideo)))*1250);
  hold on;
  plot(FilterLen:length(f),f(FilterLen:end),'r');
  ylabel('Frame rate (red is smoothed)');
  xlabel('Flash #');

  % now align them - any outside sync range become NaN
  FrameSamples = interp1(syncVideo,syncEEG(1:length(syncVideo)),1:nFrames,'linear',NaN);

  % THE FOLLOWING ONLY WORKS IF YOU HAVE 2 LEDS

  % find non-sync spots
  NonSyncSpots = find(~IsSyncSpot);
  % find those with 2 non-sync spots per frame
  NonSyncCnt = Accumulate(1+spots(NonSyncSpots,1),1);
  GoodSpots = NonSyncSpots(find(NonSyncCnt(1+spots(NonSyncSpots,1))==2));
  % select front versus rear LED in color space
  figure(2);
  clf;
  rgb = ycbcr2rgb(spots(GoodSpots,7:9));
  plot(rgb(:,1),rgb(:,2),'.','markersize',1);
  xlabel('Red');
  ylabel('Green');
  zoom on;
  fprintf('\nDiscrimination of front and rear lights\n---------------------------------------\n');
  input('   In the figure window, select the front spot so it fills the axes.\n   Then click back in this window and hit ENTER...','s');
  xr = xlim;
  yr = ylim;
  IsFrontSpot = rgb(:,1)>=xr(1) & rgb(:,1)<=xr(2) & rgb(:,2)>=yr(1) & rgb(:,2)<=yr(2);
  FrontSpots = GoodSpots(find(IsFrontSpot));
  RearSpots = GoodSpots(find(~IsFrontSpot));
  figure(2);
  subplot(2,1,1);hold on;
  plot(spots(FrontSpots,3),spots(FrontSpots,4),'.','color',[1 0 0],'markersize',10,'linestyle','none');
  plot(spots(RearSpots,3),spots(RearSpots,4),'.','color',[0 1 0],'markersize',10,'linestyle','none');
  subplot(2,1,2);hold on;
  k=0;

	% now make trajectory
  HeadPos = -1*ones(nFrames,4);
  HeadPos(1+spots(FrontSpots,1),1:2) = spots(FrontSpots,3:4);
  HeadPos(1+spots(RearSpots,1),3:4) = spots(RearSpots,3:4);
  % interpolate missing stretches up to 10 frames long
  cHeadPos = CleanWhl(HeadPos, 10, inf);
  cHeadPos(find(cHeadPos==-1))=NaN; % so it doesn't interpolate between 100 and -1 and get 50.

	cleanHeadPos = HeadPos(HeadPos(:,1)~=-1&HeadPos(:,2)~=-1&HeadPos(:,3)~=-1&HeadPos(:,4)~=-1,:);
  fprintf('\nTrajectory of the rat\n----------------------\n');
  while ~strcmp(input('   Hit ENTER to show the next 100 samples, or type ''done''+ENTER to proceed...','s'),'done'),
    k = k+1;
		if k*100 > length(cleanHeadPos), break; end
    cla;
    set(gca,'xlim',[0 368],'ylim',[0 240]);
    plot(cleanHeadPos((k-1)*100+1:k*100,1),cleanHeadPos((k-1)*100+1:k*100,2),'.','color',[1 0 0],'markersize',10,'linestyle','none');
    plot(cleanHeadPos((k-1)*100+1:k*100,3),cleanHeadPos((k-1)*100+1:k*100,4),'.','color',[0 1 0],'markersize',10,'linestyle','none');
    for j=(k-1)*100+1:k*100, line([cleanHeadPos(j,1) cleanHeadPos(j,3)],[cleanHeadPos(j,2) cleanHeadPos(j,4)],'color',[0 0 0]); end
    set(gca,'xlim',[0 368],'ylim',[0 240]);
  end

	% now make wheel file by interpolating
  TargetSamples = 0:32:length(eeg);
  GoodFrames = find(isfinite(FrameSamples));
  Whl(:,1:4) = interp1(FrameSamples(GoodFrames),cHeadPos(GoodFrames,:),TargetSamples,'linear',-1);
  Whl(find(~isfinite(Whl)))=-1;
end

if ~isempty(events),
  % Update events: remove all initial SYNC events and replace them with the corrected ones (according to user input)
  nonSYNC = events(events(:,2) ~= 83 | events(:,3) ~= 89,:);
  events = [nonSYNC;[syncEvents 83*ones(size(syncEvents)) 89*ones(size(syncEvents))]];
  events = sortrows(events,1);
  % Throw any events occurring after the last SYNC event
  lastSYNC = find(events(:,2) == 83 & events(:,3) == 89);lastSYNC = lastSYNC(end);
  events = events(1:lastSYNC,:);
  % Synchronize events on electrophysiological data
  timestamps = interp1(syncEvents,syncEEG(1:length(syncEvents))/1250*1000,events(:,1),'linear',-1);
  events(:,1) = timestamps;
  events = double(uint32(events));
end

if ~isempty(spots),
  figure(1);
end
while 1,
  i = input('\n\nSave to disk (yes/no)? ', 's');
  if strcmp(i,'yes') | strcmp(i,'no'), break; end
end
if i(1) == 'y'
  if ~isempty(spots),
    fprintf('Saving %s\n', [fileBase '.whl']);
    msave([fileBase '.whl'], Whl);
  end
  if ~isempty(events),
    fprintf('Saving %s\n', [fileBase '.evt']);
    msave([fileBase '.evt'],events);
  end
end
