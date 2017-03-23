
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
eeg = eegAll(1,:);
if exist([fileBase '.maz']),
  events = load([fileBase '.maz']);
end
fprintf('Done\n');

% find upstrokes of eeg square wave - use mean+-half s.d. as trigger points
MeanEeg = mean(eeg); StdEeg = std(eeg);
syncEEG = SchmittTrigger(eeg,MeanEeg+StdEeg/2,MeanEeg-StdEeg/2);


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
        counter=0;
        for i=1:m
           if (spots(i,3)>=xr(1) & spots(i,3)<=xr(2) & spots(i,4)>=yr(1) & spots(i,4)<=yr(2)),
	     counter=counter+1;
           end
        end
        spots2 = zeros(m-counter,n);
	i2=1;
        for i=1:m
           if ~(spots(i,3)>=xr(1) & spots(i,3)<=xr(2) & spots(i,4)>=yr(1) & spots(i,4)<=yr(2)),
	     spots2(i2,:) = spots(i,:);
	     i2=i2+1;
           end
        end
	clear spots;
	spots = zeros(m-counter,n);
	spots = spots2;
        plot(spots(:,3),spots(:,4),'.','markersize',1);
        zoom on
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
        [syncEvents,syncEEG] = DisplaySYNC2(syncEvents,syncEEG,nSamplesPerScreen);
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

  % THE FOLLOWING IS TO REMOVE SPURIOUS SPOTS FROM TRACKING USING 2 LEDS (SHOULD WORK OK FOR 1 LED)

  % find non-sync spots
  NonSyncSpots = find(~IsSyncSpot);
  % find those with 2 non-sync spots per frame
  NonSyncCnt = Accumulate(1+spots(NonSyncSpots,1),1);

  GoodSpots = NonSyncSpots(find(NonSyncCnt(1+spots(NonSyncSpots,1))==1 | NonSyncCnt(1+spots(NonSyncSpots,1))==2));

  removeBadSpots = 'yes';
  while (~strcmp(removeBadSpots, 'no'))
  IdentifyBadFrames = 'begin';
  while (~strcmp(IdentifyBadFrames,'no'))
    IdentifyBadFrames = input('\n\n Do you want to identify frames with 2 spots that are too far apart to be real (yes/no)? ', 's');
    if strcmp(IdentifyBadFrames,'yes'),
      badframes = 0;
      totalframes = 0;
      MaxTwoSpotDist = str2num(input('\n What maximum distance between spots (for 2 spots) should be used (default=18)? ', 's'));
      if isempty(MaxTwoSpotDist),
	MaxTwoSpotDist = 18;
      end
      fprintf('\nDetecting spurious spots\n---------------------------------------\n');
      figure(2);
      clf; 
      hold on;
      [m,n]=size(GoodSpots);
      NewGoodSpots = zeros(m,1);
      plot(spots(GoodSpots,3),spots(GoodSpots,4),'.');

      % frames in which there are two spots and they are too far apart to be real are eliminated
      % it plots in red a line connecting the spots from the to be rejected frames.

      i=1;
      while(i<=m)
        totalframes = totalframes +1;
        if (NonSyncCnt(1+spots(GoodSpots(i),1))==1 )
          NewGoodSpots(i) = 1;
          i=i+1;
        else
          if ((((spots(GoodSpots(i),3) - spots(GoodSpots(i+1),3))^2 + (spots(GoodSpots(i),4) - spots(GoodSpots(i+1),4))^2)^(1/2)) < MaxTwoSpotDist )
            NewGoodSpots(i) = 1;
            NewGoodSpots(i+1) = 1;
	    else
            badframes = badframes +1;
            plot([spots(GoodSpots(i),3), spots(GoodSpots(i+1),3)],[ spots(GoodSpots(i),4), spots(GoodSpots(i+1),4)],'r');
          end
          i = i+2;
        end
      end       
      keyin = '';
      while (~strcmp(keyin, 'no') & ~strcmp(keyin, 'yes'))
        fprintf('Out of %i frames, %i bad frames detected. ',totalframes, badframes);
        keyin = input('Eliminate these frames (yes/no)? ', 's');
        if (strcmp(keyin, 'yes'))
          GoodSpots = GoodSpots(find(NewGoodSpots == 1));
	  IdentifyBadFrames = 'no';
        end
      end
    end
  end

