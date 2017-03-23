function [retY,dpY,caY,cpY,rewY,wpY,F]=CalcMazeRegionsSpectra3(taskType,fileBaseMat,fileExt,nChannels,Channels,Fs,nFFT,WinLength,NW,plotBool,removeExp,autoSave,fileNameFormat,trialTypesBool,mazeLocationsBool)
% function [y, F]=CalMazeRegionsSpectra(fileBaseMat,fileExt,nChannels,Channels,Fs,nFFT,WinLength,NW,plotBool,removeExp,trialTypesBool,mazeLocationsBool)
% calculates the average power spectra for each channel in each maze
% location using a single time window centered (in time) on each maze location
% uses mtcsd to calculate pspec

if ~exist('trialTypesBool','var') | isempty(trialTypesBool)
    trialTypesBool = [1  0  1  0  0   0   0   0   0   0   0   0  0];
                   % lr rr rl ll lrp rrp rlp llp lrb rrb rlb llb xp
end
if ~exist('mazeLocationsBool','var') | isempty(mazeLocationsBool)
    mazeLocationsBool = [1  1  1  1  1  1   1   1   1];
                      % rp lp dp cp ca rca lca rra lra
end
if ~exist('removeExp', 'var') | isempty(removeExp)
    removeExp = 0;
end
if ~exist('wholeFileBool', 'var') | isempty(wholeFileBool)
    wholeFileBool = 0;
end
if ~exist('plotBool', 'var') | isempty(plotBool)
   plotBool = 1;
end

if plotBool
    figure()
    clf
end

[numfiles n] = size(fileBaseMat);
numsamples = []; % tracks the size of the data chunk used for each p-spec calculation
for i=1:numfiles
    
    fprintf('\nloading %s...\n',fileBaseMat(i,:));

    whldat = LoadMazeTrialTypes(fileBaseMat(i,:),trialTypesBool,mazeLocationsBool);

    [whlm n] = size(whldat);
    
    if plotBool
        numSubplots = ceil(sqrt(numfiles));
        subplot(numSubplots,numSubplots,i);
        hold on
        plot(whldat(:,1),whldat(:,2),'.')
    end

    infoStruct = dir([fileBaseMat(i,:) fileExt]); % get size of eegfile
    bps = 2; % bytes per sample
    eegFileLen = infoStruct.bytes/nChannels/bps;

    eegWhlFactor = eegFileLen/whlm;
    fprintf('EEG file length =  %i...\n',eegFileLen);    
    
    %last = 1;
    
    tempMazeLocationsBool = [0  0  0  0  0  0   0   1   1];
                      % rp lp dp cp ca rca lca rra lra
    ra = LoadMazeTrialTypes(fileBaseMat(i,:),trialTypesBool,tempMazeLocationsBool);
    ra = ra(:,1);
    tempMazeLocationsBool = [0  0  1  0  0  0   0   0   0];
                      % rp lp dp cp ca rca lca rra lra
    dp = LoadMazeTrialTypes(fileBaseMat(i,:),trialTypesBool,tempMazeLocationsBool);
    dp = dp(:,1);
    tempMazeLocationsBool = [0  0  0  0  1  0   0   0   0];
                      % rp lp dp cp ca rca lca rra lra
    ca = LoadMazeTrialTypes(fileBaseMat(i,:),trialTypesBool,tempMazeLocationsBool);
    ca = ca(:,1);
    tempMazeLocationsBool = [0  0  0  1  0  0   0   0   0];
                      % rp lp dp cp ca rca lca rra lra
    cp = LoadMazeTrialTypes(fileBaseMat(i,:),trialTypesBool,tempMazeLocationsBool);
    cp = cp(:,1);
    tempMazeLocationsBool = [0  0  0  0  0  1   1   0   0];
                      % rp lp dp cp ca rca lca rra lra
    rw = LoadMazeTrialTypes(fileBaseMat(i,:),trialTypesBool,tempMazeLocationsBool);
    rw = rw(:,1);
    tempMazeLocationsBool = [1  1  0  0  0  0   0   0   0];
                      % rp lp dp cp ca rca lca rra lra
    wp = LoadMazeTrialTypes(fileBaseMat(i,:),trialTypesBool,tempMazeLocationsBool);
    wp = wp(:,1);
    
    %xp?
    mazeLocations = [ra dp ca cp rw wp];
    [m nLocations] = size(mazeLocations);
   
    currentLocation = 1;
    firstIndex = find(mazeLocations(1:end,currentLocation)~=-1);
    while (firstIndex < whlm),
        
        nextLocIndex = firstIndex(1)-1+find(mazeLocations(firstIndex(1):end,mod(currentLocation,nLocations)+1)~=-1);
        if isempty(nextLocIndex), break; end
        lastIndex = find(mazeLocations(1:nextLocIndex(1),currentLocation)~=-1);
        if isempty(lastIndex), break; end
        windowCenter = round(mean([lastIndex(end),firstIndex(1)]));
                  
        if whldat(windowCenter,1)~=-1,
            if plotBool == 1
                subplot(numSubplots,numSubplots,i);
                plot(whldat(firstIndex(1),1),whldat(firstIndex(1),2),'g.')
                plot(whldat(lastIndex(end),1),whldat(lastIndex(end),2),'g.')
                plot(whldat(windowCenter,1),whldat(windowCenter,2),'r.')
            end

            eegCenter = round(windowCenter*eegWhlFactor);

            eeg = bload([fileBaseMat(i,:) fileExt],[nChannels WinLength],max(0,(eegCenter-WinLength/2)*nChannels*2),'int16')';
            for j=1:length(Channels)

                %[y1 F1] = spectrum(eeg(:,j),nFFT,nOverlap,WinLength,Fs);
                calcMTCSD = 1;
                if calcMTCSD ==1
                     [y1 F1] = mtcsd(eeg(:,Channels(j)),nFFT,Fs,WinLength,0,NW);
                else
                    hamWin = hamming(WinLength);
                    F1 = [0:WinLength-1].*Fs./WinLength;
                    y1 = abs(fft(eeg(:,Channels(j)).*hamWin)).^2;
                end
                %keyboard
                if ~exist('y','var'),
                    y = zeros(length(F1),length(Channels),nLocations); % matrix holding power info for each channel for each freq for each maze location
                    t = zeros(nLocations,1); % total length of segments calculated so far
                    F = F1; % frequencies
                end

                if length(F1)~=length(F),
                    there_is_problem_f1_f_not_equal
                end
                
                y(:,Channels(j),currentLocation) = (y(:,Channels(j),currentLocation)*t(currentLocation) + y1(:,1)*WinLength)/(t(currentLocation)+WinLength); % average spectrum from current segment with previous segments
                
            end
            t(currentLocation) = t(currentLocation) + WinLength; % add length of current segment to total length
            fprintf('t(%i)=%d, ',currentLocation,t(currentLocation));
        end
        
        firstIndex = nextLocIndex;
        currentLocation = mod(currentLocation,nLocations)+1;
    end
