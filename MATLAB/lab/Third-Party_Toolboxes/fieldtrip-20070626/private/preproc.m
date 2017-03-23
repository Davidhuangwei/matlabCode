function [dat, label, time, cfg] = preproc(dat, label, fsample, cfg, offset, begpadding, endpadding);

% PREPROC applies various preprocessing steps on a piece of EEG/MEG data
% that already has been read from a data file. 
%
% This function can serve as a subfunction for all FieldTrip modules that
% want to preprocess the data, such as PREPROCESSING, ARTIFACT_XXX,
% TIMELOCKANALYSIS, etc. It ensures consistent handling of both MEG and EEG
% data and consistency in the use of all preprocessing configuration
% options.
%
% Use as
%   [dat, label, time, cfg] = preproc(dat, label, fsample, cfg, offset, begpadding, endpadding)
%
% The required input arguments are
%   dat         Nchan x Ntime data matrix
%   label       Nchan x 1 cell-array with channel labels
%   cfg         configuration structure, see below
%   fsample     sampling frequency
% and the optional input arguments are
%   offset      of the first datasample (see below)
%   begpadding  number of samples used for padding (see below)
%   endpadding  number of samples used for padding (see below)
%
% The output is
%   dat         Nchan x Ntime data matrix
%   label       Nchan x 1 cell-array with channel labels
%   time        Ntime x 1 vector with the latency in seconds
%   cfg         configuration structure, optionally with extra defaults set
%
% Note that the number of input channels and the number of output channels
% can be different, for example when the user specifies that he/she wants
% to add the implicit EEG reference channel to the data matrix.
%
% The offset field specifies the difference in the latency of the beginning
% of the data relative to the occurence of the trigger (expressed in
% samples). An offset of 0 means that the first sample of the trial
% corresponds with the trigger. A positive offset indicates that the first
% sample is later than the triger, a negative offset indicates that the
% trial begins before the trigger. The offset should be specified EXCLUDING
% the filter padding at the begin of the data. You can leave it empty,
% which implies that the first sample of the data corresponds with latency 0.
%
% The filtering of the data can introduce artifacts at the edges, hence it
% is better to pad the data with some extra signal at the begin and end.
% After filtering, this padding is removed and the other preprocessing
% steps are applied to the remainder of the data. The input fields
% begpadding and endpadding should be specified in samples. You can also
% leave them empty, which implies that the data is not padding.
%
% The configuration can contain
%   cfg.lpfilter      = 'no' or 'yes'  lowpass filter
%   cfg.hpfilter      = 'no' or 'yes'  highpass filter
%   cfg.bpfilter      = 'no' or 'yes'  bandpass filter
%   cfg.bsfilter      = 'no' or 'yes'  bandstop filter
%   cfg.lnfilter      = 'no' or 'yes'  line noise removal using notch filter
%   cfg.dftfilter     = 'no' or 'yes'  line noise removal using discrete fourier transform
%   cfg.medianfilter  = 'no' or 'yes'  jump preserving median filter
%   cfg.lpfreq        = lowpass  frequency in Hz
%   cfg.hpfreq        = highpass frequency in Hz
%   cfg.bpfreq        = bandpass frequency range, specified as [low high] in Hz
%   cfg.bsfreq        = bandstop frequency range, specified as [low high] in Hz
%   cfg.lnfreq        = line noise frequency in Hz, default 50Hz
%   cfg.lpfiltord     = lowpass  filter order
%   cfg.hpfiltord     = highpass filter order
%   cfg.bpfiltord     = bandpass filter order
%   cfg.bsfiltord     = bandstop filter order
%   cfg.lnfiltord     = line noise notch filter order
%   cfg.medianfiltord = length of median filter
%   cfg.lpfilttype    = digital filter type, 'but' (default) or 'fir'
%   cfg.hpfilttype    = digital filter type, 'but' (default) or 'fir'
%   cfg.bpfilttype    = digital filter type, 'but' (default) or 'fir'
%   cfg.bsfilttype    = digital filter type, 'but' (default) or 'fir'
%   cfg.lpfiltdir     = filter direction, 'twopass' (default), 'onepass' or 'onepass-reverse'
%   cfg.hpfiltdir     = filter direction, 'twopass' (default), 'onepass' or 'onepass-reverse'
%   cfg.bpfiltdir     = filter direction, 'twopass' (default), 'onepass' or 'onepass-reverse' 
%   cfg.bsfiltdir     = filter direction, 'twopass' (default), 'onepass' or 'onepass-reverse' 
%   cfg.detrend       = 'no' or 'yes'
%   cfg.blc           = 'no' or 'yes'
%   cfg.blcwindow     = [begin end] in seconds, the default is the complete trial
%   cfg.hilbert       = 'no' or 'yes'
%   cfg.rectify       = 'no' or 'yes'
%   cfg.implicitref   = 'label' or empty, add the implicit EEG reference as zeros
%   cfg.boxcar        = 'no' or number in seconds
%   cfg.derivative    = 'no' or 'yes', compute the derivative
%   cfg.absdiff       = 'no' or 'yes', compute absolute value of derivative
%   cfg.reref         = 'no' or 'yes'
%   cfg.refchannel    = cell-array with new reference channel(s)
%
% See also READ_FCDC_DATA, READ_FCDC_HEADER

