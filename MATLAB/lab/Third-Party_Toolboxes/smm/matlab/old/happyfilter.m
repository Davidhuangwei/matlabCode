function smoothpower = happyfilter(filebase,fileext,numchannel,channels,lowband,highband,forder,avgfilorder,DBconversion,savefilt,savepow)

if ~exist('savefilt', 'var')
    savefilt = 0;
end
if ~exist('savepow', 'var')
    savepow = 0;
end
if ~exist('DBconversion', 'var')
     DBconversion = 0;
end


%%%%%%%%%% parameters to play with %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% parameters for program flow control
verbose = 1;
showfiltchar = 0;
showrealanal = 1;
pause on;

% parameters for detection tuning
sampl = 1250; % sampling rate of the eegh file in Hz (5kHz)

               % filter order has to be even; .. the longer the more
               % selective, but the operation will be linearly slower
    	       % to the filter order
               % avgfilorder should be odd. length of averaging filter
avgfilterdelay = floor(avgfilorder/2);  % compensated delay period
forder = ceil(forder/2)*2;           %make sure filter order is even

% parameters for ripple period (ms)
min_sw_period = 50 ; % minimum sharpwave period = 50ms ~ 6 cycles 
max_sw_period = 250; % maximum sharpwave period = 250ms ~ 30 cycles
                     % of ripples (max, not used now)
min_isw_period = 30; % minimum inter-sharpwave period;

% threshold SD (standard deviation) for ripple detection 
thresholdf = 4;     % threshold for ripple detection
max_thresholdf = 7; % the peak of the detected region must satisfy
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

inname = [filebase fileext];

verdisp('filtering...',verbose);
thresholdbuffer = readmulti(inname,numchannel,channels); % from .eeg
filtered_data = Filter0(firfiltb,thresholdbuffer); % filtering
clear thresholdbuffer;

if savefilt,
    outname = [filebase '_' num2str(lowband) '-' num2str(highband) 'Hz' fileext '.filt'];
    fprintf('Saving %s\n', outname);
    bsave(outname,filtered_data','int16');
end

power = filtered_data.^2; 
clear filtered_data;
smoothpower = Filter0(avgfiltb,power); % averaging & 
clear power;

if savepow,
    outname = [filebase '_' num2str(lowband) '-' num2str(highband) 'Hz' fileext '.100DBpow'];
    fprintf('Saving %s\n', outname);
    bsave(outname,1000*log10(smoothpower'),'int16');
end

if (DBconversion),
    smoothpower = 10*log10(smoothpower);
end
return 
