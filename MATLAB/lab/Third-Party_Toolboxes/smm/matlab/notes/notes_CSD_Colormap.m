nChans = 84;
swSeg1 = bload('sm9603m2_222_s1_267_linintp1.csd',[nChans round(200*1250/1000)],round((4*60+33.247)*1250)*2*nChans,'int16');
chanPerShank = 14;
nShanks = 6;
colorRange = NaN*ones(2,1);
clf;
for i=1:nShanks
    subplot(1,nShanks,i);
     pcolor(swSeg1(i*chanPerShank:-1:(i-1)*chanPerShank+1,:));
     shading('interp')
     set(gca,'ytick',[],'xtick',[])
     colorRange(1) = min([colorRange(1) get(gca,'clim')]);
     colorRange(2) = max([colorRange(2) get(gca,'clim')]);
end
for i=1:nShanks
    subplot(1,nShanks,i);
    set(gca,'clim',colorRange);
end

nChans = 72;
swSeg121=bload('sm9603m2_222_s1_267_linintp121.csd',[nChans round(200*1250/1000)],round((4*60+33.247)*1250)*2*nChans,'int16');
chanPerShank = 12;
nShanks = 6;
colorRange = NaN*ones(2,1);
clf;
for i=1:nShanks
    subplot(1,nShanks,i);
     pcolor(swSeg121(i*chanPerShank:-1:(i-1)*chanPerShank+1,:));
     shading('interp')
     set(gca,'ytick',[],'xtick',[])
     colorRange(1) = min([colorRange(1) get(gca,'clim')]);
     colorRange(2) = max([colorRange(2) get(gca,'clim')]);
end
for i=1:nShanks
    subplot(1,nShanks,i);
    set(gca,'clim',colorRange);
end

nChans = 84;
ppStimSeg121=bload('sm9603m2_227_s1_273.dat_linintp1.csd',[nChans round(20*20000/1000)],round((1*60+0.658)*20000)*2*nChans,'int16');
chanPerShank = 14;
nShanks = 6;
colorRange = NaN*ones(2,1);
clf;
for i=1:nShanks
    subplot(1,nShanks,i);
     pcolor(ppStimSeg121(i*chanPerShank:-1:(i-1)*chanPerShank+1,:));
     shading('interp')
     set(gca,'ytick',[],'xtick',[])
     colorRange(1) = min([colorRange(1) get(gca,'clim')]);
     colorRange(2) = max([colorRange(2) get(gca,'clim')]);
end
for i=1:nShanks
    subplot(1,nShanks,i);
    set(gca,'clim',colorRange);
end


nChans = 72;
ppStimSeg121=bload('sm9603m2_227_s1_273.dat_linintp121.csd',[nChans round(20*20000/1000)],round((1*60+0.658)*20000)*2*nChans,'int16');
chanPerShank = 12;
nShanks = 6;
colorRange = NaN*ones(2,1);
clf;
for i=1:nShanks
    subplot(1,nShanks,i);
     pcolor(ppStimSeg121(i*chanPerShank:-1:(i-1)*chanPerShank+1,:));
     shading('interp')
     set(gca,'ytick',[],'xtick',[])
     colorRange(1) = min([colorRange(1) get(gca,'clim')]);
     colorRange(2) = max([colorRange(2) get(gca,'clim')]);
end
for i=1:nShanks
    subplot(1,nShanks,i);
    set(gca,'clim',colorRange);
end