end

if removeExp,
    for j=1:nLocations
        for i=1:length(Channels)
            [beta,y(:,Channels(i),j)] = hajexpfit(F,log(y(:,Channels(i),j)));
        end
    end
end

retY = y(:,:,1);
dpY = y(:,:,2);
caY = y(:,:,3);
cpY = y(:,:,4);
rewY = y(:,:,5);
wpY = y(:,:,6);

allY = y(:,:,:).*shiftdim(repmat(t,[1,length(F),length(Channels)]),1);
allY = sum(allY,3)./sum(t);

allNoPortsY = y(:,:,[1,3,4,5]).*shiftdim(repmat(t([1,3,4,5]),[1,length(F),length(Channels)]),1);
allNoPortsY = sum(allNoPortsY,3)./sum(t([1,3,4,5]));

i = 'y';
if (autoSave == 0)
    while 1,
        i = input('Save to disk (yes/no)? ', 's');
        if strcmp(i,'yes') | strcmp(i,'no'), break; end
    end
end
if i(1) == 'n'
    CountTrialTypes(fileBaseMat,1,trialTypesBool);
    return;
else
    trialsMat = CountTrialTypes(fileBaseMat,1,trialTypesBool);     
    if fileNameFormat == 1,
        outname = [taskType '_' fileBaseMat(1,1) fileBaseMat(1,2:4) fileBaseMat(1,5) fileBaseMat(1,6:8) ...
            '-' fileBaseMat(end,1) fileBaseMat(end,2:4) fileBaseMat(end,5) fileBaseMat(end,6:8)...
            fileExt '_MazeRegionsSpectra_Win' num2str(WinLength) '_NW' num2str(NW) '.mat'];
    end
    if fileNameFormat == 0,
        outname = [taskType '_' fileBaseMat(1,7) fileBaseMat(1,10:12) fileBaseMat(1,14) fileBaseMat(1,17:19) ...
            '-' fileBaseMat(end,7) fileBaseMat(end,10:12) fileBaseMat(end,14) fileBaseMat(end,17:19) ...
            fileExt '_MazeRegionsSpectra_Win' num2str(WinLength) '_NW' num2str(NW) '.mat'];
    end
    if fileNameFormat == 2,
                outname = [taskType '_' fileBaseMat(1,:) '-' fileBaseMat(end,8:10) ...
                    fileExt '_MazeRegionsSpectra_Win' num2str(WinLength) '_NW' num2str(NW) '.mat'];
    end
    fprintf('Saving %s\n', outname);
    save(outname,'F','caY','cpY','rewY','retY','wpY','dpY','allY','allNoPortsY','trialsMat');
end   

return;
        