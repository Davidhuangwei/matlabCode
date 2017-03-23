function [data] = preprocessing(cfg);

% PREPROCESSING reads MEG and/or EEG data according to user-specified trials
% and applies several user-specified preprocessing steps to the signals.
%
% Use as
%   [data] = preprocessing(cfg)
%
% The configuration structure contains all details for the dataset,
% trials and preprocessing options. You can only start preprocessing after
% defining the pieces of data of interest (i.e. the trials), which is
% for example done based on the occurence of a trigger in the data.
% Furthermore, you might want to remove all trials that are contaminated
% with artifacts.
%
% The options for defining the trials are documented and set in
% DEFINETRIAL. See the help of that function to see how these are
% configured, and how you can specify non-default trial definitions.
%
% The options for artifact detection and rejection are documented and set
% in REJECTARTIFACT. See the help of that function to see how these are
% configured, and how non-default rejection parameters should be specified.
%
% The input data is specified according to
%   cfg.dataset      = string
%  or
%   cfg.datafile     = string
%   cfg.headerfile   = string
%
% Furthermore you can specify
%   cfg.channel      = Nx1 cell-array with selection of channels (default = 'all'),
%                      see CHANNELSELECTION for details
%   cfg.continuous   = 'yes' or 'no' whether the file contains continuous data
%                      (default is determined automatic)
%
% The preprocessing options for all channels are
%   cfg.padding       = length to which the trials are padded for filtering
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
%   cfg.dftfreq       = line noise frequencies for DFT filter, default [50 100 150] Hz
%   cfg.lpfiltord     = lowpass  filter order
%   cfg.hpfiltord     = highpass filter order
%   cfg.bpfiltord     = bandpass filter order
%   cfg.bsfiltord     = bandstop filter order
%   cfg.lnfiltord     = line noise notch filter order
%   cfg.lpfilttype    = digital filter type, 'but' (default) or 'fir'
%   cfg.hpfilttype    = digital filter type, 'but' (default) or 'fir'
%   cfg.bpfilttype    = digital filter type, 'but' (default) or 'fir'
%   cfg.bsfilttype    = digital filter type, 'but' (default) or 'fir'
%   cfg.lpfiltdir     = filter direction, 'twopass' (default), 'onepass' or 'onepass-reverse'
%   cfg.hpfiltdir     = filter direction, 'twopass' (default), 'onepass' or 'onepass-reverse'
%   cfg.bpfiltdir     = filter direction, 'twopass' (default), 'onepass' or 'onepass-reverse'
%   cfg.bsfiltdir     = filter direction, 'twopass' (default), 'onepass' or 'onepass-reverse'
%   cfg.medianfiltord = length of median filter
%   cfg.detrend       = 'no' or 'yes'
%   cfg.blc           = 'no' or 'yes'
%   cfg.blcwindow     = [begin end] in seconds, the default is the complete trial
%   cfg.hilbert       = 'no' or 'yes'
%   cfg.rectify       = 'no' or 'yes'
%   cfg.precision     = 'single' or 'double' (default)
%
% Preprocessing options that you should only use for EEG data are
%   cfg.reref         = 'no' or 'yes'
%   cfg.implicitref   = 'label' or empty, add the implicit EEG reference as zeros
%   cfg.refchannel    = cell-array with new EEG reference channel(s)

