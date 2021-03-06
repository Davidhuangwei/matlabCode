%-----------------------------------------------------------------------------------------------------%
% Description of the output variables generated by ANALYZE_XYDATA (ANALYSIS OF BEHAVIOR toolbox.) 
%-----------------------------------------------------------------------------------------------------%

% distance.stamps               - distribution of occupancy time over subareas of the arena (s)
% distance.x, .y, .times        - animal track (pixels)
% raw_minbymin                  - raw animal tracks split minute-by-minute 
% distance.duration             - total duration of the session (s)
% distance.DensityMatrix        - is a 2D density map (each visit to the pixel is counted as 1). 
% distance.DensityMatrix_cmbins - is a 2D density map with pixel resolution of 1 cm 

% distance.raw      - distances travelled between two consequtive frames(cm); 
% distance.duration - time intervals between two consequtive frames (s, at f=25Hz, must be 0.04 s); 
% distance.all      - total distance travelled during the recording
% distance.median   - median of the distance distribution, calculated from consequtive frames (cm)
% distance.mean     - mean of the distance distribution, calculated from consequtive frames (cm)
% distance.std      - SD of the distance distribution, calculated from consequtive frames (cm)
% distance.max      - MAX of the distance distribution, calculated from consequtive frames (cm)
% distance.min      - MIN of the distance distribution, calculated from consequtive frames (cm)

% distance.secondbysecond - second-by-second distances (travelled between two consequtive seconds, cm)
% distance.acc_dece - second-by-second acceleration/deceleration (cm/s^2)

% distance.cumulative_raw            - second-by-second cumulative distances (cm).
% distance.cumulative_normalized     - second-by-second cumulative distances normalized by the total distance travelled.
% distance.minutebyminute_timestamps - binned time stamps converted from s into min.
% distance.minutebyminute            - minute-by-minute distances (travelled between two consequtive minutes, cm)
% distance.minutebyminute_ratio      - minute-by-minute distances normalized by the total distance travelled.




