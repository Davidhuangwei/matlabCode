% timef() - Returns estimates and plots of event-related (log) spectral
%           perturbation (ERSP) and inter-trial coherence (ITC) changes 
%           in an input data channel. (To plot only the ERSP or ITC, 
%           set ERSP_PLOT or ITC_PLOT flags to 0 in script file).
%           Uses either fixed-window, zero-padded FFTs (fastest), OR wavelet
%           0-padded DFTs, both Hanning-tapered. Output frequency spacing is 
%           the lowest frequency (srate/winsize) divided by the padratio.
%           NaN input values (such as returned by eventlock()) are ignored.
%           If a topo vector and electrode location file are given, 
%           the figure also shows a topoplot() of the specified scalp map.
%           If coher alpha is given, then bootstrap statistics are computed 
%           (from a distribution of NACCU(=200) surrogate data epochs) and 
%           non-significant features of the output plots are zeroed out 
%           (i.e., plotted in green). If BASE_BOOT set in script, surrogate
%           ERSP data is drawn from windows with center times < DEFAULT_BASELN(=0) 
%           Left-click on a subplot to view it in a separate window.
%
% Usage: 
%      >> [ersp,itc,powbase,times,freqs,erspboot,itcboot] = timef(data,        ...
%                                              frames,tlimits,titl,            ...
%                                              srate,cycles,winsize,timesout,  ...
%                                              padratio,maxfreq,tvec,eloc_file,...
%                                              alpha,marktimes,powbase,pboot,rboot);
%
% NOTE: >> timef details  % scrolls more detailed info!
%
% Inputs:                                                   {defaults}
%       data        = single-channel (1,frames*nepochs) data  {none}
%       frames      = frames per epoch                        {768}
%       tlimits     = epoch time limits (ms) [mintime maxtime]{[-1000 2000]}
%       titl        = figure title                            {none}
%       srate       = data sampling rate (Hz)                 {256}
%       cycles      = >0 -> number of cycles in each analysis window 
%                     =0 -> use FFT (constant window length)  {0}
%                     Note that when cycles==0, nfreqs is total number of FFT 
%                     frequencies.
%       winsize     = cycles==0: data subwindow length (2^k<frames)
%                     cycles >0: *longest* window length to use; 
%                     determines the lowest output frequency  {~frames/8}
%       timesout    = number of output times (int<frames-winframes){200}
%       padratio    = FFT-length/winframes (2^k)              {2}
%                     Multiplies the number of output frequencies by
%                     dividing their spacing. When cycles==0, frequency
%                     spacing is (low freq/padratio).
%       maxfreq     = maximum frequency to plot (Hz) (and to output, 
%                     if cycles==0)                           {50}
%       tvec        = scalp topography (map) to plot          {[]}
%       eloc_file   = electrode location file for scalp map   {no default}
%                     ascii file in format of  >> topoplot example   
%       alpha       = Two-tailed bootstrap significance prob. level {none}
%                     Sets n.s. plotted output values to green (0). 
%       marktimes   = times to mark with a dotted vertical line{def|nan->none}
%       powbase     = baseline spectrum to log-subtract       {def|nan->from data}
%       pboot       = bootstrap power limits (cf. timef() out){def|nan -> from data}
%       rboot       = bootstrap ITC limits (cf. timef() out)  {def|nan -> from data}
%
% Outputs: 
%            ersp   = log spectral differences (dB) from baseline (nfreqs,timesout)
%            itc    = inter-trial coherencies (nfreqs,timesout) (range: [0 1])
%          powbase  = baseline power spectrum (in whole epoch or given baseline)
%            times  = vector of output times (subwindow centers) in ms.
%            freqs  = vector of frequency bin centers in Hz.
%         erspboot  = [2,nfreqs] matrix of [lower;upper] ERSP significance diffs.
%          itcboot  = [2,nfreqs] matrix of [lower;upper] ITC thresholds (not diffs).
%
% Authors: Sigurd Enghoff & Scott Makeig, SCCN/INC/UCSD, La Jolla, 8/1/98
%
% See also: timefrq(), timefdetails()