% Undocumented local options:
% cfg.artfctdef
% cfg.removemcg
% cfg.trl
% cfg.version
%
% This function depends on PREPROC which has the following options:
% cfg.absdiff
% cfg.blc, documented
% cfg.blcwindow, documented
% cfg.boxcar
% cfg.bpfilter, documented
% cfg.bpfiltord, documented
% cfg.bpfilttype, documented
% cfg.bpfreq, documented
% cfg.bsfilter, documented
% cfg.bsfiltord, documented
% cfg.bsfilttype, documented
% cfg.bsfreq, documented
% cfg.derivative
% cfg.detrend, documented
% cfg.dftfilter, documented
% cfg.dftfreq, documented
% cfg.hilbert, documented
% cfg.hpfilter, documented
% cfg.hpfiltord, documented
% cfg.hpfilttype, documented
% cfg.hpfreq, documented
% cfg.implicitref, documented
% cfg.lnfilter, documented
% cfg.lnfiltord, documented
% cfg.lnfilttype, documented
% cfg.lnfreq, documented
% cfg.lpfilter, documented
% cfg.lpfiltord, documented
% cfg.lpfilttype, documented
% cfg.lpfreq, documented
% cfg.medianfilter, documented
% cfg.medianfiltord, documented
% cfg.rectify, documented
% cfg.refchannel, documented
% cfg.reref, documented

% Copyright (C) 2003, Robert Oostenveld, SMI, FCDC
%
% $Log: preprocessing.m,v $
% Revision 1.79  2007/05/30 13:24:43  roboos
% renamed the hidden option cfg.datatype to cfg.continuous=yes/no and added it to the documentation
%
% Revision 1.78  2007/05/02 15:23:07  roboos
% added option for bandstopfiltering
%
% Revision 1.77  2007/01/09 09:49:53  roboos
% allow numeric channel selections, give warning when cfg.rejectxxx is present (since deprecated)
%
% Revision 1.76  2007/01/04 17:07:37  roboos
% only call definetrial and rejectartifact if really needed, give a warning in that case (is deprecated)
%
% Revision 1.75  2006/11/29 09:06:36  roboos
% renamed all cfg options with "sgn" into "channel", added backward compatibility when required
% updated documentation, mainly in the artifact detection routines
%
% Revision 1.74  2006/10/04 07:10:07  roboos
% updated documentation
%
% Revision 1.73  2006/08/31 07:56:05  roboos
% added onepass-reverse filter to documentation
%
% Revision 1.72  2006/06/14 12:51:01  roboos
% updated documentation
%
% Revision 1.71  2006/06/14 12:43:54  roboos
% removed the documentation for cfg.lnfilttype, since that option is not supported by preproc
%
% Revision 1.70  2006/06/14 11:52:06  roboos
% changed some comments, minor change to the handling of cfg.padding
%
% Revision 1.69  2006/06/13 14:48:09  ingnie
% updated documentation
%
% Revision 1.68  2006/05/30 20:57:15  roboos
% updated documentation
%
% Revision 1.67  2006/04/27 11:18:34  chrhes
% reinstated the default setting for the 'medianfilter' option since that was still broken, and changed a few words in the documentation.
%
% Revision 1.66  2006/04/25 20:20:46  roboos
% moved some of the sanity checks from preprocessing to private/preproc
% reinserted the default of some of the cfg settings, since that was broken
%
% Revision 1.65  2006/04/25 17:03:17  ingnie
% updated documentation and removed defaults that were also present in preproc.m from code
%
% Revision 1.64  2006/04/20 09:58:34  roboos
% updated documentation
%
% Revision 1.63  2005/11/23 10:44:11  roboos
% added bp/lp/hp/lnfilttype to the documentation
%
% Revision 1.62  2005/09/14 07:47:11  roboos
% added support for single precision data as output
%
% Revision 1.61  2005/09/02 13:51:39  roboos
% added defaulf cfg.dftfreq=[50 100 150], added new option to documentation
%
% Revision 1.60  2005/08/05 09:16:22  roboos
% removed the obsolete data.offset
%
% Revision 1.59  2005/05/17 17:50:37  roboos
% changed all "if" occurences of & and | into && and ||
% this makes the code more compatible with Octave and also seems to be in closer correspondence with Matlab documentation on shortcircuited evaluation of sequential boolean constructs
%
% Revision 1.58  2005/05/04 07:28:41  roboos
% changed fprintf into progress, added cfg.feedback default
%
% Revision 1.57  2005/04/13 08:48:38  roboos
% changed tab to space in a comment
%
% Revision 1.56  2005/01/25 13:59:57  roboos
% added check for cfg.datatype=continous and extended the call to read_fcdc_data with the boundary check for non-continous data
%
% Revision 1.55  2005/01/21 15:23:31  roboos
% added default for medianfilter and medianfilterord
%
% Revision 1.54  2005/01/21 09:53:11  roboos
% implemented median filter in preproc, updated help
%
% Revision 1.53  2005/01/10 16:52:11  roboos
% modifield the piece of code that does the actual preprocessing to use the
% private/preproc function. This ensures consistency with all other functions
% that perform filtering, etc.
%
% Revision 1.52  2004/12/06 12:43:03  roboos
% added warning for inconsistent EEG-rereferencing configuration
%
% Revision 1.51  2004/11/17 08:58:02  roboos
% re-ordered help and included description of cfg.detrend
% changed order of preprocessing: hilbert and rectify as last options
% removed the modification of the padding for integer number of line-noise cycles, this only worked if padding was unequal to 0
% the dftfilter function now takes care of ensuring that the sine wave is estimated on a integer number of line-noise cycles
%
% Revision 1.50  2004/11/15 09:17:14  roboos
% moved dataset to filename conversion into separate function (private/dataset2files)
%
% Revision 1.49  2004/10/01 09:53:45  roboos
% added one line of comments
%
% Revision 1.48  2004/09/22 10:20:27  roboos
% converted to use external subfunctions time2offset and offset2time
% and add offset field to data structure if it is missing
%
% Revision 1.47  2004/09/14 11:10:48  jansch
% fixed bug in sanity check concerning bpfiltering in conjunction with
% hilbert-transformation
%
% Revision 1.46  2004/08/20 06:57:19  roboos
% removed channel specific processing options for EMG and EEG, these are now applied to all channels
% updated and restructured help, added some extra configuration checks
%
% Revision 1.45  2004/08/05 08:58:51  roboos
% added reference to DEFINETRIAL in help
%
% Revision 1.44  2004/06/28 15:03:28  olejen
% removed empty line
%
% Revision 1.43  2004/06/28 15:02:01  roboos
% added empty line to demonstrate Ole
%
% Revision 1.42  2004/06/24 12:09:50  roberto
% removed old version information
%
% Revision 1.41  2004/06/24 10:13:43  roberto
% cosmetical changes in comments only
%
% Revision 1.40  2004/06/03 15:50:20  roberto
% removed experimental event handling, should be part of definetrial and further users own responsibility
%
% Revision 1.39  2004/05/27 15:48:56  roberto
% added cfg.removeeog and added handle for functino that should be implemented by Ali

