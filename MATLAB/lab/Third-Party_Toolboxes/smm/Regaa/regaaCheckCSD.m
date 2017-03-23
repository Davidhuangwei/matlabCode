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

[whlm,n]=size(whldata);
%[eegm,n]=size(eeg);

%factor = whlm/eegm;

%if (length(eegfiltdata) ~= eegm | length(eegpowdata) ~= eegm | length(csdchdata) ~= eegm | length(csdfiltdata) ~= eegm | length(csdpowdata) ~= eegm) , ERROR_file_sizes_do_not_match
%end

time = 1 % in seconds
while ceil((time+timewindow/2)*whlsamp) < whlm

    cla;
    subplot(4,2,1);
    plot(whldata(round(time*whlsamp),1),whldata(round(time*whlsamp),2),'.','color',[1 0 0],'markersize',25,'linestyle','none');
    %plot(whldata(ceil(j*factor),1), whldata(ceil(j*factor),2),'.','color',[1 0 0],'markersize',25,'linestyle','none');
    set(gca,'xlim',[0 368],'ylim',[0 240]);
    
    % eeg trace
    keyboard
    
    eeg = bload(eegFileName,[eegNChan timewindow*eegsamp], round((time-timewindow/2)*eegsamp)*eegNChan*2,'int16');
    subplot(4,2,2); 
    cla;
    plot([ceil((time-timewindow/2)*eegsamp)+1:floor((time+timewindow/2)*eegsamp)]./eegsamp, eeg(eegCh,:));
    set(gca, 'xlim',[time-timewindow/2 time+timewindow/2]);
    
    if 0
    hold on;   
    plot([j-timewindow:j+timewindow]./eegsamp, eegfiltdata(j-timewindow:j+timewindow),'color',[1 0 0]);

    for i=1:9
       plot(([j-timewindow j-timewindow]+i*timewindow/5)/eegsamp, eegwinheight,':', 'color' , [0 0 0]);
    end
    plot([j j]./eegsamp,eegwinheight,'color',[1 0 0]);
    set(gca,'xlim',[(j-timewindow) (j+timewindow)]./eegsamp,'ylim', eegwinheight);
    
    % eeg power trace
    subplot(4,2,4); 
    cla;
    plot([j-timewindow:j+timewindow]./eegsamp, eegpowdata(j-timewindow:j+timewindow));
    hold on;
    for i=1:9
       plot(([j-timewindow j-timewindow]+i*timewindow/5)/eegsamp, eegpowwinheight,':', 'color' , [0 0 0]);
    end
    plot([j j]./eegsamp,eegpowwinheight,'color',[1 0 0]);
    set(gca,'xlim',[(j-timewindow) (j+timewindow)]./eegsamp,'ylim', eegpowwinheight);
    
    % csd trace
    subplot(4,2,6); 
    cla;
    plot([j-timewindow:j+timewindow]./eegsamp, csdchdata(j-timewindow:j+timewindow));
    hold on;   
    %plot([j-timewindow:j+timewindow]./eegsamp,
    plot([j-timewindow:j+timewindow]./eegsamp, csdfiltdata(j-timewindow:j+timewindow),'color',[1 0 0]);

    for i=1:9
       plot(([j-timewindow j-timewindow]+i*timewindow/5)/eegsamp, csdwinheight,':', 'color' , [0 0 0]);
    end
    plot([j j]./eegsamp,csdwinheight,'color',[1 0 0]);
    set(gca,'xlim',[(j-timewindow) (j+timewindow)]./eegsamp,'ylim', csdwinheight);
    
    % csd power trace
    subplot(4,2,8); 
    cla;
    plot([j-timewindow:j+timewindow]./eegsamp, csdpowdata(j-timewindow:j+timewindow));
    hold on;
    for i=1:9
       plot(([j-timewindow j-timewindow]+i*timewindow/5)/eegsamp, csdpowwinheight,':', 'color' , [0 0 0]);
    end
    plot([j j]./eegsamp,csdpowwinheight,'color',[1 0 0]);
    set(gca,'xlim',[(j-timewindow) (j+timewindow)]./eegsamp,'ylim', csdpowwinheight);
    end
    
   
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


