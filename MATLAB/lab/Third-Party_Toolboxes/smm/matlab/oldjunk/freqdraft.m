function avefreq = freqdraft(filebase,nchannels,channels,savefilt,saveminima)
maxfreq = 15;
samp = 1250;
minimadist = samp/maxfreq;
minamplitude = 0;
highcut = 35;
forder = 500;
fileext = '.eeg';

filename = [filebase fileext];
eegdata = bload(filename,[nchannels inf],0,'int16');
lowpassfilt = fir1(forder,highcut/samp*2,'low');
filtered_data = Filter0(lowpassfilt,eegdata');
[eegm n] = size(eegdata);
clear eegdata;

if savefilt,
    outname = [filebase '_' num2str(highcut) 'Hz' '_highcut' fileext '.filt'];
    fprintf('Saving %s\n', outname);
    bsave(outname,filtered_data','int16');
end

minima = cell(length(channels),1);
minimadiff = cell(length(channels),1);
for i=1:length(channels)
    minima{i} = LocalMinima(filtered_data(:,channels(i)),minimadist,minamplitude);
end
clear filtered_data;

if saveminima,
    outname = [filebase '_' num2str(highcut) 'Hz' '_highcut_' num2str(maxfreq) '_maxfreq' fileext '_minima.mat'];
    fprintf('Saving %s\n', outname);
    save(outname,'minima');
end

whldat = load([filebase '.whl']);
[whlm n] = size(whldat);

factor = eegm/whlm;
avefreq = zeros(whlm, length(channels));
for j=1:length(channels)
    for i=1:(whlm)
        minEegIndex = max(1,floor((i-1)*factor-factor/2));
        maxEegIndex = min(eegm,floor(i*factor-factor/2)-1);
        minimaIndexes = find(minima{j}>=minEegIndex & minima{j}<=maxEegIndex);
        minimadiff = diff(minima{j});
        avefreq(i,j) = mean(minimadiff(minimaIndexes));
    end
end
return


factor = eegm/whlm;
avefreq = zeros(whlm, length(channels));
for j=1:length(channels)
    minimadiff = (diff([minima40(1); minima40]) + diff([minima40; minima40(end)]))./2;
    for i=1:(whlm)
        eegindex = i*factor-factor/2;      
        minimaindex = find(abs(minima40-eegindex) == min(abs(minima40-eegindex)));
        avefreq(i) = minimadiff(minimaindex(1));
    end
end

