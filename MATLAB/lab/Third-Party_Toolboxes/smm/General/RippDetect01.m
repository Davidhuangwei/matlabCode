% function sdetected = ripdetecth(inname,numchannel,channels,plotBool,shanknumber,condition1,condition2,condition3,time1(sec),time2))
% channels start from 1. (unlike josef's program.. it uses in matlab
% indexing convention); (must supply .eeg 1.25khz, 
% channel 1 of 1), results are returned in eeg unit (1.25kHz). figure

function [RippleTime, taxis]=RippDetect01(FileBase,fileExt,totalchannels,ChNums,varargin) %,Mult,shanknumber,drugconditions,drugtimes)

[plotBool,thresholdf,max_thresholdf] = DefaultArgs(varargin,{1,3,4});

%%%%%%%%%% parameters to play with %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% parameters for program flow control
verbose = 1;
showfiltchar = 0;
pause on;

% parameters for detection tuning
sampl = 1250; % sampling rate of the eeg file in Hz (5kHz)

highband = 250; % bandpass filter range (250Hz to 120Hz)
lowband = 120; %

forder = 200;  % filter order has to be even; .. the longer the more
               % selective, but the operation will be linearly slower
    	       % to the filter order
avgfilorder = 101; % do not change this... length of averaging filter
avgfilterdelay = floor(avgfilorder/2);  % compensated delay period
forder = ceil(forder/2)*2;           %make sure filter order is even

% parameters for ripple period (ms)
min_sw_period = 50 ; % minimum sharpwave period = 50ms ~ 6 cycles
max_sw_period = 250; % maximum sharpwave period = 250ms ~ 30 cycles
                     % of ripples (max, not used now)
min_isw_period = 30; % minimum inter-sharpwave period;

% thresholdf = 3   % threshold for ripple detection
% max_thresholdf = 4 % the peak of the detected region must satisfy   this value on top of being  supra-thresholdf.




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% changing something below this line will result in changing the
% algorithm (i.e. not the parameter)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% calculate the convolution function (passbands are normalized to
% the Nyquist frequency)
fname=([FileBase fileExt])
firfiltb = fir1(forder,[lowband/sampl*2,highband/sampl*2]);
avgfiltb = ones(avgfilorder,1)/avgfilorder;



% determine the threshold
verdisp('computing threshold...',verbose);
eeg = readmulti(fname,totalchannels,ChNums);% from .eeg

% for i=1:length(art)
%     badtimechunk{i}=[art(i,1):art(i,2)];
% end
% badtime=cat(2,badtimechunk{:});    
% goodeegtime=setdiff([1:length(eeg)],badtime);
% eeg=eeg(goodeegtime);
filtered_data = Filter0(firfiltb,eeg); % filtering
filtered_data2 = filtered_data.^2; % filtered * filtered >0
rawdat=Filter0(avgfiltb,sum(filtered_data2,2));
sdat=unity(rawdat); %% sdat = unity(Filter0(avgfiltb,sum(filtered_data2,2))); % averaging &
                                                       % standardizing

% if isempty(AbsoluteThreshold)==0;
% 	thresholdf=(AbsoluteThreshold(1)-mean(rawdat))/std(rawdat)
% 	max_thresholdf=(AbsoluteThreshold(2)-mean(rawdat))/std(rawdat)
% end

% threshold SD (standard deviation) for ripple detection

% if isempty(AbsoluteThreshold)==1
% 	thresholdf = 3   % threshold for ripple detection
% 	max_thresholdf = 4 % the peak of the detected region must satisfy   this value on top of being  supra-thresholdf.
% 	absolutethresholdf=thresholdf*std(rawdat)+mean(rawdat)
% 	absolutemax_thresholdf=max_thresholdf*std(rawdat)+mean(rawdat)
% 	AbsoluteThreshold=[absolutethresholdf absolutemax_thresholdf]
% end






% (1) primary detection of ripple periods, based on thresholding
thresholded = sdat > thresholdf;
primary_detection_b = find(diff(thresholded)>0);
primary_detection_e = find(diff(thresholded)<0);

