% erpimage() - image single-trial ERPs optionally sorted on and/or aligned to 
%                 an input variable and smoothed by moving-average (Note: to
%                 return event-aligned data without plotting, use eventlock()).
%                 Click on axes to examine separately and zoom.
% Usage:
%   >> [outdata,outvar,outtrials,limits,axhndls,...
%         erp,amps,cohers,cohsig,ampsig,...
%           outamps,phsangls,phsamp,sortidx] = ...
%             erpimage(data,sortvar,times,'title',avewidth,decimate,[option(s)]);
% Inputs:
%   data     - single-channel data: format (1,frames*trials) or (frames,trials)
%   sortvar  - vector variable to sort trials on (ntrials = length(sortvar))
%                     Example: sortvar = rts (in ms)
%   times    - vector of times in ms (frames=length(times)){def|0->[0:frames-1]}
%              OR [startms ntimes srate] = start time (ms), sampling rate (Hz),
%                                          ntimes = time points per epoch
%  'title'   - title string {default none}
%   avewidth - ntrials in moving average window (may be non-int) {def|0->1}
%   decimate - factor to decimate ntrials out by (may be non-int) {def|0->1}
%   option(s)- 'align',[time] -> time lock data to sortvar aligned to time in msec
%                 (time = Inf -> align to median sortvar) {defulat: no align}
%            - 'nosort'-> don't sort data on sortvar {default: sort}
%            - 'noplot'-> don't plot sortvar {default: plot if in times range}
%            - 'limits',[lotime hitime minerp maxerp loamp hiamp locoher hicoher] 
%                        (can use nan for missing items and omit late items)
%            - 'caxis',[lo hi] -> set color axis limits {default: data bounds}
%            - 'cbar' -> plot color bar to right of erp-image {default no}
%            - 'erp' -> plot erp time average of the trials below the image
%            - 'phase', [time prctile freq] -> sort by phase at freq (Hz)
%                    or [time prct minfrq maxfrq] -> sort by phase at max 
%                freq. in [minfrq,maxfrq] in window ending at time (cf. times array)
%                prctile = percent data to reject for low amplitude (prct = [0-100]) 
%                or high amplitude (prctile = (-100-0)) {default: [0 25 8 13]}
%            - 'coher',[freq] -> plot erp plus amp & coher at freq (Hz)
%                    (or at phase freq above, if specified).
%                or [freq alpha] -> add coher. signif. level line at alpha
%                   (alpha range: (0,0.1]) {default none}
%            - 'allamps' -> image the amplitudes at each time & trial. Requires
%                   coher with alpha significance. {default image data, not allamps}
%            - 'srate',[freq]-> specify data sampling rate in Hz 
%                         (if not given in times arg above)
%            - 'vert',[times] -> plot vertical dotted lines at specified times
% Outputs:
%   outdata  = (times,epochsout) data matrix (after smoothing)
%   outvar   = (1,epochsout)  sortvar vector (after smoothing)
%   outtrials= (1,epochsout)  smoothed trial numbers 
%   limits   = (1,8) array as in option 'limits' above (undefined -> nan)
%   axhndls  = vector of 1-4 plot axes handles
%   erp      = plotted ERP average
%   amps     = mean amplitude time course
%   coher    = mean inter-trial phase coherence time course
%   cohsig   = coherence significance level
%   ampsig   = amplitude significance levels [lo high]
%   outamps  = matrix of imaged amplitudes
%   phsangls = vector of sorted trial phases at the phase-sorting frequency
%   phsamp   = vector of sorted trial amplitudes at the phase-sorting frequency
%   sortidx  = indices of sorted data epochs plotted

% Tzyy-Ping Jung & Scott Makeig, CNL / Salk Institute, La Jolla 3-2-98
% Uses external toolbox functions: phasecoher(), rmbase(), cbar()
% Uses included functions:         plot1erp(), phasedet(),
%
% 3/5/98 added nosort option -sm
% 3/22/98 added colorbar ylabel, sym. range finding -sm
% 5/08/98 added noplot option -sm
% 6/09/98 added align, erp, coher options -sm
% 6/10/98 added limits options -sm
% 6/26/98 made number of variables output 8, as above -sm 
% 9/16/98 plot out-of-bounds sortvars at nearest times boundary -sm
% 10/27/98 added cohsig, alpha -sm
% 10/28/98 adjust maxamp, maxcoh computation -sm
% 05/03/99 added horizontal ticks beneath coher trace, fixed vert. 
%          scale printing -t-pj
% 05/07/99 converted amps plot to log scaling -sm
% 05/14/99 added sort by alpha phase -se
% 07/23/99 made "Phase-sorted" axis label -sm
% 07/24/99 added 'allamps' option -sm
% 08/04/99 added new times spec., 'srate' arg, made 'phase' and 'allamps'
%          work together, plot re-aligned time zeros  -sm
% 06/26/99 debugged cbar; added vert lines at aligntime to plot1erp() axes -sm
% 09/29/99 fixed srate computation from times -sm & se
% 01/18/00 output outsort without clipping -sm
% 02/29/00 added 'vert' arg, fixed xticklabels, added ampsig -sm
% 03/03/00 added 'vert' arg lines to erp/amp/coher axes -sm
% 03/17/00 added axcopy -sm & tpj
%
% Known Bugs:
% 'limits', [lotime hitime] does not work with 'erp'
% 'limits', [... loerp hierp] (still??) may duplicate "ghost" grey numbers on the coher axis?

function [data,outsort,outtrials,limits,axhndls,erp,amps,cohers,cohsig,ampsig,allamps,phaseangles,phsamp,sortidx] = erpimage(data,sortvar,times,titl,avewidth,decfactor,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12)

%
%%%%%%%%%%%%%%%%%%%%%%% Define defaults %%%%%%%%%%%%%%%%%%%%%%%
%
YES = 1;  % logical variables
NO  = 0;

