% pop_plotdata() - Plot average of EEG channels or independent components in
%                  a rectangular array. Else, (over)plot single trials.
%
% Usage:
%   >> avg = pop_plotdata(EEG, typeplot, indices, trials, title, singletrials);
%
% Inputs:
%   EEG        - Input dataset 
%   typeplot   - Type data to plot (1=channels, 0=components) {Default:1}
%   indices    - Array of channels (or component) indices to plot 
%                     {Default: all}
%   trials     - Array of trial indices. sum specific trials in the average 
%                     {Default: all}
%   title      - Plot title. {Default: []}.
%   singletrials - [0|1], Plot average or overplot single trials 
%                      0 plot average, 1 plot single trials {Default: 0}
%
% Outputs:
%   avg        - [matrix] Data average
% 
% Author: Arnaud Delorme, CNL / Salk Institute, 2001
%
% See also: plotdata(), eeglab()

%123456789012345678901234567890123456789012345678901234567890123456789012

% Copyright (C) 2001 Arnaud Delorme, Salk Institute, arno@salk.edu
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

% $Log: pop_plotdata.m,v $
% Revision 1.12  2002/10/16 01:15:07  arno
% nan_mean
%
% Revision 1.11  2002/10/16 01:05:17  arno
% using nan_mean
%
% Revision 1.10  2002/10/16 00:44:13  arno
% remove nan plot
%
% Revision 1.9  2002/10/14 17:17:24  arno
% handle NaN
%
% Revision 1.8  2002/08/17 21:54:36  scott
% pop labels and help msg
%
% Revision 1.7  2002/08/12 21:14:46  arno
% text
%
% Revision 1.6  2002/08/12 02:17:13  arno
% same
%
% Revision 1.5  2002/08/12 02:15:03  arno
% changing gui
%
% Revision 1.4  2002/08/12 01:38:35  arno
% color
%
% Revision 1.3  2002/08/11 22:17:52  arno
% color
%
% Revision 1.2  2002/08/06 21:56:25  arno
% spelling
%
% Revision 1.1  2002/04/05 17:32:13  jorn
% Initial revision
%

% 01-25-02 reformated help & license -ad 
% 03-08-02 add eeglab options -ad
% 03-18-02 added title -ad & sm
% 03-30-02 added single trial capacities -ad

function [sigtmp, com] = pop_plotdata(EEG, typeplot, indices, trials, plottitle, singletrials);
% warning signal must be in a 3D form before averaging

sigtmp = [];
com = '';
if nargin < 1
   help pop_plotdata;
   return;
end;
if nargin < 2
	typeplot = 1; %1=signal; 0=component
end;
if exist('plottitle') ~= 1
	plottitle = '';
end;

if nargin <3
	if typeplot
		result = inputdlg2( {'Channel number(s):' 'Plot title:' 'Plot single trials instead of average (yes|no)'}, 'Plot ERP in rect. array -- pop_plotdata()', 1, {['1:' int2str(EEG.nbchan)] [fastif(isempty(EEG.setname),'',[ EEG.setname ' ERP'])] 'no'}, 'plotdata' );
	else
		result = inputdlg2( {'Component number(s):' 'Plot title:' 'Plot single trials instead of average (yes|no)'}, 'Component ERP in rect. array -- pop_plotdata()', 1, {['1:' int2str(size(EEG.icaweights,1))] [fastif(isempty(EEG.setname), '',[EEG.setname ' ERP'])] 'no'}, 'plotdata' );
	end;		
	if length(result) == 0 return; end;
	indices   	 = eval( [ '[' result{1} ']' ] );
	plottitle    = result{2};
	singletrials = strcmp( lower(result{3}), 'yes');
end;	
if ~(exist('trials') == 1)
	trials = 1:EEG.trials;
end;	
if exist('plottitle') ~= 1
    plottitle = '';
end;    
if exist('singletrials') ~= 1
    singletrials = 0;
end;    

if EEG.trials > 1 & singletrials == 0
    fprintf('Selecting trials and components...\n');
	if typeplot == 1
	   sigtmp = nan_mean(EEG.data(indices,:,trials),3);
 	else
	   if isempty(EEG.icasphere)
	      error('no ICA data for this set, first run ICA');
	   end;   
	   eeg_options; % changed from eeglaboptions 3/30/02 -sm
	   if option_computeica
	        if length(indices) ~= size(EEG.icaact)
	    	   tmpdata = EEG.icaact(indices,:,:);
	        else
	    	   tmpdata = EEG.icaact;
	        end;
	   else
	       fprintf('Computing ICA...\n');
	       tmpdata = (EEG.icaweights(indices,:)*EEG.icasphere)*reshape(EEG.data(:,:,trials), EEG.nbchan, length(trials)*EEG.pnts);
	       tmpdata = reshape( tmpdata, size(tmpdata,1), EEG.pnts, length(trials));
	   end;
	   fprintf('Averaging...\n');
	   sigtmp = nan_mean(tmpdata,3);
	end;
else
	if typeplot == 1
	   sigtmp = EEG.data(indices,:,trials);
	else
	   if isempty(EEG.icasphere)
	      error('no ICA data for this set, first run ICA');
	   end;   
	   sigtmp = EEG.icaact(indices,:,trials);
	end;
end;
figure;
try, icadefs; set(gcf, 'color', BACKCOLOR); catch, end;

% plot
% ----
sigtmp = reshape( sigtmp, size(sigtmp,1),  size(sigtmp,2)*size(sigtmp,3));
if ~isempty(EEG.chanlocs) & typeplot
    plotdata(sigtmp, EEG.pnts, [EEG.xmin*1000 EEG.xmax*1000 0 0], plottitle, EEG.chanlocs(indices)); %'tmp.nam');
else
	plotdata(sigtmp, EEG.pnts, [EEG.xmin*1000 EEG.xmax*1000 0 0], plottitle, indices);
end;
if typeplot == 1
	set(gcf, 'name', 'ERP in rect. array -- pop_plotdata()');
else
	set(gcf, 'name', 'component ERPs  -- pop_plotdata()');
end;

switch nargin
	case {0, 1, 2, 3}, com = sprintf('pop_plotdata(%s, %d, [%s], [1:%d], ''%s'', %d);', inputname(1), typeplot, num2str(indices), EEG.trials, plottitle, singletrials);
	case 4, com = sprintf('pop_plotdata(%s, %d, [%s], [%s], ''%s'', %d);', inputname(1), typeplot, num2str(indices), num2str(trials), plottitle, singletrials);
end;
return;

function out = nan_mean(in, dim)
    tmpin = in;
    tmpin(find(isnan(in(:)))) = 0;
    out = sum(tmpin, dim) ./ sum(~isnan(in),dim);
