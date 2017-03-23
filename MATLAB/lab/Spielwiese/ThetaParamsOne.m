%function [ThPh, ThAmp, ThFr] = ThetaParams(FileBase, Eeg, eFsChannel, Overwrite, FreqRange, PhaseMethod, FreqMethod, Filter)
% computes Theta params for each sample of the eeg file
% using different methods:
% 1. PhaseMethod: how to determine instantaneous phase
% 'max' or 'min' - detects theta peak/trough and the linearly interpolates the
% all the points in cycles; for frequency - computes the spectrogram and
% gets the amp and freq from there .. then interpolates all other points
% 'hilbert' - narrow band filter, and use hilbert transform to get phase, amplitude
% and freq.
% NB!!! in all methods : 0 is theta peak!! Be carefull that your channel is
% in CA1 pyramidal layer!
% 2. FreqMethod - how to compute instantaneous frequency
% 'spect' - compute spectrogram and estimate power peaks in each slice and
% get respective frequency. these value are then cubically interpolated to
% get freq. at every point. this is quite robust method as long as
% oscillation is there .. and it's time resolution is limited
% 'analyt' - computes phase derivative (derivative of the smoothed
% unwrapped phase) - this gives analytical instantaneous frequency. can
% have jumps - need to work on that yet. so use 'spect' for now.
% Filter - is the choise of the filter .. 'butt','cheb','mt' or your own
% filter as [a;b] matrix
%
% if no output is given - saves the results in the FileBase.thpar.mat file
%%
%% changed from Anton's Theta Params such that the input is one
%% continuous signal (e.g. preselected eeg signal)

function  [ThPh, ThAmp, ThFr] = ThetaParamsOne(FileBase, eeg, eFs, varargin)

[Channel, Overwrite, FreqRange, PhaseMethod, FreqMethod, Filter] = ...
    DefaultArgs(varargin,{Channels(1), 0, [4 12], 'max','spect','butt'});

Verbose=0;

UseParams = struct('Channel',Channel,'FreqRange',FreqRange,'PhaseMethod',PhaseMethod, 'FreqMethod',FreqMethod,'Filter',Filter);

SameParams =1;
Compute= [0 0 0];

if FileExists([FileBase '.thpar.mat']) & nargin>1
  load([FileBase '.thpar.mat'],'Params');
  fds = fieldnames(Params);
  for i=1:length(fds)
    if isnumeric(Params.(fds{i}))
      if sum(Params.(fds{i})~=UseParams.(fds{i}))>0
	SameParams=0;
	Compute(i)=1;
      end
    elseif isstr(Params.(fds{i}))
      if ~strcmp(Params.(fds{i}),UseParams.(fds{i}))
	SameParams=0;
	Compute(i)=1;
      end
    else
      error('wrong Parameter value ');
    end
  end
else
  Compute=[1 1 1];
end

if Overwrite || ~FileExists([FileBase '.thpar.mat']) || ~SameParams 
  Recompute=1;
else
  Recompute=0;
end