% 10-19-98 avoided division by zero (using MIN_ABS) -sm
% 10-19-98 improved usage message and commandline info printing -sm
% 10-19-98 made valid [] values for tvec and eloc_file -sm
% 04-01-99 added missing freq in freqs and plots, fixed log scaling bug -se & -tpj
% 06-29-99 fixed frequency indexing for constant-Q -se
% 08-24-99 reworked to handle NaN input values -sm
% 12-07-99 adjusted ERPtimes to plot ERP under ITC -sm
% 12-22-99 debugged ERPtimes, added BASE_BOOT -sm 
% 01-10-00 debugged BASE_BOOT=0 -sm
% 02-28-00 added NOTE on formula derivation below -sm
% 03-16-00 added axcopy() feature -sm & tpj
% 04-16-00 added multiple marktimes loop -sm
% 04-20-00 fixed ITC cbar limits when spcified in input -sm
% 07-29-00 changed frequencies displayed msg -sm
% 10-12-00 fixed bug in freqs when cycles>0 -sm
% 02-07-01 fixed inconsistency in BASE_BOOT use -sm
% 01-25-02 reformated help & license, added links -ad 

function [P,R,mbase,times,freqs,Pboot,Rboot] = timef(X,epoch,timelim,ftitle,Fs,varwin,winsize,nwin,oversmp,maxfreq,topovec,eloc_file,alpha,marktimes,powbase,pboot,rboot)

% NOTE:  Normally, R = |Sum(Pxy)| / (Sum(|Pxx|)*Sum(|Pyy|)) is coherence.
%        But here, we consider    Phase(PPy) = 0 and |Pyy| = 1 -> Pxy = Pxx
%          giving, R = |Sum(Pxx)|/Sum(|Pxx|), the inter-trial coherence (ITC)

% Constants set here:
PLOT_ERSP       = 1;            % Flag plot of spectral perturb. (ERSP) (1/0)
PLOT_ITC        = 1;			% Flag plot of inter-trial coherence (1/0)
LINEWIDTH       = 2;            % plot thick (2) or thin (1) traces

BASE_BOOT       = 0;            % 0 = bootstrap ERSP averages from whole epoch 
                                % 1 = bootstrap ERSP averages from baseline only
BASELINE_END    = 0;            % times < this are in the BASE_BOOT baseline.

NACCU           = 200;			% Number of bootstrap sub-windows to accumulate
ERSP_CAXIS_LIMIT = 0;           % 0 -> use data limits; else positive value
                                % giving symmetric +/- caxis limits.
ITC_CAXIS_LIMIT  = 0;           % 0 -> use data limits; else positive value
                                % giving symmetric +/- caxis limits.
MIN_ABS          = 1e-8;        % avoid division by ~zero

% Commandline arg defaults:
DEFAULT_EPOCH	= 768;			% Frames per epoch
DEFAULT_TIMELIM = [-1000 2000];	% Time range of epochs (ms)
DEFAULT_FS		= 256;			% Sampling frequency (Hz)
DEFAULT_NWIN	= 200;			% Number of windows = horizontal resolution
DEFAULT_VARWIN	= 0;			% Fixed window length or fixed number of cycles.
								% =0: fix window length to that determined by nwin
								% >0: set window length equal to varwin cycles
								%     Bounded above by winsize, which determines
								%     the min. freq. to be computed.
DEFAULT_OVERSMP	= 2;			% Number of times to oversample frequencies 
DEFAULT_MAXFREQ = 50;			% Maximum frequency to display (Hz)
DEFAULT_TITLE	= '';			% Figure title
DEFAULT_ELOC    = 'chan.locs';	% Channel location file
DEFAULT_ALPHA   = nan;			% Percentile of bins to keep
DEFAULT_MARKTIME= nan;

% Font sizes:
AXES_FONT       = 10;           % axes text FontSize
TITLE_FONT      = 8;

if (nargin < 1)
	help timefold
	return
end

if isstr(X) & strcmp(X,'details')
   more on
   help timefdetails
   more off
   return
end

if (min(size(X))~=1 | length(X)<2)
	error('Data must be a row or column vector.');
end