% set the defaults
if ~isfield(cfg, 'channel'),      cfg.channel = {'all'};        end
if ~isfield(cfg, 'removemcg'),    cfg.removemcg = 'no';         end
if ~isfield(cfg, 'removeeog'),    cfg.removeeog = 'no';         end
if ~isfield(cfg, 'feedback'),     cfg.feedback = 'text';        end
if ~isfield(cfg, 'precision'),    cfg.precision = 'double';     end
if ~isfield(cfg, 'padding'),      cfg.padding = 0;              end % padding is only done when filtering

% these options relate to the actual preprocessing, it is neccessary to specify here because of padding
if ~isfield(cfg, 'lnfilter'),     cfg.lnfilter = 'no';          end
if ~isfield(cfg, 'dftfilter'),    cfg.dftfilter = 'no';         end
if ~isfield(cfg, 'lpfilter'),     cfg.lpfilter = 'no';          end
if ~isfield(cfg, 'hpfilter'),     cfg.hpfilter = 'no';          end
if ~isfield(cfg, 'bpfilter'),     cfg.bpfilter = 'no';          end
if ~isfield(cfg, 'medianfilter'), cfg.medianfilter = 'no';      end
% these options relate to the actual preprocessing, it is neccessary to specify here because of channel selection
if ~isfield(cfg, 'reref'),        cfg.reref = 'no';             end
if ~isfield(cfg, 'refchannel'),   cfg.refchannel = {};          end
if ~isfield(cfg, 'implicitref'),  cfg.implicitref = [];         end

