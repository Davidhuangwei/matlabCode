function dspower = filtrectsmoothds2(filebase,fileext,nchannels,lowband,highband,forder,avgfilorder,savefilt,savepow,savedspow,savememory)

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

firfiltb = fir1(forder,[lowband/sampl*2,highband/sampl*2]); % band-pass filter
avgfiltb = ones(avgfilorder,1)/avgfilorder; % smoothing filter


bps = 2; % bytes per sample
forderBuff = max([forder avgfilorder]);%*nchannels*bps;

outBufferSize = 2^floor(log2(6000000/nchannels/bps)) % up to 60MB buffer (divisible by nchannels)

%inname = [filebase fileext];

filtfile = fopen('test.filt','w');
if filtfile == -1,
    FILE_DIDNT_OPEN
end

infoStruct = dir([filebase fileext]);
numSamples = infoStruct.bytes/nchannels/bps 
Woffset = 0; % in samples
Roffset = forderBuff; % in samples
readpos = 0; % in samples
inBufferSize = outBufferSize + forderBuff % outBufferSize + 1 forder buffer

while readpos < numSamples,
    if numSamples-readpos < inBufferSize,
        inBufferSize = numSamples-readpos;
        outBufferSize = inBufferSize - forderBuff;
        Roffset = -forderBuff
    end
    fprintf('Loading data... \n'); 
    eegdat = bload([filebase fileext],[nchannels inBufferSize],readpos*nchannels*bps,'int16');
    fprintf('filtering...\n'); 
    filtered_data = Filter0(firfiltb, eegdat');
    
    fprintf('writing...\n'); 
    fwrite(filtfile,filtered_data(Woffset+1:outBufferSize+Woffset,:)','int16');
    
    inBufferSize = outBufferSize + 2 * forderBuff;
    readpos = readpos + outBufferSize - Roffset
    Woffset = forderBuff;
    Roffset = 0;
end

if fclose(filtfile)
       FILE_DIDNT_CLOSE
end

dspow = 1;

return

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
    power = zeros(size(filtered_data));
    power = filtered_data(:,i).^2;
    clear filtered_data;
    smoothpower = zeros(size(power));
    fprintf('Channels: '); 
    for i=1:nchannels
        fprintf('%d, ', i);
        smoothpower(:,i) = Filter0(avgfiltb,power); % rectify & smooth
    end
    clear power;
else
    smoothpower = Filter0(avgfiltb,filtered_data.^2); % rectify & smooth
    clear filtered_data;
end

whldat = load([filebase '.whl']);
[whlm n] = size(whldat);
dspower = zeros(whlm, nchannels);
for i=1:nchannels
    dspower(:,i) = avedownsample(smoothpower(:,i), whlm); % resample to the size of whldat
end

fprintf('Calculating log10...\n');
if savepow,
    if savememory,
        DB100power = zeros(size(smoothpower));
        fprintf('Channels: ');
        for i=1:nchannels
            fprintf('%d, ', i);
            DB100powerdat(:,i) = log10(smoothpower(:,1)); % calculate decibels*100 (for viewing with standard software)
            smoothpower(:,1) = [];
        end
        clear smoothpower;
        for i=1:nchannels
            DB100powerdat(:,i) = 1000.*DB100powerdat(:,i); % calculate decibels*100 (for viewing with standard software)
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
