function calcpowerbat(filebasemat,numchannels,channels,DBconversion)
chan1 = channels(1:floor(length(channels)/2));
chan2 = channels((floor(length(channels)/2)+1):end);

[numfiles n] = size(filebasemat);
for i=1:numfiles
    filebase = filebasemat(i,:);
    inname = [filebase '.eeg'];
    thetapower = happyfilter(inname,numchannels,chan1,6,14,600,601,DBconversion);
    thetapower2 = happyfilter(inname,numchannels,chan2,6,14,600,601,DBconversion);
    thetapower = [thetapower thetapower2];
    clear thetapower2;
    if (DBconversion),
        outfilename = [filebase '_6-14_Hz_DB_sm_power.mat']
    else
        outfilename = [filebase '_6-14_Hz_sm_power.mat']
    end
    save(outfilename, 'thetapower');
    clear thetapower;
end

for i=1:numfiles
    filebase = filebasemat(i,:);
    inname = [filebase '.eeg'];
    gammapower = happyfilter(inname,numchannels,chan1,30,80,300,301,DBconversion);
    gammapower2 = happyfilter(inname,numchannels,chan2,30,80,300,301,DBconversion);
    gammapower = [gammapower1 gammapower2];
    clear gammapower2;
    if (DBconversion),
        outfilename = [filebase '_30-80_Hz_DB_sm_power.mat']
    else
        outfilename = [filebase '_30-80_Hz_sm_power.mat']
    end
    save(outfilename, 'gammapower');
    clear gammapower;
end
