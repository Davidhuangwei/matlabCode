function regaabhv(filebase, channel, powdata)


eegdata = bload([filebase '.eeg' ], [97 inf], 0, 'int16');
eegchdata = eegdata(channel,:)';

whldata = load([filebase '.whl']);
eegsamp = 1250;
filetime = size(eegchdata)/eegsamp;
whlsamp = 39.0625;
timewindow = 1; % in seconds
eegwinheight = 9000; %in units
figure(1);
cla;
step=10;
j=(floor(1+(timewindow*eegsamp/2)/eegsamp*whlsamp));
[whlm,n]=size(whldata);
[eegm,n]=size(eegchdata);
while ((j<whlm) & (j/whlsamp*eegsamp+(timewindow)*eegsamp/2)<eegm)
    cla;
    subplot(3,1,1);
    plot(whldata(j,1), whldata(j,2),'.','color',[1 0 0],'markersize',25,'linestyle','none');
    set(gca,'xlim',[0 368],'ylim',[0 240]);
    subplot(3,1,2);    
    plot(eegchdata(j*eegsamp/whlsamp-timewindow*eegsamp/2:j*eegsamp/whlsamp+timewindow*eegsamp/2));
    hold on;
    line([eegsamp*timewindow/2 eegsamp*timewindow/2],[-eegwinheight eegwinheight],'color',[1 0 0]);
    set(gca,'xlim',[0 timewindow*eegsamp],'ylim', [-eegwinheight eegwinheight]);
    set(gca, 'xtick', [0 eegsamp/2 eegsamp], 'xticklabel', [j/whlsamp-timewindow/2 j/whlsamp j/whlsamp+timewindow/2]);
    subplot(3,1,3);    
    plot(powdata(j*eegsamp/whlsamp-timewindow*eegsamp/2:j*eegsamp/whlsamp+timewindow*eegsamp/2));
    hold on;
    line([eegsamp*timewindow/2 eegsamp*timewindow/2],[-eegwinheight eegwinheight],'color',[1 0 0]);
    set(gca,'xlim',[0 timewindow*eegsamp],'ylim', [-eegwinheight eegwinheight]);
    set(gca, 'xtick', [0 eegsamp/2 eegsamp], 'xticklabel', [j/whlsamp-timewindow/2 j/whlsamp j/whlsamp+timewindow/2]);
     i = input('how far to step (in video frames)?');
     if (i~=[]),
       step = i;
     end
     j=j+step;
end


