function [y, f]=calcchanspectrum9(filebasemat,fileext,nchannels,channels,Fs,nFFT,WinLength,NW,plotBool,removeexp,wholeFileBool,trialTypesBool,mazeLocationsBool)
% function [y, f]=calcchanspectrum6(filebasemat,fileext,nchannels,channels,nFFT,nOverlap,WinLength,Fs,removeexp,wholeFileBool,trialTypesBool,mazeLocationsBool)
% uses bload to read data
% uses mtchglong to calculate pspec

if ~exist('trialTypesBool','var') | isempty(trialTypesBool)
    trialTypesBool = [1  0  1  0  0   0   0   0   0   0   0   0  0];
                   % lr rr rl ll lrp rrp rlp llp lrb rrb rlb llb xp
end
if ~exist('mazeLocationsBool','var') | isempty(mazeLocationsBool)
    mazeLocationsBool = [0  0  0  1  1  1   1   1   1];
                      % rp lp dp cp ca rca lca rra lra
end
if ~exist('removeexp', 'var') | isempty(removeexp)
    removeexp = 0;
end
if ~exist('wholeFileBool', 'var') | isempty(wholeFileBool)
    wholeFileBool = 0;
end
if ~exist('plotBool', 'var') | isempty(plotBool)
   plotBool = 1;
end

figure()
clf

[numfiles n] = size(filebasemat);
numsamples = []; % tracks the size of the data chunk used for each p-spec calculation
for i=1:numfiles
    
    fprintf('\nloading %s...\n',filebasemat(i,:));

    if wholeFileBool == 0,
        whldat = loadmazetrialtypes(filebasemat(i,:),trialTypesBool,mazeLocationsBool);
    else
        fprintf('All trial types included\n');
    end
    
    [whlm n] = size(whldat);
    
    numSubplots = ceil(sqrt(numfiles));
    subplot(numSubplots,numSubplots,i);
    hold on
    plot(whldat(:,1),whldat(:,2),'.')

    infoStruct = dir([filebasemat(i,:) fileext]); % get size of eegfile
    bps = 2; % bytes per sample
    eegFileLen = infoStruct.bytes/nchannels/bps;

    eegWhlFactor = eegFileLen/whlm;
    fprintf('EEG file length =  %i...\n',eegFileLen);    
    
    %last = 1;
    
    mazeLocationsBool = [0  0  0  0  0  0   0   1   1];
                      % rp lp dp cp ca rca lca rra lra
    ra = loadmazetrialtypes(filebasemat(i,:),trialTypesBool,mazeLocationsBool);
    ra = ra(:,1);
    mazeLocationsBool = [0  0  1  0  0  0   0   0   0];
                      % rp lp dp cp ca rca lca rra lra
    dp = loadmazetrialtypes(filebasemat(i,:),trialTypesBool,mazeLocationsBool);
    dp = dp(:,1);
    mazeLocationsBool = [0  0  0  0  1  0   0   0   0];
                      % rp lp dp cp ca rca lca rra lra
    ca = loadmazetrialtypes(filebasemat(i,:),trialTypesBool,mazeLocationsBool);
    ca = ca(:,1);
    mazeLocationsBool = [0  0  0  1  0  0   0   0   0];
                      % rp lp dp cp ca rca lca rra lra
    cp = loadmazetrialtypes(filebasemat(i,:),trialTypesBool,mazeLocationsBool);
    cp = cp(:,1);
    mazeLocationsBool = [0  0  0  0  0  1   1   0   0];
                      % rp lp dp cp ca rca lca rra lra
    rw = loadmazetrialtypes(filebasemat(i,:),trialTypesBool,mazeLocationsBool);
    rw = rw(:,1);
    mazeLocationsBool = [1  1  0  0  0  0   0   0   0];
                      % rp lp dp cp ca rca lca rra lra
    wp = loadmazetrialtypes(filebasemat(i,:),trialTypesBool,mazeLocationsBool);
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

            eeg = bload([filebasemat(i,:) fileext],[nchannels WinLength],max(0,(eegCenter-WinLength/2)*nchannels*2),'int16')';
            for j=1:length(channels)

                %[y1 f1] = spectrum(eeg(:,j),nFFT,nOverlap,WinLength,Fs);
                calcMTCSD = 1;
                if calcMTCSD ~=1
                     [y1 f1] = mtcsd(eeg(:,channels(j)),nFFT,Fs,WinLength,0,NW);
                else
                    hamWin = hamming(WinLength);
                    f1 = [0:WinLength-1].*Fs./WinLength;
                    y1 = abs(fft(eeg(:,channels(j)).*hamWin)).^2;
                end
                %keyboard
                if ~exist('y','var'),
                    y = zeros(length(f1),length(channels)); % matrix holding power info for each channel for each freq
                    t = 0; % total length of segments calculated so far
                    f = f1; % frequencies
                end

                if length(f1)~=length(f),
                    there_is_problem_f1_f_not_equal
                end

                y(:,j) = (y(:,j)*t + y1(:,1)*WinLength)/(t+WinLength); % average spectrum from current segment with previous segments

            end
            t = t + WinLength; % add length of current segment to total length
            fprintf('t1=%d t=%d, ',WinLength,t);
        end
        
        firstIndex = nextLocIndex;
        currentLocation = mod(currentLocation,nLocations)+1;
    end
end
if removeexp,
    for i=1:length(channels)
        [beta,y(:,i)] = hajexpfit(f,log(y(:,i)));
    end
end
counttrialtypes(filebasemat,1,trialTypesBool);
return;
        