% Copyright (C) 2004-2005, Robert Oostenveld
%
% $Log: preproc.m,v $
% Revision 1.20  2007/04/16 19:04:11  roboos
% removed an excess "end", thanks to Jo
%
% Revision 1.19  2007/04/16 16:10:36  roboos
% loop over all frequencies specified in the cfg.lnfreq (for notch filtering, 2Hz wide)
% added support bandstop filtering (cfg.bsfilter) for when the user wants to specify a wider stop-band
%
% Revision 1.18  2007/01/17 17:05:10  roboos
% use hastoolbox('signal')
%
% Revision 1.17  2006/08/31 07:56:05  roboos
% added onepass-reverse filter to documentation
%
% Revision 1.16  2006/06/14 12:45:58  roboos
% removed documentation of non-functional option cfg.lnfilttype
% added support for onepass and twopass filtering using cfg.lpfiltdir etc.
%
% Revision 1.15  2006/06/14 11:56:30  roboos
% added support for multiple preprocessing stages, achieved by using a cell-array as input (each cell containing a seperate cfg)
%
% Revision 1.14  2006/04/25 20:20:50  roboos
% moved some of the sanity checks from preprocessing to private/preproc
% reinserted the default of some of the cfg settings, since that was broken
%
% Revision 1.13  2006/02/06 20:41:35  roboos
% fixed bug: padding should be removed from time axis
% fixed bug: blc window selection should be done on time axis keeping padding in mind
%
% Revision 1.12  2006/01/18 15:00:00  jansch
% moved the removal of the filter-padding to the end. replaced conv and for-loop
% by convn. implemented mydetrend as a subfunction, which behaves similar to blc.
%
% Revision 1.11  2006/01/17 14:07:43  roboos
% moved rereferencing for EEG all the way to the top, prior to filtering
% implemented cfg.absdiff=yes|no, which does abs(diff(data)) to ensure the order of these two operations (important for jump detection)
%
% Revision 1.10  2006/01/12 16:02:27  roboos
% fixed bug in boxcar, loop over conv() for multiple channels
%
% Revision 1.9  2005/12/20 13:21:46  roboos
% added boxcar convolution as proccessing method
% added temporal derivative as processing method
%
% Revision 1.8  2005/12/02 08:58:29  roboos
% made construction of the time axis optional (can take large amount of memory)
%
% Revision 1.7  2005/11/23 10:44:14  roboos
% added bp/lp/hp/lnfilttype to the documentation
%
% Revision 1.6  2005/09/08 16:56:00  roboos
% only remove padding if unequal to zero
% changed location in file where the time axis is computed
%
% Revision 1.5  2005/09/02 13:17:50  roboos
% Changed dftfilter, loop over all specified frequencies instead of explicitely taking the 2x and 3x harmonics
% Changed default for dftfilter, it now used cfg.dftfreq instead of cfg.lnfreq
% The default is cfg.dftfreq=[50 100 150]
%
% Revision 1.4  2005/05/17 17:50:49  roboos
% changed all "if" occurences of & and | into && and ||
% this makes the code more compatible with Octave and also seems to be in closer correspondence with Matlab documentation on shortcircuited evaluation of sequential boolean constructs
%
% Revision 1.3  2005/05/02 08:17:46  roboos
% implemented suggestion of Christian Forkstam: only add implicit reference channel if it is not yet present in the data
%
% Revision 1.2  2005/01/21 09:53:11  roboos
% implemented median filter in preproc, updated help
%
% Revision 1.1  2004/12/09 17:22:28  roboos
% initial version, replicates all preprocessing steps from the large preprocessing function such as filtering, detrending and re-referencing.
%

