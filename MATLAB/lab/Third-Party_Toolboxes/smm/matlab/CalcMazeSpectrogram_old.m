function [sumNperPos,sumYFreqPos,f,channelNums] = CalcMazeSpectrogram(fileBaseMat,fileExt,taskType,Channels,WinLength,NW,trialsPerFile,autoSave,fileNameFormat,trialTypesBool,mazeLocationsBool)
% function [sumNperPos,sumYFreqPos,f,channelNums] = CalcMazeSpectrogram(fileBaseMat,fileExt,taskType,Channels,WinLength,NW,trialsPerFile,autoSave,fileNameFormat,trialTypesBool,mazeLocationsBool)
% Loads files containing power spectra for each point in time that
% corresponds to a position in the .whl file. These spectra are Accumulated
% for each position contained in a _LinearizedWhl.mat. The Accumulated
% power spectra can then be used to plot positional spectrograms.

if ~exist('trialTypesBool','var') | isempty(trialTypesBool)
    trialTypesBool = [1  0  1  0  0   0   0   0   0   0   0   0  1];
                   % lr rr rl ll lrp rrp rlp llp lrb rrb rlb llb xp
end
if ~exist('mazeLocationsBool','var') | isempty(mazeLocationsBool)
    mazeLocationsBool = [1  1  1  1  1  1   1   1   1];
                      % rp lp dp cp ca rca lca rra lra
end
 
if ~exist('autoSave','var') | isempty(autoSave)
    autoSave = 1;
end
 if ~exist('fileNameFormat','var') | isempty(fileNameFormat)
    fileNameFormat = 2;
end


maxMazeX = 800;
[nfiles junk] = size(fileBaseMat);

for h=1:nfiles
    load([fileBaseMat(h,:) '_LinearizedWhl.mat']);
    linearRLaverage = ceil(linearRLaverage); % bin size = 1 pixel

    whlDat = loadmazetrialtypes(fileBaseMat(h,:),trialTypesBool,mazeLocationsBool);
    
    counttrialtypes(fileBaseMat,1,trialTypesBool);
    
    for i=1:trialsPerFile:length(linearRLaverage)
        sizeOfChunk = min(trialsPerFile,length(linearRLaverage)-i+1);

        notMinusOnes = find(linearRLaverage(i:i-1+sizeOfChunk) > 0 & whlDat(i:i-1+sizeOfChunk,1) ~= -1);

        spectraFileName = [fileBaseMat(h,:) fileExt '_SpectraPerPos' num2str(i) '-' ...
            num2str(i-1+sizeOfChunk) '_Win' num2str(WinLength) '_NW' num2str(NW) '.mat'];
        fprintf('\nReading: %s',spectraFileName);
        load(spectraFileName);

        yFreqPos = zeros(length(f),maxMazeX,length(Channels));
        nPerPos = zeros(maxMazeX,1);
        
        nPerPos = Accumulate(linearRLaverage(notMinusOnes+i-1),1,maxMazeX);
        for j = 1:length(f)
            for k=1:length(Channels)
                yFreqPos(j,:,k) = Accumulate(linearRLaverage(notMinusOnes+i-1),yData(j,Channels(k),notMinusOnes),maxMazeX);
            end
        end
        if ~exist('sumYFreqPos','var')
            sumYFreqPos = zeros(length(f),maxMazeX,length(Channels));
            sumNperPos = zeros(maxMazeX,1);
        end

        sumNperPos = sumNperPos + nPerPos;
        sumYFreqPos = sumYFreqPos + yFreqPos;

        if max(max(max(sumYFreqPos))) >= 2^63
            fprintf('summation approaching 2^64 bit limit');
            keyboard
        end
    end
end

if exist('channelNums','var')
    channelNums = channelNums(Channels);
else
    channelNums = Channels;
end

if (autoSave == 0)
    while 1,
        i = input('Save to disk (yes/no)? ', 's');
        if strcmp(i,'yes') | strcmp(i,'no'), break; end
    end
end
if i(1) == 'n'
    counttrialtypes(fileBaseMat,1,trialTypesBool);
    return;
else
    trialsMat = counttrialtypes(fileBaseMat,1,trialTypesBool);     
    if fileNameFormat == 1,
        outname = [taskType '_' fileBaseMat(1,1) fileBaseMat(1,2:4) fileBaseMat(1,5) fileBaseMat(1,6:8) ...
            '-' fileBaseMat(end,1) fileBaseMat(end,2:4) fileBaseMat(end,5) fileBaseMat(end,6:8)...
            fileExt '_MazeSpectrogram_Win' num2str(WinLength) '_NW' num2str(NW) '.mat'];
    end
    if fileNameFormat == 0,
        outname = [taskType '_' fileBaseMat(1,7) fileBaseMat(1,10:12) fileBaseMat(1,14) fileBaseMat(1,17:19) ...
            '-' fileBaseMat(end,7) fileBaseMat(end,10:12) fileBaseMat(end,14) fileBaseMat(end,17:19) ...
            fileExt '_MazeSpectrogram_Win' num2str(WinLength) '_NW' num2str(NW) '.mat'];
    end
    if fileNameFormat == 2,
                outname = [taskType '_' fileBaseMat(1,:) '-' fileBaseMat(end,8:10) ...
                    fileExt '_MazeSpectrogram_Win' num2str(WinLength) '_NW' num2str(NW) '.mat'];
    end
    fprintf('Saving %s\n', outname);
    matlabVersion = version;
    if str2num(matlabVersion(1)) > 6
        save(outname,'-V6','sumNperPos','sumYFreqPos','f','channelNums','trialsMat','fileBaseMat');
    else
        save(outname,'sumNperPos','sumYFreqPos','f','channelNums','trialsMat','fileBaseMat');
    end
end
return

% plot(squeezenPerCell(j,k,:)))
% imagesc(squeeze(log10(aveYFreqPos./avenPerCell)));