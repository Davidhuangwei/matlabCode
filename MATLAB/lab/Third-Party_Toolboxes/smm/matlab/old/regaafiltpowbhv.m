function regaafiltpowbhv(filebase, nchannels, channel, filtdata, powdata)
    
eegchdata = readmulti([filebase '.eeg' ], nchannels, channel);
whldata = load([filebase '.whl']);
eegsamp = 1250;
filetime = size(eegchdata)/eegsamp;
whlsamp = 39.0625;
timewindow = 100; % in seconds
eegwinheight = 9000; %in units
figure(1);
cla;
step=10;
j=(floor(1+(timewindow*eegsamp/2000)/eegsamp*whlsamp));
[whlm,n]=size(whldata);
[eegm,n]=size(eegchdata);
while ((j<whlm) & (j/whlsamp*eegsamp+(timewindow)*eegsamp/2000)<eegm)
    cla;
    subplot(4,1,1);
    plot(whldata(j,1), whldata(j,2),'.','color',[1 0 0],'markersize',25,'linestyle','none');
    set(gca,'xlim',[0 368],'ylim',[0 240]);
    
    subplot(4,1,2); 
    cla;
    plot(eegchdata(j*eegsamp/whlsamp-timewindow*eegsamp/2000:j*eegsamp/whlsamp+timewindow*eegsamp/2000));
    hold on;
    for i=1:9
        plot([i*eegsamp*timewindow/10000 i*eegsamp*timewindow/10000], [-eegwinheight eegwinheight],':', 'color' , [0 0 0]);
    end
    plot([eegsamp*timewindow/2000 eegsamp*timewindow/2000],[-eegwinheight eegwinheight],'color',[1 0 0]);
    set(gca,'xlim',[0 timewindow*eegsamp/1000],'ylim', [-eegwinheight eegwinheight]);
    set(gca, 'xtick', [0 eegsamp/2 eegsamp], 'xticklabel', [j/whlsamp-timewindow/2000 j/whlsamp j/whlsamp+timewindow/2000]);
    
    subplot(4,1,3);  
    cla;
    plot(powdata(j*eegsamp/whlsamp-timewindow*eegsamp/2000:j*eegsamp/whlsamp+timewindow*eegsamp/2000));
    hold on;
    for i=1:9       
        plot([i*eegsamp*timewindow/10000 i*eegsamp*timewindow/10000], [-eegwinheight eegwinheight],':', 'color' , [0 0 0]);
    end
    line([eegsamp*timewindow/2000 eegsamp*timewindow/2000],[-eegwinheight eegwinheight],'color',[1 0 0]);
    set(gca,'xlim',[0 timewindow*eegsamp/1000],'ylim', [min(powdata) max(powdata)]);
    set(gca, 'xtick', [0 eegsamp/2 eegsamp], 'xticklabel', [j/whlsamp-timewindow/2000 j/whlsamp j/whlsamp+timewindow/2000]);
    
    subplot(4,1,4);  
    cla;
    plot(filtdata(j*eegsamp/whlsamp-timewindow*eegsamp/2000:j*eegsamp/whlsamp+timewindow*eegsamp/2000));
    hold on;
    for i=1:9       
        plot([i*eegsamp*timewindow/10000 i*eegsamp*timewindow/10000], [-eegwinheight eegwinheight],':', 'color' , [0 0 0]);
    end
    line([eegsamp*timewindow/2000 eegsamp*timewindow/0002],[-eegwinheight eegwinheight],'color',[1 0 0]);
    set(gca,'xlim',[0 timewindow*eegsamp/1000],'ylim', [-1000 1000]);
    set(gca, 'xtick', [0 eegsamp/2 eegsamp], 'xticklabel', [j/whlsamp-timewindow/2000 j/whlsamp j/whlsamp+timewindow/2000]);

    i = input('how far to step (in video frames)?');
    if (i~=[]),
        step = i;
    end
    j=j+step;
end