if (nargin < 2)
	epoch = DEFAULT_EPOCH;
elseif (~isnumeric(epoch) | length(epoch)~=1 | epoch~=round(epoch))
	error('Value of frames must be an integer.');
elseif (epoch <= 0)
	error('Value of frames must be positive.');
elseif (rem(length(X),epoch) ~= 0)
	error('Length of data vector must be divisible by frames.');
end

if (nargin < 3)
	timelim = DEFAULT_TIMELIM;
elseif (~isnumeric(timelim) | sum(size(timelim))~=3)
	error('Value of tlimits must be a vector containing two numbers.');
elseif (timelim(1) >= timelim(2))
	error('tlimits interval must be ascending.');
end

if (nargin < 4)
	ftitle = DEFAULT_TITLE;
elseif (~ischar(ftitle))
	error('Title must be a string.');
end

if (nargin < 5)
	Fs = DEFAULT_FS;
elseif (~isnumeric(Fs) | length(Fs)~=1)
	error('Value of srate must be a number.');
elseif (Fs <= 0)
	error('Value of srate must be positive.');
end

if (nargin < 6)
	varwin = DEFAULT_VARWIN;
elseif (~isnumeric(varwin) | length(varwin)~=1)
	error('Value of cycles must be a number.');
elseif (varwin < 0)
	error('Value of cycles must be zero or positive.');
end

if (nargin < 7)
	winsize = max(pow2(nextpow2(epoch)-3),4);
elseif (~isnumeric(winsize) | length(winsize)~=1 | winsize~=round(winsize))
	error('Value of winsize must be an integer number.');
elseif (winsize <= 0)
	error('Value of winsize must be positive.');
elseif (varwin == 0 & pow2(nextpow2(winsize)) ~= winsize)
	error('Value of winsize must be an integer power of two [1,2,4,8,16,...]');
elseif (winsize > epoch)
	error('Value of winsize must be less than epoch length.');
end

if (nargin < 8)
	nwin = DEFAULT_NWIN;
elseif (~isnumeric(nwin) | length(nwin)~=1 | nwin~=round(nwin))
	error('Value of timesout must be an integer number.');
elseif (nwin <= 0)
	error('Value of timesout must be positive.');
end
if (nwin > epoch-winsize)
	error('Value of timesout must be <= epoch-winsize.');
end

if (nargin < 9)
	oversmp = DEFAULT_OVERSMP;
elseif (~isnumeric(oversmp) | length(oversmp)~=1 | oversmp~=round(oversmp))
	error('Value of padratio must be an integer.');
elseif (oversmp <= 0)
	error('Value of padratio must be positive.');
elseif (pow2(nextpow2(oversmp)) ~= oversmp)
	error('Value of padratio must be an integer power of two [1,2,4,8,16,...]');
end

if (nargin < 10)
	maxfreq = DEFAULT_MAXFREQ;
elseif (~isnumeric(maxfreq) | length(maxfreq)~=1)
	error('Value of maxfreq must be a number.');
elseif (maxfreq <= 0)
	error('Value of maxfreq must be positive.');
elseif (maxfreq > Fs/2)
	fprintf('Warning: value of maxfreq greater that Nyquist rate\n\n');
end

if (nargin < 11)
	topovec = [];
elseif isempty(topovec)
	topovec = [];
elseif (min(size(topovec))~=1)
	error('tvec must be a row or column vector.');
end

if (nargin < 12)
	eloc_file = DEFAULT_ELOC;
elseif isempty(eloc_file)
	eloc_file = DEFAULT_ELOC;
elseif (~ischar(eloc_file))
	error('Channel location file must be a valid text file.');
end

if (nargin < 13)
	alpha = DEFAULT_ALPHA;
elseif (~isnumeric(alpha) | length(alpha)~=1)
	error('timef(): Value of alpha must be a number.\n');
elseif (round(NACCU*alpha) < 2)
	fprintf('Value of alpha is out of the normal range [%g,0.5]\n',2/NACCU);
    NACCU = round(2/alpha);
	fprintf('  Increasing the number of bootstrap iterations to %d\n',NACCU);