TIMEX = 1;          % 1 -> plot time on x-axis; 0 -> trials on x-axis
BACKCOLOR = [0.8 0.8 0.8]; % default grey background
PLOT_HEIGHT = 0.2; % fraction of y dim taken up by each time series axes
YGAP = 0.03;        % fraction gap between time axes
YEXPAND = 1.3;      % expansion factor for y-axis about erp, amp data limits
DEFAULT_AVEWIDTH =  1; % smooth trials with this window size by default
DEFAULT_DECFACTOR = 1; % decimate by this factor by default
DEFAULT_CYCLES = 3; % use this many cycles in amp,coher computation window
DEFAULT_CBAR = NO;  % do not plot color bar by default
DEFAULT_PHARGS = [0 25 8 13]; % Default arguments for phase sorting
DEFAULT_ALPHA = 0.01;

LABELFONT = 14;     % font sizes for axis labels, tick labels
TICKFONT  = 11;
alpha     = 0;      % default alpha level for coherence significance

Noshow    = NO;     % show sortvar by default
Nosort    = NO;     % sort on sortvar by default
Caxflag   = NO;     % use default caxis by default
Caxis     = [];
Coherflag = NO;     % don't compute or show amp,coher by default
Cohsigflag= NO;     % default: do not compute coherence significance
Allampsflag=NO;     % don't image the amplitudes by default
Erpflag   = NO;     % don't show erp average by default
Alignflag = NO;     % don't align data to sortvar by default
Colorbar  = NO;     % if YES, plot a colorbar to right of erp image
Limitflag = NO;     % plot whole times range by default
Phaseflag = NO;     % don't sort by alpha phase
Srateflag = NO;     % srate not given
Vertflag  = NO;
verttimes = [];
coherfreq = nan;    % amp/coher-calculating frequency
freq = 0;           % phase-sorting frequency
srate     = nan;
aligntime = nan;
timelimits= nan;

minerp = nan; % default limits
maxerp = nan;
minamp = nan;
maxamp = nan;
mincoh = nan;
maxcoh = nan;

ax1    = nan; % default axes handles
axcb   = nan;
ax2    = nan;
ax3    = nan;
ax4    = nan;

%
%%%%%%%%%%%%%%%%%%% Test, fill in commandline args %%%%%%%%%%%%%%
%
if nargin < 2
  help erpimage
  return
end

framestot = size(data,1)*size(data,2);
ntrials = length(sortvar);
if ntrials < 2
  help erpimage
  fprintf('\nerpimage(): too few trials.\n');
  return
end

frames = floor(framestot/ntrials);
if frames*ntrials ~= framestot
  help erpimage
  fprintf(...
    '\nerpimage(); length of sortvar doesnt divide no. of data elements.\n')
  return
end

if nargin < 6
  decfactor = 0;
end
if nargin < 5
  avewidth = 0;
end
if nargin<4
  titl = '';
end
if nargin<3
  times = NO;
end
if length(times) == 1 | times == NO,
   times = 0:frames-1;
   srate = 1000*(length(times)-1)/(times(length(times))-times(1));
   fprintf('Using sampling rate %g Hz.\n',srate);
elseif length(times) == 3
   mintime = times(1);
   frames = times(2);
   srate = times(3);
   times = mintime:1000/srate:mintime+(frames-1)*1000/srate;
   fprintf('Using sampling rate %g Hz.\n',srate);
else
   srate = 1000*(length(times)-1)/(times(end)-times(1));
end
if length(times) ~= frames
   fprintf(...
 'erpimage(): length(data)(%d) ~= length(sortvar)(%d) * length(times)(%d).\n\n',...
                        framestot,              length(sortvar),   length(times));
   return
end
if avewidth == 0,
  avewidth = DEFAULT_AVEWIDTH;
end
if decfactor == 0,
  decfactor = DEFAULT_DECFACTOR;
end
if avewidth < 1
  help erpimage
  fprintf('\nerpimage(): Variable avewidth cannot be < 1.\n')
  return
end
if avewidth > ntrials
  fprintf('Setting variable avewidth to max %d.\n',ntrials)
  avewidth = ntrials;  
end
if decfactor < 1
  help erpimage
  fprintf('\nerpimage(): Variable decfactor cannot be < 1.\n')
  return
end
if decfactor > ntrials
  fprintf('Setting variable decfactor to max %d.\n',ntrials)
  decfactor = ntrials;  
