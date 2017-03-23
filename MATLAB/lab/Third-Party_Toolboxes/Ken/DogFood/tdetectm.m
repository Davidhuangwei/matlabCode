% tdetectm - theta peak detection (for 12bit) (for mice - 3hz theta).
% function [peaks] = tdetect2(fname,numch,getch,viewgraph, [dtthreshold])
% (12bit version)
% fname = input eeg filename (sampling rate = 1250 Hz)
% numch = number of channels in the file
% getch = channels (count starts from 1, not zero!) to
%         detect theta
% viewgraph = 0 for no graphics (faster), 1 to show what's
%             going on
% the returned result is in eeg time
% tdetect adds the signals specified by 'getch', take spectrum
% ratio of 0.2-1.5 Hz and 2-4Hz range, if the value is bigger than
% dtthreshold (default is 6), it detects theta peak for the buffer
% buffersize is 2048 (=2.5 seconds), 1024 overlap.


function [peaks] = tdetectm(fname,numch,getch,viewgraph, dtthreshold)

if nargin < 4
  error('function [peaks] = tdetect(fname,numch,getch,viewgraph, dtthreshold)'); 
end
if nargin == 4
dtthreshold = 6;
end


buffersize = 2048;
overlap = buffersize/2;
ovlp_ignore = 200;
buffersize2 = buffersize - overlap;
eeg_sr = 1250; %Hz

mininterval = 50; % ms
minint = round(mininterval*1000/eeg_sr);

% filter design
filter_low = 2;
filter_high = 4;
[b,a] = butter(3,[filter_low,filter_high]/eeg_sr*2);
faxis = [0:1250/buffersize/4:1250];


% delta frequency range
dl = .2; dh = 1.5;
% theta frequency range
tl = 2; th = 4; 
% power spectrum plotting frequency range
pl = 1; ph = 100;

%calculate the actual frequency domain range (for fft);
drange = find(faxis(:)>=dl & faxis(:)<dh);
trange = find(faxis(:)>=tl & faxis(:)<th);
prange = find(faxis(:)>=pl & faxis(:)<ph);

% specify which channels you want to detect theta 
nch = length(getch);

[datafile,msg] = fopen(fname,'r');

% create the template for the figure

if viewgraph
  close('all');
  figure(1);clf;
  axeshandle = zeros(2,1);
  axeshandle(1) = subplot(2,1,1); 
  set(axeshandle(1),'XLimMode','manual','XLim',[0,buffersize]);
  axeshandle(2) = subplot(2,2,3);
end
peaksdetected = [];
bufferstart = 0;
  
% do the first portion
[data,count] = fread(datafile,[numch,buffersize],'int16');
data = data -2048;
sdata = sum(data(getch,:),1);
ff = abs(fft(sdata,buffersize*4)).^2;
dtval  = sum(ff(trange))/sum(ff(drange));
if dtval >=dtthreshold
  fdata = filtfilt(b,a,sdata);
  ppp = troughdetect(fdata);
  pp = ppp(find(ppp<buffersize-ovlp_ignore));
  peaksdetected = [pp;peaksdetected];
  if viewgraph
    axes(axeshandle(1));
    hold off
    plot(sdata(:),'b');
    hold on
    plot(fdata(:),'r');
    plot(pp,fdata(pp),'g+');
    axes(axeshandle(2))
    hold off
    plot(faxis(prange),ff(prange));
    hold on;
    plot(faxis(drange),ff(drange),'r');
    plot(faxis(trange),ff(trange),'g');
    figure(1);
  end;
end

ovlbuf = sdata(length(sdata)-overlap+1:end);
bufferstart = bufferstart + buffersize2;

% do the rest
while ~feof(datafile),
  [data,count] = fread(datafile,[numch,buffersize2],'int16');
  data = data -2048;
  sdata = sum(data(getch,:),1);
  sdata = [ovlbuf,sdata];
  ff = abs(fft(sdata,buffersize*4)).^2;
  dtval  = sum(ff(trange))/sum(ff(drange));
  if dtval >=dtthreshold
    fdata = filtfilt(b,a,sdata);
    ppp = troughdetect(fdata);
    pp = ppp(find(ppp<buffersize-ovlp_ignore & ppp>=ovlp_ignore));
    peaksdetected = [peaksdetected;pp+bufferstart];
    if viewgraph
      axes(axeshandle(1));
      hold off
      plot(sdata(:),'b');
      hold on
      plot(fdata(:),'r');
      plot(pp,fdata(pp),'g+');
      axes(axeshandle(2))
      hold off
      plot(faxis(prange),ff(prange));
      hold on;
      plot(faxis(drange),ff(drange),'r');
      plot(faxis(trange),ff(trange),'g');
      set(axeshandle(1),'XLimMode','manual','XLim',[0,buffersize]);
      figure(1);
    end
  end
  ovlbuf = sdata(length(sdata)-overlap+1:end);
  bufferstart = bufferstart + buffersize2;
end

fclose(datafile);

% gather up the detected peaks and select the unique ones;
peaksdetected2 = unique(sort(peaksdetected));
peaksindex = [1:length(peaksdetected2)];
peaksdetectedconf = find(diff(peaksdetected2)<=minint);
peaksdetectedconfs = unique(sort([peaksdetectedconf;peaksdetectedconf+1]));

peaksdetectednp = peaksdetected2(setdiff(peaksindex,peaksdetectedconfs));
peaksdetectedpr = round((peaksdetected2(peaksdetectedconf)+ ...
			peaksdetected2(peaksdetectedconf+1))/2);

peakscombined = sort(unique([peaksdetectednp;peaksdetectedpr]));
peaksindex = [1:length(peakscombined)];
peaksdetectedconf = find(diff(peakscombined)<=minint);
peaksdetectedconfs = unique(sort([peaksdetectedconf;peaksdetectedconf+1]));
peaks = sort(peakscombined(setdiff(peaksindex,peaksdetectedconfs)));