if nargin<5 || isempty(offset)
  offset = 0;
end
if nargin<6 || isempty(begpadding)
  begpadding = 0;
end
if nargin<7 || isempty(endpadding)
  endpadding = 0;
end

if iscell(cfg)
  % recurse over the subsequent preprocessing stages
  if begpadding>0 || endpadding>0
    error('multiple preprocessing stages are not supported in combination with filter padding');
  end
  for i=1:length(cfg)
    tmpcfg = cfg{i};
    if nargout==1
      [dat                     ] = preproc(dat, label, fsample, tmpcfg, offset, begpadding, endpadding);
    elseif nargout==2
      [dat, label              ] = preproc(dat, label, fsample, tmpcfg, offset, begpadding, endpadding);
    elseif nargout==3
      [dat, label, time        ] = preproc(dat, label, fsample, tmpcfg, offset, begpadding, endpadding);
    elseif nargout==4
      [dat, label, time, tmpcfg] = preproc(dat, label, fsample, tmpcfg, offset, begpadding, endpadding);
      cfg{i} = tmpcfg;
    end
  end
  % ready with recursing over the subsequent preprocessing stages
  return
end

% set the defaults for the rereferencing options
if ~isfield(cfg, 'reref'),        cfg.reref = 'no';             end
if ~isfield(cfg, 'refchannel'),   cfg.refchannel = {};          end
if ~isfield(cfg, 'implicitref'),  cfg.implicitref = [];         end
% set the defaults for the signal processing options
if ~isfield(cfg, 'detrend'),      cfg.detrend = 'no';           end
if ~isfield(cfg, 'blc'),          cfg.blc = 'no';               end
if ~isfield(cfg, 'blcwindow'),    cfg.blcwindow = 'all';	end
if ~isfield(cfg, 'lnfilter'),     cfg.lnfilter = 'no';          end
if ~isfield(cfg, 'dftfilter'),    cfg.dftfilter = 'no';         end
if ~isfield(cfg, 'lpfilter'),     cfg.lpfilter = 'no';          end
if ~isfield(cfg, 'hpfilter'),     cfg.hpfilter = 'no';          end
if ~isfield(cfg, 'bpfilter'),     cfg.bpfilter = 'no';          end
if ~isfield(cfg, 'bsfilter'),     cfg.bsfilter = 'no';          end
if ~isfield(cfg, 'lpfiltord'),    cfg.lpfiltord = 6;            end
if ~isfield(cfg, 'hpfiltord'),    cfg.hpfiltord = 6;            end
if ~isfield(cfg, 'bpfiltord'),    cfg.bpfiltord = 4;            end
if ~isfield(cfg, 'bsfiltord'),    cfg.bsfiltord = 4;            end
if ~isfield(cfg, 'lnfiltord'),    cfg.lnfiltord = 4;            end
if ~isfield(cfg, 'lpfilttype'),   cfg.lpfilttype = 'but';       end
if ~isfield(cfg, 'hpfilttype'),   cfg.hpfilttype = 'but';       end
if ~isfield(cfg, 'bpfilttype'),   cfg.bpfilttype = 'but';       end
if ~isfield(cfg, 'bsfilttype'),   cfg.bsfilttype = 'but';       end
if ~isfield(cfg, 'lpfiltdir'),    cfg.lpfiltdir = 'twopass';    end
if ~isfield(cfg, 'hpfiltdir'),    cfg.hpfiltdir = 'twopass';    end
if ~isfield(cfg, 'bpfiltdir'),    cfg.bpfiltdir = 'twopass';    end
if ~isfield(cfg, 'bsfiltdir'),    cfg.bsfiltdir = 'twopass';    end
if ~isfield(cfg, 'medianfilter'), cfg.medianfilter  = 'no';     end
if ~isfield(cfg, 'medianfiltord'),cfg.medianfiltord = 9;        end
if ~isfield(cfg, 'lnfreq'),       cfg.lnfreq = 50;              end
if ~isfield(cfg, 'dftfreq')       cfg.dftfreq = [50 100 150];   end
if ~isfield(cfg, 'hilbert'),      cfg.hilbert = 'no';           end
if ~isfield(cfg, 'derivative'),   cfg.derivative = 'no';        end
if ~isfield(cfg, 'rectify'),      cfg.rectify = 'no';           end
if ~isfield(cfg, 'boxcar'),       cfg.boxcar = 'no';            end
if ~isfield(cfg, 'absdiff'),      cfg.absdiff = 'no';           end

