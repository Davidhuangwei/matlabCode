function FileInterp1D(FileBaseMat,fileExt,numChan,nShanks,nChansPerShank,interpFactor,interpMethod)
% function FileInterp1D(FileBaseMat,fileExt,numChan,nShanks,nChansPerShank,interpFactor,interpMethod)


nShanks = 6;
nChansPerShank = 16;
interpFactor = 4;
nInterpPerShank = (nChansPerShank*interpFactor) - ...
    mod(nChansPerShank*interpFactor-1,interpFactor);

for j=1:size(FileBaseMat,1)
    fileBase = FileBaseMat(j,:);
    fprintf('\nFile: %s\n',[fileBase fileExt]);
    
    interpFileName = [fileBase '_Interp' num2str(nInterpPerShank) 'PerShank' fileExt];

    interpFile = fopen(interpFileName,'w');
    if interpFile == -1,
        FILE_DIDNT_OPEN
    end

    bps = 2; % bytes per sample

    infoStruct = dir([fileBase fileExt]);
    numBytes = infoStruct.bytes;
    %Woffset = 0; % in samples
    readPos = 0; % in samples
    progressBar = 0;

    chunkSize = 2^floor(log2(30000000/numChan/bps)); % up to 30MB buffer (divisible by nchannels)
    
    interpEegChunk = zeros(nShanks*nInterpPerShank,chunkSize);

    readPos = 0;
    fprintf('#.................Interpolating..................#\n');

    while readPos < numBytes
        eegChunk = bload([fileBase fileExt],[numChan chunkSize],readPos,'int16');
        
        if numBytes - readPos > chunkSize*numChan*bps
            for i=1:nShanks
                if i==1
                    interpEegChunk((i-1)*nInterpPerShank+1:i*nInterpPerShank,:) = ...
                        interp1([1:interpFactor:nInterpPerShank-6*interpFactor nInterpPerShank-4*interpFactor:2*interpFactor:nInterpPerShank], ...
                        eegChunk([(i-1)*nChansPerShank+1:nChansPerShank-6 nChansPerShank-4:2:i*nChansPerShank],:), ...
                        1:nInterpPerShank, interpMethod);
                else
                    interpEegChunk((i-1)*nInterpPerShank+1:i*nInterpPerShank,:) = ...
                        interp1(1:interpFactor:nInterpPerShank, ...
                        eegChunk((i-1)*nChansPerShank+1:i*nChansPerShank,:), ...
                        1:nInterpPerShank, interpMethod);
                end
            end
        else
            interpEegChunk = zeros(nShanks*nInterpPerShank, (numBytes-readPos)/numChan/bps);
            for i=1:nShanks
                interpEegChunk((i-1)*nInterpPerShank+1:i*nInterpPerShank,:) = ...
                    interp1(1:interpFactor:nInterpPerShank, ...
                    eegChunk((i-1)*nChansPerShank+1:i*nChansPerShank,:), ...
                    1:nInterpPerShank, interpMethod);
            end
        end

        fwrite(interpFile, interpEegChunk,'int16');

        readPos = readPos + chunkSize*numChan*bps;
        
        while floor(50*(readPos-progressBar)/numBytes) > 0
            fprintf('#');
            progressBar = progressBar + floor(numBytes/50);
        end
    end

    fprintf('\n');
    
    if fclose(interpFile)
        FILE_DIDNT_CLOSE
    end
end

