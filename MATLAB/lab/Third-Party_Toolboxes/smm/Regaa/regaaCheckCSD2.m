function regaaCheckCSD(fileBase,timewindow,eegNChan,eegCh,csdFileExt,csdNChan,csdCh)

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
figure(11);
cla;

step = 1;
eegWinHeight = [-2000 2000];
powWinHeight = [3500 6000];
csdPowWinHeight = [2000 4000];
[whlm,n]=size(whldata);
%[eegm,n]=size(eeg);

%factor = whlm/eegm;

%if (length(eegfiltdata) ~= eegm | length(eegpowdata) ~= eegm | length(csdchdata) ~= eegm | length(csdfiltdata) ~= eegm | length(csdpowdata) ~= eegm) , ERROR_file_sizes_do_not_match
%end

time = 1 % in seconds
while ceil((time+timewindow)*whlsamp) < whlm

    cla;
    subplot(4,2,1);
    plot(whldata(round((time+timewindow/2)*whlsamp),1),whldata(round((time+timewindow/2)*whlsamp),2),'.','color',[1 0 0],'markersize',25,'linestyle','none');
    %plot(whldata(ceil(j*factor),1), whldata(ceil(j*factor),2),'.','color',[1 0 0],'markersize',25,'linestyle','none');
    set(gca,'xlim',[0 368],'ylim',[0 240]);
    
    % eeg trace
    eeg = bload(eegFileName,[eegNChan timewindow*eegsamp], round(time*eegsamp)*eegNChan*2,'int16');
    subplot(4,2,2); 
    cla;
    plot([floor(time*eegsamp)+1:floor((time+timewindow)*eegsamp)]./eegsamp, eeg(eegCh,:));
    set(gca, 'xlim',[time time+timewindow]);
    hold on;   
    kloogFactor = mod(floor((time+timewindow)*eegsamp)-floor(time*eegsamp),eegsamp-1)
    filt = bload(filtFileName,[eegNChan timewindow*eegsamp], round(time*eegsamp)*eegNChan*2,'int16');
    plot([floor(time*eegsamp)+kloogFactor:floor((time+timewindow)*eegsamp)]./eegsamp, filt(eegCh,:),'color',[1 0 0]);

    for i=1:9
       plot(([time time]+i*timewindow/5), eegWinHeight,':', 'color' , [0 0 0]);
    end
    plot([time+timewindow/2 time+timewindow/2],eegWinHeight,'color',[1 0 0]);
    %set(gca,'xlim',[(j-timewindow) (j+timewindow)]./eegsamp,'ylim', eegwinheight);
    
    % eeg power trace
    subplot(4,2,4); 
    cla;
    pow = bload(powFileName,[eegNChan timewindow*eegsamp], round(time*eegsamp)*eegNChan*2,'int16');
    plot([floor(time*eegsamp)+kloogFactor:floor((time+timewindow)*eegsamp)]./eegsamp, pow(eegCh,:));
    set(gca, 'xlim',[time time+timewindow], 'ylim', powWinHeight);
    hold on;   
    for i=1:9
       plot(([time time]+i*timewindow/5), powWinHeight,':', 'color' , [0 0 0]);
    end
    plot([time+timewindow/2 time+timewindow/2],powWinHeight,'color',[1 0 0]);

    
    % csd trace
    subplot(4,2,6); 
    csd = bload(csdFileName,[csdNChan timewindow*eegsamp], round(time*eegsamp)*csdNChan*2,'int16');
    cla;
    plot([floor(time*eegsamp)+kloogFactor:floor((time+timewindow)*eegsamp)]./eegsamp, csd(csdCh,:),'g');
    set(gca, 'xlim',[time time+timewindow]);
    hold on;   
    
    calcCsd = (2*eeg(eegCh,:)-eeg(eegCh-1,:)-eeg(eegCh+1,:));
    plot([floor(time*eegsamp)+1:floor((time+timewindow)*eegsamp)]./eegsamp, calcCsd,'b');

    csdFilt = bload(csdFiltFileName,[csdNChan timewindow*eegsamp], round(time*eegsamp)*csdNChan*2,'int16');
    plot([floor(time*eegsamp)+kloogFactor:floor((time+timewindow)*eegsamp)]./eegsamp, csdFilt(csdCh,:),'color',[1 0 0]);

    for i=1:9
       %plot(([time time]+i*timewindow/5), csdWinHeight,':', 'color' , [0 0 0]);
    end
    %plot([time+timewindow/2 time+timewindow/2],csdWinHeight,'color',[1 0 0]);

    
    
    % csd power trace
    subplot(4,2,8); 
    cla;
    csdPow = bload(csdPowFileName,[csdNChan timewindow*eegsamp], round(time*eegsamp)*csdNChan*2,'int16');
    plot([floor(time*eegsamp)+kloogFactor:floor((time+timewindow)*eegsamp)]./eegsamp, csdPow(csdCh,:));
    set(gca, 'xlim',[time time+timewindow], 'ylim', csdPowWinHeight);
    hold on;   
    for i=1:9
       plot(([time time]+i*timewindow/5), csdPowWinHeight,':', 'color' , [0 0 0]);
    end
    plot([time+timewindow/2 time+timewindow/2],csdPowWinHeight,'color',[1 0 0]);

    
   
    i = input('how far to step (in seconds)?');
    if isempty(i),
        time = time+step;
    else
        if (i=='t'),
            i = input('what time window would you like (in seconds)?');
            timewindow = i;
            time = max(time, 1+timewindow); % make sure timewindow doesn't run below the beginning of our matrices
        else         
            step = i;
            time = time+step;
        end
    end
end