% exclude ranged-out (1st or last) ripples
if (length(primary_detection_e) == length(primary_detection_b)-1)
    primary_detection_b = primary_detection_b(1:end-1);
end

if (length(primary_detection_e)-1 == length(primary_detection_b))
    primary_detection_e = primary_detection_e(2:end);
end
primary = [primary_detection_b,primary_detection_e];

% (2) secondary, merge ripples, if inter-ripples period is less
% than min_isw_period;
min_period = min_isw_period/1000 * sampl;

if isempty(primary)
    return
end
secondary=[];
tmp_rip = primary(1,:);

for ii=2:size(primary,1)
    if (primary(ii,1)-tmp_rip(2)) <min_period
        % merge two ripples
        tmp_rip = [tmp_rip(1),primary(ii,2)];
    else
        secondary = [secondary;tmp_rip];
        tmp_rip = primary(ii,:);
    end
end
secondary = [secondary;tmp_rip];

% (3) third, ripples must have it's peak power of > max_thresholdf
if isempty(secondary)
    return
end
third = [];
SDmax = [];

for ii=1:size(secondary,1)
    [max_val,max_idx] = max(sdat([secondary(ii,1):secondary(ii,2)]));
    if max_val > max_thresholdf
        third = [third;secondary(ii,:)];
        SDmax = [SDmax;max_val];
    end
end
third;
SDmax;

% (4) Fourth, detection of negative peak position of each ripple
medium_val = zeros(size(third,1),1);

for ii=1:size(third,1)
    [minval,minidx] = min (filtered_data(third(ii,1):third(ii,2)));
    medium_val(ii) = minidx+third(ii,1);
end

% anser of this function...
sdetected = [third(:,1),medium_val,third(:,2),SDmax];
%% RippleTime=[sdetected(:,1) sdetected(:,2)];
numberofripple=length(sdetected);
lengthofrecording=length(eeg)/1250/60;
ripllepermin=numberofripple/lengthofrecording

taxis = [1:length(eeg)]/sampl/60; % in min

%plot result (Fig. 0)
if plotBool==1
   figure(1);
   clf
   plot(taxis(1:2:end),unity(eeg(1:2:end,1))+100,'b');
   xlim([0 taxis(end)]);
   hold on;
   plot(taxis(1:4:end),unity(filtered_data(1:4:end,1))/2+60,'k');
   plot(taxis(1:8:end),sdat(1:8:end),'r');
   plot([taxis(1),taxis(end)],[thresholdf,thresholdf],'k-.');
   plot([taxis(1),taxis(end)],[max_thresholdf,max_thresholdf],'k:');

   for ii=1:size(sdetected,1)
       plot([sdetected(ii,1), sdetected(ii,1)]/sampl/60,[-20,-10],'m-');
       plot([sdetected(ii,1), sdetected(ii,1)]/sampl/60,[55,65],'m:');
   end

   for ii=1:size(sdetected,1)
       plot([sdetected(ii,3), sdetected(ii,3)]/sampl/60,[55,65],'m:');
   end
   xlabel('time (min)');
   ylabel('Power of Ripple (std to mean)');
   Title=['Raw Traces and Detected Ripples'];
   title(Title);
end
RippleTime=[sdetected(:,1) sdetected(:,3)];
% NoRippleTime(1,:)=[0 RippleTime(1,1)];
% for kk=1:length(RippleTime)-1
% 	NoRippleTime(kk+1,:)=[RippleTime(kk,2) RippleTime(kk+1,1)];
% end
% NoRippleTime(length(RippleTime)+1,:)=[RippleTime(length(RippleTime),2)  length(eeg)];
% cd ..
msave('RippleTime',RippleTime)
% msave('AllStatesNoRipple',NoRippleTime)



sumPow = zeros(length(ChNums),1);
for chan=1:length(ChNums)
    for i=1:size(RippleTime,1)
        sumPow(chan) = sumPow(chan) + sum(filtered_data2(RippleTime(i,1):RippleTime(i,2),chan));
    end
end
if plotBool==1
    figure(2)
    clf
    plot(log(sumPow))
    set(gca,'xtick',[1:length(ChNums)],'xticklabel',ChNums)
    title('Total Ripple Power')
    set(gcf,'name',[FileBase fileExt '_Ripple_Power_Per_Channel'])
    grid on
