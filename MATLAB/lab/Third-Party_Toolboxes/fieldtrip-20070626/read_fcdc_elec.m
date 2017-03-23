function [sens] = read_fcdc_elec(filename)

% READ_FCDC_ELEC read sensor positions from various manufacturers
% file formats. Currently supported are ASA, BESA, Polhemus and Matlab
% for EEG electrodes and CTF and Neuromag for MEG gradiometers.
%
% Use as
%   grad = read_fcdc_elec(filename)  % for gradiometers
%   elec = read_fcdc_elec(filename)  % for electrodes
%
% An electrode definition contain the following fields
%   elec.pnt     Nx3 matrix with carthesian (x,y,z) coordinates of each electrodes
%   elec.label   cell-array of length N with the label of each electrode
%
% A gradiometer definition generally consists of multiple coils per
% channel, e.g.two coils for a 1st order gradiometer in which the
% orientation of the coils is opposite. Each coil is described
% separately and a large "tra" matrix (can be sparse) has to be
% given that defines how the forward computed field is combined over
% the coils to generate the output of each channel. The gradiometer
% definition constsis of the following fields
%   grad.pnt     Mx3 matrix with the position of each coil
%   grad.ori     Mx3 matrix with the orientation of each coil
%   grad.tra     NxM matrix with the weight of each coil into each channel
%   grad.label   cell-array of length N with the label of each of the channels
%
% See also READ_FCDC_HEADER, READ_FCDC_DATA, READ_FCDC_EVENT

% Copyright (C) 2005, Robert Oostenveld
%
% $Log: read_fcdc_elec.m,v $
% Revision 1.7  2007/03/14 08:45:36  roboos
% also recognize ctf_ds and deal with it just as res4
%
% Revision 1.6  2006/01/30 13:58:41  roboos
% use read_fcdc_header and hdr.grad in case of MEG gradiometers
%
% Revision 1.5  2005/11/23 10:45:49  roboos
% added support for yokogawa gradiometers
%
% Revision 1.4  2005/09/15 12:58:52  roboos
% fixed bug, changed grad into sens (thanks to marbau)
%
% Revision 1.3  2005/08/17 19:35:30  roboos
% added a check for the presence of the file, give error if not present
%
% Revision 1.2  2005/08/05 07:35:00  roboos
% moved the reading of gradiometers from private/prepare_vol_sens into here
% renamed "elec" into "sens"
% improved and updated documentation
%
% Revision 1.1  2005/07/28 14:50:04  roboos
% moved read_fcdc_elec from private to main directory
%
% Revision 1.2  2005/04/05 12:04:26  roboos
% added support for besa_sfp
%
% Revision 1.1  2005/01/17 14:52:24  roboos
% new implementation of wrapper routine for multiple electrode file formats
%

% test whether the file exists
if ~exist(filename)
  error(sprintf('file ''%s'' does not exist', filename));
end

iseeg = 0;
ismeg = 0;

switch filetype(filename)
  % files that contain EEG electrodes
  case 'asa_elc'
    sens = read_asa_elc(filename);
    iseeg = 1;
  case 'polhemus_pos'
    sens = read_brainvision_pos(filename);
    iseeg = 1;
  case 'besa_sfp'
    tmp        = importdata(filename);
    sens.label = tmp.textdata;
    sens.pnt   = tmp.data;
    iseeg = 1;
  % gradiometer information is always stored in the header of the MEG dataset
  case {'ctf_ds', 'ctf_res4', 'neuromag_fif', 'yokogawa_ave', 'yokogawa_con', 'yokogawa_raw'}
    hdr = read_fcdc_header(filename);
    sens = hdr.grad;
    ismeg = 1;
  % matlab files can contain either electrodes or gradiometers
  case 'matlab'
    tmp = load(filename);
    if isfield(tmp, 'grad')
      sens = getfield(tmp, 'grad');
      ismeg = 1;
    elseif isfield(tmp, 'elec')
      sens = getfield(tmp, 'elec');
      iseeg = 1;
    elseif isfield(tmp, 'elc')
      sens = getfield(tmp, 'elc');
      iseeg = 1;
    else
      error('no electrodes or gradiometers found in Matlab file');
    end
  otherwise
    % other formats are sofar not supported
    error('unknown fileformat for electrodes or gradiometers');
end

% only keep positions and labels in case of EEG electrodes
if iseeg
  dum  = sens;
  sens = [];
  sens.pnt   = dum.pnt;
  sens.label = dum.label;
end

