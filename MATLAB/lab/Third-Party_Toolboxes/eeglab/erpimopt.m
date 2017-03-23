% erpimopt() - More erpimage() input arguments      
%
% For other erpimage() input arguments, see: >> help erpimage
%
% Optional inputs:
%   'phasesort' - [ms_center prct freq] Sort epochs by phase in a 3-cycle window 
%               centered at given time (ms). Percentile (prct) in range [0,100] 
%               -> percent of trials to reject for low amplitude. Else, if prct 
%               is in the range [-100,0] -> percent to reject for high amplitude
%               Freq is the phase-sorting frequency in Hz.
%               ELSE [time prct minfrq maxfrq] -> sort by phase at max power
%               frequency in the data within the range [minfrq,maxfrq]
%               (overrides frequency specified in 'coher' flag)
%               ELSE [time prct minfrq maxfrq topphase] -> sort by phase, putting
%               topphase (deg. in [-180,180]) at top {default: [0 25 8 13 180]}
%   'coher'   - [freq] -> plot erp plus amp & coher at freq (Hz)
%               [minfrq maxfrq]-> same but select frequency with max power
%               in given range. (phase freq above overwrite these parameters).
%               [minfrq maxfrq alpha] -> add coher. signif. level line at alpha
%               (alpha range: (0,0.1]) {default none}
%   'plotamps' - image amplitudes at each time & trial. Requires arg
%                'coher' with alpha signif. {default: image raw data}
%   'topo'    - {map,eloc_file} -> plot a 2-d head map (vector) at upper left. 
%               See '>> topoplot example' for electrode location file structure.
%   'spec'    - [loHz,hiHz] -> plot the mean data spectrum at upper right. 
%   'srate'   - [freq]-> specify data sampling rate in Hz for amp/coher
%               (if not in times arg above) {default: as in icadefs.m}
%   'signif'  - [lo_amp, hi_amp, coher_signif_level] -> plot preassigned
%               significance levels to save computation time. {default: none}
%   'vert'    - [times_vector] -> plot vertical dashed lines at specified times
%               ELSE  [times_matrix] -> plot vertical dashed time series at times 
%               specified by the columns of the 'vert' arg matrix. Matrix must  
%               have ntrials rows.
%   'noxlabel'- do not plot "Time (ms)" on the bottom x-axis
%   'yerplabel' - ERP ordinate axis label (default is uV)
%
% Optional outputs:
%    outdata  = (times,epochsout) data matrix (after smoothing)
%     outvar  = (1,epochsout)  sortvar vector (after smoothing)
%   outtrials = (1,epochsout)  smoothed trial numbers
%     limits  = (1,10) array, 1-9 as in 'limits' above, then analysis frequency (Hz) 
%    axhndls  = vector of 1-7 plot axes handles (img,cbar,erp,amp,coh,topo,spec)
%        erp  = plotted ERP average
%       amps  = mean amplitude time course
%      coher  = mean inter-trial phase coherence time course
%     cohsig  = coherence significance level
%     ampsig  = amplitude significance levels [lo high]
%    outamps  = matrix of imaged amplitudes (from option 'allamps')
%   phsangls  = vector of sorted trial phases at the phase-sorting frequency
%     phsamp  = vector of sorted trial amplitudes at the phase-sorting frequency
%    sortidx  = indices of sorted data epochs plotted
%
% Note: The syntax of optional inputs is not in the standard format
%       { 'key1', value1, 'key2', value2 ... } yet. This will be fixed in future
%       versions.
%
% Author: Scott Makeig, CNL / Salk Institute, 02/02/01
%
% See also: erpimage(), erpimages()

% $Log: erpimopt.m,v $
% Revision 1.7  2002/08/31 16:58:16  arno
% add yerplabel argument
%
% Revision 1.6  2002/08/09 16:28:56  arno
% plotamps and phasesort
%
% Revision 1.5  2002/04/24 18:10:51  arno
% updating phase message
%
% Revision 1.4  2002/04/24 17:55:57  arno
% updating help message
%
% Revision 1.3  2002/04/18 18:37:59  arno
% typo fixed
%
% Revision 1.2  2002/04/11 22:34:16  scott
% reformatted 'phase' help message -sm
%
% Revision 1.1  2002/04/05 17:36:45  jorn
% Initial revision
%

% 02-18-02 reformated help & license -ad 