% support for the following options was removed on 20 August 2004 in Revision 1.46
if isfield(cfg, 'emgchannel'), error('EMG specific preprocessing is not supported any more'); end
if isfield(cfg, 'emghpfreq'),  error('EMG specific preprocessing is not supported any more'); end
if isfield(cfg, 'emgrectify'), error('EMG specific preprocessing is not supported any more'); end
if isfield(cfg, 'emghilbert'), error('EMG specific preprocessing is not supported any more'); end
if isfield(cfg, 'eegchannel'), error('EEG specific preprocessing is not supported any more'); end
if isfield(cfg, 'resamplefs'), error('resampling is not supported any more, see RESAMPLEDATA'); end

% if neccessary convert dataset into headerfile and datafile
cfg = dataset2files(cfg);

% check whether the data and header file are given
if ~isfield(cfg, 'datafile') || ~isfield(cfg, 'headerfile')
  error('the datafile and/or headerfile is not correctly specified');
end

% this should be a cell array
if ~iscell(cfg.channel) && ischar(cfg.channel)
  cfg.channel = {cfg.channel};
end

% this should be a cell array
if ~iscell(cfg.refchannel) && ischar(cfg.refchannel)
  cfg.refchannel = {cfg.refchannel};
end

% do a sanity check for the re-referencing
if strcmp(cfg.reref, 'no') && ~isempty(cfg.refchannel)
  warning('no re-referencing is performed');
  cfg.refchannel = {};
end

% read the header
hdr = read_fcdc_header(cfg.headerfile);

% this option relates to reading over trial boundaries in a pseudo-continuous dataset
if ~isfield(cfg, 'continuous')
  if isfield(cfg, 'datatype') && strcmp(cfg.datatype, 'continuous')
    cfg.continuous = 'yes';
  elseif hdr.nTrials==1
    cfg.continuous = 'yes';
  else
    cfg.continuous = 'no';
  end
end

% translate the channel groups (like 'all' and 'MEG') into real labels
cfg.channel = channelselection(cfg.channel,    hdr.label);
if ~isempty(cfg.implicitref)
  % add the label of the implicit reference channel to these cell-arrays
  cfg.channel    = {cfg.channel{:}    cfg.implicitref};
end
cfg.refchannel = channelselection(cfg.refchannel, cfg.channel);

% determine the length in samples to which the data should be padded before filtering is applied
if cfg.padding>0
  if strcmp(cfg.lnfilter, 'yes') || ...
      strcmp(cfg.dftfilter, 'yes') || ...
      strcmp(cfg.lpfilter, 'yes') || ...
      strcmp(cfg.hpfilter, 'yes') || ...
      strcmp(cfg.bpfilter, 'yes') || ...
      strcmp(cfg.medianfilter, 'yes')
    padding = round(cfg.padding * hdr.Fs);
  else
    % no filtering will be done, hence no padding is neccessary
    padding = 0;
  end
  % update the configuration (in seconds) for external reference
  cfg.padding = padding / hdr.Fs;
else
  % no padding was requested
  padding = 0;
end

if ~isfield(cfg, 'trl')
  % this is only for backward compatibility
  warning('you should call DEFINETRIAL seperately from PREPROCESSING, please update your scripts');
  % add the field trl to the struct cfg, according to how the trials are to be specified
  [cfg] = definetrial(cfg);
end

