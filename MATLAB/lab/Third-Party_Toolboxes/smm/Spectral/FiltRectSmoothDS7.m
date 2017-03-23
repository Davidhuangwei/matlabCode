function dspower = FiltRectSmoothDS7(fileBaseCell,fileext,nchannels,Fs,lowband,highband,filtWin,aveWin,savedspow)
%function dspower = FiltRectSmoothDS7(fileBaseCell,fileext,nchannels,Fs,lowband,highband,forder,avgfilorder,savedspow)
% Filters data for specified band using an FIR filter, adjusting for phase offset (filter0). 
% Data is then rectified, smoothed, and downsampled to sampling freqency of .whl file.
% Filtered data, downsampled data is optionally saved to file.

nFiles = length(fileBaseCell);
for j=1:nFiles
    fileBase = fileBaseCell{j};
    fprintf('\n%s\n',fileBase);
    cd(fileBase)
    sampl = Fs;

%     if ~exist('savefilt', 'var') | isempty(savefilt)
%         savefilt = 0;
%     end
%     if ~exist('savepow', 'var') | isempty(savepow)
%         savepow = 0;
%     end
    if ~exist('savedspow', 'var') | isempty(savedspow)
        savedspow = 0;
    end
    forder = odd(filtWin*Fs) - 1;
    firfiltb = fir1(forder,[lowband/sampl*2,highband/sampl*2]); % band-pass filter
    avgfilorder = odd(aveWin*Fs);
    avgfiltb = ones(avgfilorder,1)/avgfilorder; % smoothing filter

    bps = 2; % bytes per sample
    forderBuff = max([forder avgfilorder]);%*nchannels*bps;

    outBufferSize = 2^floor(log2(30000000/nchannels/bps)); % up to 30MB buffer (divisible by nchannels)

    %inname = [fileBase fileext];
    outFileBase = [fileBase '_' num2str(lowband) '-' num2str(highband)...
        'Hz_Win' num2str(filtWin,2) '_Ave' num2str(aveWin,2) fileext];
    filtFileName = [outFileBase '.filt'];
    filtfile = fopen(filtFileName,'w');
    if filtfile == -1,
        FILE_DIDNT_OPEN
    end
    dbPowFileName = [outFileBase '.100DBpow'];
    dbPowFile = fopen(dbPowFileName,'w');
    if dbPowFile == -1,
        FILE_DIDNT_OPEN
    end

    infoStruct = dir([fileBase fileext]);
    numSamples = infoStruct.bytes/nchannels/bps;
    %Woffset = 0; % in samples
    Roffset = forderBuff; % in samples
    readPos = 0; % in samples
    writePos = 0;
    progressBar = 0;

    % values set for first read
    Roffset = forderBuff; % in samples
    inBufferSize = outBufferSize + forderBuff; % outBufferSize + 1 forder buffer
    
    disp('#.............Filtering & Smoothing..............#\n');
    while readPos < numSamples,
        if numSamples-readPos < inBufferSize, % last segment
            inBufferSize = numSamples-readPos;
            outBufferSize = inBufferSize - forderBuff;
            Roffset = -forderBuff; % to avoid getting stuck not advancing readPos
        end

        eegdat = bload([fileBase fileext],[nchannels inBufferSize],readPos*nchannels*bps,'int16');

        filtered_data = Filter0(firfiltb, eegdat'); % filter
        DB100powerdat = 1000.*log10(Filter0(avgfiltb,filtered_data.^2)); % rectify & smooth

        fwrite(filtfile,filtered_data(writePos+1:writePos+outBufferSize,:)','int16');
        fwrite(dbPowFile,DB100powerdat(writePos+1:writePos+outBufferSize,:)','int16');

        inBufferSize = outBufferSize + 2 * forderBuff;
        readPos = readPos + outBufferSize - Roffset;
        writePos = forderBuff;
        Roffset = 0;
        while floor(50*(readPos-progressBar)/numSamples) > 0
            fprintf('#');
            progressBar = progressBar + floor(numSamples/50);
        end
    end
    fprintf('\n');

    if fclose(filtfile)
        FILE_DIDNT_CLOSE
    end
    fprintf('Saved %s\n',filtFileName);

    if fclose(dbPowFile)
        FILE_DIDNT_CLOSE
    end
    fprintf('Saved %s\n',dbPowFileName);


    if savedspow
        whldat = load([fileBase '.whl']);
        [whlm n] = size(whldat);
        dspower = zeros(whlm, nchannels);

        fprintf('Down-Sampling...\n');
        for i=1:nchannels
            fprintf('Channel %i: ',i);
            smoothpower = readmulti(dbPowFileName,nchannels,i);
            dspower(:,i) = avedownsample(smoothpower, whlm); % resample to the size of whldat
            clear smoothpower;
        end
        DBdsPowFileName = [outFileBase '.100DBdspow'];
        fprintf('\nSaving %s\n', DBdsPowFileName);
        bsave(DBdsPowFileName,dspower','int16');
    end
    cd ..
end
return