end
if alpha>0.5 | alpha<=0
    error('Value of alpha is out of the allowed range (0.00,0.5).');
end
if ~isnan(alpha)
   if BASE_BOOT > 0
     fprintf('Bootstrap analysis will use data drawn from baseline windows only.\n')
   else
     fprintf('Bootstrap analysis will use data drawn from all subwindows.\n')
   end
end

if nargin<14
  marktimes = DEFAULT_MARKTIME;
end

if nargin<15
  powbase = nan;
end

if nargin<16
  pboot = nan;
end

if nargin<17
  rboot = nan;
elseif size(rboot) == [1,1]
  if varwin == 0
     rboot = rboot*ones(winsize*oversmp/2);
  end
end

if (varwin == 0) %%%%%%%%%%%%%% constant window-length FFTs %%%%%%%%%%%%%%%%
	freqs = Fs/winsize*[1:2/oversmp:winsize]/2;
	win = hanning(winsize);

	P  = zeros(oversmp*winsize/2,nwin); % summed power
	PP = zeros(oversmp*winsize/2,nwin); % power
	R  = zeros(oversmp*winsize/2,nwin); % mean coherence
	RR = zeros(oversmp*winsize/2,nwin); % (coherence)
	Pboot = zeros(oversmp*winsize/2,NACCU); % summed bootstrap power
	Rboot = zeros(oversmp*winsize/2,NACCU); % summed bootstrap coher
    Rn = zeros(1,nwin);
    Rbn = 0;

else % %%%%%%%%%%%%%%%%%% Constant-Q (wavelet) DFTs %%%%%%%%%%%%%%%%%%%%%%%%%%%%

	freqs = Fs*varwin/winsize*[2:2/oversmp:winsize]/2;
    dispf = find(freqs <= maxfreq);
    freqs = freqs(dispf);

	win = dftfilt(winsize,maxfreq/Fs,varwin,oversmp,1);
	P = zeros(size(win,2),nwin);       % summed power
	R = zeros(size(win,2),nwin);       % mean coherence
	PP = repmat(nan,size(win,2),nwin); % initialize with nans
	RR = repmat(nan,size(win,2),nwin); % initialize with nans
	Pboot = zeros(size(win,2),NACCU);  % summed bootstrap power
	Rboot = zeros(size(win,2),NACCU);  % summed bootstrap coher
    Rn = zeros(1,nwin);
    Rbn = 0;
end

wintime = (1000/Fs)*(winsize/2);
times = [timelim(1)+wintime:(timelim(2)-timelim(1)-2*wintime)/(nwin-1):timelim(2)-wintime];
ERPtimes = [timelim(1):(timelim(2)-timelim(1))/(epoch-1):timelim(2)+0.000001];
ERPindices = [];
for ti=times
 [tmp indx] = min(abs(ERPtimes-ti));
 ERPindices  = [ERPindices indx];
end
ERPtimes = ERPtimes(ERPindices); % subset of ERP frames on t/f window centers

if BASE_BOOT
   baseln = find(times < BASELINE_END); % subtract means of pre-0 (centered) windows
else
   baseln = 1:length(times); % use all times as baseline
end
if ~isnan(alpha) & length(baseln)==0
  fprintf('timef(): no window centers in baseline (times<%g) - shorten (max) window length.\n', BASELINE_END)
  return
elseif ~isnan(alpha) & BASE_BOOT
  fprintf('   %d bootstrap windows in baseline (times<%g).\n',...
          BASELINE_END,length(baseln))
end
dispf = find(freqs <= maxfreq);
stp = (epoch-winsize)/(nwin-1);