end
return
%  FigureTitle=([FileBase '/ripple.' FileBase '.' num2str(shanknumber) '.' num2str(ChNums) '.fig']);
%  saveas(gcf,FigureTitle);
%  close(gcf)

%
%  % plot ripple detection time course + eeg spectogramm
%
%  if plotBool==1
%     figure;
%     subplot(2,2,1)
%     taxis = [1:length(eeg)]/sampl/60; % in sec
%     plot(taxis(1:2:end),unity(eeg(1:2:end,1))+100,'b');
%     xlim([0 taxis(end)]);
%     hold on;
%     plot(taxis(1:4:end),unity(filtered_data(1:4:end,1))/2+60,'k');
%     plot(taxis(1:8:end),sdat(1:8:end),'r');
%     plot([taxis(1),taxis(end)],[thresholdf,thresholdf],'k-.');
%     plot([taxis(1),taxis(end)],[max_thresholdf,max_thresholdf],'k:');
%     time1=drugtimes(1,1);
%     time2=drugtimes(1,2);
%     plot([time1/60,time1/60],[-20,120],'b:');
%     plot([time2/60,time2/60],[-20,120],'g:');
%     for ii=1:size(sdetected,1)
%         plot([sdetected(ii,1), sdetected(ii,1)]/sampl/60,[-20,-10],'m-');
%         plot([sdetected(ii,1), sdetected(ii,1)]/sampl/60,[55,65],'m:');
%     end
%
%     for ii=1:size(sdetected,1)
%         plot([sdetected(ii,3), sdetected(ii,3)]/sampl/60,[55,65],'m:');
%     end
%     arrow([time1/60 130],[time1/60 120],'Color','g');
%     arrow([time2/60 130],[time2/60 120],'Color','r');
%     xlabel('time (min)');
%     ylabel('Power of Ripple (std to mean)');
%     Title=['Raw Traces and Detected Ripples (Shank ' num2str(shanknumber) '; Site ' num2str(ChNums) '; Animal ' FileBase ')'];
%     title(Title);
%  end
%
%
%  numberoftimebin=floor(length(eeg)/1250/300);
%  matrice=[];
%      for nn=0:numberoftimebin-1
%          numberofripple=length(find(sdetected(:,1)>nn*300*1250 & sdetected(:,1)<((nn+1)*300*1250)));
%          associatedtime=(300*nn)+150;
%          matrice(nn+1,:)=[numberofripple associatedtime/60];
%      end
%  
%  
%  limite1=(time1+300)*1250;
%  limite11=max(find(sdetected(:,1)<limite1));
%  limite2=(time2+300)*1250;
%  limite22=max(find(sdetected(:,1)<limite2));
%  
%  
%  subplot(2,2,2)
%  plot(matrice(:,2),matrice(:,1));
%  hold on
%  plot([time1/60,time1/60],[0,70],'b:');
%  plot([time2/60,time2/60],[0,70],'g:');
%  xlim([0 taxis(end)]);
%  arrow([time1/60 80],[time1/60 70],'Color','g');   
%  arrow([time2/60 80],[time2/60 70],'Color','g');
%  xlabel('time (min)');
%  ylabel('Number of ripple (/5min)');
%  Title=['Number Ripple Detected (Shank' num2str(shanknumber) ')'];
%  title(Title);
%  
%  
%  
%  %%%%%%%%%%%%%%%%%%%%%%%%%%
%  %calculate the power spectrum during time of the experiement
%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  
%  [y,f,t] = mtchglong(eeg,2^11,1250,2^10,0,3,[],[],[0 200]);  %y=powerspectrum, f=frequence, t=time
%  
%  
%  subplot(2,2,3)
%  imagesc(t/60,f,log10(y)');
%  ylim([0 200])
%  xlabel('time (min)');
%  ylabel('frequency (Hz)');
%  Title=['Power Spectrum (Shank' num2str(shanknumber) ')'];
%  title(Title);
%  
%  
%  subplot(2,2,4)
%  ylim([0 15]);
%  gf = find(f<15);
%  imagesc(t/60,f(gf),log10(y(:,gf))');
%  xlabel('time (min)');
%  ylabel('frequency (Hz)');
%  Title=['Power Spectrum in the theta range (Shank' num2str(shanknumber) ')'];
%  title(Title);
%  
%  FigureTitle=([FileBase '/rippleandpower.' FileBase '.' num2str(shanknumber) '.' num2str(ChNums) '.fig']);
%  saveas(gcf,FigureTitle);
%  close(gcf)
%  
%  
%  sFN1=[FileBase '/' drugconditions{1},'.swr.res.',num2str(shanknumber)];
%  msave(sFN1,sdetected(1:limite11,:));
%  
%  sFN2=[FileBase '/' drugconditions{2},'.swr.res.',num2str(shanknumber)];
%  msave(sFN2,sdetected(limite11:limite22,:));
%  
%  
%  sFN3=[FileBase '/' drugconditions{3},'.swr.res.',num2str(shanknumber)];
%  msave(sFN3,sdetected(limite22:end,:));
%  
%  % plot powerspectrum in 10 min chunkeeg each condition
%  
%  Taxis = [1:length(eeg)]/1250/60; % in min
%  Taxis=Taxis';
%  figure;
%  for dd=1:length(drugconditions);
%  	condition=drugconditions{dd};
%      Legend=[condition, ', eeg'];
%      StoredLegend{dd}=Legend;
%  	
%      if 	dd==1
%  		chunkeeg=eeg((drugtimes(dd)-15*60)*1250: (drugtimes(dd)-5*60)*1250);
%  		chunktimes=Taxis((drugtimes(dd)-15*60)*1250: (drugtimes(dd)-5*60)*1250);
%          [Power F]=psd(chunkeeg,2^11,1250,2^10);
%  		subplot(2,2,1);
%  		plot(F,10*log10(abs(Power)),'b');
%  		hold on;
%  		subplot(2,2,3)
%          plot(F,10*log10(abs(Power)),'b');
%          hold on
%          
%          
%          Stdfactor=std(chunkeeg);   %Normalized the eeg
%  		Stdchunkeeg=chunkeeg/Stdfactor;
%  		[StdPower F]=psd(Stdchunkeeg,2^11,1250,2^10);
%  		subplot(2,2,2);
%  		plot(F,10*log10(abs(StdPower)),'b');
%  		hold on
%  
%          subplot(2,2,4)
%          plot(F,10*log10(abs(StdPower)),'b');
%          hold on
%          Traces(:,dd)=chunkeeg;
%          Times(:,dd)=chunktimes;
%      else
%  		if	dd==2
%  			color='g';
%  		end
%  
%  		if	dd==3
%  			color='r';
%          end
%          
%          chunkeeg=eeg((drugtimes(dd-1)+35*60)*1250:(drugtimes(dd-1)+45*60)*1250);
%  		chunktimes=Taxis((drugtimes(dd-1)+35*60)*1250:(drugtimes(dd-1)+45*60)*1250);
%          [Power F]=psd(chunkeeg,2^11,1250,2^10);
%  		subplot(2,2,1)
%  		plot(F,10*log10(abs(Power)),color);
%          
%          subplot(2,2,3)
%  		plot(F,10*log10(abs(Power)),color);
%          
%          Stdfactor=std(chunkeeg);
%  		Stdchunkeeg=chunkeeg/Stdfactor;
%  		[StdPower F]=psd(Stdchunkeeg,2^11,1250,2^10);
%  		subplot(2,2,2);
%  		plot(F,10*log10(abs(StdPower)),color);
%  		
%          subplot(2,2,4);
%  		plot(F,10*log10(abs(StdPower)),color);
%          Traces(:,dd)=chunkeeg;
%          Times(:,dd)=chunktimes;
%      end
%      
%      subplot(2,2,1)
%      xlim([0 200])
%      
%      subplot(2,2,2)
%      xlim([0 200])
%      
%      subplot(2,2,3)
%      xlim([0 50])
%      ylim([min(10*log10(abs(Power))) max(10*log10(abs(Power)))+10])
%      
%      subplot(2,2,4)
%      xlim([0 50])
%      ylim([min(10*log10(abs(StdPower))) max(10*log10(abs(StdPower)))+5])
%      
%  end
%   
%  
%  subplot(2,2,1)
%   xlabel('Frequency (Hz)');
%   ylabel('Power (dB)');
%   i=['EEG Power (Shank ' num2str(shanknumber) '; Site ' num2str(ChNums) '; Animal ' FileBase ')'];
%   title(i);
%   legend(num2str(StoredLegend{1}),num2str(StoredLegend{2}),num2str(StoredLegend{3}))
%  
%  
%  subplot(2,2,2)
%   xlabel('Frequency (Hz)');
%   ylabel('Power (dB/std)');
%   i=['EEG/std Power'];
%   title(i);
%  legend([num2str(StoredLegend{1}) '/std'],[num2str(StoredLegend{2}) '/std'],[num2str(StoredLegend{3}) '/std'])
%  FigureTitle=([FileBase '/chungeepower.' FileBase '.' num2str(shanknumber) '.' num2str(ChNums) '.fig']);
%  saveas(gcf,FigureTitle);
%  close(gcf)
%  
%  
%  
%  % plot the eeg and shunk eeg
%  figure
%  plot(Taxis(1:2:end),unity(eeg(1:2:end,1))+50,'k');
%  time1=drugtimes(1,1);
%  time2=drugtimes(1,2);
%  arrow([time1/60 90],[time1/60 80],'Color','g');   
%  arrow([time2/60 90],[time2/60 80],'Color','r');
%  hold on;
%  for dd=1:length(drugconditions)
%      if	dd==1
%  		color='b';
%      end
%      
%      if	dd==2
%  		color='g';
%  	end
%  
%  	if	dd==3
%  		color='r';
%      end
%      plot(Times(1:2:end,dd),unity(Traces(1:2:end,dd)),color);
%  end
%  FigureTitle=([FileBase '/chungeeganalysed.' FileBase '.' num2str(shanknumber) '.' num2str(ChNums) '.fig']);
%  saveas(gcf,FigureTitle);
%  close(gcf)
%  
%  
%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  %
%  % Compute some ripple feature (WrippleFfre) for each drug condition
%  %
%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  
%  PowLimit=[100 200];
%  
%  if (Mult==2)
%      eeg=eeg*2;
%  end;
%  
%  if (length(ChNums)>1)
%      eeg=mean(eeg,2);
%  end;
%      
%  % eeg=eeg*2;
%  feeg = drSinoFilt(eeg,1,3);
%  % eeg = eeg/std(eeg); %normalize
%  
%  StandardDeviation=std(feeg)
%  ripthresh=mean(feeg)+std(feeg)*3 %threshold for ripple wave counts
%  %ripthresh1=mean(feeg)+std(feeg)*8
%  
%  for dd=1:length(drugconditions)
%      condition=drugconditions{dd}
%      [analsum, swPer] = davTruncate(FileBase,[],ChNums,6,shanknumber,condition);%load the ripple 
%      
%      
%      nRips = size(swPer, 1);
%      nRipstxt = num2str(nRips);
%  	%if (nRips < 5), return;
%  	%end; % exits function if there are not enough ripples to analyze
%      
%      j=1;
%      z=1;
%      Keep=[];%zeros(513,1);
%      Reject=[];%zeros(513,1);
%      KeepTraces={};
%      LengthofRipple=[];
%      nKeepBigPeaks=[];
%      nKeepAllPeaks=[];
%      RippleFrequence=[];
%      %RipCycles = [RipCycles;1./(diff(PkfChunk(:))/1250)];
%      MaxPow=[];
%      FreqofMaxPower=[];
%      RippleNumber=[];
%      TimeofRippleOccurence=[];
%      
%      
%      for iii=1:nRips
%          %extract segment corresponding to ripple
%          Chunk = eeg(swPer(iii,1):swPer(iii,3));
%          fChunk = feeg(swPer(iii,1):swPer(iii,3));
%          PkfChunk = LocalMinima(-fChunk,5);
%          KeepBigPeaks = PkfChunk(find(fChunk(PkfChunk)>ripthresh));
%          [p f] = Spmtm((Chunk-mean(Chunk)), 1.5, 1024, 1250);    % p is a matrix storing all spectra
%          [Traces]=fChunk;
%          TimeofRippleOccurence1=(swPer(iii,1)-1)/1250;
%          Flow=83:103;
%          FHi=104:144;
%          Plow=p(Flow);
%          PHi=p(FHi);
%          %     fprintf(['Mean of low = ' num2str(mean(Plow)) ' Mean of high = ' num2str(mean(PHi)) '\n']);
%          %if (mean(Plow)<mean(PHi) & length(KeepBigPeaks)>=3)
%          
%          
%          if  length(KeepBigPeaks)>=3 %&fChunk(KeepBigPeaks)<ripthresh1;
%              Keep(:,j)=p;
%  	        KeepTraces{j}=Traces;
%              LengthofRipple(j)=(max(PkfChunk)-min(PkfChunk))/1250;
%              nKeepBigPeaks(j) = length(KeepBigPeaks);
%              nKeepAllPeaks(j) = length(PkfChunk);
%              RippleFrequence(j) = 1/mean(diff(PkfChunk)/1250);
%  		    %RipCycles = [RipCycles;1./(diff(PkfChunk(:))/1250)];
%              PowlimLines=find(f>PowLimit(1) & f<PowLimit(2));
%              [maxPow ind] = max(p(PowlimLines));
%  	        MaxPow(j)=maxPow;
%              FreqofMaxPower(j) = f(PowlimLines(ind));
%  	        RippleNumber(j)=(j);
%  	        TimeofRippleOccurence(j)=TimeofRippleOccurence1;
%              j=j+1;
%              
%  
%          else
%              Reject=[];
%              Reject(:,z) = p;
%              z=z+1;
%          end
%      
%      end	
%      
%      if (Keep(1,1)==0 & size(Keep,2)==1), NumKeep=0; else, NumKeep=num2str(size(Keep,2)); end;
%  	if (size(Reject,1)==0 & size(Reject,2)==0), NumRej=0; else, NumRej=num2str(size(Reject,2)); end;
%  	
%  	fprintf(['\n# of accepted Rips: ' NumKeep]);
%  	fprintf(['\n# of rejected Rips: ' NumRej '\n']);
%  	
%  	KeptMeanPow = mean(Keep, 2);
%  	KeptErrPow = std(Keep, [], 2) / sqrt(size(Keep,2));
%  	PowlimLines=find(f>PowLimit(1) & f<PowLimit(2));
%  	f = f(PowlimLines);
%  	KeptMeanPow = KeptMeanPow(PowlimLines);
%  	
%  	% made by us , not Original :))
%  	MeanRipPow = mean(Keep(PowlimLines,:),1);
%  	MeanRipPowUnity = unity(log(MeanRipPow)); % transforms power into std from the mean of the log-power
%  	RipStats = [RippleNumber(:) TimeofRippleOccurence(:) nKeepBigPeaks(:) nKeepAllPeaks(:) RippleFrequence(:) LengthofRipple(:) FreqofMaxPower(:) MaxPow(:)];
%  	
%  	KeptErrPow = KeptErrPow(PowlimLines);
%  	
%  	
%  	
%  	
%  	sFN1=[FileBase '/' condition,'RippleMeanPowerforShank',num2str(shanknumber)];
%  	msave(sFN1,[f(:) KeptMeanPow(:) KeptErrPow(:)]);
%  	sFN2=[FileBase '/' condition,'RippleStatsforShank',num2str(shanknumber)];
%  	msave(sFN2,[RippleNumber(:) TimeofRippleOccurence(:) nKeepBigPeaks(:) nKeepAllPeaks(:) RippleFrequence(:) LengthofRipple(:) FreqofMaxPower(:) MaxPow(:)]);
%  
%  end
%  
%  
%  
%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  %for each tetrode/shank this function plot distribution of the frequency,numberofcycle, number of big cycle,
%  %length of rippleand the frequency associated with the maximum power
%  
%  
%  
%  figure;
%  subplot(2,2,1);
%  
%                  %Trace the distribution of the frequency of ripples
%  
%  for dd=1:length(drugconditions)
%      condition=drugconditions{dd}
%      FileName=[FileBase '/' condition,'RippleStatsforShank',num2str(shanknumber)];
%      Data=load(FileName);
%      BIN=100:1:245;
%      Distri=hist(Data(:,5),BIN)/length(Data(:,5));  
%      SmoothDistribution(Distri,BIN,0.05,dd);
%      hold on;
%      xlabel('Frequency (Hz)');
%      ylabel('Porbability');
%      i=['Ripple Frequency Distribution (Shank ' num2str(shanknumber) '; Site ' num2str(ChNums) '; Animal ' FileBase ')'];
%      title(i);
%      j1=length(Data(:,5));
%      jj=[condition,' (n=' num2str(j1) ')'];
%      name{dd}=jj;
%  end
%  
%  if length(name)==2
%     legend(num2str(name{1}),num2str(name{2}))
%  end
%  
%  if length(name)==3
%     legend(num2str(name{1}),num2str(name{2}),num2str(name{3}))
%  end
%      
%   
%             
%      
%  subplot(2,2,2);    
%      
%  for dd=1:length(drugconditions)
%      condition=drugconditions{dd}
%      FileName=[FileBase '/' condition,'RippleStatsforShank',num2str(shanknumber)];
%      Data=load(FileName);
%      BIN=3:1:30;
%      Distri=hist(Data(:,3),BIN)/length(Data(:,3));
%      SmoothDistribution(Distri,BIN,0.04,dd);
%      hold on;
%      
%      
%      i=['Number Of Big Oscillation Distribution(Tetrode' num2str(shanknumber) ')'];
%      title(i);
%      j1=length(Data(:,4));
%      jj=[condition, '(n=' num2str(j1) ')'];
%  end
%  
%  if length(name)==2
%     legend(num2str(name{1}),num2str(name{2}))
%  end
%  
%  if length(name)==3
%     legend(num2str(name{1}),num2str(name{2}),num2str(name{3}))
%  end
%      
%  
%  							%Trace the distribution of length of ripples
%  subplot(2,2,3);
%  
%  for dd=1:length(drugconditions)
%      condition=drugconditions{dd};
%      FileName=[FileBase '/' condition,'RippleStatsforShank',num2str(shanknumber)];
%      Data=load(FileName);
%      BIN=0.01:0.005:0.150;
%      Distri=hist(Data(:,6),BIN)/length(Data(:,6));
%      SmoothDistribution(Distri,BIN,0.04,dd);
%      hold on;
%      xlabel('Length of Ripple (sec)');
%      ylabel('Probability');
%      i=['Length of Ripples Distribution(Shank' num2str(shanknumber) ')'];
%      title(i);
%      j1=length(Data(:,4));
%      jj=[condition,' (n=',num2str(j1) ')'];
%  end
%  if length(name)==2
%     legend(num2str(name{1}),num2str(name{2}))
%  end
%  
%  if length(name)==3
%     legend(num2str(name{1}),num2str(name{2}),num2str(name{3}))
%  end
%   
%  
%  % Mean POwer
%  
%  subplot(2,2,4)
%  for dd=1:length(drugconditions)
%      condition=drugconditions{dd};
%      FileName=[FileBase '/' condition,'RippleMeanPowerforShank',num2str(shanknumber)];
%      Data=load(FileName);
%  	if  dd==1
%          color='k';
%      end
%  
%      if  dd==2
%          color='g';
%      end
%  
%      if  dd==3
%          color='b';
%      end
%  
%      if  i-1==4
%          color='r';
%      end
%          
%      SlimErrorBar(Data(:,1),Data(:,2),Data(:,3),color);
%  	hold on;
%  	xlabel('Frequency (Hz)');
%  	ylabel('Power');
%  	Titre1=['Mean of Power Ripple'];
%  	title(Titre1);
%  end
%  FigureTitle=([FileBase '/ripplefeatures.' FileBase '.' num2str(shanknumber) '.' num2str(ChNums) '.fig']);
%  saveas(gcf,FigureTitle);
%  close(gcf)
