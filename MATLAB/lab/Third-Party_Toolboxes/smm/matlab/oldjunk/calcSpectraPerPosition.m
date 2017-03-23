function calcSpectraPerPosition(fileBaseMat,fileext,nchannels,channelNums,Fs,nFFT,WinLength,NW,pointsPerFile)
% function calcSpectraPerPosition(filebase,fileext,nchannels,channelNums,Fs,nFFT,WinLength,NW,pointsPerFile)
% For each time point in the .whl file a surrounding window from the .eeg
% file is used to calculate a power spectrum with the multi-taper method. 
% The output is saved in several consecutive files whos names includes the 
% time range of .whl file to which the spectra correspond.
% INPUT:
% Fs = sampling rate
% nFFT = size of zero padding
% WinLength = size of window used to calculate spectrum
% NW = determines number of tapers (NW*2-1 = tapers)
% pointsPerFile = number of time points contained in each output file
% OUTPUT File contains:
% yData = (#Frequencies, #channelNums, pointsPerFile)
% f = frequencies
% channelNums = which channels for which spectra were calculated 

if ~exist('pointsPerFile', 'var') | isempty(pointsPerFile)                                                 
    pointsPerFile = 1000;                                                                                  
end                                                                                                        

bps = 2; % bytes per sample                                                                                

for k=1:size(fileBaseMat,1)
    filebase = fileBaseMat(k,:);
    
    whldat = load([filebase '.whl']);
    [whlm n] = size(whldat);

    infoStruct = dir([filebase fileext]);
    eegm = infoStruct.bytes/nchannels/bps;

    eegWhlFactor = eegm/whlm;
    yData = [];
    for i=1:whlm
        eegData = bload([filebase fileext],[nchannels WinLength],max(0,nchannels*round(eegWhlFactor*i-WinLength/2)*bps),'int16');
        yChan = [];
        for j=1:length(channelNums)
            [y f] = mtcsd(eegData(channelNums(j),:),nFFT,Fs,WinLength,0,NW);
            f = f(find(f<150));
            y = y(1:length(f));
            yChan = [yChan y];
        end
        yData = cat(3,yData,yChan);
        if mod(i,pointsPerFile) == 0;
            outFileName = [filebase fileext '_SpectraPerPos'  num2str(i+1-pointsPerFile) '-' ...
                num2str(i) '_Win' num2str(WinLength) '_NW' num2str(NW) '.mat'];
            fprintf('\nSaving %s', outFileName);
            save(outFileName, 'yData', 'f', 'channelNums');
            yData = [];
        end
    end
    outFileName = [filebase fileext '_SpectraPerPos'  num2str(whlm+1-mod(whlm,pointsPerFile)) '-' ...
        num2str(whlm) '_Win' num2str(WinLength) '_NW' num2str(NW) '.mat'];
    fprintf('\nSaving %s', outFileName);
    save(outFileName, 'yData', 'f', 'channelNums');
end