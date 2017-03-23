function smoothavefreq = freqdraft(filebase,nchannels,channel)
maxfreq = 15;
samp = 1250;
minimadist = samp/maxfreq;
minamplitude = 0;
highcut = 35;
forder = 500;
fileext = '.eeg';

filename = [filebase fileext];
eegdata = readmulti(filename,nchannels,channel);
lowpassfilt = fir1(forder,highcut/samp*2,'low');
filtered_data = Filter0(lowpassfilt,eegdata);
[eegm n] = size(eegdata);
clear eegdata;

minima = LocalMinima(filtered_data,minimadist,minamplitude);
clear filtered_data;

whldat = load([filebase '.whl']);
[whlm n] = size(whldat);


factor = eegm/whlm;
avefreq = zeros(whlm, 1);
minimadiff = (diff([minima(1); minima]) + diff([minima; minima(end)]))./2;
for i=1:(whlm)
    eegindex = i*factor-factor/2;      
    minimaindex = find(abs(minima-eegindex) == min(abs(minima-eegindex)));
    avefreq(i) = minimadiff(minimaindex(1));
end


if ~exist('smoothlen'),
    smoothlen = 13; %default
end

% filter a hanning window
hanfilter = hanning(smoothlen);
smoothavefreq = Filter0(hanfilter,avefreq);

