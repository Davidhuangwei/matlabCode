% function sdetected = ripdetecth(inname,numchannel,channels)
% channels start from 1. (unlike josef's program.. it uses in matlab
% indexing convention); (must supply .eegh file, sampled at 5khz, 
% channel 1 of 1), results are returned in eegh unit (5kHz). 

function sdetected = ripdetecth(inname,numchannel,channels,showrealanal)

if nargin==3
    showrealanal=1;
else
    % do nothing
end

%%%%%%%%%% parameters to play with %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% parameters for program flow control
verbose = 1;
showfiltchar = 0;
showrealanal = 1;
pause on;

% parameters for detection tuning
sampl = 1250; % sampling rate of the eegh file in Hz (5kHz)

highband = 180; % bandpass filter range (180Hz to 90Hz)
lowband = 90; % 

forder = 500;  % filter order has to be even; .. the longer the more
               % selective, but the operation will be linearly slower
    	       % to the filter order
avgfilorder = 501; % do not change this... length of averaging filter
avgfilterdelay = floor(avgfilorder/2);  % compensated delay period
forder = ceil(forder/2)*2;           %make sure filter order is even

% parameters for ripple period (ms)
min_sw_period = 50 ; % minimum sharpwave period = 50ms ~ 6 cycles 
max_sw_period = 250; % maximum sharpwave period = 250ms ~ 30 cycles
                     % of ripples (max, not used now)
min_isw_period = 30; % minimum inter-sharpwave period;

% threshold SD (standard deviation) for ripple detection 
thresholdf = 3;     % threshold for ripple detection
max_thresholdf = 6; % the peak of the detected region must satisfy
                    % this value on top of being  supra-thresholdf.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% changing something below this line will result in changing the
% algorithm (i.e. not the parameter)                       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% calculate the convolution function (passbands are normalized to
% the Nyquist frequency)
firfiltb = fir1(forder,[lowband/sampl*2,highband/sampl*2]);
avgfiltb = ones(avgfilorder,1)/avgfilorder;

% determine the threshold
verdisp('computing threshold...',verbose);
thresholdbuffer = readmulti(inname,numchannel,channels); % from .eeg
filtered_data = Filter0(firfiltb,thresholdbuffer); % filtering
filtered_data2 = filtered_data.^2; % filtered * filtered >0
sdat = unity(Filter0(avgfiltb,sum(filtered_data2,2))); % averaging & 
                                                       % standardizing

% (1) primary detection of ripple periods, based on thresholding
thresholded = sdat > thresholdf;
primary_detection_b = find(diff(thresholded)>0);
primary_detection_e = find(diff(thresholded)<0);

% exclude ranged-out (1st or last) ripples
if (length(primary_detection_e) == length(primary_detection_b)-1)
    primary_detection_b = primary_detection_b(1:end-1);
end

if (length(primary_detection_e)-1 == length(primary_detection_b))
    primary_detection_e = primary_detection_e(2:end);
end
primary = [primary_detection_b,primary_detection_e];

% (2) secondary, merge ripples, if inter-ripples period is less
% than min_isw_period;
min_period = min_isw_period/1000 * sampl;

if isempty(primary) 
    return
end
secondary=[];
tmp_rip = primary(1,:);

for ii=2:size(primary,1)
    if (primary(ii,1)-tmp_rip(2)) <min_period
        % merge two ripples
        tmp_rip = [tmp_rip(1),primary(ii,2)];
    else
        secondary = [secondary;tmp_rip];
        tmp_rip = primary(ii,:);
    end    
end
secondary = [secondary;tmp_rip];

% (3) third, ripples must have it's peak power of > max_thresholdf
if isempty(secondary)
    return
end
third = [];
SDmax = [];

for ii=1:size(secondary,1)
    [max_val,max_idx] = max(sdat([secondary(ii,1):secondary(ii,2)]));
    if max_val > max_thresholdf
        third = [third;secondary(ii,:)];
        SDmax = [SDmax;max_val];
    end
end
third;
SDmax;

% (4) Fourth, detection of negative peak position of each ripple
medium_val = zeros(size(third,1),1);

for ii=1:size(third,1)
    [minval,minidx] = min (filtered_data(third(ii,1):third(ii,2)));
    medium_val(ii) = minidx+third(ii,1);
end

% anser of this function...
sdetected = [third(:,1),medium_val,third(:,2),SDmax];

% whos

 %plot result (Fig. 0)
 if showrealanal==1
    figure(1);
    clf
    taxis = [1:length(thresholdbuffer)]/5000*1000; % in ms
    plot(taxis(1:2:end),unity(thresholdbuffer(1:2:end,1))+10,'b');
    hold on;
    plot(taxis(1:4:end),unity(filtered_data(1:4:end,1))/3+14,'k');
    plot(taxis(1:8:end),sdat(1:8:end),'r');
    plot([taxis(1),taxis(end)],[thresholdf,thresholdf],'k-.');
    plot([taxis(1),taxis(end)],[max_thresholdf,max_thresholdf],'k:');

    for ii=1:size(sdetected,1)
        plot([sdetected(ii,1), sdetected(ii,1)]/5000*1000,...
            [-2,18],'k-');
    end
   
    for ii=1:size(sdetected,1)
        plot([sdetected(ii,3), sdetected(ii,3)]/5000*1000,...
            [-2,18],'k:');
    end
end