end
%
%%%%%%%%%%%%%%%%% Collect option args %%%%%%%%%%%%%%%%%%%%%%%%%
%
if nargin > 6
  flagargs = [];
  for i=7:nargin
    Arg = eval(['arg' int2str(i-6)]);
    if Caxflag == YES
      Caxis = Arg;
      if size(Caxis,1) ~= 1 | size(Caxis,2) ~= 2
        help erpimage
        fprintf('\nerpimage(): caxis arg must be a (1,2) vector.\n');
        return
      end
      Caxflag = NO;
    elseif Coherflag == YES
       if size(Arg,1) ~= 1 | ( size(Arg,2) ~= 1 & size(Arg,2) ~= 2)
        help erpimage
        fprintf('\nerpimage(): coher arg must be size (1,1) or (1,2).\n');
        return
       end
       coherfreq = Arg(1);
       if size(Arg,2) == 2
         Cohsigflag = YES;
         alpha  = Arg(2);
         if alpha < 0 | alpha > 0.1
           fprintf('erpimage(): alpha value %g out of bounds.\n',alpha); 
           return
         end
       end
       Coherflag = NO;
       Erpflag = YES;  % plot amp, coher below erp time series
    elseif Alignflag == YES
       if length(Arg) ~= 1 
        help erpimage
        fprintf('\nerpimage(): align arg must be a scalar msec.\n');
        return
       end
       aligntime = Arg(1);
       Alignflag = NO;
    elseif Limitflag == YES
      %  [lotime hitime loerp hierp loamp hiamp locoher hicoher]
      if size(Arg,1) ~= 1 | size(Arg,2) < 2 ...
          | size(Arg,2) > 8 ...
        help erpimage
        fprintf('\nerpimage(): limits arg must be a vector sized (1,2<->8).\n');
        return
      end
      if  (Arg(1) ~= nan) & (Arg(2) <= Arg(1))
        help erpimage
        fprintf('\nerpimage(): time limits out of order or out of range.\n');
        return
      end
      if Arg(1) < min(times)
          Arg(1) = min(times);
          fprintf('Adjusting mintime limit to first data value %g\n',min(times));
      end
      if Arg(2) > max(times)
          Arg(2) = max(times);
          fprintf('Adjusting maxtime limit to last data value %g\n',max(times));
      end
      timelimits = Arg(1:2);
      if length(Arg)> 2
        minerp = Arg(3);
      end
      if length(Arg)> 3
        maxerp = Arg(4);
      end
      if maxerp ~= nan & maxerp <= minerp
        help erpimage
        fprintf('\nerpimage(): erp limits args out of order.\n');
        return
      end
      if length(Arg)> 4
        minamp = Arg(5);
      end
      if length(Arg)> 5
        maxamp = Arg(6);
      end
      if maxamp <= minamp
        help erpimage
        fprintf('\nerpimage(): amp limits args out of order.\n');
        return
      end
      if length(Arg)> 6
        mincoh = Arg(7);
      end
      if length(Arg)> 7
        maxcoh = Arg(8);
      end
      if maxcoh <= mincoh
        help erpimage
        fprintf('\nerpimage(): coh limits args out of order.\n');
        return
      end
      Limitflag = NO;

     elseif Srateflag == YES
          srate = Arg(1);
          Srateflag = NO;
     elseif Vertflag == YES
          verttimes = Arg;
          Vertflag = NO;
     elseif Phaseflag == YES
          phargs = DEFAULT_PHARGS;
          n = length(Arg);
          if n > 4
            error('erpimage(): Too many arguments for keyword ''phase''');
          end
          if n == 4
            phargs = Arg;
          else
            phargs(1:n) = Arg;
          end
          
          if min(phargs([3:end])) < 0
            error('erpimage(): Invalid negative argument for keyword ''phase''');
          end
          if min(phargs(1)) < times(1) | max(phargs(1)) > times(end)
            error('erpimage(): End time for phase sorting filter out of bound.');
          end

          if phargs(2) >= 100 | phargs(2) < -100
            error('%-argument for keyword ''phase'' must be (-100;100)');
          end
          
          if length(phargs) == 4 & phargs(3) > phargs(4)
            error('erpimage(): Phase sorting frequency range must be increasing.');
          end
          if length(phargs) == 4 & phargs(3) == phargs(4)
            phargs = phargs(1:3);
          end
          Phaseflag = NO;
    elseif strcmp(Arg,'nosort')
      Nosort = YES;
    elseif strcmp(Arg,'noplot')
      Noshow = YES;
    elseif strcmp(Arg,'caxis')
      Caxflag = YES;
    elseif strcmp(Arg,'coher')
      Coherflag = YES;
    elseif strcmp(Arg,'allamps')
      Allampsflag = YES;
    elseif strcmp(Arg,'erp')
      Erpflag = YES;
    elseif strcmp(Arg,'align')
      Alignflag = YES;
    elseif strcmp(Arg,'cbar') | strcmp(Arg,'colorbar')
      Colorbar = YES;
    elseif strcmp(Arg,'limits')
      Limitflag = YES;
    elseif strcmp(Arg,'phase')
      Phaseflag = YES;
    elseif strcmp(Arg,'srate')
      Srateflag = YES;
    elseif strcmp(Arg,'vert')
      Vertflag = YES;
    else
      help erpimage
      fprintf('\nerpimage(): unknown arg %s\n',Arg);
      return
    end
  end
end

if   Caxflag == YES ...
  |Coherflag == YES ...
  |Alignflag == YES ...
  |Limitflag == YES
    help erpimage
    fprintf('\nerpimage(): missing option arg.\n')
    return
end
if Allampsflag & ( isnan(coherfreq) | ~Cohsigflag )
 fprintf('\nerpimage(): allamps flag requires coher freq, srate, and cohsig.\n');
 return
end
if ~exist('srate') | srate <= 0 
  fprintf('\nerpimage(): Data srate must be specified and > 0.\n');
  return
end
if exist('phargs')
 if phargs(3) > srate/2
  fprintf('erpimage(): Phase-sorting frequency must be less than Nyquist rate.');
 end
end
if ~isnan(coherfreq)
 if coherfreq <= 0 | coherfreq > srate/2 | srate <= 0
  fprintf('\nerpimage(): coher frequency (%g) out of range.\n',coherfreq);
  return
 end
end
          
if isnan(timelimits)
   timelimits = [min(times) max(times)];
end
if ~isnan(aligntime)
 if ~isinf(aligntime) ...
      & (aligntime < timelimits(1) | aligntime > timelimits(2))
  help erpimage
  fprintf('\nerpimage(): requested align time outside of time limits.\n');
  return
 end
end
% 
%%%%%%%%%%%%%%%%  Replace nan's with 0s %%%%%%%%%%%%%%%%%%%%
%
nans= find(isnan(data));
if length(nans)
  fprintf('Replaced %d nan in data with 0s.\n');
  data(nans) = 0;
end
%
%%%%%%%%%%%%%% Reshape data to (frames,ntrials) %%%%%%%%%%%%%
%
if size(data,2) ~= ntrials
   if size(data,1)>1
     data=reshape(data,1,frames*ntrials);
   end
   data=reshape(data,frames,ntrials);
end
fprintf('Plotting input data as %d epochs of %d frames.\n',...
                             ntrials,frames);
