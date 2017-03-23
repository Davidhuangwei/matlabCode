function regaafiltpowbhv(filebase, nchannels, channel,timewindow, filtdata, powdata)

eegchdata = readmulti([filebase '.eeg' ], nchannels, channel);

eegwinheight = [0.9*min(eegchdata) 0.9*max(eegchdata)]; %in unit  
filtwinheight = [min(filtdata) max(filtdata)];
powwinheight = [min(powdata) max(powdata)];
if ~exist('timewindow', 'var'),
    timewindow = 1; % in seconds
end
timewindow = ceil(timewindow*1250/2); % convert to eeg samples and divide by 2
 
whldata = load([filebase '.whl']);
eegsamp = 1250; % samples/sec
whlsamp = 39.0625; % samples/sec
figure(1);
cla;

[whlm,n]=size(whldata);
[eegm,n]=size(eegchdata);

factor = whlm/eegm;

if (length(filtdata) ~= eegm | length(powdata) ~= eegm), ERROR_file_sizes_do_not_match
end

j=1+timewindow; % j counted in eeg samples
step=10;
while ((j<eegm) & (ceil(j*factor)<whlm))

    cla;
    subplot(4,1,1);
    plot(whldata(ceil(j*factor),1), whldata(ceil(j*factor),2),'.','color',[1 0 0],'markersize',25,'linestyle','none');
    set(gca,'xlim',[0 368],'ylim',[0 240]);
    
    subplot(4,1,2); 
    cla;
    plot([j-timewindow:j+timewindow]./eegsamp, eegchdata(j-timewindow:j+timewindow));
    
    plot([j-timewindow:j+timewindow]./eegsamp, filtdata(j-timewindow:j+timewindow),'color',[1 0 0]);

    hold on;
    for i=1:9
       plot(([j-timewindow j-timewindow]+i*timewindow/5)/eegsamp, eegwinheight,':', 'color' , [0 0 0]);
    end
    plot([j j]./eegsamp,eegwinheight,'color',[1 0 0]);
    set(gca,'xlim',[(j-timewindow) (j+timewindow)]./eegsamp,'ylim', eegwinheight);
 
    subplot(4,1,3); 
    cla;
    plot([j-timewindow:j+timewindow]./eegsamp, filtdata(j-timewindow:j+timewindow));
    hold on;
    for i=1:9
       plot(([j-timewindow j-timewindow]+i*timewindow/5)/eegsamp, filtwinheight,':', 'color' , [0 0 0]);
    end
    plot([j j]./eegsamp,filtwinheight,'color',[1 0 0]);
    set(gca,'xlim',[(j-timewindow) (j+timewindow)]./eegsamp,'ylim', filtwinheight);

    subplot(4,1,4); 
    cla;
    plot([j-timewindow:j+timewindow]./eegsamp, powdata(j-timewindow:j+timewindow));
    hold on;
    for i=1:9
       plot(([j-timewindow j-timewindow]+i*timewindow/5)/eegsamp, powwinheight,':', 'color' , [0 0 0]);
    end
    plot([j j]./eegsamp,powwinheight,'color',[1 0 0]);
    set(gca,'xlim',[(j-timewindow) (j+timewindow)]./eegsamp,'ylim', powwinheight);
    
    i = input('how far to step (in seconds)?');
    if (i==[]),
        j = j+step;
    else
        if (i=='t'),
            i = input('what time window would you like (in seconds)?');
            timewindow = ceil(i*1250/2);
            j = max(j, 1+timewindow); % make sure timewindow doesn't run below the beginning of our matrices
        else         
            step = ceil(i*1250);
            j = j+step;
        end
    end
end