fprintf('Computing Event-Related Spectral Perturbation (ERSP) and\n');
fprintf('  Inter-trial Coherence (ITC) images based on %d trials\n',length(X)/epoch);
fprintf('  of %d frames sampled at %g Hz.\n',epoch,Fs);
fprintf('Each trial contains samples from %d ms before to\n',timelim(1));
fprintf('  %d ms after the timelocking event.\n',timelim(2));
fprintf('The window size used is %d samples (%g ms) wide.\n',winsize,2*wintime);
fprintf('The window is applied %d times at an average step\n',nwin);
fprintf('  size of %g samples (%gms).\n',stp,1000*stp/Fs);
fprintf('Results are oversampled %d times; the %d frequencies\n',oversmp,length(dispf));
fprintf('  displayed are from %2.1f Hz to %3.1f Hz.\n',freqs(dispf(1)),freqs(dispf(end)));
if ~isnan(alpha)
  fprintf('Only significant values (bootstrap p<%g) will be colored;\n',alpha) 
  fprintf('  non-significant values will be plotted in green\n');
end

trials = length(X)/epoch;
baselength = length(baseln);
fprintf('\nOf %d trials total, processing trial:',trials);

for i=1:trials
    if (rem(i,100)==0)
        fprintf('\n');
    end
	if (rem(i,10) == 0)
		fprintf('%d',i);
	elseif (rem(i,2) == 0)
		fprintf('.');
	end

    ERP = blockave(X,epoch); % compute the ERP trial average

    Wn = zeros(1,nwin);
	for j=1:nwin,
		tmpX = X([1:winsize]+floor((j-1)*stp)+(i-1)*epoch); % pull out data epoch
		tmpX = tmpX - mean(tmpX);
		if ~any(isnan(tmpX))
		  if (varwin == 0) % FFT
			tmpX = win .* tmpX(:);
			tmpX = fft(tmpX,oversmp*winsize);
			tmpX = tmpX(2:oversmp*winsize/2+1);
		  else % wavelet
			tmpX = win' * tmpX(:); 
          end
		
		  PP(:,j) = abs(tmpX).^2; % power
          if abs(tmpX) < MIN_ABS
		   RR(:,j) = zeros(size(RR(:,j)));
          else
		   RR(:,j) = tmpX ./ abs(tmpX); % normalized cross-spectral vector
          end
          Wn(j) = 1;
        end
	end % window

	if ~isnan(alpha) % save surrogate data for bootstrap analysis
        j = 1;
        goodbasewins = find(Wn==1);
        if BASE_BOOT % use baseline windows only
          goodbasewins = find(goodbasewins<=baselength); 
        end
        ngdbasewins = length(goodbasewins);
        if ngdbasewins>1
		  while j <= NACCU
            i=ceil(rand*ngdbasewins);
            i=goodbasewins(i);
			Pboot(:,j) = Pboot(:,j) + PP(:,i);
			Rboot(:,j) = Rboot(:,j) + RR(:,i);
            j = j+1;
          end
          Rbn = Rbn + 1;
	    end
	end % bootstrap
	
    Wn = find(Wn>0);
    if length(Wn)>0
	  P(:,Wn) = P(:,Wn) + PP(:,Wn); % add non-nan windows
	  R(:,Wn) = R(:,Wn) + RR(:,Wn);
	  Rn(Wn) = Rn(Wn) + ones(1,length(Wn)); % count number of addends
    end
end % trial
fprintf('\nNow plotting...\n');

if min(Rn) < 1
  fprintf('timef(): No valid timef estimates for windows %s of %d.\n',...
                         int2str(find(Rn==0)),length(Rn));
  Rn(find(Rn<1))==1;
  return