%
%%%%%%%%%%%%%%%%%%% Align data to sortvar %%%%%%%%%%%%%%%%%%%
%
if ~isnan(aligntime)
  if isinf(aligntime)
    ssv = sort(sortvar); % ssv = 'sorted sortvar'
    aligntime= median(sortvar);
    % aligntime= median(ssv(ceil(ntrials/20)):floor(19*ntrials/20)); 
                       % Alternative: trimmed median - ignore top/bottom 5%
    fprintf('Aligning data to median sortvar.\n'); 
  end
  fprintf('Realigned sortvar plotted at %g ms.\n',aligntime);

  aligndata=0*ones(frames,ntrials); % begin with matrix of nan's
  shifts = zeros(1,ntrials);
  for i=1:ntrials, %%%%%%%%% foreach trial %%%%%%%%%
   shft = round((aligntime-sortvar(i))*srate/1000);
   shifts(i) = shft;
   if shft>0, % shift right
    if frames-shft > 0
     aligndata(shft+1:frames,i)=data(1:frames-shft,i);
    else
     fprintf('No aligned data for epoch %d - shift (%d frames) too large.\n',i,shft);
    end
   elseif shft < 0 % shift left
    if frames+shft > 0
     aligndata(1:frames+shft,i)=data(1-shft:frames,i);
    else
     fprintf('No aligned data for epoch %d - shift (%d frames) too large.\n',i,shft);
    end
   else % shft == 0
     aligndata(:,i) = data(:,i);
   end 
  end % end trial
  fprintf('Shifted epochs by %d to %d frames.\n',min(shifts),max(shifts));
  data = aligndata;                       % now data is aligned to sortvar
end 
%
%%%%%%%%%%%%%%% Sort the data on sortvar %%%%%%%%%%%%%%%%%%%%
%
if exist('phargs') == 1
        if length(phargs) == 4 % find max frequency in specified band
                [pxx,freqs] = psd(data(:),1024,srate,frames,0);
                pxx = 10*log10(pxx);
                n = find(freqs >= phargs(3) & freqs <= phargs(4));
                [dummy maxx] = max(pxx(n));
                freq = freqs(n(maxx));
        else
                freq = phargs(3); % else use specified frequency
        end

        [dummy minx] = min(abs(times-phargs(1)));
        winlen = floor(3*srate/freq);
        winloc = minx-[winlen:-1:0];
        winloc = winloc(find(winloc>0 & winloc<=frames));

        [phaseangles phsamp] = phasedet(data,frames,srate,winloc,freq);

        fprintf(...
  'Sorting data epochs by phase at %.2f Hz, window ending at %f3. ms.\n',...  
             freq,phargs(1));
        fprintf('Phase is computed using a filter of length %d frames.\n',...
             length(winloc));

        %
        % reject small (or large) phsamp trials
        %
        if phargs(2)>=0
          n = find(prctile(phsamp,phargs(2)) <= phsamp);
          data = data(:,n);
        else
          phargs(2) = 100+phargs(2);
          n = find(prctile(phsamp,phargs(2)) >= phsamp);
          data = data(:,n);
        end
        %
        % remove low-amplitude trials
        %
        phaseangles = phaseangles(n);
        sortvar = sortvar(n);
        ntrials = length(n);
        %
        % sort remaining data by phase angle
        %
        [phaseangles sortidx] = sort(-phaseangles);
        data = data(:,sortidx);
        phaseangles = -phaseangles;
        phsamp = phsamp(n(sortidx));
        sortvar = sortvar(sortidx);
     fprintf('Size of data = [%d,%d]\n',size(data,1),size(data,2));
        sortidx = n(sortidx); % return original indices in sorted order

elseif Nosort == YES
  fprintf('Not sorting data on input sortvar.\n');
  sortidx = 1:ntrials;	
else
  fprintf('Sorting data on input sortvar.\n');
  [sortvar,sortidx] = sort(sortvar);
  data = data(:,sortidx);
end
if max(sortvar)<0
   fprintf('Inverting sortvar to make it positive.\n');
   sortvar = -sortvar;
end
% 
%%%%%%%%%%%%%%%%%% Smooth data using moving average %%%%%%%%
%
if ~isnan(coherfreq)
  urdata = data; % compute amp, coher on unsmoothed data
end
if ~Allampsflag % if imaging potential,
 if avewidth > 1 | decfactor > 1
  if Nosort == YES
    fprintf('Smoothing the data using a window width of %g epochs ',avewidth);
  else
    fprintf('Smoothing the sorted epochs with a %g-epoch moving window.',...
                       avewidth);
  end
  fprintf('\n');
  fprintf('  and a decimation factor of %g\n',decfactor);
  [data,outtrials] = movav(data,1:ntrials,avewidth,decfactor); 
                                            % Note: using square window
  [outsort,outtrials] = movav(sortvar,1:ntrials,avewidth,decfactor); 
  fprintf('Output data will be %d frames by %d smoothed trials.\n',...
                          frames,length(outtrials));
 else % don't smooth
  outtrials = 1:ntrials;
  outsort = sortvar;
 end

 %
 %%%%%%%%%%%%%%%%%%%%%%%%% Find color axis limits %%%%%%%%%%%%%%%%%
 %
 if ~isempty(Caxis) 
  mindat = Caxis(1);
  maxdat = Caxis(2);
  fprintf('Using the specified caxis range of [%g,%g].\n',...
                                           mindat,maxdat);
 else
  mindat = min(min(data));
  maxdat = max(max(data));
  maxdat =  max(abs([mindat maxdat])); % make symmetrical about 0
  mindat = -max(abs([mindat maxdat]));
  fprintf(...
     'The caxis range will be the sym. abs. data range [%g,%g].\n',...
                                                     mindat,maxdat);
 end
end % if ~Allampsflag
%
%%%%%%%%%%%%%%%%%%%%%%%%%% Set time limits %%%%%%%%%%%%%%%%%%%%%%
%
if isnan(timelimits(1))
    timelimits = [min(times) max(times)];
