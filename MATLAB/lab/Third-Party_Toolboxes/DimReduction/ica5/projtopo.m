% projtopo - plot projections of one or more ICA components along with 
%                 the original data in a 2-d topographic array. Returns 
%                 the data plotted. Click on subplot to examine separately.
%
%   [projdata] = projtopo(data,weights,sphere,[compnums],'chan_locs',...
%                                 'title',[limits],colors,chans);
%
%   data        = single epoch of runica() input data (chans,frames) 
%   weights     = weight matrix from runica()
%   sphere      = sphering matrix from runica()
%  [compnums]   = vector of component numbers to project and plot 
%  'chan_locs'  = channel locations file (Ex: >> topoplot('example'))
%                 Else: [rows cols] for rectangular grid array
% Optional:
%
%  'title'      = (fairly short) plot title {0 -> 'projtopo()'}
%  [limits]     = [xmin xmax ymin ymax]  (x's in msec) 
%                          {0, or both y's 0 -> data limits}
%   colors      = file of color codes, 3 chars per line  ('.' = space)
%                          {0 -> default color order (black/white first)}
%   chans       = vector of channel numbers to plot

% Without color arg, reads filename for PROJCOLORS from icadefs.m

% 04-02-98 Scott Makeig CNL / Salk Institute, La Jolla from plotproj()
% 03-15-00 added plotchans arg -sm
% 03-16-00 added axcopy() feature -sm & tpj

function [projdata] = projtopo(data,weights,sphere,compnums,chan_locs,titl,limits,colors,plotchans)

icadefs      % read default PROJCOLORS & MAXPLOTDATACHANS variables from icadefs.m
axsize = 0;  % use plottopo() default
DEFAULT_TITLE = 'projtopo()';
%
% Substitute for missing arguments
%
if nargin < 8,
    colors = PROJCOLORS;
elseif colors==0,
    colors = PROJCOLORS;
end

if nargin < 7,
    limits = 0;
end
if nargin < 6,
    titl = 0;
end
if titl==0,
    titl = DEFAULT_TITLE;
end

if nargin < 5,
    help projtopo
    fprintf('projtopo(): must have at least five arguments.\n\n');
    return
end
%
% Test data size
%
[chans,framestot] = size(data);
if ~exist('plotchans') | isempty(plotchans) | plotchans==0
   plotchans = 1:chans; % default
end
frames = framestot; % assume one epoch

[wr,wc]           = size(weights);
[sr,sc]           = size(sphere);

if sc~=chans,
     fprintf('projtopo(): sizes of sphere and data matrices incompatible.\n');
    return
end;
if sr~=sc,
     fprintf('projtopo(): sphere must be a square matrix.\n');
    return
end;
if wc~=sr,
     fprintf('projtopo(): sizes of weights and sphere matrices incompatible.\n');
    return
end;
%
% Substitute for 0 arguments
%
if compnums == 0,
    compnums = [1:wr];
end;
if size(compnums,1)>1,        % handle column of compnums !
    compnums = compnums';
end;
if length(compnums) > MAXPLOTDATACHANS,
    fprintf(...
  'projtopo(): cannot plot more than %d channels of data at once.\n',...
         MAXPLOTDATACHANS);
    return
end;

if max(compnums)>wr,
   fprintf(...
 '\n    projtopo(): Component index (%d) > number of components (%d).\n', ...
                                 max(compnums),wr);
   return
end

fprintf('Reconstructing (%d chan, %d frame) data summing %d components.\n', ...
                   chans,frames,length(compnums));
%
% Compute projected data for single components
%
projdata = data;
fprintf('projtopo(): Projecting component(s) ');
for s=compnums,            % for each component 
   fprintf('%d ',s);
   proj = icaproj(data,weights,sphere,0,s); % let offsets distribute 
   projdata = [projdata proj];  % append projected data onto projdata
end;
fprintf('\n');
%
% Make the plot
%
% >> plottopo(data,'chan_locs',frames,limits,title,channels,axsize,colors,ydir) 

plottopo(projdata,chan_locs,size(data,2),limits,titl,plotchans,axsize,colors);
                                                % make the plottopo() plot
axcopy(gcf);