end
P = P ./ (ones(size(P,1),1) * Rn);
if isnan(powbase)
  fprintf('Computing the mean baseline spectrum\n');
  mbase = mean(P(:,baseln)');
else
  fprintf('Using the input baseline spectrum\n');
  mbase = powbase;
end
P = 10 * (log10(P) - repmat(log10(mbase)',[1 nwin])); % convert to (10log10) dB
Rsign = sign(imag(R));
R = abs(R) ./ (ones(size(R,1),1)*Rn); % convert coherence vector to magnitude

if ~isnan(alpha) % if bootstrap analysis included . . .
    if Rbn>0
	 i = round(NACCU*alpha);
     if isnan(pboot)
      Pboot = Pboot / Rbn; % normalize
	  Pboot = 10 * (log10(Pboot) - repmat(log10(mbase)',[1 NACCU]));
	  Pboot = sort(Pboot');
	  Pboot = [mean(Pboot(1:i,:)) ; mean(Pboot(NACCU-i+1:NACCU,:))];
     else
      Pboot = pboot;
     end
  
     if isnan(rboot)
	  Rboot = abs(Rboot) / Rbn;
	  Rboot = sort(Rboot');
	  Rboot = mean(Rboot(NACCU-i+1:NACCU,:));
     else
      Rboot = rboot;
     end
    else
      fprintf('No valid bootstrap trials...!\n');
    end
end

set(gcf,'DefaultAxesFontSize',AXES_FONT)
colormap(jet(256));

pos = get(gca,'position');
q = [pos(1) pos(2) 0 0];
s = [pos(3) pos(4) pos(3) pos(4)];

if (PLOT_ERSP & PLOT_ITC) %%%%%%%% image both ERSP and ITC %%%%%%%%%%%%%%%%%%

	h(1) = subplot('Position',[.1 .67 .9 .33].*s+q);
	
	PP = P;
	if ~isnan(alpha) % zero out nonsignif. power differences
		PP(find((PP > repmat(Pboot(1,:)',[1 nwin])) ...
                    & (PP < repmat(Pboot(2,:)',[1 nwin])))) = 0;
	end

    if ERSP_CAXIS_LIMIT == 0
	   ersp_caxis = [-1 1]*1.1*max(max(abs(P(dispf,:))));
    else
       ersp_caxis = ERSP_CAXIS_LIMIT*[-1 1];
    end
    %
    %%%%%%% image the ERSP %%%%%%%%%%%%%%%%%%%%%%%%%%
    %
	imagesc(times,freqs(dispf),PP(dispf,:),ersp_caxis); 

	hold on
	plot([0 0],[0 freqs(max(dispf))],'--m','LineWidth',LINEWIDTH); % plot time 0
    if ~isnan(marktimes) % plot marked time
     for mt = marktimes(:)'
	   plot([mt mt],[0 freqs(max(dispf))],'--k','LineWidth',LINEWIDTH);
     end
    end
	hold off
	set(h(1),'YTickLabel',[],'YTick',[])
	set(h(1),'XTickLabel',[],'XTick',[])

	h(2) = gca;
	h(3) = cbar('vert'); % ERSP colorbar axes
	set(h(2),'Position',[.1 .67 .8 .33].*s+q)
	set(h(3),'Position',[.95 .67 .05 .33].*s+q)
	title('ERSP (dB)')

	E = [min(P(dispf,:));max(P(dispf,:))];
	h(4) = subplot('Position',[.1 .57 .8 .1].*s+q); % plot marginal ERSP means
                                                    % below the ERSP image
	plot(times,E,[0 0],...
	     [min(E(1,:))-max(max(abs(E)))/3 max(E(2,:))+max(max(abs(E)))/3], ...
             '--m','LineWidth',LINEWIDTH)
	axis([min(times) max(times) ...
             min(E(1,:))-max(max(abs(E)))/3 max(E(2,:))+max(max(abs(E)))/3])
	
	tick = get(h(4),'YTick');
	set(h(4),'YTick',[tick(1) ; tick(end)])
	set(h(4),'YAxisLocation','right')
    set(h(4),'TickLength',[0.020 0.025]);
	xlabel('Time (ms)')
	ylabel('dB')

	E = 10 * log10(mbase(dispf));
	h(5) = subplot('Position',[0 .67 .1 .33].*s+q); % plot mean spectrum
                                                    % to left of ERSP image
	if ~isnan(alpha)
		plot(freqs(dispf),Pboot(:,dispf)+[E;E],'LineWidth',LINEWIDTH)
	else
		plot(freqs(dispf),E,'LineWidth',LINEWIDTH)
	end

	axis([freqs(1) freqs(max(dispf)) min(E)-max(abs(E))/3 max(E)+max(abs(E))/3])
	tick = get(h(5),'YTick');
    if (length(tick)>2)
	   set(h(5),'YTick',[tick(1) ; tick(end-1)])
    end
    set(h(5),'TickLength',[0.020 0.025]);
	set(h(5),'View',[90 90])
	xlabel('Frequency (Hz)')
	ylabel('dB')

    %
    %%%%%%%%%%%% Image the ITC %%%%%%%%%%%%%%%%%%
    %
	h(6) = subplot('Position',[.1 .1 .9 .33].*s+q); % ITC image

	RR = R;
	if ~isnan(alpha)
		RR(find(RR < repmat(Rboot(1,:)',[1 nwin]))) = 0;
	end

    if ITC_CAXIS_LIMIT == 0
	   coh_caxis = min(max(max(R(dispf,:))),1)*[-1 1]; % 1 WAS 0.4 !
    else
       coh_caxis = ITC_CAXIS_LIMIT*[-1 1];
    end

if exist('Rsign')
	imagesc(times,freqs(dispf),Rsign(dispf,:).*RR(dispf,:),coh_caxis); % <---
else
	imagesc(times,freqs(dispf),RR(dispf,:),coh_caxis); % <---
end

	hold on
	plot([0 0],[0 freqs(max(dispf))],'--m','LineWidth',LINEWIDTH);
    if ~isnan(marktimes)
     for mt = marktimes(:)'
	   plot([mt mt],[0 freqs(max(dispf))],'--k','LineWidth',LINEWIDTH);
     end
    end
	hold off
	set(h(6),'YTickLabel',[],'YTick',[])
	set(h(6),'XTickLabel',[],'XTick',[])

	h(7) = gca;
	h(8) = cbar('vert');
	h(9) = get(h(8),'Children');
	set(h(7),'Position',[.1 .1 .8 .33].*s+q)
	set(h(8),'Position',[.95 .1 .05 .33].*s+q)
	set(h(8),'YLim',[0 coh_caxis(2)]); 
	title('ITC')

    %
    %%%%% plot the ERP below the ITC image %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
	% E = mean(R(dispf,:));

    ERPmax = max(ERP);
    ERPmin = min(ERP);
    ERPmax = ERPmax + 0.1*(ERPmax-ERPmin);
    ERPmin = ERPmin - 0.1*(ERPmax-ERPmin);
	h(10) = subplot('Position',[.1 0 .8 .1].*s+q); % ERP

	if ~isnan(alpha)

    % plot(times,E,[times(1) times(length(times))],...
    %       mean(Rboot(dispf))*[1 1],[0 0],...
    %    [min(E)-max(E)/3 max(E)+max(E)/3],'--m','LineWidth',LINEWIDTH)
    % axis([min(times) max(times) min(E)-max(E)/3 ...
    %       max([E mean(Rboot(dispf))])+max(E)/3]);

		plot(ERPtimes,ERP(ERPindices),...
            [times(1) times(length(times))],[0 0],...
            [0 0],[ERPmin ERPmin],'--m','LineWidth',LINEWIDTH);
		axis([min(ERPtimes) max(ERPtimes) ERPmin ERPmax]);
	else

		% plot(times,E,[0 0],[min(E)-max(E)/3 max(E)+max(E)/3],'--m',...
        %      'LineWidth',LINEWIDTH)
		% axis([min(times) max(times) min(E)-max(E)/3 max(E)+max(E)/3]);

		plot(ERPtimes,ERP(ERPindices),...
            [times(1) times(length(times))],[0 0],...
            [0 0],[ERPmin ERPmax],'--m','LineWidth',LINEWIDTH);
		axis([min(ERPtimes) max(ERPtimes) ERPmin ERPmax]);
	end

	tick = get(h(10),'YTick');
	set(h(10),'YTick',[tick(1) ; tick(end)])
    set(h(10),'TickLength',[0.02 0.025]);
	set(h(10),'YAxisLocation','right')
	xlabel('Time (ms)')
	ylabel('uV')

	E = mean(R(dispf,:)');
	h(11) = subplot('Position',[0 .1 .1 .33].*s+q); % plot the marginal mean
                                                    % ITC left of the ITC image
	if ~isnan(alpha)
		plot(freqs(dispf),E,freqs(dispf),Rboot(dispf),'LineWidth',LINEWIDTH)
		axis([freqs(1) freqs(max(dispf)) 0 max([E Rboot(dispf)])+max(E)/3])
	else
		plot(freqs(dispf),E,'LineWidth',LINEWIDTH)
		axis([freqs(1) freqs(max(dispf)) min(E)-max(E)/3 max(E)+max(E)/3])
	end

	tick = get(h(11),'YTick');
	set(h(11),'YTick',[tick(1) ; tick(length(tick))])
	set(h(11),'View',[90 90])
    set(h(11),'TickLength',[0.020 0.025]);
	xlabel('Frequency (Hz)')
	ylabel('ERP')
    %
    %%%%%%%%%%%%%%% plot a topoplot() %%%%%%%%%%%%%%%%%%%%%%%
    %
	if (~isempty(topovec))
		h(12) = subplot('Position',[-.1 .43 .2 .14].*s+q);
		topoplot(topovec,eloc_file,'electrodes','off')
		axis('square')
	end

elseif PLOT_ERSP %%%%%%%%%%%% Image ERSP only %%%%%%%%%%%%%%%%%%

	h(1) = subplot('Position',[.1 .1 .9 .9].*s+q);

	PP = P;
	if ~isnan(alpha)
		PP(find((PP > repmat(Pboot(1,:)',[1 nwin])) ...
                 & (PP < repmat(Pboot(2,:)',[1 nwin])))) = 0;
	end

    if ERSP_CAXIS_LIMIT == 0
	   ersp_caxis = [-1 1]*1.1*max(max(abs(P(dispf,:))));
    else
       ersp_caxis = ERSP_CAXIS_LIMIT*[-1 1];
    end

	imagesc(times,freqs(dispf),PP(dispf,:),ersp_caxis);

	hold on
	plot([0 0],[0 freqs(max(dispf))],'--m','LineWidth',LINEWIDTH)
    if ~isnan(marktimes)
     for mt = marktimes(:)'
	   plot([mt mt],[0 freqs(max(dispf))],'--k','LineWidth',LINEWIDTH);
     end
    end
	hold off
	set(h(1),'YTickLabel',[],'YTick',[])
	set(h(1),'XTickLabel',[],'XTick',[])
	h(2) = gca;
	h(3) = cbar('vert');
	set(h(2),'Position',[.1 .1 .8 .9].*s+q)
	set(h(3),'Position',[.95 .1 .05 .9].*s+q)
	title('ERSP (dB)')

	E = mean(P(dispf,:));
	h(4) = subplot('Position',[.1 0 .8 .1].*s+q);
	plot(times,E,...
         [0 0],[min(E)-max(abs(E))/3 max(E)+max(abs(E))/3],...
         '--m','LineWidth',LINEWIDTH)
	axis([min(times) max(times) min(E)-max(abs(E))/3 max(E)+max(abs(E))/3])
	
	tick = get(h(4),'YTick');
	set(h(4),'YTick',[tick(1) ; tick(end)])
	set(h(4),'YAxisLocation','right')
    set(h(4),'TickLength',[0.02 0.025]); % longer ticks
	xlabel('Time (ms)')
	ylabel('dB')

	E = 10 * log10(mbase(dispf));
	h(5) = subplot('Position',[0 .1 .1 .9].*s+q);
	plot(freqs(dispf),E,'LineWidth',LINEWIDTH)
	axis([freqs(1) freqs(max(dispf)) min(E)-max(abs(E))/3 max(E)+max(abs(E))/3])
	tick = get(h(5),'YTick');
	set(h(5),'YTick',[tick(1) ; tick(end-1)])
	set(h(5),'View',[90 90])
    set(h(5),'TickLength',[0.020 0.025]);
	xlabel('Frequency (Hz)')
	ylabel('dB')	

elseif PLOT_ITC % plot ITC only

    fprintf('timef(): Option to print ITC alone not currently supported.\n');
    return
end

if (length(ftitle) > 0)
	axes('Position',pos,'Visible','Off');               
	h(13) = text(-.05,1.01,ftitle);
	set(h(13),'VerticalAlignment','bottom')     
	set(h(13),'HorizontalAlignment','left') 
    set(h(13),'FontSize',TITLE_FONT);
end

axcopy(gcf);