if Recompute 
  if FileExists([FileBase '.thpar.mat'])
    load([FileBase '.thpar.mat']);
  end
  %if Overwrite - compute and overwrite 
  
  
  %now do eeg filtering
  %if ~strcmp(Params.Filter,UseParams.Filter) | sum(Params.FreqRange~=Params.FreqRange)>0 ...
  %       |~strcmp(Params.PhaseMethod,UseParams.PhaseMethod)
  %if FileExists([FileBase '.eeg'])
  %  eeg = LoadBinary([FileBase '.eeg'],Channel,Par.nChannels)';
  %elseif FileExists([FileBase '.eeg.0'])
  %  eeg = bload([FileBase '.eeg.0'],[1 inf])';
  %end
  nT = length(eeg);
  
  %if Compute(2)%~strcmp(Params.FreqMethod,UseParams.FreqMethod)
  switch FreqMethod
    
   case 'spect'
    weeg = WhitenSignal(eeg);
    %choose window: should be ~7 cycles to give good freq. resolution
    
    win = 2^floor(1+log2((eFs/mean(FreqRange)*25)));
    step = 2^nextpow2(eFs*0.2);
    %compute spectrogram in the freq. range 1: fr(2)+5Hz
    [y,f,t] = mtchglong(weeg,win,eFs,win,win-step,1,'linear',[],[1 FreqRange(2)+5]);
    
    t =  t+ win/2/eFs; %times of the centers of the windows
    tsmpl = [1; floor(t(:)*eFs); nT]; %get t in samples
    if 0
      %computer maxima of power in each slice - not very reliable
      powstats = sq(PowerPeakStats(log(y), f, FreqRange));
      pkfreq = powstats(:,1);
    else
      %instead, find the center of mass of the freq. range
      %keyboard
      fi = find(f>FreqRange(1) & f<FreqRange(2));
      pkfreq = dotdot(sum(dotdot(y(:,fi),'*',f(fi)'),2),'/',sum(y(:,fi),2));
    end
    hFr = interp1(tsmpl,[pkfreq(1) ; pkfreq; pkfreq(end)], [1:nT],'pchip')';
    ThAmpSpec = interp1(tsmpl,powstats(:,3),[1:nT],'cubic');
    
    if Verbose
      %test spec
      figure
      clf
      imagesc(t,f,log(y)');axis xy
      rem = load([FileBase '.sts.REM']);
      hold on;plot([rem(1,1):rem(1,2)]/1250, ThFr([rem(1,1):rem(1,2)]),'k.');
      xlim([rem(1,1) rem(1,2)]/1250)
      pause
    end
      
    
   case 'analyt'
    
    k = 500;
    gaussker = normpdf(-k:k,0, k/4)';
    smoothThPh = Filter0(gaussker,unwrap(ThPh));
    ThFr= diff(smoothThPh)*eFs/2/pi;
    
   otherwise
    error('unknow FreqMethod');
  end
  
  
  switch Filter
   case 'butt'
    eegf = ButFilter(eeg,4,FreqRange/eFs*2,'bandpass');
    
   case 'cheb'
    [b a] = Scheby2(4,20, FreqRange/eFs*2);
    eegf = Sfiltfilt(b,a,eeg);
    
   case 'mt'
    eegf = MTFilter(eeg, FreqRange, eFs, 2^nextpow(0.5*eFs));
      
   case 'adapt'
    if ~exist('ThFr','var')
      load([FileBase '.thpar.mat'],'ThFr');
    end
    eegf = AdaptiveFilter([eeg, ThFr(:)], 'filter', 1250*3, 1250, 5);
    eegf(:,2)=[];
    
   otherwise
    if isnumeric(Filter)
	eegf = Sfiltfilt(Filter(:,2),Filter(:,1),eeg);
    else
      error('don''t know such Filter choice');
    end
  end
  
  %if ~strcmp(Params.PhaseMethod,UseParams.PhaseMethod)
  switch PhaseMethod
    %both min and max have problem due to bias to rational numers
    %2*pi*(1,1/2,0,1/4,1/8,1/16 ...) those are mostly in the
    %[0:pi/2] range and if smoothed will create a bias to [0:pi/2]
    %values 
   case 'max'
    MinPeriod = 0.8*eFs./FreqRange(2);
    ThPk = LocalMinima(-eegf,MinPeriod,0);
    ThPk = [1; ThPk; nT];
    ThPh = PhaseFromCycles([1:nT]', ThPk(1:end-1), ThPk(2:end));
    ThAmp = interp1(ThPk, abs(eegf(ThPk)), [1:nT]','cubic');
    ThPh(1)=ThPh(2);
   case 'min'
    MinPeriod = 0.8*eFs./FreqRange(2);
    ThTr = LocalMinima(eegf,MinPeriod,0);
    ThTr = [1; ThTr; nT];
    ThPh = PhaseFromCycles([1:nT]', ThTr(1:end-1), ThTr(2:end));
    ThPh = ThPh + pi;    % shift such that 0 is theta peak
    ThAmp = interp1(ThTr, abs(eegf(ThTr)), [1:nT]','cubic');
    
   case 'hilbert'
    hilb = hilbert(eegf);
    ThPh = angle(hilb);
    ThAmp = abs(hilb);
    
    %            case 'adapt'
   otherwise
    error('unknow PhaseMethod');
    
  end
  
  if Overwrite || ~FileExists([FileBase '.thpar.mat'])
    Params = UseParams;
    save([FileBase '.thpar.mat'], 'ThPh', 'ThAmp','ThFr','Params');
  end
  % else
  %     fprintf('don''t have to do anything if you don''t want to overwrite\n');
  %     return;
end


if nargout>1 && ~Recompute
  load([FileBase '.thpar.mat']);
end


% for the later implementation:
%now load the phases vectors (and amplitude)
% compute the correction for the phase - later
% [PhCdf x]= cdfcall(ThPh); bin x; PhaseCorr = 2*pi*PhCdf - pi;
%get the continuous phase - from hilbert transofrm
  

