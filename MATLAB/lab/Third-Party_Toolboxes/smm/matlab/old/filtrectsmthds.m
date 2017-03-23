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
if ~exist('savememory', 'var')
    savememory = 0;
end

inname = [filebase fileext];

firfiltb = fir1(forder,[lowband/sampl*2,highband/sampl*2]); % band-pass filter
avgfiltb = ones(avgfilorder,1)/avgfilorder; % smoothing filter

fprintf('Loading data and filtering...\n'); 
if savememory,
    eegfileinfo = dir(inname); 
    eeglength = eegfileinfo.bytes/nchannels/2; % length of eeg data in samples per channel
    filtered_data = zeros(eeglength,nchannels);
    for i=1:nchannels 
        fprintf('Channel %d, ',i);
        filtered_data(:,i) = Filter0(firfiltb,readmulti(inname,nchannels,i)); % loading & filtering 1 channel at a time
    end
else
    filtered_data = Filter0(firfiltb, bload(inname, [nchannels inf], 0, 'int16')'); % filtering & filtering all channels
end

if savefilt,
    outname = [filebase '_' num2str(lowband) '-' num2str(highband) 'Hz' fileext '.filt'];
    fprintf('Saving %s\n', outname);
    bsave(outname,filtered_data','int16');
end
    
fprintf('Smoothing...\n');
if savememory,
    smoothpower = zeros(size(filtered_data));
    fprintf('Channels: '); 
    for i=1:nchannels
        fprintf('%d, ', i);
        smoothpower(:,i) = Filter0(avgfiltb,filtered_data(:,i).^2); % rectify & smooth
    end
else
    smoothpower = Filter0(avgfiltb,filtered_data.^2); % rectify & smooth
end
clear filtered_data;

whldat = load([filebase '.whl']);
for i=1:nchannels
    dspower(:,i) = avedownsize(smoothpower(:,i), whldat); % resample to the size of whldat
end

if savepow,
    if savememory,
        DB100power = zeros(size(smoothpower));
        for i=1:nchannels
            DB100powerdat(:,i) = 1000*log10(smoothpower(:,i)); % calculate decibels*100 (for viewing with standard software)
        end
    else
        DB100powerdat = 1000*log10(smoothpower);
    end
    clear smoothpower;
    outname = [filebase '_' num2str(lowband) '-' num2str(highband) 'Hz' fileext '.100DBpow'];
    fprintf('Saving %s\n', outname);
    bsave(outname,DB100powerdat','int16');
    clear DB100powerdat;
end

if savedspow,
    outname = [filebase '_' num2str(lowband) '-' num2str(highband) 'Hz' fileext '.100DBdspow'];
    fprintf('\nSaving %s\n', outname);
    bsave(outname,1000*log10(dspower'),'int16');
end

return
