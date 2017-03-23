function [y, f]=calcchanspectrum3(filebasemat,fileext,nchannels,channels,nFFT,nOverlap,WinLength,Fs,removeexp,wholefile,trialtypesbool)

if ~exist('trialtypesbool', 'var')
    trialtypesbool = [1  0  1  0  0   0   0   0   0   0   0   0  0  0  0  0];
                    %cr ir cl il crp irp clp ilp crb irb clb ilb xp rp lp dp
end
if ~exist('removeexp', 'var')
    removeexp = 0;
end
if ~exist('wholefile', 'var')
    wholefile = 0;
end

numtrials = 0; % for counting trials
nxp = 0;
ncr = 0;
nir = 0;
ncl = 0;
nil = 0;
ncrp = 0;
nirp = 0;
nclp = 0;
nilp = 0;
ncrb = 0;
nirb = 0;
nclb = 0;
nilb = 0;

[numfiles n] = size(filebasemat);

for i=1:numfiles
    
    fprintf('loading %s...\n',filebasemat(i,:));
    whldat = load([filebasemat(i,:) '.whl']);

    if wholefile == 0,
        load([filebasemat(i,:) '_whl_indexes.mat']);
        
        if exist([filebasemat(i,:) '_whl_indexes.mat'],'file'),
            fprintf('Including: ');
            load([filebasemat(i,:) '_whl_indexes.mat']);
            included = [];
            if trialtypesbool(1), 
                included = [included correctright];
                numtrials = numtrials + cr;
                ncr = ncr + cr;
                fprintf('cr n=%i, ', ncr);
            end
            if trialtypesbool(2), 
                included = [included incorrectright];
                numtrials = numtrials + ir;
                nir = nir + ir;
                fprintf('ir n=%i, ', nir);
            end
            if trialtypesbool(3), 
                included = [included correctleft];
                numtrials = numtrials + cl;
                ncl = ncl + cl;
                fprintf('cl n=%i, ', ncl);
            end
            if trialtypesbool(4), 
                included = [included incorrectleft];
                numtrials = numtrials + il;
                nil = nil + il;
                fprintf('il n=%i, ', nil);
            end
            if trialtypesbool(5), 
                included = [included pondercorrectright];
                numtrials = numtrials + crp;
                ncrp = ncrp + crp;
                fprintf('crp n=%i, ', ncrp);
            end
            if trialtypesbool(6), 
                included = [included ponderincorrectright];
                numtrials = numtrials + irp;
                nirp = nirp + irp;
                fprintf('irp n=%i, ', nirp);
            end
            if trialtypesbool(7), 
                included = [included pondercorrectleft];
                numtrials = numtrials + clp;
                nclp = nclp + clp;
                fprintf('clp n=%i, ', nclp);
            end
            if trialtypesbool(8), 
                included = [included ponderincorrectleft];
                numtrials = numtrials + ilp;
                nilp = nilp + ilp;
                fprintf('ilp n=%i, ', nilp);
            end
            if trialtypesbool(9), 
                included = [included badcorrectright];
                numtrials = numtrials + crb;
                ncrb = ncrb + crb;
                fprintf('crb n=%i, ', ncrb);
            end
            if trialtypesbool(10), 
                included = [included badincorrectright];
                numtrials = numtrials + irb;
                nirb = nirb + irb;
                fprintf('irb n=%i, ', nirb);
            end
            if trialtypesbool(11), 
                included = [included badcorrectleft];
                numtrials = numtrials + clb;
                nclb = nclb + clb;
                fprintf('clb n=%i, ', nclb);
            end
            if trialtypesbool(12), 
                included = [included badincorrectleft];
                numtrials = numtrials + ilb;
                nilb = nilb + ilb;
                fprintf('ilb n=%i, ', nilb);
            end
            if trialtypesbool(13), 
                included = [included exploration];
                numtrials = numtrials + xp;
                nxp = nxp + xp;
                fprintf('xp n=%i, ', nxp);
            end
            fprintf('total n=%i ', numtrials);
            includedwhldat = -1*ones(size(whldat));
            includedwhldat(included,:) = whldat(included,:);
            whldat = includedwhldat;
            if trialtypesbool(16)==0,
                if exist('dp','var'),
                    whldat(dp) = -1;
                    fprintf(' dp removed');
                end
            end
            fprintf('\n');
        else
            whl_indexes_file_not_found
        end
    else
        fprintf('All trial types included\n');
    end
    
    [whlm n] = size(whldat);
    
    eeg = bload([filebasemat(i,:) fileext],[nchannels inf],0,'int16');
    [n eegm] = size(eeg);
    factor = eegm/whlm;
        
    last = 1;
    while ~isempty(last),
        first = last(1)-1 + find(whldat(last(1):end,1)~=-1); 
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
return;
        