% test whether the Matlab signal processing toolbox is available
if strcmp(cfg.medianfilter, 'yes') && ~hastoolbox('signal')
  error('median filtering requires the Matlab signal processing toolbox');
end

% do a sanity check on the filter configuration
if strcmp(cfg.bpfilter, 'yes') && ...
   (strcmp(cfg.hpfilter, 'yes') || strcmp(cfg.lpfilter,'yes')),
  error('you should not apply both a bandpass AND a lowpass/highpass filter');
end

% do a sanity check on the hilbert transform configuration
if strcmp(cfg.hilbert, 'yes') && ~strcmp(cfg.bpfilter, 'yes')
  error('hilbert transform should be applied in conjunction with bandpass filter')
end

% do a sanity check on hilbert and rectification
if strcmp(cfg.hilbert, 'yes') && strcmp(cfg.rectify, 'yes')
  error('hilbert transform and rectification should not be applied both')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% do the rereferencing in case of EEG
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~isempty(cfg.implicitref) && ~any(strmatch(cfg.implicitref,label))
  label = {label{:} cfg.implicitref};
  dat(end+1,:) = 0;
end
if strcmp(cfg.reref, 'yes'),
  cfg.refchannel = channelselection(cfg.refchannel, label);
  refindx = match_str(label, cfg.refchannel);
  if isempty(refindx)
    error('reference channel was not found')
  end
  dat = avgref(dat, refindx);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% do the filtering on the padded data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(cfg.medianfilter, 'yes'), dat = medfilt1(dat, cfg.medianfiltord, [], 2); end
