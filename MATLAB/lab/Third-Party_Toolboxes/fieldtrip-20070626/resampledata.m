function [data] = resampledata(cfg, data);

% RESAMPLEDATA performs a resampling or downsampling of the data
%
% Use as
%   [data] = resampledata(cfg, data)
%
% The data should be organised in a structure as obtained from 
% the PREPROCESSING function. The configuration should contain
%   cfg.resamplefs = frequency at which the data will be resampled (default = 256 Hz)
%   cfg.detrend    = 'no' or 'yes', prior to resampling (default = 'yes')
%   cfg.feedback   = 'no', 'text', 'textbar', 'gui' (default = 'text')
%
% The following fields in the structure 'data' are changed
%   data.fsample        
%   data.trial          
%   data.time

% Copyright (C) 2003-2006, FC Donders Centre, Markus Siegel
%
% $Log: resampledata.m,v $
% Revision 1.10  2007/04/03 15:37:07  roboos
% renamed the checkinput function to checkdata
%
% Revision 1.9  2007/03/30 17:05:40  ingnie
% checkinput; only proceed when input data is allowed datatype
%
% Revision 1.8  2006/08/16 08:24:18  roboos
% replaced fprintf by progress(), added cfg.feedback, updated documentation
%
% Revision 1.7  2005/09/15 11:31:07  roboos
% added support for single precision data, by temporarily converting to double precision
%
% Revision 1.6  2005/08/08 14:09:27  roboos
% fixed bug (data.origfsample was used but not defined)
% renamed cfg.originalfs to cfg.origfs
%
% Revision 1.5  2005/08/05 09:06:04  roboos
% removed the offset field in the output
% changed the way in which the new time-axis is computed
%
% Revision 1.4  2005/06/29 12:46:29  roboos
% the following changes were done on a large number of files at the same time, not all of them may apply to this specific file
% - added try-catch around the inclusion of input data configuration
% - moved cfg.version, cfg.previous and the assignment of the output cfg to the end
% - changed help comments around the configuration handling
% - some changes in whitespace
%
% Revision 1.3  2004/11/02 14:32:28  roboos
% included cfg.detrend in help
% fixed bug in timeaxis (inconsistent with offset due to rounding error)
% added cfg, cfg.version and cfg.previous to output
%
% Revision 1.2  2004/09/02 09:42:43  marsie
% initial CVS release
% included linear detrending (default)
%

% check if the input data is valid for this function
data = checkdata(data, 'datatype', 'raw', 'feedback', 'yes');

% set the defaults
if ~isfield(cfg, 'resamplefs'), cfg.resamplefs = 256;  end
if ~isfield(cfg, 'detrend'),    cfg.detrend = 'yes';   end
if ~isfield(cfg, 'feedback'),   cfg.feedback = 'text'; end

% remember the original sampling frequency in the configuration
cfg.origfs = data.fsample;

% specify the new sampling frequency in the output
data.fsample = cfg.resamplefs;

fprintf('original sampling rate: %d Hz\nnew sampling rate: %d Hz\n',cfg.origfs,cfg.resamplefs);

progress('init', cfg.feedback, 'resampling data');
nch = length(data.label);
ntr = length(data.trial);
for itr = 1:ntr
  progress(itr/ntr, 'resampling data in trial %d from %d\n', itr, ntr);
  if strcmp(cfg.detrend,'yes')
    data.trial{itr} = detrend(data.trial{itr}')';
  end
  if isa(data.trial{itr}, 'single')
    % temporary convert this trial to double precision
    data.trial{itr} = single(resample(double(data.trial{itr})',double(cfg.resamplefs),double(cfg.origfs)))';
  else
    data.trial{itr} = resample(data.trial{itr}',cfg.resamplefs,cfg.origfs)';
  end
  % recompute and remember the time axis
  nsmp = size(data.trial{itr},2);
  data.time{itr} = data.time{itr}(1) + (0:(nsmp-1))/cfg.resamplefs;
end
progress('close');

% add version information to the configuration
try
  % get the full name of the function
  cfg.version.name = mfilename('fullpath');
catch
  % required for compatibility with Matlab versions prior to release 13 (6.5)
  [st, i] = dbstack;
  cfg.version.name = st(i);
end
cfg.version.id = '$Id: resampledata.m,v 1.10 2007/04/03 15:37:07 roboos Exp $';
% remember the configuration details of the input data
try, cfg.previous = data.cfg; end
% remember the exact configuration details in the output 
data.cfg = cfg;

