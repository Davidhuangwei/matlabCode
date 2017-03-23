function tracesPlot(fileBase,time,timewindow,eegNChan,eegCh,csdFileExt,csdNChan,csdCh,figNum,eegWinHeight,powWinHeight,csdWinHeight,csdPowWinHeight)

videoLimits = [368 240];
%eegchdata = readmulti([filebase '.eeg' ], nchannels, channel);
%eegwinheight = [mean(eegchdata)-3*std(eegchdata) mean(eegchdata)+3*std(eegchdata)];
%csdwinheight = [mean(csdchdata)-3*std(csdchdata) mean(csdchdata)+3*std(csdchdata)];  
%eegpowwinheight = [min(eegpowdata) max(eegpowdata)];
%csdpowwinheight = [min(csdpowdata) max(csdpowdata)];
eegFileName = [fileBase '.eeg'];
powFileName = [fileBase '_6-14Hz.eeg.100DBpow'];  
filtFileName = [fileBase '_6-14Hz.eeg.filt'];   
csdFileName = [fileBase csdFileExt];
csdFiltFileName = [fileBase '_6-14Hz' csdFileExt '.filt'];
csdPowFileName =  [fileBase '_6-14Hz' csdFileExt '.100DBpow'];

if ~exist('timewindow', 'var') | isempty(timewindow),
    timewindow = 1; % in seconds
end
%timewindow = ceil(timewindow*1250/2); % convert to eeg samples and divide by 2
 
whldata = load([fileBase '.whl']);
eegsamp = 1250; % samples/sec
whlsamp = 39.0625; % samples/sec
figure(figNum);
clf;

step = 1;
if ~exist('eegWinHeight','var') | isempty(eegWinHeight)
    eegWinHeight = [-2000 2000];
end
if ~exist('powWinHeight','var') | isempty(powWinHeight)
    powWinHeight = [3500 6000];
end
if ~exist('csdWinHeight','var') | isempty(csdWinHeight)
    csdWinHeight = [-2000 2000];
end
if ~exist('csdPowWinHeight','var') | isempty(csdPowWinHeight)
    csdPowWinHeight = [0 5000];
end
[whlm,n]=size(whldata);
%[eegm,n]=size(eeg);

%factor = whlm/eegm;

%if (length(eegfiltdata) ~= eegm | length(eegpowdata) ~= eegm | length(csdchdata) ~= eegm | length(csdfiltdata) ~= eegm | length(csdpowdata) ~= eegm) , ERROR_file_sizes_do_not_match
%end

time = time-timewindow/2; % in seconds
if ceil((time+timewindow)*whlsamp) < whlm

    cla;
    subplot(4,2,1);
    plot(whldata(:,1),videoLimits(2)-whldata(:,2),'.','color',[0.5 0.5 0.5]);
    hold on
    plot(whldata(round((time+timewindow/2)*whlsamp),1),videoLimits(2)-whldata(round((time+timewindow/2)*whlsamp),2),'.','color',[1 0 0],'markersize',25,'linestyle','none');
    %plot(whldata(ceil(j*factor),1), whldata(ceil(j*factor),2),'.','color',[1 0 0],'markersize',25,'linestyle','none');
    set(gca,'xlim',[0 368],'ylim',[0 240]);
    
    % eeg trace
    eeg = bload(eegFileName,[eegNChan timewindow*eegsamp], round(time*eegsamp)*eegNChan*2,'int16');
    subplot(4,2,2); 
    cla;
    kloogFactor = mod(floor((time+timewindow)*eegsamp)-floor(time*eegsamp),eegsamp-1);
    plot([floor(time*eegsamp)+kloogFactor:floor((time+timewindow)*eegsamp)]./eegsamp, eeg(eegCh,:));
    hold on;   
    filt = bload(filtFileName,[eegNChan timewindow*eegsamp], round(time*eegsamp)*eegNChan*2,'int16');
    plot([floor(time*eegsamp)+kloogFactor:floor((time+timewindow)*eegsamp)]./eegsamp, filt(eegCh,:),'color',[1 0 0]);
    for i=1:9
       plot(([time time]+i*timewindow/5), eegWinHeight,':', 'color' , [0 0 0]);
    end
    plot([time+timewindow/2 time+timewindow/2],eegWinHeight,'color',[1 0 0]);
    %set(gca,'xlim',[(j-timewindow) (j+timewindow)]./eegsamp,'ylim', eegwinheight);
    set(gca, 'xlim',[time time+timewindow], 'ylim', eegWinHeight);
    
    % eeg power trace
    subplot(4,2,4); 
    cla;
    pow = bload(powFileName,[eegNChan timewindow*eegsamp], round(time*eegsamp)*eegNChan*2,'int16');
    plot([floor(time*eegsamp)+kloogFactor:floor((time+timewindow)*eegsamp)]./eegsamp, pow(eegCh,:)./100);
    hold on;   
    for i=1:9
       plot(([time time]+i*timewindow/5), powWinHeight,':', 'color' , [0 0 0]);
    end
    plot([time+timewindow/2 time+timewindow/2],powWinHeight,'color',[1 0 0]);
    set(gca, 'xlim',[time time+timewindow], 'ylim', powWinHeight);
    
    % csd trace
    subplot(4,2,6); 
    csd = bload(csdFileName,[csdNChan timewindow*eegsamp], round(time*eegsamp)*csdNChan*2,'int16');
    cla;
    plot([floor(time*eegsamp)+kloogFactor:floor((time+timewindow)*eegsamp)]./eegsamp, csd(csdCh,:),'g');
    hold on;   
    
    calcCsd = (2*eeg(eegCh,:)-eeg(eegCh-1,:)-eeg(eegCh+1,:));
    plot([floor(time*eegsamp)+kloogFactor:floor((time+timewindow)*eegsamp)]./eegsamp, calcCsd,'b');

    csdFilt = bload(csdFiltFileName,[csdNChan timewindow*eegsamp], round(time*eegsamp)*csdNChan*2,'int16');
    plot([floor(time*eegsamp)+kloogFactor:floor((time+timewindow)*eegsamp)]./eegsamp, csdFilt(csdCh,:),'color',[1 0 0]);

    for i=1:9
       %plot(([time time]+i*timewindow/5), csdWinHeight,':', 'color' , [0 0 0]);
    end
    %plot([time+timewindow/2 time+timewindow/2],csdWinHeight,'color',[1 0 0]);
    set(gca, 'xlim',[time time+timewindow], 'ylim', csdWinHeight);

    
    
    % csd power trace
    subplot(4,2,8); 
    cla;
    csdPow = bload(csdPowFileName,[csdNChan timewindow*eegsamp], round(time*eegsamp)*csdNChan*2,'int16');
    plot([floor(time*eegsamp)+kloogFactor:floor((time+timewindow)*eegsamp)]./eegsamp, csdPow(csdCh,:)./100);
    hold on;   
    for i=1:9
       plot(([time time]+i*timewindow/5), csdPowWinHeight,':', 'color' , [0 0 0]);
    end
    plot([time+timewindow/2 time+timewindow/2],csdPowWinHeight,'color',[1 0 0]);
    set(gca, 'xlim',[time time+timewindow], 'ylim', csdPowWinHeight);

    
   
else
    YourOutaTime
end

