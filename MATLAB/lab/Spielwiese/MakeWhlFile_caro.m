function MakeWhlFile_caro(Spots_BaseFileName, Dat_BaseFileName, Save_Path)

% function [] = MakeWhlFile_3spots_e2(Spots_BaseFileName, Dat_BaseFileName, Save_Path);
%
% Synchronize eeg and tracking data
%
% Required parameters
%   Spots_BaseFileName (do not include extension)  
%
% Optional parameters 
%   Dat_BaseFileName (expected: tot N of ch in dat file: 33ch, SYNC signal on the last ch) (do not include extension)
%   Path to save output files (used only if Dat_BaseFileName is given)
%
% Input Data Files
%   Dat_BaseFileName.dat
%   Spots_BaseFileName.spots (m1v file processed with FindLed script)
%
% Output Data Files (all ASCII files)
%    *.VideoSync              (:,1 - n of samples (in 1250Hz); :,2 - 0,1 values of SYNC)
%    *.SyncEeg01              (:,1 - n of samples (in video samling freq), :,2 - 0,1 values of SYNC)
%    *.ParamWheel             (1,1: eeg on, 1,2: eeg off, 2,1: video on, 2,2: video off)
%    *.SyncTrackCoord         (spots assigned to each frame while SYNC was ON = NOT upsampled)
%    *.SyncTrackCoord_1250Hz  (spots assigned to each frame while SYNC was ON = upsampled to 1250Hz)
%    *.SyncTrackCoord_39Hz    (spots assigned to each frame while SYNC was ON = upsampled to 39Hz)
%    *.TrackingMovie.mpg - NOT YET 
%
% Functions called: 
%    charact_EEG_SYNC_signal
%    readsinglech
%    SchmittTriggerUpDown
%    detect_EEG_SYNC_pulses 
%    bload
%    ycbcr2rgb
%    SelectCluster
%    ExtractTrackingSpots
%    Inverse01Value
%    MakeMovieFrame
%    DrawTrackSpots    (... and might be some others as well :) - sorry )
%
% Note: this is an interactive function; follow instructions on the
% main window and figure-titles
%
% Synchronization: 
%    it is expected that camera sampling frequency is NOT regular -> all up
%    and down strokes from video and eeg files are allined = the same N of
%    strokes in both files is REQUIRED (program is terminated if this
%    condition is not fullfiled)
%
% default maximal distance between rat tracking LEDs: 40pixels (35 for new Kenji's LEDs)
%
% Please, note this the program is not very robust at this point. (any report of small insects will be helpful! thanks. e. 07/21/05).
%
% ==========================================================================================================

if nargin == 1                          % only tracking file name base -> look at tracking only	
  tracking_analysis = 1;
  track_sync_analysis = 0;
  eeg_sync_analysis = 0;      
elseif nargin > 1                       % tracking + eeg + synchronization of eeg and tracking
  if length(Dat_BaseFileName) > 0
    tracking_analysis = 1;
    track_sync_analysis = 1;
    eeg_sync_analysis = 1; 
  else 
    tracking_analysis = 1;
    track_sync_analysis = 0;
    eeg_sync_analysis = 0;          
  end
end

if nargin > 1
  BackSlPos = find(Dat_BaseFileName == '/');
  Dat_FileName = Dat_BaseFileName(BackSlPos(end)+1 : end);
  if nargin == 2
    if BackSlPos(end) > 1; 
      Save_Path = Dat_BaseFileName(1:BackSlPos(end));                              
    else Save_Path = '';
    end
  end
  if nargin == 3
    Save_Path = [Save_Path '/'];
  end     
end

PlotTrackSpots = 0;              % plot spots as they are assigned to fields (takes a long time to go through)
PlotInterpTrackSpots = 0;
MakeTrackMovie = 0;

% variables:
FieldsPerSec = 29.97;    % Hz (not reliable - FieldsPerSec sampling frequency determinted based on eeg time stamps for Spots-coordinates interpolation)
EegSamplRate = 1250;     % Hz
MaxLedDist = 30;         % pixels
InterpTrackSamplRate = EegSamplRate / 32;    % wheel file sampling frequency is 1250/32 = 39.06Hz (-> spots samling each 32 eeg data point)

format bank;
ScrSize = get(0,'ScreenSize');
ScrSize(1:2) = ScrSize(1:2) + 100;
ScrSize(3:4) = ScrSize(3:4) - 100;

% ==========================================================================================================
%                                      EEG_SYNC pulses
% ==========================================================================================================

% 1. extract SYNC signal from Dat_BaseFileName.eeg file 
% 2. remove noise at the beginning and at the end of the eeg-SYNC 
% output: SYNC-eeg between in values [0 1] and time-stamps of ALL up and ALL down strokes

if eeg_sync_analysis == 1;
  %[SyncEeg, UpDownSyncEeg] = charact_EEG_SYNC_signal(Dat_BaseFileName);
  [orig_eeg, SyncEeg] = charact_EEG_SYNC_signal(Dat_BaseFileName);      % 1-N sample, 2-SyncEeg values
  SyncEegLog = SyncEeg(:,2) > mean(SyncEeg(:,2));
  SyncEeg01(length(SyncEeg),2) = zeros;
  SyncEeg01(:,1) = SyncEeg(:,1);
  SyncEeg01(SyncEegLog, 2) = 1;
end

% ==========================================================================================================
%                                     all VIDEO pulses
% ==========================================================================================================

% Load *.m1v file
% video file structure: one detected bright spot per line (
%                       columns: N of frame, N points within the detected point (size), mean X, mean Y, sd
%                       X, sd Y, mean Luminiscence, mean Crominance, mean
%                       Cb (Luminance ~ intensity (BW), Cr and Cb ~ color)

spots = [];
if exist([Spots_BaseFileName '.spots']),
  fprintf('\n\n Loading video data .... \n');  
  spots = load([Spots_BaseFileName '.spots']);
  nFrames = max(spots(:,1))+1;
else error(['there is no video file ' Spots_BaseFileName '.spots'])
end

% change the first field # to 1 (from0)
spots(:,1) = spots(:,1) + 1;

% determine baseline brightness (the first 10sec of darkness - with NO LEDs) and keep all points above this baseline 
if min(spots(:,7)) < 23
  BaslBright = ceil(mean(spots(1:10*FieldsPerSec,7)));
  basl_spots = spots(find(spots(:,7)>BaslBright),:);
else
  basl_spots = spots;
end

% separate SYNC and tracking LEDs
% 1. choose proper brightness threshold
inp = 0;
thrash = min(basl_spots(:,7))-1;
orig_thrash = min(basl_spots(:,7))-1;
while length(inp) > 0 
  figure('Position',[1 ScrSize(4)/2 ScrSize(3)/2 ScrSize(4)/2]);
  hist(basl_spots(find(basl_spots(:,7)>thrash),7),500);
  xlabel('brightness'); ylabel('N of spots');
  if length(spots(1,:)) > 10*FieldsPerSec
    xlim([ceil(mean(spots(1:10*FieldsPerSec,7))) max(basl_spots(:,7))/4]);
  else
    xlim([ceil(min(spots(:,7))) max(basl_spots(:,7))]);    
  end
  curr_thrash_spots = basl_spots(find(basl_spots(:,7)>thrash),:);
  figure('Position',[10 ScrSize(4)/2 ScrSize(3)/2 ScrSize(4)/2]);
  plot(curr_thrash_spots(:,3),curr_thrash_spots(:,4),'.','markersize',1,'color', 'k');
  xlabel('X coord.'); ylabel('Y coord.');
  title(['Set new brightness thrashold or hit enter']);
  fprintf('\n\nCurrent thrashold is %d.\n', thrash);
  fprintf('\nOriginal thrashold with which mpg file was processed is %d.\n', orig_thrash);
  inp = input('\n\n Set brightness thrashold so that tracking and SYNC LEDs can be well distinquished.\n\n Hit "enter" if brightness thrashold is acceptable or type a value (0-250) and hit "enter":  ','s');
  if length(str2num(inp)) > 0; 
    inp = str2num(inp);
    thrash = inp;        
  end
  close gcf;
  close gcf;
end

% 2. select SYNC LED area
figure('Position',[1 ScrSize(4)/1.5 ScrSize(3)/1 ScrSize(4)/1]);
fprintf('\n\n\n Select a `broad` square area that contains SYNCchronization LED.\n If there is no SYNC LED, double click in the figure.');  
plot(curr_thrash_spots(:,3), curr_thrash_spots(:,4),'.','markersize',10,'color', 'k');
xlabel('X coord.'); ylabel('Y coord.');
title('Select a `broad` square area that contains SYNCchronization LED or double-click if there is none');
[xr, yr] = ginput(2);
close gcf;

% make a sparate matrix for SYNC and tracking data
% SYNC LED = points in the selected area & of the selected size range
IsSyncLed = basl_spots(:,3)>=min(xr) & basl_spots(:,3)<=max(xr) & basl_spots(:,4)>=min(yr) & basl_spots(:,4)<=max(yr);
if sum(IsSyncLed) > 0;
  SyncSpots = basl_spots(find(IsSyncLed),:);
else 
  SyncSpots = [];
end
IsTrackLed = ~IsSyncLed;
TrackSpots = basl_spots(find(IsTrackLed),:);


% -------------------------------------------------------------------------
%                                 1. tracking VIDEO pulses
% -------------------------------------------------------------------------

if tracking_analysis == 1;

  % convert YCbCr [Y:brightness (corresponds to BW level), Cb-Cr:color coding] to RGB color code
  TrackLed = TrackSpots;
  TrackLed(:,10:12) = ycbcr2rgb(TrackLed(:,7:9));
  
  % plot tracking LEDs on blue-green projection in order to select rear (green) and front (red) tracking LEDs
  figure('Position',[1 ScrSize(4)/1.5 ScrSize(3)/1 ScrSize(4)/1]);
  plot(TrackLed(:,11),TrackLed(:,12),'.','markersize',10, 'Color', 'b'); 
  title('Remove any redundant noisy points (double click if there are none).');
  xlabel('green'); ylabel('blue');   
  
  % remove any noisy points
  fprintf('\n\n\n Remove any noisy points (= points very far from clouds). Double click whenever you are done.\n');
  remove_more=1;
  while(remove_more==1)
    [xr, yr] = ginput(2);
    if xr(1) == xr(2) & yr(1) == yr(2); 
      remove_more=0;            
      close gcf;
      break; 
    end          
    TrackLed = TrackLed(find(~(TrackLed(:,11)>=min(xr) & TrackLed(:,11)<=max(xr) & TrackLed(:,12)>=min(yr) & TrackLed(:,12)<=max(yr))),:);
    close gcf;
    plot(TrackLed(:,11),TrackLed(:,12),'.','markersize',10, 'Color', 'b'); 
    xlabel('green'); ylabel('blue');
    title(' Remove any noisy points (= points very far from clouds). Double click whenever you are done.');
  end
  
  % separated clusters of points corresponding to different LED-colors (in green/blue space!!!)
  fprintf('\n\n\n Select a cluster that belongs to one color.\n If the color is selected, double-click within the figure.\n');
  [inCluster1] = SelectCluster(TrackLed(:,11), TrackLed(:,12), 'green', 'blue');
  [inCluster2] = SelectCluster(TrackLed(:,11), TrackLed(:,12), 'green', 'blue');
  BlueIntens1 = mean(TrackLed(find(inCluster1),12));  % content of blue color
  BlueIntens2 = mean(TrackLed(find(inCluster2),12));
  if BlueIntens1 < BlueIntens2                        % red LED has smaller content of blue color
    TrackLed(find(inCluster1),13) = 1;                % cluster 1 is a red = front LED
    TrackLed(find(inCluster2),13) = 2;                % cluster 2 is a green = rear LED
  else TrackLed(find(inCluster1),13) = 2;
    TrackLed(find(inCluster2),13) = 1;
  end
  
  % % remove all tracking noisy points
  figure('Position',[1 ScrSize(4)/1.5 ScrSize(3)/1 ScrSize(4)/1]);
  plot(TrackLed(TrackLed(:,13)==1,3),TrackLed(TrackLed(:,13)==1,4),'.','markersize',10, 'Color', 'r'); hold on;
  plot(TrackLed(TrackLed(:,13)==2,3),TrackLed(TrackLed(:,13)==2,4),'.','markersize',10, 'Color', 'g'); hold on;
  % plot(TrackLed(TrackLed(:,13)==0,3),TrackLed(TrackLed(:,13)==0,4),'.','markersize',10, 'Color', 'k'); hold on;
  title('Remove multiple square areas containing points that you do not consider to be rat`s LEDs');
  remove_more=1;
  fprintf('\n\n\n Remove multiple square areas containing points that you do not consider to be rat`s LEDs.\n If there ane NO/anymore points to remove, double click in a figure.\n');
  while(remove_more==1)
    [xr, yr] = ginput(2);
    if xr(1) == xr(2) & yr(1) == yr(2); 
      remove_more=0;  
      close gcf;
      break; 
    end 
    clf;
    TrackLed = TrackLed(find(~(TrackLed(:,3)>=min(xr) & TrackLed(:,3)<=max(xr) & TrackLed(:,4)>=min(yr) & TrackLed(:,4)<=max(yr))),:);
    plot(TrackLed(TrackLed(:,13)==1,3),TrackLed(TrackLed(:,13)==1,4),'.','markersize',10, 'Color', 'r'); hold on;
    plot(TrackLed(TrackLed(:,13)==2,3),TrackLed(TrackLed(:,13)==2,4),'.','markersize',10, 'Color', 'g'); hold on;
    %plot(TrackLed(TrackLed(:,13)==0,3),TrackLed(TrackLed(:,13)==0,4),'.','markersize',10, 'Color', 'k'); hold on;
    title('Remove multiple square areas containing points that you do not consider to be rat`s LEDs');
  end
  
  % reduce size of coordinates in order to reduce size of a movie
  TrackLed(TrackLed(:,3)>-1,3) = TrackLed(TrackLed(:,3)>-1,3) - min(TrackLed(TrackLed(:,3)>-1,3)) + 1;   
  TrackLed(TrackLed(:,4)>-1,4) = TrackLed(TrackLed(:,4)>-1,4) - min(TrackLed(TrackLed(:,4)>-1,4)) + 1;
  SpotsFrameSizeX = ceil(max(TrackLed(TrackLed(:,3)>-1,3)) - min(TrackLed(TrackLed(:,3)>-1,3)) + 1);
  SpotsFrameSizeY = ceil(max(TrackLed(TrackLed(:,4)>-1,4)) - min(TrackLed(TrackLed(:,4)>-1,4)) + 1);
  
  % figure;
  % plot(TrackLed(find(TrackLed(:,13)==1),11),TrackLed(find(TrackLed(:,13)==1),12),'.','markersize',1, 'color', 'g'); 
  % hold on;
  % plot(TrackLed(find(TrackLed(:,13)==2),11),TrackLed(find(TrackLed(:,13)==2),12),'.','markersize',1, 'color', 'r'); 
  % hold on;
  % plot(TrackLed(find(TrackLed(:,13)==0),11),TrackLed(find(TrackLed(:,13)==0),12),'.','markersize',1, 'color', 'k'); 
  % hold on;
  % xlabel('green'); ylabel('blue');       
  % structure of TrackLed matrix
  % FiledN, size, x, y, sd x, sd y, brightness, Cr, Cb, Red, Green, Blue,
  % 0-2: 0-other spot, 1-first selected cluster, 2-second selected cluster
  
end

% -------------------------------------------------------------------------
% 2. SYNC VIDEO pulses: decide which tracking points came after SYNC went ON
% -------------------------------------------------------------------------

if track_sync_analysis == 1 & length(SyncSpots) > 0;
  
  SyncSpots(:,10:12) = ycbcr2rgb(SyncSpots(:,7:9));
  
  % separate red LED from noise (in green/blue space!!!)
  fprintf('\n\n\n Select a cluster that belongs to one color.\n If the color is selected, double-click within the figure.\n');
  [IsSyncSpot] = SelectCluster(SyncSpots(:,11), SyncSpots(:,12), 'green', 'blue');
  SyncLed = SyncSpots(IsSyncSpot,:);
  
  % make sure that there are NO multiple fields with the same # and that
  % there are no fields missing (at 1 & 2):
  
  % 1. remove multiple points per field
  % (choose points that are further from the median value of brightness)
  
  MultiSpotsPerField = find(diff(SyncLed(:,1)) == 0);
  while length(MultiSpotsPerField) > 0
    SyncLed(MultiSpotsPerField(1)+1,:) = [];  
    MultiSpotsPerField = [];
    MultiSpotsPerField = find(diff(SyncLed(:,1)) == 0);
  end     
  
  % 2.add zero into the VideoSync where a field is missing
  VideoSync(TrackLed(end,1),2) = zeros;
  VideoSync(:,1) = 1:length(VideoSync);
  % VideoSync(1:SyncLed(end,1)+10) = zeros;
  VideoSync(SyncLed(:,1),2) = 1;             % missing fields appear as zero
  
  % check VideoSync and EegSync signal: remove any noisy spots!!!!!!!!!!!!!!
  CleanVideoSync(:,1) = VideoSync(:,1);
  CleanSyncEeg01(:,1) = SyncEeg01(:,1);
  CleanVideoSync(:,2) = Inverse01Value(VideoSync(1:end,2));
  CleanSyncEeg01(:,2) = Inverse01Value(SyncEeg01(1:end,2), SyncEeg(:,2));
  
  % count N of pulses (up and down strokes)
  StrokesSyncVideo = SchmittTriggerUpDown(CleanVideoSync(:,2),0.7,0.7);
  StrokesSyncEeg01 = SchmittTriggerUpDown(CleanSyncEeg01(:,2),0.7,0.7);
  
  % if NOT the same N of stokes - repeat cleaning (improve-comparison with eeg!!!)
  while length(StrokesSyncEeg01) ~= length(StrokesSyncVideo)
    fprintf(['\n N of VideoSync pulses:  ' num2str(length(StrokesSyncVideo)) '\n']);
    fprintf(['\n N of EegSync pulses:  ' num2str(length(StrokesSyncEeg01)) '\n']);    
    ans = input('N of Eeg and Video SYNC pulses is not the same!!!! Do you want to repeat removal of misplaced spots? [y/n] [y]  :'); 
    if isempty(ans)
      CleanVideoSync(:,2) = Inverse01Value(VideoSync(1:end,2));
      CleanSyncEeg01(:,2) = Inverse01Value(SyncEeg01(1:end,2), SyncEeg(:,2));
      StrokesSyncVideo = SchmittTriggerUpDown(CleanVideoSync(:,2),0.7,0.7);
      StrokesSyncEeg01 = SchmittTriggerUpDown(CleanSyncEeg01(:,2),0.7,0.7);
    elseif ans == 'n' 
      error('N of Eeg and Video SYNC pulses is not the same!!!! Give up and go home!');   
      quit; 
    end
  end
  
  VideoSync = CleanVideoSync;
  SyncEeg01 = CleanSyncEeg01;
  
  % if the same N of stokes - allign them ; if not - WHAT TO DO?????         
  if length(StrokesSyncEeg01) == length(StrokesSyncVideo)
    fprintf(['\n N of VideoSync pulses:  ' num2str(length(StrokesSyncVideo)) '\n']);
    fprintf(['\n N of EegSync pulses:  ' num2str(length(StrokesSyncEeg01)) '\n']);
    %  fprintf('\n Equal N of Eeg and Video SYNC pulses! Well done! \n');   
    % GIVE SOME STATISTICS, GIVE A CHANCE TO LOOK AT ALLIGNED SIGNALS!!!!   
  end
  
  % limit VideoSync and TrackLed matrix just for time from the first to the last stroke 
  % and save info about N of on/off sample ubti 'ParamWheel' file
  
  % remove all zero states after  = the last remaing is the last up state
  VideoSync(StrokesSyncVideo(end):end,:) = [];
  % remove all zero states before  = the first remaing is the first up state
  VideoSync(1:StrokesSyncVideo(1)-1,:) = [];        
  
  SyncEeg01(StrokesSyncEeg01(end):end,:) = [];
  SyncEeg01(1:StrokesSyncEeg01(1)-1,:) = [];
  ParamWheel(1,1) = SyncEeg01(1,1);
  ParamWheel(1,2) = SyncEeg01(end,1);
  ParamWheel(2,1) = VideoSync(1,1);
  ParamWheel(2,2) = VideoSync(end,1);
  
  % renumbered coordinates of strokes (after removal of the off states of LED)
  % the first/last stroke is identical with the first/last value in sync vectors -> all values of sync will be upsampled
  StrokesSyncVideo = SchmittTriggerUpDown(VideoSync(:,2),0.7,0.7); 
  StrokesSyncEeg01 = SchmittTriggerUpDown(SyncEeg01(:,2),0.7,0.7); 
  StrokesSyncVideo = [1; StrokesSyncVideo; length(VideoSync)];
  StrokesSyncEeg01 = [1; StrokesSyncEeg01; length(SyncEeg01)];
  
  % save SyncEeg01 and VideoSync 
  % :,1 - n of samples (in 1250Hz), :,2 - 0,1 values of SYNC
  save([Save_Path Dat_FileName '.VideoSync'], 'VideoSync', '-ascii');         
  % :,1 - n of samples (in video samling freq), :,2 - 0,1 values of SYNC
  save([Save_Path Dat_FileName '.SyncEeg01'], 'SyncEeg01', '-ascii');
  % 1,1: eeg on, 1,2: eeg off, 2,1: video on, 2,2: video off
  save([Save_Path Dat_FileName '.ParamWheel'], 'ParamWheel', '-ascii'); 
  
  % -------------------------------------------------------------------------
  % 3. Find the most suitable tracking spots recorded after the SYNC went on
  % (all video since SYNC ON)
  % -------------------------------------------------------------------------
  % structure of TrackLed matrix (1:13)
  % 1.FiledN, 2.size, 3.x, 4.y, 5.sd x, 6.sd y, 7.brightness, 8.Cr, 9.Cb, 10.Red, 11.Green, 12.Blue, 13.cluster 0-2
  % (0-other spot, 1-first selected cluster, 2-second selected cluster)
  
  % structure of SyncTrackPosit matrix
  % (1.FieldN, 2.cluster1(red)-x, 3.cluster1(red)-y, 4.cluster2(green)-x, 5.cluster2(green)-y)
  % if no spots detected -> -1
  
  % Detect the first field of the first upstroak and the last field of the last upstroak
  % keep tracking data between these two time-points = remove fields before and after LED was on/off
  % (1.FieldN, 2.RedLed-x, 3.RedLed-y, 4.GreenLed-x, 5.GreenLed-y), | -1 if not spot detected
  SyncTrackPosit=[];
  SyncTrackPosit(1:length(VideoSync), 5) = zeros;
  SyncTrackPosit = SyncTrackPosit - 1; 
  SyncTrackPosit(:,1) = VideoSync(1,1) : VideoSync(end,1);  
  % n of frame recorded while SYNC led blinking!!!!!!! (no other tracking frames are analyzed)
  
  if MakeTrackMovie == 1
    aviobj = avifile([FileNameBase '_TrackMovie.avi']);
    ReduceMovieDim = 10;
    FrameDimX = ceil(SpotsFrameSizeX / ReduceMovieDim) + 10;
    FrameDimY = ceil(SpotsFrameSizeY / ReduceMovieDim) + 10;
  end
  
  fprintf('\n\n Tracking points are being assingned to fields .... \n');
  for NField = 1 : SyncTrackPosit(end,1) - SyncTrackPosit(1,1) + 1 
    IDField = SyncTrackPosit(NField,1);
    if mod(NField, 2000) == 0
      fprintf([' field #: ' num2str(NField) ' out of ' num2str(SyncTrackPosit(end,1)) '\n']);
    end
    % take only frames that are included in SYNC matrix => recorded while SYNC led blinking  
    NfieldSpots = find(TrackLed(:,1) == IDField);                
    
    % if there are no tracking data in the filed = keep values on -1
    if length(NfieldSpots) > 0
      SyncTrackPosit(NField,:) = FindColorTrackSpots(SyncTrackPosit(NField,:), TrackLed(NfieldSpots,:));
    end
    if MakeTrackMovie == 1
      FrameSpots = SyncTrackPosit(NField,:);
      FrameSpots(FrameSpots>-1) = round(FrameSpots(FrameSpots>-1) / ReduceMovieDim) + 3;                        
      TrackMovieFrame = MakeMovieFrame(FrameSpots, FrameDimX, FrameDimY);
      TrackMovie(NField) = im2frame(TrackMovieFrame);
      a=size(TrackMovieFrame);
      if a(1) ~= FrameDimX |  a(2) ~= FrameDimY
	k=0;
      end
      aviobj = addframe(aviobj,TrackMovieFrame);
    end
  end
  
  save([Save_Path Dat_FileName '.SyncTrackCoord'], 'SyncTrackPosit', '-ascii');
  
  if MakeTrackMovie == 1
    aviobj = close(aviobj);
    movie(TrackMovie);   
    movie2avi(TrackMovie,[FileNameBase '_TrackMovie2.avi']);
  end
  
  if PlotTrackSpots == 1; 
    for  Nfig = 1 : length(SyncTrackPosit)
      DrawTrackSpots(SyncTrackPosit(Nfig,:),SpotsFrameSizeX,SpotsFrameSizeY, NField); 
      if mod(Nfig,1000) == 0
	k=0;
      end
    end
    close gcf;
  end
  
  
  % -------------------------------------------------------------------------
  % 4. Synchronize Eeg and Sync-associated coordinates (coord. upsampled to 1250/32=39.0625Hz)
  % -------------------------------------------------------------------------
  
  % if the same N of stokes - allign them ; if not - WHAT TO DO?????  
  UpsamplCoord(1:length(SyncEeg01),4) = zeros;    
  UpsamplVideoSync(1:length(SyncEeg01)) = zeros;  
  % EegSamplRate = 1250;     % Hz
  % MaxLedDist = 30;         % pixels
  % InterpTrackSamplRate = EegSamplRate / 32;    % wheel file sampling frequency is 1250/32 = 39.06Hz (-> spots samling each 32 eeg data point)
  for Ncoord = 1 : 4              %xRed, yRed, xGreen, yGreen
    switch Ncoord
     case 1; Coord = SyncTrackPosit(:, 1:2);                  % X coordinates of RED spots between two strokes (Nframe, coord)
     case 2; Coord = SyncTrackPosit(:, 1:2:3);                % Y coordinates of RED spots between two strokes
     case 3; Coord = SyncTrackPosit(:, 1:3:4);                % X coordinates of GREEN spots between two strokes
     case 4; Coord = SyncTrackPosit(:, 1:4:5);                % Y coordinates of GREEN spots between two strokes
    end
    
    % remove all -1 values and interpolate remaining coordinates to the original sampling frequency    
    ValidCoord = []; CleanCoord = []; 
    OkCoord = find(Coord(:,2) ~= -1);
    
    % the first and the last frame have coordinates so that coord from all frames can be interpolated
    if Coord(1,2) == -1; Coord(1,2) = Coord(OkCoord(1),2); end  
    if Coord(end,2) == -1; Coord(end,2) = Coord(OkCoord(end),2); end    
    OkCoord = find(Coord(:,2) ~= -1);
    ValidCoord(:,1) = OkCoord;                        % frames with non -1 coordinate values that will be interpolated
    ValidCoord(:,2) = Coord(OkCoord,2);               % frames with non -1 coordinate values that will be interpolated
    CleanCoord(:,1) = (1:length(Coord))';
    CleanCoord(:,2) = (interp1(ValidCoord(:,1), ValidCoord(:,2), 1:length(Coord)))';  
    
    % upsample tracking between each following strokes to 1250 and than reduce to 1250/32=39.0625 Hz    
    for Nstroke = 2 : length(StrokesSyncEeg01)
      EegSampleLength = StrokesSyncEeg01(Nstroke) - StrokesSyncEeg01(Nstroke-1) + 1;         % how many eeg samples between two strokes
      EegTimeCoord = StrokesSyncEeg01(Nstroke-1) : StrokesSyncEeg01(Nstroke);                % coordinates of eeg samples within the SyncEeg01 matrix
      CoordStroke = CleanCoord(StrokesSyncVideo(Nstroke-1):StrokesSyncVideo(Nstroke),2);     % video values to be upsampled        
      KnownCoord = StrokesSyncEeg01(Nstroke-1) : (EegSampleLength-1) / (length(CoordStroke)-1) : StrokesSyncEeg01(Nstroke);    % position of tracking in upsampled matrix                  
      EegTimeCoord = StrokesSyncEeg01(Nstroke-1):StrokesSyncEeg01(Nstroke);                
      UpsamplCoord(EegTimeCoord,Ncoord) = (interp1(KnownCoord, CoordStroke, EegTimeCoord))';              
      
      % upsample VideoSync to check that it matches with SyncEeg01
      if Ncoord == 4
	VideoSyncStroke = VideoSync(StrokesSyncVideo(Nstroke-1):StrokesSyncVideo(Nstroke),2);    % videoSync values to be upsampled        
	UpsamplVideoSync(EegTimeCoord) = (interp1(KnownCoord, VideoSyncStroke, EegTimeCoord))';   
      end
    end  
  end
  
  anf = SyncEeg01(1,1);
  ende = SyncEeg01(end,1);
  neeg = size(orig_eeg,1);
  WheelHigh(anf:ende,:) = UpsamplCoord(:,:);
  WheelHigh(1:anf-1,:) = -1;
  WheelHigh(ende+1:neeg,:) = -1;

  WheelLow(:,:) = WheelHigh(1:32:end,:);
  
  %% downsample tracking from 1250 to 39.0625Hz (N in 1250Hz sampling values!!!!-is it ok????)
  %BitUpsamplCoord(:,1) = SyncEeg01(1:32:end,1);
  %BitUpsamplCoord(:,2:5) = UpsamplCoord(1:32:end,:);
  %BitUpsamplCoordWhl(1:floor(length(orig_eeg)/32),1:4) = ones .* -1;
  %BitUpsamplCoordWhl(BitUpsamplCoord(1,1):BitUpsamplCoord(1,1)+length(BitUpsamplCoord)-1,1:4) = UpsamplCoord(1:32:end,:) 
  %save([Save_Path Dat_FileName '.SyncTrackCoord_1250Hz'], 'UpsamplCoord', '-ascii');
  %%save([Save_Path Dat_FileName '.SyncTrackCoordTime_1250Hz'], 'SyncEeg01', '-ascii');
  %save([Save_Path Dat_FileName '.SyncTrackCoord_39Hz'], 'BitUpsamplCoord', '-ascii');
  %save([Save_Path Dat_FileName '.whl'], 'BitUpsamplCoordWhl', '-ascii');
  
  save([Save_Path Dat_FileName '.high.whl'], 'WheelHigh', '-ascii');
  save([Save_Path Dat_FileName '.whl'], 'WheelLow', '-ascii');
  %%save([Save_Path Dat_FileName '.whl'], 'BitUpsamplCoordWhl', '-ascii');
  
  ScreenSize = get(0,'ScreenSize');
  figure('Position',[1 ScrSize(4)/1.5 ScrSize(3)/1 ScrSize(4)/1]);
  nwin = 40;
  Step = ceil(length(SyncEeg01) / nwin);
  
  if 1
    for sheet = 1 : nwin   
      remove_more=1;        
      if sheet == 1; 
	plot(SyncEeg01((sheet-1)*Step+1:(sheet-1)*Step+Step,2)+1, '.k'); hold on;
	plot(UpsamplVideoSync((sheet-1)*Step+1:(sheet-1)*Step+Step), '.r'); ylim([-0.2 2.2]); hold on;   
      else 
	if sheet < nwin; 
	  plot(SyncEeg01((sheet-1)*Step+1-round(Step/2):(sheet-1)*Step+Step,2)+1, 'x-k'); hold on;
	else plot(SyncEeg01((sheet-1)*Step+1-round(Step/2):end,2)+1, '.k'); hold on;
	end
	if sheet < nwin; 
	  plot(UpsamplVideoSync((sheet-1)*Step+1-round(Step/2):(sheet-1)*Step+Step), '.r'); ylim([-0.2 2.2]); hold on;   
	else plot(UpsamplVideoSync((sheet-1)*Step+1-round(Step/2):end), '.r'); hold on;
	end        
      end
      title('Select all `missplaced` spots (double-click if there are none)');
      while(remove_more==1)          
	[xr, yr] = ginput(2);
	if xr(1) == xr(2) & yr(1) == yr(2); 
	  remove_more=0; 
	  clf;
	  break; 
	end          
	value = round(mean(yr));
	xr = round(xr);
	yr = round(yr);
	if sheet == 1; xr = xr + (sheet-1)*Step;
	else xr = xr + ((sheet-1)*Step) - (round(Step/2));
	end
	SelectedSpot = find(UpsamplVideoSync(min(xr):max(xr)) == value) + min(xr) - 1;
	UpsamplVideoSync(SelectedSpot) = abs(UpsamplVideoSync(SelectedSpot) - 1);  % change 0->1 or 1->0      
	clf;
	plot(SyncEeg01((sheet-1)*Step+1-round(Step/2):(sheet-1)*Step+Step,2)+1, '.k'); hold on;
	plot(UpsamplVideoSync((sheet-1)*Step+1-round(Step/2):(sheet-1)*Step+Step), '.r'); ylim([-0.2 2.2]); hold on;  
	title('Select all `missplaced` spots (double-click if there are none)');
      end
    end
    close gcf;
  end
end






% ==========================================================================================================
%                                            END OF THE FUNCTION
% ==========================================================================================================







% ==========================================================================================================
%                                                THRASH BIN
% ==========================================================================================================



%                                       make a wheel file
% % interpolate x,y coordinates between each up/down state 
% % 1. take one up/down state after each other
% % 2. 
% % 3. 
% % 4. 
% % 5. 
% 
% 
% 
% % upsample x,y coordinates to the 1250/32=39.06Hz freqency
% 
% 
% figure;
% PerSheet = 40000;sheet = 1; 
% PerStep = 1;
% for sheet = 1 : round(length(UpsamplKnownSyncVect) / PerSheet)
%    clf;
%    plot(UpsamplKnownSyncVect(((sheet-1)*PerSheet)+1 : PerStep :sheet*PerSheet)-0.1,'k');
%    hold on;
%    plot(SyncEegOn(((sheet-1)*PerSheet)+1 : PerStep: sheet*PerSheet),'r');
%    ylim([-0.5 1.5]);
%    ginput(1);
% end
% 
% 
% 
% % add -1s at the begining and end of the SyncTrackPosit so that it fits
% % length of eegSync matrix (at video frequency)
% 
% if eeg_sync_analysis == 1; 
%      TimeLedKeptOn = length(SyncEegOn) / EegSamplRate;
%      VideoSamplRate = length(VideoSync) / TimeLedKeptOn;
%      SamplRateRatio = EegSamplRate/VideoSamplRate;
% 
% %      TimeLedKeptOn = (UpDownSyncEeg(end)-UpDownSyncEeg(1) + 1) / EegSamplRate;
% %      VideoSamplRate = length( length(VideoSync)) / TimeLedKeptOn;
%      SyncEegOnMatr = find(SyncEeg01==1);
%      ParamWheel(1,1) = SyncEegOnMatr(1);            % SYNC first ON: Nth eeg sample
%      ParamWheel(2,1) = SyncEegOnMatr(end);          % SYNC last ON: Nth eeg sample
%      VideoOnesMatr = find(VideoSync == 1);
%      ParamWheel(3,1) = VideoOnesMatr(1);                 % SYNC last ON: Nth tracking sample
%      ParamWheel(4,1) = VideoOnesMatr(end);               % SYNC last ON: Nth tracking sample
% 
%      % 1. save detected spots at the video sampling rate (about 30Hz)
%      TimeToLedOn = (UpDownSyncEeg(1) - 1) / EegSamplRate;
%      TimeFromLedOff = (length(SyncEeg01) - UpDownSyncEeg(end) + 1) / EegSamplRate;
%      
%      figure; 
%      subplot(2,2,1); plot(SyncTrackPosit(:,2),SyncTrackPosit(:,3),'.','markersize',1,'color', 'r'); title('RED Led')
%      subplot(2,2,2); plot(SyncTrackPosit(:,4),SyncTrackPosit(:,5),'.','markersize',1,'color', 'g'); title('GREEEN Led')
%      subplot(2,2,3); plot(SyncTrackPosit(:,6),SyncTrackPosit(:,7),'.','markersize',1,'color', 'b'); title('MEAN Led')
% %      subplot(2,2,4); plot(SyncTrackPosit(:,8),SyncTrackPosit(:,9),'.','markersize',1,'color', 'b'); title('MEAN Led')
%      
%      SamplRateRatio = InterpTrackSamplRate/VideoSamplRate;
%      TrackStart(1:round(TimeToLedOn * VideoSamplRate),7) = zeros;          % TimeToLedOff is in SEC = length of eeg recorded prior SYNC went on in sec!
%      TrackStart = TrackStart - 1;
%      TrackEnd(1:round(TimeFromLedOff * VideoSamplRate),7) = zeros;
%      TrackEnd = TrackEnd - 1;
% 
%      RealSyncTrackPosit = [TrackStart; SyncTrackPosit; TrackEnd];     
%      save([Dat_BaseFileName '.wheel_' num2str(VideoSamplRate) 'Hz'], 'RealSyncTrackPosit', '-ascii');
% 
%      % 2. interpolation of detected spots at higher sampling rate (about 39.09Hz)
%      UpsamplKnownTrackVect = [];   
%      [Ncoord y_track] = size(SyncTrackPosit);
%      for col = 2 : y_track
%           KnownTrackVect = [];
%           SamplRateRatio = InterpTrackSamplRate/VideoSamplRate;
%           KnownTrackVect(:,1) = SyncTrackPosit(:,1);
%           KnownTrackVect(:,2) = SyncTrackPosit(:,col);          
% 		KnownTrackVect(:,3) = SyncTrackPosit(:,1) *  SamplRateRatio;          	
%           UpsamplXVector = 1 :  KnownTrackVect(end,3);
%           KnownTrackVect(KnownTrackVect(:,2) <= 0,: ) = [];
%           % yi = interp1(x,Y,xi): x...coord. of know data points, Y...y corresponding to x, xi: at which data points whould yi be interpolated     
% 		UpsamplKnownTrackVect(:,col) = interp1(KnownTrackVect(:,3), KnownTrackVect(:,2), UpsamplXVector);
%      end
%      
%      figure; 
%      subplot(2,2,1); plot(UpsamplKnownTrackVect(:,2),UpsamplKnownTrackVect(:,3),'.','markersize',1,'color', 'r'); title('RED Led');
%      subplot(2,2,2); plot(UpsamplKnownTrackVect(:,4),UpsamplKnownTrackVect(:,5),'.','markersize',1,'color', 'g'); title('GREEEN Led');
%      subplot(2,2,3); plot(UpsamplKnownTrackVect(:,6),UpsamplKnownTrackVect(:,7),'.','markersize',1,'color', 'b'); title('MEAN Led');
% %      subplot(2,2,4); plot(UpsamplKnownTrackVect(:,8),UpsamplKnownTrackVect(:,9),'.','markersize',1,'color', 'b'); title('MEAN Led');
%      TrackStart = []; TrackEnd = [];
%      TrackStart(1:round(TimeToLedOn * InterpTrackSamplRate),7)  = zeros;          % TimeToLedOn is in SEC!
%      TrackStart = TrackStart - 1; 
%      TrackEnd(1:round(TimeFromLedOff * InterpTrackSamplRate),7) = zeros;          % TimeToLedOff is in SEC!
%      TrackEnd = TrackEnd - 1;
%      UpsamplKnownTrackVectAdd = [TrackStart; UpsamplKnownTrackVect; TrackEnd];
%      UpsamplKnownTrackVectAdd(:,1) = 1:length(UpsamplKnownTrackVectAdd);
% 
%      save([Dat_BaseFileName '.Intrapwheel_39Hz'], 'UpsamplKnownTrackVectAdd', '-ascii');
%      
%      % wheel param file: eeg time of the first and last blink of SYNC Led
%      save([Dat_BaseFileName '.wheelparam'], 'ParamWheel', '-ascii');
%      
%      if PlotInterpTrackSpots == 1;
%           for  Nfig = 1 : length(UpsamplKnownTrackVect)
%                DrawTrackSpots(UpsamplKnownTrackVect(Nfig,:),SpotsFrameSizeX,SpotsFrameSizeY, length(UpsamplKnownTrackVect));
%                if mod(Nfig,1000) == 0
%                    k=0;
%                end
%           end
%           close gcf;
%      end
% 
% else
%     
%      % in no eeg sync given   
%      save([Dat_BaseFileName '.NotSynchrWheel'], 'SyncTrackPosit', '-ascii');    

%end



return;





















% 
% 
%     figure(2); 
%   plot(rgb_anal(:,1),rgb_anal(:,2),'.','markersize',1); 
%   xlabel(x_label); ylabel(y_label);    
%   fprintf('\n\n\n Select a square area that contains LEDs.\n');  
%   [xr, yr] = ginput(2);
%   SpotsToKeep = find((rgb_anal(:,1)>=min(xr) & rgb_anal(:,1)<=max(xr) & rgb_anal(:,2)>=min(yr) & rgb_anal(:,2)<=max(yr)));
%   rgb_anal = rgb_anal(SpotsToKeep,:);
%   close figure 2;
%   
%   figure; 
%   plot(rgb_anal(:,1),rgb_anal(:,2),'.','markersize',1); 
%   xlabel(x_label); ylabel(y_label);   
% 
%    
%   figure('Position',[10 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2])
%   plot(LedOnOff,'b');
%   hold on; plot(filt_LedOnOff,'k');
%   ylim([min(filt_LedOnOff)-0.5 max(filt_LedOnOff)+0.5]);
%   hold on; plot(syncVideo,mean(filt_LedOnOff),'og');
%   
%   figure('Position',[1 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2])
%   plot(eeg(1:1000:end),'k');
%   ylim([min(eeg)-0.5 max(eeg)+0.5]);
%   hold on; plot(syncEEG/1000,mean(eeg),'og');
%   
%   fprintf('There are %d video flashes and %d square wave pulses.\n',length(syncVideo),length(syncEEG));
%   
% while length(syncVideo) > length(syncEEG);
%      figure('Position',[10 0 scrsz(3)/2 scrsz(4)/2]);
%      hist(diff(syncVideo));
%      inp = input('type a value of an interval that seems suspisously short in order to check corresponding pulse:  ','s');
%      inp = str2num(inp);
%      close(3);
%      short_int_coord = find(diff(syncVideo)<inp);
%      figure(1);
%      for n = 1 : length(short_int_coord)
%          figure(1);
%          plot(syncVideo(short_int_coord(n)),mean(filt_LedOnOff),'or');
%      end
%      inp = input('type a number of a point that should be excluded (first-1, second-2,...) or hit enter:  ','s');
%      inp = str2num(inp);
%      if inp > 0
%         syncVideo(short_int_coord(n)) = [];
%      end     
%      fprintf('There are %d video flashes and %d square wave pulses.\n',length(syncVideo),length(syncEEG));
%      inp = input('Do you want to repeat this process? (y/n) ','s');
%      if inp == 'n'
%          break
%      end
%   end
%   
%   
%   
% %   pause;
%   close figure 1;
%   close figure 2;
%  
%   
  

  % now we get down to synchronization
  % - find flash points using "Schmitt trigger"
  % i.e. when it goes from 0 to above threshold
%   syncVideo = SchmittTrigger(PixCnt,Thxlimresh,0);     % SchmittTrigger(Signal,UpThresh,DownThresh)

  % Before manual correction:
  %  syncEEG contains the timestamps of the SYNC upstrokes detected in the EEG
  %  syncVideo contains the timestamps of the LED onsets detected in the video
  % After manual correction:
  %  syncEEG and syncVideo will contain the corrected timestamps
  %  syncVideo will be truncated if it is longer than syncEEG, but not the other way around
  %  Therefore, length(syncVideo) <= length(syncEEG)
%   fprintf('\nSynchronization of video and EEG \n--------------------------------\n');
%   while 1,
%       fprintf('   There are %d video flashes and %d square wave pulses.\n',length(syncVideo),length(syncEEG));
%       if length(syncVideo)~=length(syncEEG),
%         fprintf('   ***** MISMATCH! *****\n');
%         inp = input('   To manually correct this, hit ENTER; to drop flashes in excess and continue, type ''done''+ENTER - but you''d better be sure...','s');
%       else
%         inp = input('   To manually edit this, hit ENTER; to continue, type ''done''+ENTER...','s');
%       end
%       if strcmp(inp,'done'),
%           if length(syncVideo) > length(syncEEG),
%               syncVideo = syncVideo(1:length(syncEEG));
%           end
%           break;
%       else
%         [syncVideo,syncEEG] = DisplaySYNC(syncVideo,syncEEG,nSamplesPerScreen);
%       end
%   end
% end

% Before manual correction:
%  syncEEG contains the timestamps of the SYNC upstrokes detected in the EEG
%  syncEvents contains the timestamps of the SYNC events in the .maz file
% After manual correction:
%  syncEEG and syncEvents will contain the corrected timestamps
%  syncEvents will be truncated if it is longer than syncEEG, but not the other way around
%  Therefore, length(syncEvents) <= length(syncEEG)

% if ~exist('events', 'var')
%     events = [];
% end
% if ~isempty(events),
%   fprintf('\nSynchronization of events and EEG\n---------------------------------\n');
%   syncEvents = events(find(events(:,2) == 83 & events(:,3) == 89));
%   while 1,
%       fprintf('   There are %d SYNC events and %d square wave pulses.\n',length(syncEvents),length(syncEEG));
%       if length(syncEvents)~=length(syncEEG),
%         fprintf('   ***** MISMATCH! *****\n');
%         inp = input('   To manually correct this, hit ENTER; to drop flashes in excess and continue, type ''done''+ENTER - but you''d better be sure...','s');
%       else
%         inp = input('   To manually edit this, hit ENTER; to continue, type ''done''+ENTER...','s');
%       end
%       if strcmp(inp,'done'),
%           if length(syncEvents) > length(syncEEG),
%               syncEvents = syncEvents(1:length(syncEEG));
%           end
%           break;
%       else
%         [syncEvents,syncEEG] = DisplaySYNC(syncEvents,syncEEG,nSamplesPerScreen);
%       end
%   end
% end

% if ~isempty(spots),
%   figure(1);
%   subplot(2,2,1);
%   plot(diff(syncVideo),'.-')
%   ylabel('# video frames between flashes');
%   xlabel('flash #');
% 
%   subplot(2,2,2)
%   plot(diff(syncEEG), '.-')
%   ylabel('# EEG samples between flashes');
%   xlabel('flash #');
% 
%   subplot(2,2,3);
% %   [b bint r] =
% %   regress(syncEEG(1:length(syncVideo)),[syncVideo,ones(size(syncVideo))])
% %   ; plot(r/1.25,'.')
%   xlabel('Flash #');
%   ylabel('deviation from linear fit (ms)');
% 
%   subplot(2,2,4);
%   hold off;
%   plot(diff(syncVideo)./diff(syncEEG(1:length(syncVideo)))*1250,'.');
%   FilterLen = 10;
%   f = filter(ones(FilterLen,1)/FilterLen, 1,diff(syncVideo)./diff(syncEEG(1:length(syncVideo)))*1250);
%   hold on;
%   plot(FilterLen:length(f),f(FilterLen:end),'r');
%   ylabel('Frame rate (red is smoothed)');
%   xlabel('Flash #');
%   pause;
%   close figure 1;

  % now align them - any outside sync range become NaN
%   FrameSamples = interp1(syncVideo,syncEEG(1:length(syncVideo)),1:nFrames,'linear',NaN);

  % THE FOLLOWING ONLY WORKS IF YOU HAVE 2 LEDS

  % find non-sync spots_thrash
% % % % % %   NonSyncSpots = find(~IsSyncLed);
  % find those with 2 non-sync spots_thrash per frame
%   NonSyncCnt = Accumulate(1+spots_thrash(NonSyncSpots,1),1);
%   GoodSpots = NonSyncSpots(find(NonSyncCnt(1+spots_thrash(NonSyncSpots,1))==2));
  % select front versus rear LED in color space  
%   clf;



%   figure;
%   plot(spots_thrash(:,7),'.','markersize',1,'color', 'k');
%   min_thr = input('\n\n\n SET MINIMAL AND MAXIMAL VALUE OF THRASHOLD FOR YOUR TRACKING (defalt: MIN=20, MAX=255).\n\n Type MINIMAL value of thrashold and hit enter or hit enter if min value is fine: ','s');
%   max_thr = input('\n Type MAXIMAL value of thrashold and hit enter or hit enter if max value is fine: ','s');
%   if length(str2num(min_thr)) > 0; 
%        min_thr = str2num(min_thr);
%   else min_thr = thrash;
%   end
%   if length(str2num(max_thr)) > 0; 
%        max_thr = str2num(max_thr);
%   else max_thr = 255;
%   end
%   close figure 1
% 
% 
% 
% if ~isempty(events),
%   % Update events: remove all initial SYNC events and replace them with the corrected ones (according to user input)
%   nonSYNC = events(events(:,2) ~= 83 | events(:,3) ~= 89,:);
%   events = [nonSYNC;[syncEvents 83*ones(size(syncEvents)) 89*ones(size(syncEvents))]];
%   events = sortrows(events,1);
%   % Throw any events occurring after the last SYNC event
%   lastSYNC = find(events(:,2) == 83 & events(:,3) == 89);lastSYNC = lastSYNC(end);
%   events = events(1:lastSYNC,:);
%   % Synchronize events on electrophysiological data
%   timestamps = interp1(syncEvents,syncEEG(1:length(syncEvents))/1250*1000,events(:,1),'linear',-1);
%   events(:,1) = timestamps;
%   events = double(uint32(events));
% end
% 
% if ~isempty(spots_thrash),
%   figure(1);
% end
% while 1,
%   inp = input('\n\nSave to disk (yes/no)? ', 's');
%   if strcmp(inp,'yes') | strcmp(inp,'no'), break; end
% end
% if inp(1) == 'y'
%   if ~isempty(spots_thrash),
%     fprintf('Saving %s\n', [FileNameBase '.whl']);
%     msave([FileNameBase '.whl'], Whl);
%   end
%   if ~isempty(events),
%     fprintf('Saving %s\n', [FileNameBase '.evt']);
%     msave([FileNameBase '.evt'],events);
%   end
% end
% 
% if 0 % no longer needed because neuroscope is cool
%   while 1,
%   inp = input('\n\nSave all position information as jpeg (yes/no)? ', 's');
%   if strcmp(inp,'yes') | strcmp(inp,'no'), break; end
%   end
%   if inp(1)=='y'
%     figure;
%     plot(plotWhl(:,1),plotWhl(:,2), '.','color',[0.5 0.5 0.5],'markersize',10,'linestyle','none' );
%     set(gca, 'xlim', [0 videoRes(1)], 'ylim', [0 videoRes(2)], 'Position', [0 0 1 1]);
%     set(gca, 'color', [0 0 0]);
%     set(gcf, 'inverthardcopy', 'off')
%     print(gcf, '-djpeg100', [FileNameBase '.jpg']);
%     eval(['!convert -geometry ' num2str(videoRes(1)) 'x' num2str(videoRes(2)) ' ' FileNameBase '.jpg' ' ' FileNameBase '.jpg']);
%   end
% end

  
    % now align them - any outside sync range become NaN
%   FrameSamples = interp1(syncVideo,syncEEG(1:length(syncVideo)),1:nFrames,'linear',NaN);

  
% 	% now make wheel file by interpolating
%   TargetSamples = 0:32:length(eeg);
%   GoodFrames = find(isfinite(FrameSamples));
%   Whl(:,1:4) = interp1(FrameSamples(GoodFrames),cHeadPos(GoodFrames,:),TargetSamples,'linear',-1);
%   Whl(find(~isfinite(Whl)))=-1;
% % end
% 
% 
% k=0;
% plotWhl = Whl(find(Whl(:,1)~=-1),:);
% fprintf('\nThe Whl file data\n----------------------\n');
% while ~strcmp(input('   Hit ENTER to show the next 100 samples, or type ''done''+ENTER to proceed...','s'),'done'),
%     k = k+1;
%     if k*100 > length(plotWhl), break; end
%     cla;
%     set(gca,'xlim',[0 videoRes(1)],'ylim',[0 videoRes(2)]);
%     plot(plotWhl((k-1)*100+1:k*100,1),plotWhl((k-1)*100+1:k*100,2),'.','color',[1 0 0],'markersize',10,'linestyle','none');
%     plot(plotWhl((k-1)*100+1:k*100,3),plotWhl((k-1)*100+1:k*100,4),'.','color',[0 1 0],'markersize',10,'linestyle','none');
%     for j=(k-1)*100+1:k*100, line([plotWhl(j,1) plotWhl(j,3)],[plotWhl(j,2) plotWhl(j,4)],'color',[0 0 0]); end
%     set(gca,'xlim',[0 videoRes(1)],'ylim',[0 videoRes(2)]);
% end


  % % % % % %   tracking_spots = spots_thrash(NonSyncSpots,:);   
% % % % % %   fprintf('\n\n\n Remove any redundant noisy points.\n');  
% % % % % %   figure; plot(tracking_spots(:,3),tracking_spots(:,4),'.','markersize',10);   
% % % % % %   remove_more=1;
% % % % % %   while(remove_more==1)
% % % % % %        [xr, yr] = ginput(2);
% % % % % %        if xr(1) == xr(2) & yr(1) == yr(2); 
% % % % % %           remove_more=0;  
% % % % % %           close gcf;
% % % % % %           break; 
% % % % % %        end          
% % % % % %        SpotsToKeep = find(~(tracking_spots(:,3)>=min(xr) & tracking_spots(:,3)<=max(xr) & tracking_spots(:,4)>=min(yr) & tracking_spots(:,4)<=max(yr)));
% % % % % %        tracking_spots = tracking_spots(SpotsToKeep,:);
% % % % % %        plot(tracking_spots(:,3),tracking_spots(:,4),'.','markersize',10);            
% % % % % %   end


%   rgb = ycbcr2rgb(spots_thrash(NonSyncSpots,7:9));
  % rgb = ycbcr2rgb(spots_thrash(GoodSpots,7:9));
%   subplot(2,2,1); plot(rgb(:,1),rgb(:,2),'.','markersize',1); xlabel('Red'); ylabel('Green');
%   subplot(2,2,2); plot(rgb(:,1),rgb(:,3),'.','markersize',1); xlabel('Red'); ylabel('Blue');
%   subplot(2,2,3); plot(rgb(:,2),rgb(:,3),'.','markersize',1); xlabel('Green'); ylabel('Blue');
%   i=0;
%   while i == 0
%      i = input('Which projection you would like to use for colores separation? (1-3):','s'); 
%      i = str2num(i);       
%   end
%   close gcf;
%   rgb_anal = 0;
%   if i == 1
%       rgb_anal = rgb(:,1:2); x_label = 'Red'; y_label='Green';
%   elseif i == 2
%       rgb(:,2) = [];
% 	 rgb_anal = rgb; x_label = 'Red'; y_label='Blue';      
%   elseif i == 3
% 	 rgb_anal = rgb(:,2:3); x_label = 'Green'; y_label='Blue';      
%   end
  
  
% % remove all tracking noisy points
% figure;
% plot(TrackSpots(:,3),TrackSpots(:,4),'.','markersize',10, 'Color', 'k');
% title('Remove multiple square areas containing points that you do not consider to be rat`s LEDs');
% remove_more=1;
% fprintf('\n\n\n Remove multiple square areas containing points that you do not consider to be rat`s LEDs.\n If there ane NO/anymore points to remove, double click in a figure.\n');
% while(remove_more==1)
%      [xr, yr] = ginput(2);
%      if xr(1) == xr(2) & yr(1) == yr(2); 
%         remove_more=0;  
%         close gcf;
%         break; 
%      end          
%      TrackSpots = TrackSpots(find(~(TrackSpots(:,3)>=min(xr) & TrackSpots(:,3)<=max(xr) & TrackSpots(:,4)>=min(yr) & TrackSpots(:,4)<=max(yr))),:);
%      plot(TrackSpots(:,3),TrackSpots(:,4),'.','markersize',10, 'Color', 'k');            
% end

% % change value of selected points form 0 to 1 and wise versa
% step = 300;
% ScreenSize = get(0,'ScreenSize');
% for sheet = 1 : floor(length(VideoSync) / step)     
%     remove_more=1;
%     figure('Position', ScreenSize);
%     plot(VideoSync((sheet-1)*step+1:(sheet-1)*step+step), 'x-k'); ylim([-0.5 1.5]); hold on;
%     title('Select all `missplaced` spots (double-click if there are none)');
%     while(remove_more==1)          
%           [xr, yr] = ginput(2);
%           if xr(1) == xr(2) & yr(1) == yr(2); 
%                remove_more=0; 
%                close gcf;    
%                break; 
%           end          
%           value = round(mean(yr));
%           xr = round(xr);
%           yr = round(yr);
%           xr = xr + (sheet-1)*step;
%           SelectedSpot = find(VideoSync(min(xr):max(xr)) == value) + min(xr) - 1;
%           VideoSync(SelectedSpot) = abs(VideoSync(SelectedSpot) - 1);  % change 0->1 or 1->0          
%           close gcf;
%           figure('Position', ScreenSize);
%           plot(VideoSync((sheet-1)*step+1:(sheet-1)*step+step), 'x-k'); ylim([-0.5 1.5]); hold on;ones = find(VideoSync == 1);
%           title('Select all `missplaced` spots (double-click if there are none)');
%      end
% end
% close gcf;
% save([FileNameBase '_VideoSync.txt']','VideoSync','-ascii');


% % Interpolate video SYNC signal - 30Hz (VideoSync) to the frequency of eeg SYNC signal 1250 Hz (EegSync01)
% % yi = interp1(x,Y,xi) returns vector yi containing elements corresponding to the elements of xi 
% % and determined by interpolation within vectors x and Y. The vector x specifies the points at which the data Y is given
% 
% VideoSyncInterp = interp1([1:length(EegSyncCut)/length(VideoSyncCut):length(EegSyncCut)], VideoSyncCut, EegSyncCut);
% 
% % detect all VideoSync and EegSync01 data between the first pulse and the
% % last pulse -> measure if time corresponding to N of samples is the same
% % yes: none of the files shorter than sync -> fill tracking data into video
% % sync matrice
% % no: find shorter one and take only corresponding N of tracking fields
% % to do: CHECK THE BEGINNING OF VIDEO AND EEG SYNCS
% % to do: CHECK Crashed recordingS
% ones = find(VideoSync == 1);
% VideoSyncCut = VideoSync;
% VideoSyncCut(1:ones(1)-1) = [];
% VideoSyncCut(ones(end)+1:end) = [];
% VideoSyncLength  = length(VideoSyncCut) / FieldsPerSec;
% 
% ones = find(EegSync01 == 1);
% EegSyncCut = EegSync01;
% EegSyncCut(1:ones(1)-1) = [];
% EegSyncCut(ones(end)+1:end) = [];
% EegSyncLength  = length(EegSyncCut) / EegSamplRate;
% 
% % N of fields from the shorter signal
% if VideoSyncLength == EegSyncLength
%     NfieldsToAnalyse = VideoSyncLength; 
% elseif VideoSyncLength > EegSyncLength       % electrophysiol crashed before syncLED turned off
%     NfieldsToAnalyse = EegSyncLength;     
% elseif VideoSyncLength < EegSyncLength       % video crashed before syncLED turned off
%     NfieldsToAnalyse = VideoSyncLength;     
% end


%     if length(NfieldSpots) == 1                      % ONE point detected in the field
%         FillClusterSpot(TrackLedTable(nfield,:), TrackLed(NfieldSpots(1),:));    
%     elseif length(NfieldSpots) == 2                  % TWO points detected in the field
%         dist = CountDist(TrackLed(NfieldSpots(1),3),TrackLed(NfieldSpots(1),4),TrackLed(NfieldSpots(2),3),TrackLed(NfieldSpots(2),4));
%         if dist > MaxLedDist                                % if distance between two detected spots too large
%            if TrackLed(NfieldSpots(1),13) == 0;             % if one of them cluster 0 -> take the other spot
%                FillClusterSpot(TrackLedTable(nfield,:), TrackLed(NfieldSpots(1),:));  
%            else                                             % if both belong to cluster 1 or 2 ????????? 
%               % ?????????????????????????????????? 
%            end
%         else                                                % if distance between two detected spots not too long: assign them according clusters
%            if TrackLed(NfieldSpots(1),13) ==  TrackLed(NfieldSpots(2),13);            % if both spots belong to the same cluster                                        
%                 FillClusterSpot(TrackLedTable(nfield,:), TrackLed(NfieldSpots(1),:));   %  assign the first one to its cluster
%                 TrackLed(NfieldSpots(2),13) = 0;
%                 FillClusterSpot(TrackLedTable(nfield,:), TrackLed(NfieldSpots(2),:));   %  and the second one to cluster 0 
%            else                                             % if each of them belongs to different cluster                                               
%                 FillClusterSpot(TrackLedTable(nfield,:), TrackLed(NfieldSpots(1),:));   %  assign the first one to its cluster
%                 FillClusterSpot(TrackLedTable(nfield,:), TrackLed(NfieldSpots(2),:));   %  and the second one to cluster 0 
%            end    
%         end 
%     elseif length(TrackLed(nfield,1)) == 3           % THREE points detected in the field
%         dist12 = CountDist(TrackLed(NfieldSpots(1),3),TrackLed(NfieldSpots(1),4),TrackLed(NfieldSpots(2),3),TrackLed(NfieldSpots(2),4));
%         dist13 = CountDist(TrackLed(NfieldSpots(1),3),TrackLed(NfieldSpots(1),4),TrackLed(NfieldSpots(3),3),TrackLed(NfieldSpots(3),4));
%         dist23 = CountDist(TrackLed(NfieldSpots(2),3),TrackLed(NfieldSpots(2),4),TrackLed(NfieldSpots(3),3),TrackLed(NfieldSpots(3),4));
%         if dist12 > MaxLedDist & dist13 > MaxLedDist & dist23 < MaxLedDist       % if spot 1 too far from other two spots - use the other two
%                 FillClusterSpot(TrackLedTable(nfield,:), TrackLed(NfieldSpots(2),:));  
%                 FillClusterSpot(TrackLedTable(nfield,:), TrackLed(NfieldSpots(3),:));  
%         elseif dist12 > MaxLedDist & dist23 > MaxLedDist & dist23 < MaxLedDist       % if spot 2 too far from other two spots - use the other two
%                 FillClusterSpot(TrackLedTable(nfield,:), TrackLed(NfieldSpots(1),:)); 
%                 FillClusterSpot(TrackLedTable(nfield,:), TrackLed(NfieldSpots(3),:));  
%         elseif dist13 > MaxLedDist & dist13 > MaxLedDist & dist23 < MaxLedDist       % if spot 3 too far from other two spots - use the other two
%                 FillClusterSpot(TrackLedTable(nfield,:), TrackLed(NfieldSpots(1),:));  
%                 FillClusterSpot(TrackLedTable(nfield,:), TrackLed(NfieldSpots(2),:));  
%         elseif dist13 < MaxLedDist & dist13 < MaxLedDist & dist23 < MaxLedDist       % if all spots close to each other            
%                 FillClusterSpot(TrackLedTable(nfield,:), TrackLed(NfieldSpots(1),:));   %  assign all three spots according to their clusters
%                 FillClusterSpot(TrackLedTable(nfield,:), TrackLed(NfieldSpots(2),:));
%                 FillClusterSpot(TrackLedTable(nfield,:), TrackLed(NfieldSpots(3),:));                
%         end    % if all three spots too appart from each other - none of them is assigned to the TrackLedTable table
%     elseif length(TrackLed(nfield,1)) > 3           % FOUR or more points detected in the field            
%         Nclu1 = find(TrackLed(NfieldSpots,13) == 1);                                 % how many spots belong to cluster 1?
%         Nclu2 = find(TrackLed(NfieldSpots,13) == 2);                                 % how many spots belong to cluster 2?
%         Nclu0 = find(TrackLed(NfieldSpots,13) == 0);                                 % how many spots belong to cluster 0?         
%         
%     end

% % upsample video SYNC pulse to the EegSync freqency and compare it with eeg SYNC
% UpsamplKnownSyncVect = [];   
% KnownSyncTrackVect = [];
% TimeLedKeptOn = length(SyncEegOn) / EegSamplRate;
% VideoSamplRate = length(VideoSync) / TimeLedKeptOn;
% SamplRateRatio = EegSamplRate/VideoSamplRate;
% KnownSyncTrackVect(:,1) = 1 : length(VideoSync);
% KnownSyncTrackVect(:,2) = VideoSync;             % zeros and ones          
% KnownSyncTrackVect(:,3) = (KnownSyncTrackVect(:,1) * SamplRateRatio);          	
% UpsamplXSyncVector = round(KnownSyncTrackVect(1,1)) :  round(KnownSyncTrackVect(end,3));
% % yi = interp1(x,Y,xi): x...coord. of know data points, Y...y corresponding to x, xi: at which data points whould yi be interpolated     
% UpsamplKnownSyncVect = interp1(KnownSyncTrackVect(:,3), KnownSyncTrackVect(:,2), UpsamplXSyncVector);         % m48: 1.364.813
%     

% % upsample video sync signal to the 1250Hz freq.
% UpsamplKnownSyncVect = [];   
% KnownSyncTrackVect = [];
% TimeLedKeptOn = length(SyncEeg01) / EegSamplRate;
% VideoSamplRate = length(VideoSync) / TimeLedKeptOn;
% SamplRateRatio = EegSamplRate/VideoSamplRate;
% KnownSyncTrackVect(:,1) = 1 : length(VideoSync);
% KnownSyncTrackVect(:,2) = VideoSync;             % zeros and ones          
% KnownSyncTrackVect(:,3) = 1 : SamplRateRatio : length(SyncEeg01); %KnownSyncTrackVect(1,1) :  : KnownSyncTrackVect(end,1);          	
% UpsamplXSyncVector = round(KnownSyncTrackVect(1,1)) :  round(KnownSyncTrackVect(end,3));
% % yi = interp1(x,Y,xi): x...coord. of know data points, Y...y corresponding to x, xi: at which data points whould yi be interpolated     
% UpsamplKnownSyncVect = interp1(KnownSyncTrackVect(:,3), KnownSyncTrackVect(:,2), UpsamplXSyncVector);         % m48: 1.364.813
% 
% % clean SYNC up/down signal (change value of selected points form 0 to 1 and vise versa)
% nwin = 40;
% EegVidDiff = (length(SyncEeg01)-length(UpsamplKnownSyncVect));
% if EegVidDiff < 0;
%     UpsamplKnownSyncVect(end - abs(EegVidDiff) + 1:end) = [];    
% else EegVidDiff > 0;
%     UpsamplKnownSyncVect = UpsamplKnownSyncVect(1: end - abs(EegVidDiff));    
% end 
% 
% Step = ceil(length(SyncEeg) / nwin);

% % UpDownSyncVideo = SchmittTriggerUpDown(VideoSync,0.9,0.9);
% DownSyncEeg01 = SyncEeg01(1: floor(length(SyncEeg01)/length(VideoSync)) :end);
% DownSyncEeg01 = DownSyncEeg01 - min(DownSyncEeg01);
% DownSyncEeg01 = DownSyncEeg01 / max(DownSyncEeg01);
% % UpDownSyncEeg = SchmittTriggerUpDown(DownSyncEeg01,mean(DownSyncEeg01),mean(DownSyncEeg01));
% EegStep = round(length(DownSyncEeg01) / nwin);
% 
% wnSyncVideo = SchmittTriggerUpDown(UpsamplKnownSyncVect,0.9,0.9);
% UpDownSyncEeg = SchmittTriggerUpDown(SyncEeg,mean(SyncEeg),mean(SyncEeg));
% 
% length(SchmittTriggerUpDown(SyncEeg,0.5,0.5))
% length(SchmittTriggerUpDown(UpsamplKnownSyncVect,0.9,0.9))
% 
% % limit EEG Sync matrix just for time when LED was blinking
% % SyncEegOn = SyncEeg01;
% % SyncEegOnes = find(SyncEegOn==1);
% % SyncEegOn(SyncEegOnes(end)+1:end) = [];                                                                     % m48: 1.364.813
% % SyncEegOn(1:SyncEegOnes(1)-1) = [];
% 
% % upsample video sync signal to the 1250Hz freq.
% UpsamplKnownSyncVect = [];   
% KnownSyncTrackVect = [];
% TimeLedKeptOn = length(SyncEeg01) / EegSamplRate;
% VideoSamplRate = length(VideoSync) / TimeLedKeptOn;
% SamplRateRatio = EegSamplRate/VideoSamplRate;
% KnownSyncTrackVect(:,1) = 1 : length(VideoSync);
% KnownSyncTrackVect(:,2) = VideoSync;             % zeros and ones          
% KnownSyncTrackVect(:,3) = 1 : SamplRateRatio : length(SyncEeg01); %KnownSyncTrackVect(1,1) :  : KnownSyncTrackVect(end,1);          	
% UpsamplXSyncVector = round(KnownSyncTrackVect(1,1)) :  round(KnownSyncTrackVect(end,3));
% % yi = interp1(x,Y,xi): x...coord. of know data points, Y...y corresponding to x, xi: at which data points whould yi be interpolated     
% UpsamplKnownSyncVect = interp1(KnownSyncTrackVect(:,3), KnownSyncTrackVect(:,2), UpsamplXSyncVector);         % m48: 1.364.813
% 
% % detect N of Up&DownStroaks in VideoSync data
% PulseTrig = 0.9;
% UpDownSyncVideo = SchmittTriggerUpDown(VideoSync,PulseTrig,PulseTrig);
% UpDownUpsampledSyncVideo = SchmittTriggerUpDown(UpsamplKnownSyncVect,PulseTrig,PulseTrig);
% UpDownSyncEeg = SchmittTriggerUpDown(SyncEegOn,PulseTrig,PulseTrig);
% fprintf('N of Video strokes:  %d. \n', length(UpDownSyncVideo));
% fprintf('N of Eeg strokes:    %d. \n', length(UpDownSyncEeg));
% if length(UpDownSyncVideo) ~= length(UpDownSyncEeg)
%     fprintf('\n N of Video and Eeg strokes is not equal!!! \n');
% end
% 
% % plot upsampl-video sync signal + eeg sync + up/down strokes for each of them
% 
% step = round((1250/VideoSamplRate)*300);
% overlap = 2;
% ScreenSize = get(0,'ScreenSize');
% figure('Position', ScreenSize);
% for sheet = 1 : floor(length(VideoSync) / step)     
%     remove_more=1;        
%     if sheet == 1; 
%         plot(UpsamplKnownSyncVect((sheet-1)*step+1:(sheet-1)*step+step), 'x-r'); ylim([-0.5 1.5]); hold on;
%         VideoStrokes = find(UpDownUpsampledSyncVideo>(sheet-1)*step+1 & UpDownUpsampledSyncVideo<(sheet-1)*step+step); 
%         plot(UpDownUpsampledSyncVideo(VideoStrokes),0.9,'og');
%         plot(SyncEegOn((sheet-1)*step+1:(sheet-1)*step+step)+2, 'x-k'); ylim([-0.5 1.5]); hold on;
%         EegStrokes = find(UpDownSyncEeg>(sheet-1)*step+1 & UpDownSyncEeg<(sheet-1)*step+step); 
%         plot(UpDownSyncEeg(EegStrokes),0.9,'ob');      
%         
%         %line([]);
%     else 
%         plot(VideoSync((sheet-1)*step+1-(round(step/overlap)):(sheet-1)*step+step), 'x-k'); ylim([-0.5 1.5]); hold on;
%         VideoStrokes = find(UpDownUpsampledSyncVideo>(sheet-1)*step+1-(round(step/overlap)) & UpDownUpsampledSyncVideo<(sheet-1)*step+step-(round(step/overlap))); 
%         plot(UpDownUpsampledSyncVideo(VideoStrokes),0.9,'og');
%         plot(SyncEegOn((sheet-1)*step+1-(round(step/overlap)):(sheet-1)*step+step), 'x-k')+2; ylim([-0.5 1.5]); hold on;
%         EegStrokes = find(UpDownSyncEeg>(sheet-1)*step+1-(round(step/overlap)) & UpDownSyncEeg<(sheet-1)*step+step-(round(step/overlap))); 
%         plot(UpDownSyncEeg(EegStrokes),0.9,'ob');
%     end
%     title('Select all `missplaced` spots (double-click if there are none)');
%     while(remove_more==1)          
%           [xr, yr] = ginput(2);
%           if xr(1) == xr(2) & yr(1) == yr(2); 
%                remove_more=0; 
%                clf;
%                break; 
%           end          
%           value = round(mean(yr));
%           xr = round(xr);
%           yr = round(yr);
%           if sheet == 1; xr = xr + (sheet-1)*step;
%           else xr = xr + ((sheet-1)*step) - (round(step/2));
%           end
%           SelectedSpot = find(VideoSync(min(xr):max(xr)) == value) + min(xr) - 1;
%           VideoSync(SelectedSpot) = abs(VideoSync(SelectedSpot) - 1);  % change 0->1 or 1->0          
%           clf;
%           plot(VideoSync((sheet-1)*step+1-(round(step/2)):(sheet-1)*step+step), 'x-k'); ylim([-0.5 1.5]); hold on;
%           ones = find(VideoSync == 1);
%           title('Select all `missplaced` spots (double-click if there are none)');
%      end
% end
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% % upsample video sync always only between two following strokes for 1250Hz
% UpsamplVideoSyncVect = [];
% for UpDown = 1 : length(UpDownSyncEeg)
%     VideoSyncNewMatrix = [];
%     VideoSyncValues = [];
%     UpSamplCoord = [];    
%     if UpDown == 1;                
%         VideoSyncValues = VideoSync(1:UpDownSyncVideo(UpDown));                       % values of VideoSync between two up/down strokes
%         UpStep = length(1:UpDownSyncEeg(UpDown))/length(1:UpDownSyncVideo(UpDown));   % values of VideoSync interpol x coordinates
%         VideoSyncNewMatrix = 1 : UpStep : UpDownSyncEeg(UpDown); 
%         UpSamplCoord = 1:SyncEegOn(UpDownSyncEeg(UpDown));                            % values of SyncEegVideo between two up/down strokes
%     else 
%         VideoSyncValues = VideoSync(UpDownSyncVideo(UpDown-1) : UpDownSyncVideo(UpDown));
%         UpStep = length(UpDownSyncEeg(UpDown-1):UpDownSyncEeg(UpDown))/length(UpDownSyncVideo(UpDown-1):UpDownSyncVideo(UpDown));
%         VideoSyncNewMatrix = 1 : UpStep : UpDownSyncEeg(UpDown)-UpDownSyncEeg(UpDown-1); 
%         UpSamplCoord = UpDownSyncEeg(UpDown-1):UpDownSyncEeg(UpDown);      
%     end     
%     % yi = interp1(x,Y,xi): x...coord. of know data points, Y...y corresponding to x, xi: at which data points whould yi be interpolated     
%     Upsampl = interp1(VideoSyncNewMatrix, VideoSyncValues, UpSamplCoord);  
%     UpsamplVideoSyncVect = [UpsamplVideoSyncVect Upsampl];
% end        
% 
% 




