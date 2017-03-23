%function th = ThetaPeriodsEI(FileBase, Mode, Overwrite, Channels, FreqRange,  Electrodes, MinLength)
% computes various measures related to theta on Channel in FreqRange 
% and gives gui interface to select the periods 
% uses bothextracell and intracell info, channels = [extra intra]
% Mode = 'comp'/ 'disp'/'both'
% MinLength = minimal length of theta period
% 
function th = ThetaPeriodsEI(FileBase, varargin)
[ Mode, Overwrite,Channels, FreqRange, Electrodes,MinLength] = DefaultArgs(varargin,{'comp',1,[],[2 5], [],10});
WinSec = 5; % window to compute spectra etc
ResampleCoef = 10; % how much to downsample eeg
ClipWin = 3;%msec - for clipping the spike in IC trace
Par = LoadPar([FileBase '.par']);
SampleRate = 1e6/Par.SampleTime;
eSampleRate = 1250;

if strcmp(Mode,'comp') | strcmp(Mode,'both')

if length(Channels)~=2 error('channels must be [extra intra]'); end

if isempty(Electrodes) & FileExists([FileBase '.cluloc'])
	cluloc = load([FileBase '.cluloc']);
	Electrodes = cluloc(find(cluloc(:,3)==Channels(1)),1);
	Electrodes = unique(Electrodes);