if strcmp(cfg.lpfilter, 'yes'),     dat = lowpassfilter (dat, fsample, cfg.lpfreq, cfg.lpfiltord, cfg.lpfilttype, cfg.lpfiltdir); end
if strcmp(cfg.hpfilter, 'yes'),     dat = highpassfilter(dat, fsample, cfg.hpfreq, cfg.hpfiltord, cfg.hpfilttype, cfg.hpfiltdir); end
if strcmp(cfg.bpfilter, 'yes'),     dat = bandpassfilter(dat, fsample, cfg.bpfreq, cfg.bpfiltord, cfg.bpfilttype, cfg.bpfiltdir); end
if strcmp(cfg.bsfilter, 'yes'),     dat = bandstopfilter(dat, fsample, cfg.bsfreq, cfg.bsfiltord, cfg.bsfilttype, cfg.bsfiltdir); end
if strcmp(cfg.lnfilter, 'yes'),
  for i=1:length(cfg.lnfreq)
    % filter out the 50Hz noise, optionally also the 100 and 150 Hz harmonics
    dat = notchfilter(dat, fsample, cfg.lnfreq(i), cfg.lnfiltord);
  end
end
if strcmp(cfg.dftfilter, 'yes'),
  for i=1:length(cfg.dftfreq)
    % filter out the 50Hz noise, optionally also the 100 and 150 Hz harmonics
    dat = dftfilter(dat, fsample, cfg.dftfreq(i));
  end
end

if strcmp(cfg.detrend, 'yes')
  nsamples     = size(dat,2);
  blcbegsample = 1        + begpadding;
  blcendsample = nsamples - endpadding;
  dat = mydetrend(dat, blcbegsample, blcendsample);
end
if strcmp(cfg.blc, 'yes') || nargout>2
  % determine the complete time axis for the baseline correction
  % but only construct it when really needed, since it takes up a large amount of memory
  % the time axis should include the filter padding
  nsamples = size(dat,2);
  time = (offset - begpadding + (0:(nsamples-1)))/fsample;
end
if strcmp(cfg.blc, 'yes')
  if isstr(cfg.blcwindow) && strcmp(cfg.blcwindow, 'all')
    blcbegsample = 1        + begpadding;
    blcendsample = nsamples - endpadding;
    dat          = blc(dat, blcbegsample, blcendsample);
  else
    % determine the begin and endsample of the baseline period and baseline correct for it
    blcbegsample = nearest(time, cfg.blcwindow(1));
    blcendsample = nearest(time, cfg.blcwindow(2));
    dat          = blc(dat, blcbegsample, blcendsample);
  end
end
if strcmp(cfg.hilbert, 'yes'),
  dat = abs(hilbert(dat'))';
end
if strcmp(cfg.rectify, 'yes'),
  dat = abs(dat);
end
if isnumeric(cfg.boxcar)
  numsmp = round(cfg.boxcar*fsample);
  if ~rem(numsmp,2)
    % the kernel should have an odd number of samples
    numsmp = numsmp+1;
  end
  kernel = ones(1,numsmp) ./ numsmp;
  %begsmp = (numsmp-1)/2 + 1;
  %endsmp = (numsmp-1)/2 + size(dat,2);
  %for i=1:size(dat,1)
  %  tmp = conv(dat(i,:), kernel);
  %  % remove the kernel padding at the edges
  %  dat(i,:) = tmp(begsmp:endsmp);
  %end
  dat = convn(dat, kernel, 'same');
end
if strcmp(cfg.derivative, 'yes'),
  dat = [diff(dat, 1, 2) 0];
end
if strcmp(cfg.absdiff, 'yes'),
  % this implements abs(diff(data), which is required for jump detection
  dat = abs([diff(dat, 1, 2) 0]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% remove the filter padding and do the preprocessing on the remaining trial data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if begpadding~=0 || endpadding~=0
  dat = dat(:, (1+begpadding):(end-endpadding));
  if strcmp(cfg.blc, 'yes') || nargout>2
    time = time((1+begpadding):(end-endpadding));
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%subfunction which does the detrending on the data without filter-padding
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dat = mydetrend(dat, blcbegsample, blcendsample);
nsamples = size(dat,2);
vec1     = [ones(1,nsamples) ; 0:(nsamples-1)];
vec0     = vec1;
vec0(:, [1:(blcbegsample-1) (blcendsample+1):nsamples]) = 0;
beta     = dat/vec0;
dat      = dat - beta*vec1;
