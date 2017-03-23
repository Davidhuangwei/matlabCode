% eegfilt() - (high|low|band)pass filter EEG data using two-way least-squares 
%              FIR filtering. Multiple data channels and epochs supported.
%                    (Requires the Signal Processing Toolbox)
% Usage:
%        >> [smoothdata] = eegfilt(data,srate,locutoff,hicutoff);
% or
%   [smoothdata,filtwts] = eegfilt(data,srate,locutoff,hicutoff, ...
%                                             epochframes,filtorder);
% Inputs:
%    data       = (channels,frames*epochs) data to filter
%    srate      = data sampling rate (Hz)
%    locutoff   = low edge frequency in pass band (Hz)  {0 -> lowpass}
%    hicutoff   = high edge frequency in pass band (Hz) {0 -> highpass}
%
%    epochframes= frames per epoch (filter each epoch separately {def/0: all}
%    filtorder  = length of the filter in points {default 3*fix(srate/locutoff)}
%
% Outputs:
%    smoothdata = smoothed data
%    filtwts    = filter coefficients [smoothdata <- filtfilt(filtwts,1,data)]

% 4-22-97 Scott Makeig CNL / Salk Institute, La Jolla CA from bandpass.m
% 5-08-97 fixed frequency bound computation -sm
% 10-22-97 added MINFREQ tests -sm

function [smoothdata,filtwts] = eegfilt(data,srate,locutoff,hicutoff,epochframes,filtorder)

if nargin<4
    fprintf('');
    help eegfilt
    return
end

if ~exist('firls')
   fprintf('\n*** eegfilt() requires the signal processing toolbox.\ ***n\n');
   return
end

[chans frames] = size(data);
if chans > 1 & frames == 1,
    help eegfilt
    fprintf('eegfilt() - input data should be a row vector.\n\n');
    return
end
nyq            = srate*0.5;  % Nyquist frequency
MINFREQ = 0.1/nyq;

minfac         = 3;    % this many (lo)cutoff-freq cycles in filter 
min_filtorder  = 15;   % minimum filter length
trans          = 0.25; % fractional width of transition zones

if locutoff>0 & hicutoff > 0 & locutoff > hicutoff,
    fprintf('\n eegfilt(): locutoff > hicutoff ???\n');
    help eegfilt
    return
end
if locutoff < 0 | hicutoff < 0,
   help eegfilt
   return
end

if locutoff>nyq,
    fprintf('\n eegfilt(): locutoff cannot be > srate/2.\n.',nyq);
    help eegfilt
    return
end

if hicutoff>=nyq
   hicutoff = 0; 
end

if nargin<6
   filtorder = 0;
end

if filtorder==0,
   if locutoff>0,
     filtorder = minfac*fix(srate/locutoff);
   elseif hicutoff>0,
     filtorder = minfac*fix(srate/hicutoff);
   end
     
   if filtorder < min_filtorder
        filtorder == min_filtorder;
    end
end

if nargin<5
       epochframes = 0;
end
if epochframes ==0,
    epochframes = frames;    % default
end
epochs = fix(frames/epochframes);
if epochs*epochframes ~= frames,
    fprintf('eegfilt(): epochframes does not divide frames.\n');
    return
end

if filtorder*3 > epochframes,   % Matlab filtfilt() restriction
    fprintf('eegfilt(): epochframes must be 3 times the filtorder.\n');
    return
end

if locutoff > 0 & hicutoff > 0,    % bandpass filter
  fprintf('eegfilt() - performing %d-point bandpass filtering.\n',filtorder);
  f=[MINFREQ (1-trans)*locutoff/nyq locutoff/nyq hicutoff/nyq (1+trans)*hicutoff/nyq 1]; 
  m=[0       0                      1            1            0                      0]; 
elseif locutoff > 0                % highpass filter
 if locutoff/nyq < MINFREQ
    help eegfilt
    fprintf('eegfilt() - highpass cutoff freq must be > %g Hz\n\n',MINFREQ*nyq);
    return
 end
 fprintf('eegfilter() - performing %d-point highpass filtering.\n',filtorder);
 f=[MINFREQ locutoff*(1-trans)/nyq locutoff/nyq 1]; 
 m=[   0             0                   1      1];
elseif hicutoff > 0                %  lowpass filter
 if hicutoff/nyq < MINFREQ
    help eegfilt
    fprintf('eegfilt() - lowpass cutoff freq must be > %g Hz\n\n',MINFREQ*nyq);
    return
 end
 fprintf('eegfilt() - performing %d-point lowpass filtering.\n',filtorder);
 f=[MINFREQ hicutoff/nyq hicutoff*(1+trans)/nyq 1]; 
 m=[     1           1              0                 0];
else
 help eegfilt
 return
end

filtwts = firls(filtorder,f,m); % get FIR filter coefficients

smoothdata = zeros(chans,frames);
for e = 1:epochs                % filter each epoch, channel 
    for c=1:chans
      smoothdata(c,(e-1)*epochframes+1:e*epochframes) ...
        = filtfilt(filtwts,1,data(c,(e-1)*epochframes+1:e*epochframes));
    end
end