end
%
%%%%%%%%%%%%% Image the aligned/sorted/smoothed data %%%%%%%%%%%%
%
if ~isnan(coherfreq)       % if plot three time axes
     image_loy = 3*PLOT_HEIGHT;
elseif Erpflag == YES   % elseif if plot only one time axes
     image_loy = 1*PLOT_HEIGHT;
else                    % else plot erp-image only
     image_loy = 0*PLOT_HEIGHT;
end
gcapos=get(gca,'Position');
delete(gca)
ax1=axes('Position',...
    [gcapos(1) gcapos(2)+image_loy*gcapos(4) ...
     gcapos(3) (1-image_loy)*gcapos(4)]);

ind = isnan(data);    % find nan's in data
[i j]=find(ind==1);
if ~isempty(i)
  data(i,j) = 0;      % plot shifted nan data as 0 (=green)
end

if ~Allampsflag %%%%%%%%%%%%%%%% Plot ERP image %%%%%%%%%%%%%%%%%%%%%%%%%%%
 if TIMEX
  imagesc(times,outtrials,data',[mindat,maxdat]);% plot time on x-axis
  set(gca,'Ydir','normal');
  axis([timelimits(1) timelimits(2) ...
       min(outtrials) max(outtrials)]);
 else
  imagesc(outtrials,times,data,[mindat,maxdat]); % plot trials on x-axis
  axis([min(outtrials) max(outtrials)...
       timelimits(1) timelimits(2)]);
 end
 hold on
 drawnow
else % if Allampsflag %%%%%% Plot allamps instead of data %%%%%%%%%%%%%%%%%%
 if freq > 0 
    coherfreq = freq; % use phase-sort frequency
 end
 if alpha>0
   fprintf('Computing and plotting %g coherence significance level...\n',alpha);
   [amps,cohers,cohsig,ampsig,allamps] = ...
     phasecoher(urdata,length(times),srate,coherfreq,DEFAULT_CYCLES,alpha);
   fprintf('Coherence significance level: %g\n',cohsig);
   fprintf('Amplitude significance levels: [%g %g]\n',ampsig(1),ampsig(2));
 else
   [amps,cohers,cohsig,ampsig,allamps] = ...
     phasecoher(urdata,length(times),srate,coherfreq,DEFAULT_CYCLES,0);
 end
 % fprintf('#1 Size of allamps = [%d %d]\n',size(allamps,1),size(allamps,2));
 base = find(times<=0);
 if length(base)<2
     base = 1:floor(length(times)/4); % default first quarter-epoch
 end
 amps = 20*log10(amps); % convert to dB
 ampsig = 20*log10(ampsg); % convert to dB
 [amps,baseamp] = rmbase(amps,length(times),base); % remove baseline
 ampsig = ampsig-baseamp;
 baseall = mean(mean(allamps(base,:)));
 % fprintf('#2 Size of allamps = [%d %d]\n',size(allamps,1),size(allamps,2));
 fprintf('Dividing by the mean baseline amplitude %g\n',baseall);
 allamps = allamps./baseall;
 % fprintf('#3 Size of allamps = [%d %d]\n',size(allamps,1),size(allamps,2));

 if avewidth > 1 | decfactor > 1
     % Note: using square window
   if Nosort == YES
    fprintf('Smoothing the amplitude epochs using a window width of %g epochs ',avewidth);
   else
    fprintf('Smoothing the sorted amplitude epochs with a %g-epoch moving window.',...
                       avewidth);
   end
   fprintf('\n');
   fprintf('  and a decimation factor of %g\n',decfactor);
   fprintf('4 Size of allamps = [%d %d]\n',size(allamps,1),size(allamps,2));
   [allamps,outtrials] = movav(allamps,1:ntrials,avewidth,decfactor); 
                                            % Note: using square window
   fprintf('5 Size of allamps = [%d %d]\n',size(allamps,1),size(allamps,2));
   [outsort,outtrials] = movav(sortvar,1:ntrials,avewidth,decfactor); 
   fprintf('Output data will be %d frames by %d smoothed trials.\n',...
                          frames,length(outtrials));
 else
  outtrials = 1:ntrials;
  outsort = sortvar;
 end
 allamps = 20*log10(allamps); % convert to dB
 % allamps = allamps';
 %
 %%%%%%%%%%%%%%%%%%%%%%%%% Find color axis limits %%%%%%%%%%%%%%%%%
 %
 if ~isempty(Caxis) 
   mindat = Caxis(1);
   maxdat = Caxis(2);
  fprintf('Using the specified caxis range of [%g,%g].\n',...
                                           mindat,maxdat);
 else
  mindat = min(min(allamps));
  maxdat = max(max(allamps));
  maxdat =  max(abs([mindat maxdat])); % make symmetrical about 0
  mindat = -max(abs([mindat maxdat]));
  fprintf(...
     'The caxis range will be the sym. abs. data range [%g,%g].\n',...
                                                     mindat,maxdat);
 end
 %
 %%%%%%%%%%%%%%%%%%%%% Image amplitudes at coherfreq %%%%%%%%%%%%%%%%%%%%
 %
 fprintf('Plotting amplitudes at freq %g Hz instead of potentials.\n',coherfreq);
 if TIMEX
  imagesc(times,outtrials,allamps',[mindat,maxdat]);% plot time on x-axis
  set(gca,'Ydir','normal');
  axis([timelimits(1) timelimits(2) ...
       min(outtrials) max(outtrials)]);
 else
  imagesc(outtrials,times,allamps,[mindat,maxdat]); % plot trials on x-axis
  axis([min(outtrials) max(outtrials)...
       timelimits(1) timelimits(2)]);
 end
  drawnow
  hold on
end %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~isempty(verttimes)
  fprintf('Plotting vertical lines at times: ');
  for vt = verttimes
     fprintf('%g ',vt);
     if isnan(aligntime) % if non-aligned data
       if TIMEX          % overplot vt on image
         plot([vt vt],[0 max(outtrials)],'k:','Linewidth',2.0);
       else
         plot([0 max(outtrials)],[vt vt],'k:','Linewidth',2.0);
       end
     else                % aligned data
       if TIMEX          % overplot realigned vt on image
         plot(aligntime+vt-outsort,outtrials,'k:','LineWidth',2.0); 
       else
         plot(outtrials,aligntime+vt-outsort,'k:','LineWidth',2.0); 
       end                                                 
     end
  end
  fprintf('\n');
end

set(gca,'FontSize',TICKFONT)
hold on;
if ~isnan(aligntime) % if trials time-aligned 
 if times(1) <= aligntime & times(frames) >= aligntime
  plot([aligntime aligntime],[0 ntrials],'k','Linewidth',2.0); 
     % plot vertical line at aligntime
 end
else % trials not time-aligned 
 if times(1) <= 0 & times(frames) >= 0
  plot([0 0],[0 ntrials],'k:','Linewidth',2.4); % plot vertical line at time 0
 end
end

if Noshow == NO & (min(outsort) < timelimits(1) ...
                   | max(outsort) > timelimits(2))
  ur_outsort = outsort; % store the pre-adjusted values
  fprintf('Not all sortvar values within time vector limits: \n')
  fprintf('        outliers will be shown at nearest limit.\n');
  i = find(outsort< timelimits(1));
  outsort(i) = timelimits(1);
  i = find(outsort> timelimits(2));
  outsort(i) = timelimits(2);
end

if TIMEX
 if Nosort == YES
  l=ylabel('Trial Number');
 else
  if Phaseflag
    l=ylabel('Phase-sorted Trials');
  else
    l=ylabel('Sorted Trials');
  end
 end
else
 if Nosort == YES
  l=xlabel('Trial Number');
 else
  if Phaseflag
    l=ylabel('Phase-sorted Trials');
  else
    l=xlabel('Sorted Trials');
  end
 end
end
set(l,'FontSize',LABELFONT);

t=title(titl);
set(t,'FontSize',LABELFONT);

set(gca,'Box','off');
set(gca,'Fontsize',TICKFONT);
set(gca,'color',BACKCOLOR);
if Erpflag == NO
  l=xlabel('Time (ms)');
  set(l,'Fontsize',LABELFONT);
end
%
%%%%%%%%%%%%%%%%%%%% Overplot sortvar %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
if Noshow == YES
  fprintf('Not overplotting sorted sortvar on data.\n');

elseif isnan(aligntime) % plot sortvar on un-aligned data

  fprintf('Overplotting sorted sortvar on data.\n');
  hold on; 
  if TIMEX      % overplot sortvar
    plot(outsort,outtrials,'k','LineWidth',2); 
  else
    plot(outtrials,outsort,'k','LineWidth',2);
  end                                                 
  drawnow
else % plot re-aligned zeros on sortvar-aligned data
  fprintf('Overplotting sorted sortvar on data.\n');
  hold on; 
  if TIMEX      % overplot aligned sortvar on image
    plot([aligntime aligntime],[0 ntrials],'k','LineWidth',2);
  else
    plot([[0 ntrials],aligntime aligntime],'k','LineWidth',2);
  end
  fprintf('Overplotting realigned times-zero on data.\n');
  hold on; 
  if TIMEX      % overplot realigned 0-time on image
    plot(0+aligntime-outsort,outtrials,'k','LineWidth',1.6); 
  else
    plot(0+outtrials,aligntime-outsort,'k','LineWidth',1.6); 
  end                                                 
  drawnow
end
%
%%%%%%%%%%%%%%%%%%%%%%%% Plot colorbar %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
if Colorbar == YES
   pos=get(ax1,'Position');
   axcb=axes('Position',...
       [pos(1)+pos(3)+0.02 pos(2) ...
        0.03 pos(4)]);
   cbar(axcb,0,[mindat,maxdat]); % plot colorbar to right of image
    drawnow
   axes(ax1); % reset current axes to the erpimage
end
%
%%%%%%%%%%%%%%%%%%%%%%% Compute ERP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
if Erpflag == YES
 axes(ax1); % reset current axes to the erpimage
 xtick = get(ax1,'Xtick');     % remember x-axis tick locations
 xticklabel = get(ax1,'Xticklabel');     % remember x-axis tick locations
 erp=nanmean(data');           % compute erp average, ignoring nan's
 %
 %%%%%% Plot ERP time series below image %%%%%%%%%%%%%%%%%
 %
 if isnan(maxerp)
  fac = 10;
  maxerp = 0;
  while maxerp == 0
   maxerp = round(fac*YEXPAND*max(erp))/fac; % minimal decimal places
   fac = 10*fac;
  end
 end
 if isnan(minerp)
  fac = 1;
  minerp = 0;
  while minerp == 0
    minerp = round(fac*YEXPAND*min(erp))/fac; % minimal decimal places
    fac = 10*fac;
  end
 end
 limit = [timelimits(1:2) -max(abs([minerp maxerp])) max(abs([minerp maxerp]))];
          
 if ~isnan(coherfreq)
  set(ax1,'Xticklabel',[]);     % remove tick labels from bottom of image
  ax2=axes('Position',...
     [gcapos(1) gcapos(2)+2/3*image_loy*gcapos(4) ...
      gcapos(3) (image_loy/3-YGAP)*gcapos(4)]);
 else
  ax2=axes('Position',...
     [gcapos(1) gcapos(2) ...
      gcapos(3) image_loy*gcapos(4)]);
 end
 plot1erp(ax2,times,erp,limit); % plot ERP
 if ~isnan(aligntime)
   line([aligntime aligntime],[limit(3:4)*1.1],'Color','k'); % x=median sort value
 end

 set(ax2,'Xtick',xtick);        % use same Xticks as erpimage above
 if ~isnan(coherfreq)
   set(ax2,'Xticklabel',[]);    % remove tick labels from ERP x-axis
 else % bottom axis
   set(ax2,'Xticklabel',xticklabel); % add ticklabels to ERP x-axis
 end

 set(ax2,'Yticklabel',[]);      % remove tick labels from left of image
 set(ax2,'YColor',BACKCOLOR);
 if isnan(coherfreq)
  if TIMEX
   l=xlabel('Time (ms)');
   set(l,'FontSize',LABELFONT);
  else
   l=ylabel('Time (ms)');
   set(l,'FontSize',LABELFONT);
  end
 end

 if ~isempty(verttimes)
  for vt = verttimes
     if isnan(aligntime)
       if TIMEX      % overplot vt on ERP
         plot([vt vt],[limit(3:4)],'k:','Linewidth',2.0);
       else
         plot([0 max(outtrials)],[limit(3:4)],'k:','Linewidth',2.0);
       end
     else
       if TIMEX      % overplot realigned vt on ERP
         plot(repmat(median(aligntime+vt-outsort),1,2),[limit(3),limit(4)],'k:','LineWidth',2.0); 
       else
         plot([limit(3),limit(4)],repmat(median(aligntime+vt-outsort),1,2),'k:','LineWidth',2.0); 
       end                                                 
     end
   end
end

 ydelta = 1/10*(times(frames)-times(1)); 
 ytextoffset = times(1)-1.1*ydelta;
 ynumoffset = times(1)-0.3*ydelta; % was 0.3

 t=text(ynumoffset,0.7*limit(3), num2str(limit(3)));
 set(t,'HorizontalAlignment','right','FontSize',TICKFONT)

 t=text(ynumoffset,0.7*limit(4), num2str(limit(4)));
 set(t,'HorizontalAlignment','right','FontSize',TICKFONT)

 ynum = 0.7*(limit(3)+limit(4))/2;
 t=text(ytextoffset,ynum,'\muV','Rotation',90);
 set(t,'HorizontalAlignment','center','FontSize',LABELFONT)

 set(ax2,'Fontsize',TICKFONT);
 set(ax2,'Box','off','color',BACKCOLOR);
  drawnow
else
  erp = [];
end
%
%%%%%%%%%%%%%%%%%%%%% Plot amp, coher time series %%%%%%%%%%%%%%
%
if ~isnan(coherfreq) 
   if freq > 0 
      coherfreq = freq; % use phase-sort frequency
   end
   %
   %%%%%% Plot amp axis below ERP %%%%%%%%%%%%%%%%%%%%%%%%
   %
   axis('off')
   if ~Allampsflag %%%% don't repeat computation
    if Cohsigflag == NO
     fprintf('Computing and plotting amplitude at %g Hz.\n',coherfreq);
     [amps,cohers] = ...
       phasecoher(urdata,size(times,2),srate,coherfreq,DEFAULT_CYCLES);
    else
     fprintf(...
     'Computing and plotting %g coherence significance level at %g Hz...\n',...
                           alpha,                          coherfreq);
     [amps,cohers,cohsig,ampsig] = ...
       phasecoher(urdata,size(times,2),srate,coherfreq,DEFAULT_CYCLES,alpha);
     fprintf('Coherence significance level: %g\n',cohsig);
     fprintf('Amplitude significance levels: [%g %g]\n',ampsig(1),ampsig(2));
    end
    amps = 20*log10(amps); % convert to dB
    ampsig = 20*log10(ampsig); % convert to dB
    base = find(times<=0);
    if length(base)<2
       base = 1:floor(length(times)/4); % default first quarter-epoch
    end
    [amps,baseamp] = rmbase(amps,length(times),base); % remove baseline
    ampsig = ampsig-baseamp; % remove baseline
   end % ~Allampsflag

   ax3=axes('Position',...
     [gcapos(1) gcapos(2)+1/3*image_loy*gcapos(4) ...
      gcapos(3) (image_loy/3-YGAP)*gcapos(4)]);

   if isnan(maxamp) % if not specified
    fac = 1;
    maxamp = 0;
    while maxamp == 0
     maxamp = floor(YEXPAND*fac*max(amps))/fac; % minimal decimal place
     fac = 10*fac;
    end
    maxamp = maxamp + 10/fac;
   else
    maxamp = maxamp-baseamp;
   end
   if isnan(minamp) % if not specified
    fac = 1;
    minamp = 0;
    while minamp == 0
     minamp = floor(YEXPAND*fac*max(-amps))/fac; % minimal decimal place
     fac = 10*fac;
    end
    minamp = minamp + 10/fac;
    minamp = -minamp;
   else
    minamp = minamp-baseamp;
   end

   fprintf('    amps range: [%g,%g]\n',minamp,maxamp);
   plot1erp(ax3,times,amps,[timelimits(1) timelimits(2) minamp maxamp]); % plot AMP
   if ~isnan(aligntime)
     line([aligntime aligntime],[minamp maxamp]*1.1,'Color','k'); % x=median sort value
   end
   set(ax3,'Xtick',xtick);
   set(ax3,'Xticklabel',[]);   % remove tick labels from bottom of image
   set(ax3,'Yticklabel',[]);   % remove tick labels from left of image
   set(ax3,'YColor',BACKCOLOR);
   axis('off');
   set(ax3,'Box','off','color',BACKCOLOR);

   if ~isempty(verttimes)
    for vt = verttimes
     if isnan(aligntime)
       if TIMEX      % overplot vt on amp
         plot([vt vt],[minamp maxamp],'k:','Linewidth',2.0);
       else
         plot([0 max(outtrials)],[minamp maxamp],'k:','Linewidth',2.0);
       end
     else
       if TIMEX      % overplot realigned vt on amp
         plot(repmat(median(aligntime+vt-outsort),1,2),[minamp,maxamp],'k:','LineWidth',2.0); 
       else
         plot([minamp,maxamp],repmat(median(aligntime+vt-outsort),1,2),'k:','LineWidth',2.0); 
       end                                                 
     end
    end
   end

   if Cohsigflag % plot amplitude significance levels
     hold on
      plot([timelimits(1) timelimits(2)],[ampsig(1) ampsig(1)],'r');
      plot([timelimits(1) timelimits(2)],[ampsig(2) ampsig(2)],'r');
   end

   t=text(ynumoffset,maxamp, num2str(maxamp,3));
   set(t,'HorizontalAlignment','right','FontSize',TICKFONT);

   t=text(ynumoffset,0, num2str(0));
   set(t,'HorizontalAlignment','right','FontSize',TICKFONT);

   t=text(ynumoffset,minamp, num2str(minamp,3));
   set(t,'HorizontalAlignment','right','FontSize',TICKFONT);

   t=text(ytextoffset,(maxamp+minamp)/2,'dB','Rotation',90);
   set(t,'HorizontalAlignment','center','FontSize',LABELFONT);

   axtmp = axis;
   text(1/13*(axtmp(2)-axtmp(1))+axtmp(1), ...
        11/13*(axtmp(4)-axtmp(3))+axtmp(3), ...
        [num2str(baseamp,4) ' dB']);
    drawnow;
   %
   %%%%%% Make coher axis below amp %%%%%%%%%%%%%%%%%%%%%%
   %
   ax4=axes('Position',...
     [gcapos(1) gcapos(2) ...
      gcapos(3) (image_loy/3-YGAP)*gcapos(4)]);
   if isnan(maxcoh)
    fac = 1;
    maxcoh = 0;
    while maxcoh == 0
     maxcoh = floor(YEXPAND*fac*max(cohers))/fac; % minimal decimal place
     fac = 10*fac;
    end
    maxcoh = maxcoh + 10/fac;
   end
   if isnan(mincoh)
     mincoh = 0;
   end
   coh_handle = plot1erp(ax4,times,cohers,[timelimits mincoh maxcoh]); % plot COHER
   if ~isnan(aligntime)
     line([aligntime aligntime],[[mincoh maxcoh]*1.1],'Color','k'); % x=median sort value
   end
   % set(ax4,'Xticklabel',[]);    % remove tick labels from bottom of image
   set(ax4,'Xtick',xtick);
   set(ax4,'Xticklabel',xticklabel);
   set(ax4,'Yticklabel',[]);    % remove tick labels from left of image
   set(ax4,'YColor',BACKCOLOR);

   if ~isempty(verttimes)
    for vt = verttimes
     if isnan(aligntime)
       if TIMEX      % overplot vt on coher
         plot([vt vt],[mincoh maxcoh],'k:','Linewidth',2.0);
       else
         plot([0 max(outtrials)],[mincoh maxcoh],'k:','Linewidth',2.0);
       end
     else
       if TIMEX      % overplot realigned vt on coher
         plot(repmat(median(aligntime+vt-outsort),1,2),[mincoh,maxcoh],'k:','LineWidth',2.0); 
       else
         plot([mincoh,maxcoh],repmat(median(aligntime+vt-outsort),1,2),'k:','LineWidth',2.0); 
       end                                                 
     end
    end
   end

   t=text(ynumoffset,0, num2str(0));
   set(t,'HorizontalAlignment','right','FontSize',TICKFONT);

   t=text(ynumoffset,maxcoh, num2str(maxcoh));
   set(t,'HorizontalAlignment','right','FontSize',TICKFONT);

   t=text(ytextoffset,maxcoh/2,'Coh','Rotation',90);
   set(t,'HorizontalAlignment','center','FontSize',LABELFONT);
    drawnow

   if Cohsigflag % plot coherence significance level
     hold on
     plot([timelimits(1) timelimits(2)],[cohsig cohsig],'r');
   end

   set(ax4,'Box','off','color',BACKCOLOR);
   set(ax4,'Fontsize',TICKFONT);
   l=xlabel('Time (ms)');
   set(l,'Fontsize',LABELFONT);
   axtmp = axis;
   text(8/13*(axtmp(2)-axtmp(1))+axtmp(1), ...
        8/13*(axtmp(4)-axtmp(3))+axtmp(3), ...
        [num2str(coherfreq,4) ' Hz']);
else
   amps   = [];    % null outputs unless coherfreq specified
   cohers = [];
end
limits = [timelimits(1:2) minerp maxerp minamp maxamp mincoh maxcoh];
axhndls = [ax1 axcb ax2 ax3 ax4];
if exist('ur_outsort')
   outsort = ur_outsort; % restore outsort clipped values, if any
end
if nargout<1
   data = []; % don't spew out data if no args out and no ;
end

axcopy; % turn on popup zoom windows
%
%%%%%%%%%%%%%%%%%%% function plot1erp() %%%%%%%%%%%%%%%%%%%%%%%%
%
function [plot_handle] = plot1erp(ax,Time,erp,axlimits)

  [plot_handle] = plot(Time,erp,'LineWidth',1.9); hold on
  axis([axlimits(1:2) 1.1*axlimits(3:4)])
  l1=line([axlimits(1:2)],[0 0],    'Color','k','linewidth',2.0); % y=zero-line
  l2=line([0 0],[axlimits(3:4)*1.1],'Color','k','linewidth',1.6); % x=zero-line

%
%%%%%%%%%%%%%%%%%%% function phasedet() %%%%%%%%%%%%%%%%%%%%%%%%
%
% phasedet() - function used in erpimage.m
%              Constructs a complex filter at frequency freq
%

function [ang,amp,win] = phasedet(data,frames,srate,nwin,freq)
% Typical values:
%   frames = 768;
%   srate = 256;
%   nwin = [200:300];
%   freq = 10;

data = reshape(data,[frames prod(size(data))/frames]);
win = exp(2i*pi*freq(:)*[1:length(nwin)]/srate);
win = win .* repmat(hanning(length(nwin))',length(freq),1);
resp = win * data(nwin,:);
ang = angle(resp);
amp = abs(resp);
if ~exist('allamps')
   allamps = [];
end
