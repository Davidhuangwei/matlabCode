function interpolated = interpolatebadchan2(fileBase,fileExt,chanMat,badChans)

outDir = ['../processed/' fileBase '/'];

linintpFile = fopen([filebase '_linintp' fileExt],'w');
if linintpFile == -1,
    FILE_DIDNT_OPEN
end

inputfile = [filebase fileExt]
outputfile = linintpFile

nchannels = 97;
bps = 2; % bytes per sample

infoStruct = dir([filebase fileExt]);
numSamples = infoStruct.bytes/nchannels/bps;

chunkSize = 2^floor(log2(6000000/nchannels/bps)); % up to 60MB buffer (divisible by nchannels)

for i=0:chunkSize:numSamples-1

    interpolated = bload([filebase fileExt],[97 chunkSize],i*nchannels*bps,'int16');

    if filebase(1,1:6) == 'sm9603'
        interpolated(16,:) = interpolated(15,:);
        interpolated(81,:) = interpolated(82,:);
        bscnoe =  [21 23 25 27 29 31 55 69 71 73 86 93]; % bad single channels not on end of shank
        for i=1:length(bscnoe)
            interpolated(bscnoe(i),:) = (interpolated(bscnoe(i)-1,:) + interpolated(bscnoe(i)+1,:))/2;
        end
        tempchan = (interpolated(74,:) + interpolated(77,:))/2;
        interpolated(75,:) = (tempchan + interpolated(74,:))/2;
        interpolated(76,:) = (tempchan + interpolated(77,:))/2;
    end
    if filebase(1,1:6) == 'sm9608'
        interpolated(80,:) = interpolated(79,:);
        interpolated(81,:) = interpolated(82,:);
        bscnoe =  [54 73 84 86 89 91]; % bad single channels not on end of shank
        for i=1:length(bscnoe)
            interpolated(bscnoe(i),:) = (interpolated(bscnoe(i)-1,:) + interpolated(bscnoe(i)+1,:))/2;
        end
        tempchan = (interpolated(69,:) + interpolated(72,:))/2;
        interpolated(70,:) = (tempchan + interpolated(69,:))/2;
        interpolated(71,:) = (tempchan + interpolated(72,:))/2;
        tempchan = (interpolated(74,:) + interpolated(77,:))/2;
        interpolated(75,:) = (tempchan + interpolated(74,:))/2;
        interpolated(76,:) = (tempchan + interpolated(77,:))/2;
        interpolated(94,:) = (interpolated(92,:) + interpolated(96,:))/2;
        interpolated(93,:) = (interpolated(94,:) + interpolated(92,:))/2;
        interpolated(95,:) = (interpolated(94,:) + interpolated(96,:))/2;
    end
        
        
    fwrite(linintpFile,interpolated,'int16');


end

if fclose(linintpFile)
       FILE_DIDNT_CLOSE
end
return


