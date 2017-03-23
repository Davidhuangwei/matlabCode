function dspow = filtpowds(filebase,fileext,nchannels,lowband,highband,forder,avgfilorder,savefilt,savepow,savedspow,savememory)

sampl = 1250;

if ~exist('savefilt', 'var')
    savefilt = 0;
end
if ~exist('savepow', 'var')
    savepow = 0;
end
if ~exist('savedspow', 'var')
    savedspow = 0;
end
if ~exist('calcslow', 'var')
    savememory = 0;
end

inname = [filebase fileext];

firfiltb = fir1(forder,[lowband/sampl*2,highband/sampl*2]);
avgfiltb = ones(avgfilorder,1)/avgfilorder;

fprintf('Loading data and filtering...\n'); 
if calcslow,
    eegfileinfo = dir(inname); 
    eeglength = eegfileinfo.bytes/nchannels/2; % length in samples of eeg data per channel
    filtered_data = zeros(eeglength,nchannels);
    for i=1:nchannels 
        fprintf('Channel %d, ',channels(j));
        eegdata = readmulti(inname,nchannels,i);
        filtered_data = [filtered_data Filter0(firfiltb,eegdata)]; % filtering
        filtered_data = Filter0(firfiltb,thresholdbuffer
    end
    
thresholdbuffer = bload(inname, [nchannels inf],0, 'int16');
filtered_data = Filter0(firfiltb,thresholdbuffer'); % filtering
clear thresholdbuffer

if savefilt,
    outname = [filebase '_' num2str(lowband) '-' num2str(highband) 'Hz' fileext '.filt'];
    fprintf('Saving %s\n', outname);
    bsave(outname,filtered_data','int16');
end

if savepow,
    power = filtered_data.^2; 
    clear filtered_data;
    smoothpower = Filter0(avgfiltb,power); % averaging & 
    clear power;
    
    outname = [filebase '_' num2str(lowband) '-' num2str(highband) 'Hz' fileext '.100DBpow'];
    fprintf('Saving %s\n', outname);
    bsave(outname,1000*log10(smoothpower'),'int16');
end