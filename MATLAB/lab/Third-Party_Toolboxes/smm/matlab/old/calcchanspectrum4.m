function [y, f]=calcchanspectrum4(filebasemat,fileext,nchannels,channels,nFFT,nOverlap,WinLength,Fs,removeexp,wholefile,trialtypesbool,mazelocationsbool)

if ~exist('trialtypesbool','var')
    trialtypesbool = [1  0  1  0  0   0   0   0   0   0   0   0  0];
                    %cr ir cl il crp irp clp ilp crb irb clb ilb xp
end
if ~exist('mazelocationsbool','var')
    mazelocationsbool = [0  0  0  1  1  1   1   1   1];
                       %rp lp dp cp ca rca lca rra lra
end
if ~exist('removeexp', 'var')
    removeexp = 0;
end
if ~exist('wholefile', 'var')
    wholefile = 0;
end

[numfiles n] = size(filebasemat);

for i=1:numfiles
    
    fprintf('loading %s...\n',filebasemat(i,:));

    if wholefile == 0,
        whldat = loadmazetrialtypes(filebasemat(i,:),trialtypesbool,mazelocationsbool);
    else
        fprintf('All trial types included\n');
    end
    
    [whlm n] = size(whldat);
    
    eeg = bload([filebasemat(i,:) fileext],[nchannels inf],0,'int16');
    [n eegm] = size(eeg);
    factor = eegm/whlm;
        
    last = 1;
    while ~isempty(last),
        first = last(1)-1 + find(whldat(last(1):end,1)~=-1); % find data segments of interest 
        if isempty(first), break; end
        last = first(1)-1 + find(whldat(first(1):end,1)==-1);
        if isempty(last), break; end
        
        eegfirst = ceil(first(1)*factor);
        eeglast = floor((last(1)-1)*factor);
        
        t1 = eeglast - eegfirst;
        
        for j=1:length(channels)
            [y1 f1] = spectrum(eeg(j,eegfirst:eeglast),nFFT,nOverlap,WinLength,Fs);

            if ~exist('y','var'),
                y = zeros(length(f1),length(channels));
                t = 0;
                f = f1;
            end
            
            if length(f1)~=length(f),
                there_is_problem_f1_f_not_equal
            end
            
            y(:,j) = (y(:,j)*t + y1(:,1)*t1)/(t+t1);
            
        end
        t = t + t1;
        %fprintf('t1=%d t=%d, ',t1,t);
    end
end
if removeexp,
    for i=1:length(channels)
        [beta,y(:,i)] = hajexpfit(f,log(y(:,i)));
    end
end
counttrialtypes(filebasemat,1,trialtypesbool);
return;
        