% The next part of the program determines if there are large jumps in the frame to frame location of the
% spots specifically, if the spot in frame B is more than twice as far from A than B is from C, and
% |B-A| is above a threshold, B is probably junk and should be tossed. The algorithm operates somewhat 
% recursively to eliminate jumps that span more than one frame.

  IdentifyBadFrames = 'begin';
  while (~strcmp(IdentifyBadFrames,'no'))
    IdentifyBadFrames = input('\n\n Do you want to identify frames with spots that jump around suscpiciously (yes/no)? ', 's');
    if strcmp(IdentifyBadFrames,'yes'),
      badframes = 0;
      totalframes = 0;
      SpotJumpThresh = str2num(input('\n What minimum spot jump distance threshold should be used (default=18)? ', 's'));
      if isempty(SpotJumpThresh),
	SpotJumpThresh = 18;
      end
      fprintf('\nDetecting spurious spots\n---------------------------------------\n');
      figure(2);
      clf;
      hold on;
      plot(spots(GoodSpots,3),spots(GoodSpots,4),'.');
      [m,n] = size(GoodSpots);
      NewGoodSpots = zeros(m,1);
      NewGoodSpots(1) = 1; % defaultthe first frame is assumed to be good
      A=1;
      B = A+1+(NonSyncCnt(1+spots(GoodSpots(A),1))-1); % B is either 1 or two lines after A depending on how many spots are in frame A
      C = B+1+(NonSyncCnt(1+spots(GoodSpots(B),1))-1); % C is either 1 or two lines after B depending on how many spots are in frame A
      oldC = C;

      while (C+1<=m)
        if (NonSyncCnt(1+spots(GoodSpots(A),1))==1 ) % if there's one spot in frame A
          Ax = spots(GoodSpots(A),3);
          Ay = spots(GoodSpots(A),4);
        else
          Ax = mean([spots(GoodSpots(A),3), spots(GoodSpots(A+1),3)]);
          Ay = mean([spots(GoodSpots(A),4), spots(GoodSpots(A+1),4)]);
        end
        if (NonSyncCnt(1+spots(GoodSpots(B),1))==1 ) % if there's one spot in frame B
          Bx = spots(GoodSpots(B),3);
          By = spots(GoodSpots(B),4);
          Boffset = 0;
        else
          Bx = mean([spots(GoodSpots(B),3), spots(GoodSpots(B+1),3)]);
          By = mean([spots(GoodSpots(B),4), spots(GoodSpots(B+1),4)]);
          Boffset = 1;
        end
        if (NonSyncCnt(1+spots(GoodSpots(C),1))==1 ) % if there's one spot in frame C
          Cx = spots(GoodSpots(C),3);
          Cy = spots(GoodSpots(C),4);
          Coffset = 0;
        else 
          Cx = mean([spots(GoodSpots(C),3), spots(GoodSpots(C+1),3)]);
          Cy = mean([spots(GoodSpots(C),4), spots(GoodSpots(C+1),4)]);
          Coffset = 1;
        end

        % if the spot in frame B is more than twice as far from A than B is from C, and |B-A| is above a threshold, B is probably junk
        if (((Ax-Bx)^2+(Ay-By)^2)^(1/2) >= SpotJumpThresh & ((Ax-Cx)^2+(Ay-Cy)^2)^(1/2) < (((Ax-Bx)^2+(Ay-By)^2)^(1/2))/2 )
	  plot([Ax, Bx], [ Ay, By],'r');
          % A stays the same
          B = oldC;
          C = oldC+1+(NonSyncCnt(1+spots(GoodSpots(oldC),1))-1); % next frame after the old C frame
          oldC = C; % set new oldC
          totalframes = totalframes + 1;
          badframes = badframes + 1;

          % if C is further from B than B is from A (i.e. animal is moving away from point A) or if jitter is small, keep B
        else if (((Ax-Bx)^2+(Ay-By)^2)^(1/2) < SpotJumpThresh | ((Cx-Bx)^2+(Cy-By)^2) > ((Ax-Bx)^2+(Ay-By)^2))
            NewGoodSpots(B) = 1;
            if (NonSyncCnt(1+spots(GoodSpots(B),1))==2 ) % write both spots in frame B if there are two
              NewGoodSpots(B+1) = 1;
            end
            A = B;
            B = oldC;
            C = oldC+1+(NonSyncCnt(1+spots(GoodSpots(oldC),1))-1); % next frame after the old C frame
            oldC = C; % set new oldC
            totalframes = totalframes + 1;
  
            else
              % get the next spot too if neither of the above are true yet
              C = C+1+Coffset;
            end
        end
      end
      keyin = '';
      while (~strcmp(keyin, 'no') & ~strcmp(keyin, 'yes'))
        fprintf('Out of %i frames, %i bad frames detected. ',totalframes, badframes);
        keyin = input('Eliminate these frames (yes/no)? ', 's');
        if (strcmp(keyin, 'yes'))
          GoodSpots = GoodSpots(find(NewGoodSpots == 1));
          IdentifyBadFrames = 'no';
        end
      end
    end
  end
  figure(2);
  clf;
  plot(spots(GoodSpots,3),spots(GoodSpots,4),'.');
  keyin = '';
  while (~strcmp(keyin, 'no') & ~strcmp(keyin, 'yes'))
    keyin = input('Do you wish to try to remove more bad frames (yes/no)? ', 's');
    removeBadSpots = keyin;
  end
  end

  % now make trajectory
  HeadPos = -1*ones(nFrames,4);
  [m,n] = size(GoodSpots);
  i = 1;
  j = 1;
  while (i<=nFrames & j<=m)
    if (i == 1+spots(GoodSpots(j),1))
      if (NonSyncCnt(1+spots(GoodSpots(j),1))==1 )
        HeadPos(i,1:2) = spots(GoodSpots(j),3:4);
        HeadPos(i,3:4) = spots(GoodSpots(j),3:4);
	j=j+1;
      else
        % average position for frames with two spots
        HeadPos(i,1:2) = mean(spots(GoodSpots(j:j+1),3:4));
        HeadPos(i,3:4) = mean(spots(GoodSpots(j:j+1),3:4));
	j=j+2;
      end
    end
    i=i+1;
  end

   % interpolate missing stretches up to 10 frames long
  cHeadPos = CleanWhl(HeadPos, 10, inf);
  cHeadPos(find(cHeadPos==-1))=NaN; % so it doesn't interpolate between 100 and -1 and get 50.

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

figure(2)
  plot(cHeadPos(:,1),cHeadPos(:,2))

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
