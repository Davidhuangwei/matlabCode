function dspower = filtrectsmoothds3(filebase,fileext,nchannels,lowband,highband,forder,avgfilorder,savefilt,savepow,savedspow)
%function dspower = filtrectsmoothds3(filebase,fileext,nchannels,lowband,highband,forder,avgfilorder,savefilt,savepow,savedspow)

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

outBufferSize = 2^floor(log2(6000000/nchannels/bps)); % up to 60MB buffer (divisible by nchannels)

%inname = [filebase fileext];
filtFileName = [filebase '_' num2str(lowband) '-' num2str(highband) 'Hz' fileext '.filt'];
filtfile = fopen([filebase '_' num2str(lowband) '-' num2str(highband) 'Hz' fileext '.filt'],'w');
if filtfile == -1,
    FILE_DIDNT_OPEN
end
dbPowFileName = [filebase '_' num2str(lowband) '-' num2str(highband) 'Hz' fileext '.100DBpow'];
dbPowFile = fopen([filebase '_' num2str(lowband) '-' num2str(highband) 'Hz' fileext '.100DBpow'],'w');
if dbPowFile == -1,
    FILE_DIDNT_OPEN
end

infoStruct = dir([filebase fileext]);
numSamples = infoStruct.bytes/nchannels/bps; 
%Woffset = 0; % in samples
Roffset = forderBuff; % in samples
readPos = 0; % in samples
writePos = 0;
progressBar = 0;

% values set for first read
Roffset = forderBuff; % in samples
inBufferSize = outBufferSize + forderBuff; % outBufferSize + 1 forder buffer

fprintf('\n#.............Filtering & Smoothing..............#\n');
while readPos < numSamples,
    while floor(50*(readPos-progressBar)/numSamples) > 0
        fprintf('#');
        progressBar = progressBar + floor(numSamples/50);
    end
    if numSamples-readPos < inBufferSize, % last segment
        inBufferSize = numSamples-readPos;
        outBufferSize = inBufferSize - forderBuff;
        Roffset = -forderBuff; % to avoid getting stuck not advancing readPos
    end

    eegdat = bload([filebase fileext],[nchannels inBufferSize],readPos*nchannels*bps,'int16');
    
    filtered_data = Filter0(firfiltb, eegdat'); % filter
    DB100powerdat = 1000.*log10(Filter0(avgfiltb,filtered_data.^2)); % rectify & smooth

    fwrite(filtfile,filtered_data(writePos+1:writePos+outBufferSize,:)','int16');
    fwrite(dbPowFile,DB100powerdat(writePos+1:writePos+outBufferSize,:)','int16');
    
    inBufferSize = outBufferSize + 2 * forderBuff;
    readPos = readPos + outBufferSize - Roffset;
    writePos = forderBuff;
    Roffset = 0;
end
fprintf('#\n');

if fclose(filtfile)
       FILE_DIDNT_CLOSE
end
fprintf('Saved %s\n',filtFileName);

if fclose(dbPowFile)
       FILE_DIDNT_CLOSE
end
fprintf('Saved %s\n',dbPowFileName);


if savedspow
    whldat = load([filebase '.whl']);
    [whlm n] = size(whldat);
    dspower = zeros(whlm, nchannels);

    fprintf('Down-Sampling...\n');
    for i=1:nchannels
        fprintf('Channel %i: ',i);
        smoothpower = readmulti(dbPowFileName,nchannels,i);
        dspower(:,i) = avedownsample(smoothpower, whlm); % resample to the size of whldat
        clear smoothpower;
    end
    DBdsPowFileName = [filebase '_' num2str(lowband) '-' num2str(highband) 'Hz' fileext '.100DBdspow'];
    fprintf('\nSaving %s\n', DBdsPowFileName);
    bsave(DBdsPowFileName,dspower','int16');
end


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
