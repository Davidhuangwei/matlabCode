function [y, f]=calcchanspectrum5(filebasemat,fileext,nchannels,channels,nFFT,nOverlap,WinLength,Fs,removeexp,wholeFileBool,trialTypesBool,mazeLocationsBool)
%  can handle large files to save memory at expense of speed
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

for i=1:numfiles
    
    fprintf('loading %s...\n',filebasemat(i,:));

    if wholeFileBool == 0,
        whldat = loadmazetrialtypes(filebasemat(i,:),trialTypesBool,mazeLocationsBool);
    else
        fprintf('All trial types included\n');
    end
    
    [whlm n] = size(whldat);
    
    last = 1;
    while ~isempty(last),
        % find a data segment in returned whl file
        first = last(1)-1 + find(whldat(last(1):end,1)~=-1); 
        if isempty(first), break; end
        last = first(1)-1 + find(whldat(first(1):end,1)==-1);
        if isempty(last), break; end
 %           fprintf('  
        for j=1:length(channels)
            eeg = readmulti([filebasemat(i,:) fileext],nchannels,channels(j));
            % eeg = bload([filebasemat(i,:) fileext],[97 
            eegm = length(eeg);
            factor = eegm/whlm;
            % calculate location of corresponding segment in eeg file
            eegfirst = ceil(first(1)*factor); 
            eeglast = floor((last(1)-1)*factor);
            
            t1 = eeglast - eegfirst; % length of current segment (used in averaging together multiple segments)

            [y1 f1] = spectrum(eeg(eegfirst:eeglast),nFFT,nOverlap,WinLength,Fs);

            if ~exist('y','var'),
                y = zeros(length(f1),length(channels)); % matrix holding power info for each channel for each freq
                t = 0; % total length of segments calculated so far
                f = f1; % frequencies
            end
            
            if length(f1)~=length(f),
                there_is_problem_f1_f_not_equal
            end
            
            y(:,j) = (y(:,j)*t + y1(:,1)*t1)/(t+t1); % average spectrum from current segment with 
            
        end
        t = t + t1; % add length of current segment to total length
        %fprintf('t1=%d t=%d, ',t1,t);
    end
end
if removeexp,
    for i=1:length(channels)
        [beta,y(:,i)] = hajexpfit(f,log(y(:,i)));
    end
end
counttrialtypes(filebasemat,1,trialTypesBool);
return;
        