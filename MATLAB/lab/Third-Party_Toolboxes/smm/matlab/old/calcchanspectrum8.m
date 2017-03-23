function [y, f]=calcchanspectrum6(filebasemat,fileext,nchannels,channels,nFFT,nOverlap,WinLength,Fs,NW,removeexp,wholeFileBool,trialTypesBool,mazeLocationsBool)
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
    
    infoStruct = dir([filebasemat(i,:) fileext]); % get size of eegfile
    bps = 2; % bytes per sample
    eegFileLen = infoStruct.bytes/nchannels/bps;

    factor = eegFileLen/whlm;
    fprintf('EEG file length =  %i...\n',eegFileLen);    
    
    last = 1;
    while ~isempty(last),
        % find a data segment in returned whl file
        first = last(1)-1 + find(whldat(last(1):end,1)~=-1); 
        if isempty(first), break; end
        last = first(1)-1 + find(whldat(first(1):end,1)==-1);
        if isempty(last), break; end
        
        % calculate location of corresponding segment in eeg file
        eegfirst = ceil(first(1)*factor);
        eeglast = floor((last(1)-1)*factor);
        numsamples = [numsamples eeglast-eegfirst]; % tracks the size of the data chunk used for each p-spec calculation
        if (eeglast-eegfirst) < WinLength
%            fprintf('oldlast=%i,oldfirst=%i\n',eeglast,eegfirst);
            neweeglast = eeglast+ceil((WinLength-(eeglast-eegfirst))/2);
            neweegfirst = eegfirst-floor((WinLength-(eeglast-eegfirst))/2);
            eegfirst = neweegfirst;
            eeglast = neweeglast;
%            fprintf('newlast=%i,newfirst=%i\n',eeglast,eegfirst);
        end
        
        t1 = eeglast - eegfirst; % length of current segment (used in averaging together multiple segments)

        eeg = bload([filebasemat(i,:) fileext],[nchannels (eeglast-eegfirst)],eegfirst*nchannels*2,'int16')';
        for j=1:length(channels)

            %[y1 f1] = spectrum(eeg(:,j),nFFT,nOverlap,WinLength,Fs);
            %[y1 f1] = mtcsd(eeg(:,j)',nFFT,Fs,WinLength,nOverlap,2);
            [y1 f1] = mtcsd(eeg(:,j),nFFT,Fs,WinLength,nOverlap,NW);
            %keyboard
            if ~exist('y','var'),
                y = zeros(length(f1),length(channels)); % matrix holding power info for each channel for each freq
                t = 0; % total length of segments calculated so far
                f = f1; % frequencies
            end
            
            if length(f1)~=length(f),
                there_is_problem_f1_f_not_equal
            end
            
            y(:,j) = (y(:,j)*t + y1(:,1)*t1)/(t+t1); % average spectrum from current segment with previous segments
            
        end
        t = t + t1; % add length of current segment to total length
        fprintf('t1=%d t=%d, ',t1,t);
    end
end
if removeexp,
    for i=1:length(channels)
        [beta,y(:,i)] = hajexpfit(f,log(y(:,i)));
    end
end
counttrialtypes(filebasemat,1,trialTypesBool);
fprintf('datachunk mean=%i STD=%i\n', mean(numsamples),std(numsamples));
return;
        