end


    %compute or load 
    if ~FileExists([FileBase '.ThetaPeriods.mat']) | Overwrite
        %compute again
        eeg = readmulti([FileBase '.eeg'],Par.nChannels, Channels);
	nT = size(eeg,1);
	%clip the spikes in itracell data
	[dummy iRes] = CluOnChannels(FileBase, Channels(2));
	niRes = length(iRes); 
	iRes = round(iRes/(SampleRate/eSampleRate))+1;
	InterpWindow = round(ClipWin*eSampleRate/1000); %window in which to clip the spike: 
	IntPoints = repmat(iRes,1,InterpWindow*2+1) + repmat([-InterpWindow:InterpWindow],niRes,1);
	IntPoints = reshape(IntPoints',[],1);
	IntPoints = IntPoints(find(IntPoints>InterpWindow & IntPoints<=nT-InterpWindow));
	NonIntPoints = setdiff([1:nT],IntPoints);
	%now clip by interpolating eeg in +/- InterpWindow around each spike 
	eeg(IntPoints,2) = interp1(NonIntPoints,eeg(NonIntPoints,2),IntPoints);
	
	eeg = resample(eeg,1,ResampleCoef);
        eSampleRate = eSampleRate/ResampleCoef;
	Win = round(WinSec*eSampleRate);
	Win= Win+mod(Win,2); 
	Step = Win/2;
	Overlap = Win-Step;
        nFFT = 2^round(log2(Win)+1);
        
        if size(FreqRange,1)==2
%            compute theta modulation of gamma power
            thFreqRange = FreqRange(1,:);
            gammaFreqRange = FreqRange(2,:);
            gfil = ButFilter(eeg(:,1), 2, gammaFreqRange/eSampleRate*2,'bandpass');
            %gfil = abs(gfil);
            th.gpow  = mean(mtchglong(gfil, nFFT, eSampleRate, Win,  [], 2, [], [], thFreqRange),2);
        else
	    thFreqRange = FreqRange;
            th.gpow = [];
            
        end
	
        % compute spectral sruff
	weeg = WhitenSignal(eeg);
	%keyboard
        [y,f,t,phi,fst] = mtchglong(weeg, nFFT, eSampleRate, Win,  [], 2, [], [], [1 min(eSampleRate/2,80)]);
	thf = find(f>thFreqRange(1) & f<thFreqRange(2));
        th.fst_th = mean(sq(fst(:,thf,1)),2);
        th.pow_the = mean(sq(y(:,thf,1,1)),2);
	th.pow_thi = mean(sq(y(:,thf,2,2)),2);
        th.t = t + (t(2)-t(1))/2;
     	
	th.spec.ye = sq(y(:,:,1,1));
	th.spec.yi = sq(y(:,:,2,2));
	th.spec.f = f;
	th.spec.fse = sq(fst(:,:,1));
	th.spec.fsi = sq(fst(:,:,2));
        % now detect burst of theta 
        osc =  DetectPeaks(FileBase,-1,4,0.3, 0, 1250, [],'butt',thFreqRange,Channels(1), 'eeg', 0);
        
        %osc.Bursts = [BurstCenterTime, BurstLength, BurstPow, BurstFreq BurstBeg BurstEnd]
        
        th.bursts.t = osc.Bursts(:,1)/1250;
        th.bursts.pow = osc.Bursts(:,3);
        th.bursts.len = diff(osc.Bursts(:,5:6),1,2);
        th.bursts.freq = osc.Bursts(:,4);
     
	%now compute the running histogram of phases
	[res,clu,nclu,thph] = ReadEl4CCG(FileBase,Electrodes);
	 res = round(res/(SampleRate/eSampleRate));
	 thph = mod(thph*180/pi,360);
	 %keyboard
	[th.phhist, th.pht, th.phbins] = RunningHistDiscr(res,thph, Win*2, round(th.t*eSampleRate)+1, 20);
	 
        % now compute the running histogram and stats of the intracell trace
	
	[th.intrah th.intrat th.intrabins] = RunningHist(eeg(:,2)-RunningMean(eeg(:,2),501),Win,Step,40);
	th.intrastat.std = RunningFun(eeg(:,2),'std',Win,Step);
	th.intrastat.skew = RunningFun(eeg(:,2),'skewness',Win,Step);
	th.intrastat.kurtosis = RunningFun(eeg(:,2),'kurtosis',Win,Step);
	th.intrastat.mean = RunningFun(eeg(:,2),'mean',Win,Step);
	
	

    end
end

if strcmp(Mode,'disp') | strcmp(Mode,'both')
	if strcmp(Mode,'disp') & FileExists([FileBase '.ThetaPeriodsEI.mat']) 
        	load([FileBase '.ThetaPeriodsEI.mat']);
        	th = OutArgs; clear OutArgs;
  	end
	% load events detectedby Kazu
	[EvtRes, EvtClu, EvtLabels, Labels] = LoadEvt([FileBase '.the.evt'],1);
	EvtLength = sum(diff(reshape(EvtRes,2,[])));
	
	
	
	%automatic theta periods detection just using the thetaratio
	thfin = find(th.spec.f>2 & th.spec.f<4);
	thfout = find(th.spec.f<2 | (th.spec.f> 4& th.spec.f<6));
	thratio = log(mean(th.spec.ye(:,thfin),2))-log(mean(th.spec.ye(:,thfout),2));
	
	nStates =2;
	% fit gaussian mixture and to HMM - experimental version .. uses only thetaratio , not IC membrane potential
	[th.TheState thhmm thdec] = gausshmm(thratio,nStates,1,0);
	
	for i=1:nStates 
	thratio_st(i) = mean(thratio(th.TheState==i));
	end
	[dummy TheInd] = max(thratio_st);
	InTh = (th.TheState==TheInd);
	DeltaT = th.t(2)-th.t(1);
	MinSeg = round(MinLength/DeltaT);
	TransTime = ThreshCross(InTh,0.5,MinSeg);
	th.ThePeriods = th.t(TransTime);
	%keyboard
	msave([FileBase '.ath'],round(th.ThePeriods*eSampleRate));
	EvtRes1 = th.ThePeriods(:);
	%keyboard
	EvtLength1 = sum(diff(th.ThePeriods,1,2));
	
	
	fprintf('Total length of theta detected manually : %f\n',EvtLength);
	
	fprintf('Total length of theta detected automatically  : %f\n',EvtLength1);
	
		
	figure(981)
	clf
	nx = 8;
	

subplot(nx,1,1)
	if 0
	plot(th.t, (th.pow_the));axis tight
	title('theta power, extra');
	else
	imagesc(th.t, th.spec.f,log(th.spec.ye)');axis xy;ca=caxis; caxis([ca(1) ca(2)*1.2]);ylim([1 10]);
	title('theta power, extra');
	end
	
subplot(nx,1,2)
	if 0
	plot(th.t, (th.pow_thi));axis tight
	title('theta power, intra');
	elseif 0
	imagesc(th.t, th.spec.f,log(th.spec.yi)');axis xy;ca=caxis; %caxis([ca(1) ca(2)*0.8]);
	title('theta power, intra');
	else
	plot(th.t, thratio);axis tight
	title('theta power ratio');
	end

subplot(nx,1,3)
	plot(th.t, log(th.gpow));axis tight
	title('theta power of gamma power, extra');

subplot(nx,1,4)
	plot(th.t,log(th.fst_th));axis tight
	title('f-stat of theta, extra');

subplot(nx,1,5)
	plot(th.bursts.t,th.bursts.len,'*');axis tight
	title('theta bursts');
	xlim([th.t(1) th.t(end)]); 
	subplot(nx,1,6)
	imagesc(th.pht/125, th.phbins(2:end), th.phhist');
	title('phase of extra units');

subplot(nx,1,7)
	imagesc(th.t, th.intrabins,th.intrah);
	yl = ylim; yr = min(abs(yl)); ylim([-1 1]*0.5*yr);
	title('intra membrane potential distribution');
	axis xy	
	
subplot(nx,1,8)
	plot(th.t,th.intrastat.std); axis tight
	
	for i=1:8
		subplot(nx,1,i)
		Lines(EvtRes,[],'g');
		yl = ylim;
		Lines(EvtRes1,[],'r');
	end
	
	% browse features and cluster manually
	%ThePerClu = xgobi([thratio(:) th.intrastat.std(:) th.intrastat.kurtosis(:) th.t(:)]);
	%thei = find(ThePerClu==2);
	%tht = th.t(thi);
	
	if 0
	figure
	subplot(311)
	plot(th.t, thratio);axis tight
	subplot(312)
	plot(th.t,th.intrastat.std); axis tight
	subplot(313)
	%stairs(th.t, [ThePerClu(:) ThState(:)]); axis tight; ylim([0 3]);
	stairs(th.t, [th.TheState(:)]); axis tight; ylim([0 3]);
	%legend('manual','hmm');
	keyboard
	end
	  
end
