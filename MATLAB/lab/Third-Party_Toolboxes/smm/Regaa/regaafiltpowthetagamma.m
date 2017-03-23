function regaafiltpowthetagamma(filebase, nchannels, channel,timewindow, eegchdata, filtdata1, filtdata2, powdata)

%eegchdata = readmulti([filebase '.eeg' ], nchannels, channel);

eegwinheight = [mean(eegchdata)-3*std(eegchdata) mean(eegchdata)+3*std(eegchdata)]% [0.8*min(eegchdata) 0.8*max(eegchdata)];   
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

whlm=size(whldata,1);
eegm=size(eegchdata,1);

factor = whlm/eegm;

if (length(filtdata1) ~= eegm | length(powdata) ~= eegm), ERROR_file_sizes_do_not_match
end

j=1+timewindow; % j counted in eeg samples
step=10;
while ((j<eegm) & (ceil(j*factor)<whlm))

    subplot(3,1,1);
    cla;
    plot(whldata(:,1),whldata(:,2),'.','color',[0.5 0.5 0.5]);
    hold on
    plot(whldata(ceil(j*factor),1), whldata(ceil(j*factor),2),'.','color',[1 0 0],'markersize',25,'linestyle','none');
    set(gca,'xlim',[0 368],'ylim',[0 240]);
    
    subplot(3,1,2); 
    cla;
    plot([j-timewindow:j+timewindow]./eegsamp, eegchdata(j-timewindow:j+timewindow));
    hold on;   
    plot([j-timewindow:j+timewindow]./eegsamp, filtdata1(j-timewindow:j+timewindow),'color',[1 0 0]);
    plot([j-timewindow:j+timewindow]./eegsamp, filtdata1(j-timewindow:j+timewindow)+filtdata2(j-timewindow:j+timewindow),'color',[0 1 0]);
    

    for i=1:9
       plot(([j-timewindow j-timewindow]+i*timewindow/5)/eegsamp, eegwinheight,':', 'color' , [0 0 0]);
    end
    plot([j j]./eegsamp,eegwinheight,'color',[1 0 0]);
    set(gca,'xlim',[(j-timewindow) (j+timewindow)]./eegsamp,'ylim', eegwinheight);
 
    subplot(3,1,3); 
    cla;
    plot([j-timewindow:j+timewindow]./eegsamp, powdata(j-timewindow:j+timewindow),'r');
    hold on;
    for i=1:9
       plot(([j-timewindow j-timewindow]+i*timewindow/5)/eegsamp, powwinheight,':', 'color' , [0 0 0]);
    end
    plot([j j]./eegsamp,powwinheight,'color',[1 0 0]);
    set(gca,'xlim',[(j-timewindow) (j+timewindow)]./eegsamp,'ylim', powwinheight);
    
    i = input('how far to step (in seconds)?');
    if isempty(i),
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


