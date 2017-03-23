function specgrambhv(filebase, eegchdata, babs, f, t, minfreq, maxfreq)


%eegdata = bload([filebase '.eeg' ], [97 inf], 0, 'int16');
%eegchdata = eegdata(channel,:)';
%[b f t] = specgram(cheegdat, 2^13, 1250,2^11, 1800);
%[b f t] = mtpsg(eegchdata, 2^8, 1250, 2^7, 100);
%babs = abs(b);
eegsamp = 1250;
whldata = load([filebase '.whl']);
whlsamp = 39.0625;

[whlm n] = size(whldata);
[m,babsn]=size(babs);
[eegm,n]=size(eegchdata);

filetime = whlm/whlsamp;
babssamp = babsn/filetime;
timewindow = 1; % in seconds
eegwinheight = 9000; %in units
figure(1);
cla;
step=10;

j=(floor(1+(timewindow*babssamp/2)/babssamp*whlsamp));
while ((j<whlm) & (j/whlsamp*babssamp+(timewindow)*babssamp/2)<babsn & (j/whlsamp*eegsamp+(timewindow)*eegsamp/2)<eegm)
    cla;
    subplot(3,1,1);
    plot(whldata(j,1), whldata(j,2),'.','color',[1 0 0],'markersize',25,'linestyle','none');
    set(gca,'xlim',[0 368],'ylim',[0 240]);
    subplot(3,1,2); 
    imagesc(t(j*babssamp/whlsamp-timewindow*babssamp/2:j*babssamp/whlsamp+timewindow*babssamp/2), ...
        f(min(find(f>minfreq)):max(find(f<maxfreq))),log(babs(min(find(f>minfreq)):max(find(f<maxfreq)),j*babssamp/whlsamp-timewindow*babssamp/2:j*babssamp/whlsamp+timewindow*babssamp/2)))
  %  set(gca,'xlim',[t(j*babssamp/whlsamp-timewindow*babssamp/2) t(j*babssamp/whlsamp+timewindow*babssamp/2)]);
 %   set(gca, 'xtick', [0 eegsamp/2 eegsamp], 'xticklabel', [j/whlsamp-timewindow/2 j/whlsamp j/whlsamp+timewindow/2]);
    subplot(3,1,3);
    plot(eegchdata(j*eegsamp/whlsamp-timewindow*eegsamp/2:j*eegsamp/whlsamp+timewindow*eegsamp/2));
    hold on;
    line([eegsamp*timewindow/2 eegsamp*timewindow/2],[-eegwinheight eegwinheight],'color',[1 0 0]);
    
    set(gca,'xlim',[0 timewindow*eegsamp],'ylim',[-eegwinheight eegwinheight]);
    set(gca, 'xtick', [0 eegsamp/2 eegsamp], 'xticklabel', [j/whlsamp-timewindow/2 j/whlsamp j/whlsamp+timewindow/2]);

  % set(gca,'xlim',[j*eegsamp/whlsamp-timewindow*eegsamp/2 j*eegsamp/whlsamp+timewindow*eegsamp/2],'ylim',[-eegwinheight eegwinheight]);
   % set(gca, 'xtick', [j*eegsamp/whlsamp-timewindow*eegsamp/2 j*eegsamp/whlsamp j*eegsamp/whlsamp+timewindow*eegsamp/2], 'xticklabel', [j/whlsamp-timewindow/2 j/whlsamp j/whlsamp+timewindow/2]);

     i = input('how far to step (in video frames)?');
     if (i~=[]),
       step = i;
     end
     j=j+step;
end