if any(strmatch('reject',       fieldnames(cfg))) || ...
    any(strmatch('rejecteog',    fieldnames(cfg))) || ...
    any(strmatch('rejectmuscle', fieldnames(cfg))) || ...
    any(strmatch('rejectjump',   fieldnames(cfg)))
  % this is only for backward compatibility
  warning('you should call REJECTARTIFACT seperately from PREPROCESSING, please update your scripts');
  % adjust the field trl such, that only data without prespecified artifacts is read
  [cfg] = rejectartifact(cfg);
end

if ~isfield(cfg, 'trl') || (isfield(cfg, 'trl') && size(cfg.trl,1)<1)
  error('no trials were selected for preprocessing, see DEFINETRIAL for help');
end

% compute the template for MCG and the QRS latency indices, and add it to the configuration
if strcmp(cfg.removemcg, 'yes')
  cfg = template_mcg(cfg);
  mcgchannel = channelselection(cfg.artfctdef.mcg.channel, hdr.label);
  mcgindx    = match_str(cfg.channel, mcgchannel);
  for i=1:length(mcgchannel)
    fprintf('removing mcg on channel %s\n', mcgchannel{i});
  end
end

% determine the channel numbers of interest for preprocessing
[chnindx, rawindx] = match_str(cfg.channel, hdr.label);

progress('init', cfg.feedback, 'reading and preprocessing');
for i=1:size(cfg.trl,1)
  progress(i/size(cfg.trl,1), 'reading and preprocessing trial %d from %d\n', i, size(cfg.trl, 1));
  % non-zero padding is used for filtering and line noise removal
  nsamples = cfg.trl(i,2)-cfg.trl(i,1)+1;
  if nsamples>padding
    % the trial is already longer than the total lenght requested
    begsample  = cfg.trl(i,1);
    endsample  = cfg.trl(i,2);
    begpadding = 0;
    endpadding = 0;
  else
    % begpadding+nsamples+endpadding = total length of raw data that will be read
    begpadding = ceil((padding-nsamples)/2);
    endpadding = floor((padding-nsamples)/2);
    begsample  = cfg.trl(i,1) - begpadding;
    endsample  = cfg.trl(i,2) + endpadding;
    if begsample<1
      warning('cannot apply enough padding at begin of file');
      begpadding = begpadding - (1 - begsample);
      begsample  = 1;
    end
    if endsample>(hdr.nSamples*hdr.nTrials)
      warning('cannot apply enough padding at end of file');
      endpadding = endpadding - (endsample - hdr.nSamples*hdr.nTrials);
      endsample  = hdr.nSamples*hdr.nTrials;
    end
  end

  % read the raw data with padding on both sides of the trial
  dat = read_fcdc_data(cfg.datafile, hdr, begsample, endsample, rawindx, strcmp(cfg.continuous, 'yes'));

  % do the preprocessing on the padded trial data and remove the padding after filtering
  [cutdat{i}, label, time{i}, cfg] = preproc(dat, hdr.label(rawindx), hdr.Fs, cfg, cfg.trl(i,3), begpadding, endpadding);

  % remove from memory
  clear dat

  if strcmp(cfg.precision, 'single')
    % convert to single precision, i.e. 4 byte floating point values
    cutdat{i} = single(cutdat{i});
  end

end % for all trials
progress('close');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% collect the results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% add the version details of this function call to the configuration
try
  % get the full name of the function
  cfg.version.name = mfilename('fullpath');
catch
  % required for compatibility with Matlab versions prior to release 13 (6.5)
  [st, i] = dbstack;
  cfg.version.name = st(i);
end
cfg.version.id   = '$Id: preprocessing.m,v 1.79 2007/05/30 13:24:43 roboos Exp $';

data.cfg                = cfg;                  % configuration details
data.hdr                = hdr;                  % header details of the datafile
data.label              = cfg.channel;          % labels of channels that have been read
data.trial              = cutdat;               % cell-array with TIMExCHAN
data.time               = time;                 % vector with the timeaxis for each individual trial
data.fsample            = hdr.Fs;
if isfield(hdr, 'grad')
  data.grad             = hdr.grad;             % gradiometer system in head coordinates
end
