function regaafiltpowbhv(filebase, nchannels, channel, filtdata, powdata)
    
eegchdata = readmulti([filebase '.eeg' ], nchannels, channel);
whldata = load([filebase '.whl']);
eegsamp = 1250/1000;
whlsamp = 39.0625/1000;
timewindow = 1000; % in miliseconds
eegwinheight = 5000; %in units
figure;
cla;

[whlm,n]=size(whldata);
[eegm,n]=size(eegchdata);
factor = whlm/eegm;

j=1+timewindow/2;
step=100;
while (ceil((j+timewindow/2)*eegsamp)<eegm & ceil(j*whlsamp)<whlm)

    cla;
    subplot(4,1,1);
    plot(whldata(ceil(j*whlsamp),1), whldata(ceil(j*whlsamp),2),'.','color',[1 0 0],'markersize',25,'linestyle','none');
    set(gca,'xlim',[0 368],'ylim',[0 240]);
    
    subplot(4,1,2); 
    cla;
    plot( [ceil((j-timewindow/2)*eegsamp):ceil((j+timewindow/2)*eegsamp)]./(eegsamp*1000),...
        eegchdata(ceil((j-timewindow/2)*eegsamp):ceil((j+timewindow/2)*eegsamp)),'-');
    hold on;
  %  for i=1:9
   %    plot([i*eegsamp*timewindow/10000 i*eegsamp*timewindow/10000], [-eegwinheight eegwinheight],':', 'color' , [0 0 0]);
       % end
  %  plot([j j],[-eegwinheight eegwinheight],'color',[1 0 0]);
    set(gca,'ylim', [-eegwinheight eegwinheight]);
    %'xlim',[0 timewindow*eegsamp/1000],
   % set(gca, 'xtick', [0 ], 'xticklabel', [j/whlsamp-timewindow/2000 j/whlsamp j/whlsamp+timewindow/2000]);
  
    i = input('how far to step (in seconds)?');
    if (i~=[]),
        step = i*1000;
    end
    j=j+step;
end


