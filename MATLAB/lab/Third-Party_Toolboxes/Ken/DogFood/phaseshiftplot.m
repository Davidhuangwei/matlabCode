function phaseshiftplot()
% phaseshift plotting program - part II
% this script plots data files.  

global plotto plotfrom plottime plotstep cellno mapcell eeg thetat
global sampl ssampl track spiket numclu plotfigure bb aa
global currentdir datadir dataname ctrlpanel cellpopup_handle

%find objects for control panel
back_handle = findobj(ctrlpanel,'Tag','backbutton');
forw_handle = findobj(ctrlpanel,'Tag','forwbutton');
peri_handle = findobj(ctrlpanel,'Tag','period_inp');
step_handle = findobj(ctrlpanel,'Tag','step_inp');
to_handle = findobj(ctrlpanel,'Tag','to_inp');
from_handle = findobj(ctrlpanel,'Tag','from_inp');
cellpopup_handle = findobj(ctrlpanel,'Tag','cellpopup');

currentdir = pwd;

% the time period to analyze and plot (in seconds)
plotto = plotfrom + plottime;
if plotfrom <0,
  plotfrom = 0;
end
if plotto > length(eeg)/sampl,
  plotto = length(eeg)/sampl;
end
  
% update the control panel info

set(peri_handle,'String',num2str(plotto-plotfrom));
set(step_handle,'String',num2str(plotstep));
set(from_handle,'String',num2str(plotfrom));
set(to_handle,'String',num2str(plotto));


plotperiod = [plotfrom,plotto];
plotperiod2 = plotperiod * ssampl;

range = [floor(plotperiod(1)*sampl)+1:floor(plotperiod(2)*sampl)];
trange = [floor(plotperiod(1)*sampl/32)+1:floor(plotperiod(2)*sampl/32)];

eegr = eeg(range);
eegroffset = mean(eegr);
eegr = eegr - eegroffset;

trackr = track(trange,:);

spikeinrange = spiket{cellno}(find((spiket{cellno} >= plotperiod2(1)) ...
	       & (spiket{cellno} <= plotperiod2(2))));

spikeinrange = round((spikeinrange - range(1)*16) / 16)+1;

tracknew = trackr(find(trackr(:,1) >=0),:);



set(0,'CurrentFigure',plotfigure);
subplot(2,2,1);
hold off
maxfr = max(max(mapcell));
mapcelln = ceil(mapcell/maxfr*63);
image(mapcelln);
hold on
plot (tracknew(:,1)/8,tracknew(:,2)/8,'r');
axis ij;
axis ([1,328/8,1,244/8]);
set(gca,'YTick',[],'XTick',[]);
title(['frate rate map track record']);


taxis = [1:length(eegr)]/sampl;

% filter the eeg trace (use filtfilt if you are equipped with
% signal processing toolkit)

feegr= filtfilt(bb,aa,eegr);

subplot(2,1,2);
hold off
plot(taxis,eegr/max(abs(eegr)),'r');
hold on
plot(taxis,feegr/max(abs(feegr)),'g');
% draw spikes as dots
% plot(taxis(spikeinrange),zeros(1,length(spikeinrange))-1.5,'.');
axis([0,taxis(length(taxis)),-2,2])

% draw spikes as lines
for ii=1:length(spikeinrange),
  x1 = taxis(spikeinrange(ii));
  y1 = -1.50;
  x2 = taxis(spikeinrange(ii));
  y2 = -1.70;
  line([x1,x2],[y1,y2]);
end


% detect local bottom peak;
dfeegr = diff(feegr);
zerox = [];
for ii = 2:length(dfeegr)-1,
  if dfeegr(ii-1) < 0 & dfeegr(ii+1) > 0 & feegr(ii) < 0;
    zerox = [zerox,ii];
  end
end

% plot bottom peaks
upperlimit = 2.5;
lowerlimit = -2.5;
% plot(zerox/sampl,zeros(1,length(zerox))-0.5,'k.');

axis([0,taxis(length(taxis)),lowerlimit,upperlimit])

phases = zeros(1,length(spikeinrange));
phaseplotbottom = 1.2;

lhandle = line([0,taxis(length(taxis))], ...
	       [phaseplotbottom,phaseplotbottom]);
set(lhandle,'LineStyle','-','Color',[0.5 0.5 0.5]);

lhandle = line([0,taxis(length(taxis))], ...
	       [phaseplotbottom,phaseplotbottom]+1);
set(lhandle,'LineStyle','-','Color',[0.5 0.5 0.5]);

lhandle = line([0,taxis(length(taxis))], ...
	       [phaseplotbottom,phaseplotbottom]+.5);
set(lhandle,'LineStyle','-','Color',[.8 .5 .7]);

lhandle = line([0,taxis(length(taxis))], ...
	       [phaseplotbottom,phaseplotbottom]+.75);
set(lhandle,'LineStyle','-.','Color',[.8 .5 1]);

lhandle = line([0,taxis(length(taxis))], ...
	       [phaseplotbottom,phaseplotbottom]+.25);
set(lhandle,'LineStyle','-.','Color',[.8 .5 1]);

set(gca,'YTick',[phaseplotbottom,phaseplotbottom+1], ...
	'YTickLabel',['  0';'360']);

phased = [];
for ii = 1:length(spikeinrange),
  for jj = 1:length(zerox)-1,
    if spikeinrange(ii)>=zerox(jj) & spikeinrange(ii)<zerox(jj+1),
      phasef = (spikeinrange(ii)-zerox(jj))/(zerox(jj+1)-zerox(jj)) ;
      phased = [;phased,phasef*360];
      x1 = taxis(zerox(jj));
      y1 = phasef+phaseplotbottom;
      x2 = taxis(zerox(jj+1));
      y2 = phasef+phaseplotbottom;
      line([x1,x2],[y1,y2]);
    end
  end
end

subplot(2,2,2),
hist(phased,20);
title('phase histogram')
set(gca,'XLim',[0,360]);
cd(currentdir);
