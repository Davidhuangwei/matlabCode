function [pos_sum pow_sum] = calcpospowsum(filebasemat,nchannels,channels,lowband,highband,forder,avgfilorder,autosave,trialtypesbool)
% function [pow_sum pos_sum] = calcpowsumpossum(filebasemat,nchannels,channels,lowband,highband,forder,avgfilorder)
%
% 'pos_sum' is a 2D matrix containing the number of video frames the animals spent in each spatial position
% 'pow_sum' is a 2D by nchannels matrix containing the sum of the power in the given freq band for each position
% 'filebasemat' has a list of filebase names in each row of a 2D matrix
% 'nchannels' is the number of channels in the filebase.eeg files
% 'channels' is a 1 by n matrix containing the channel numbers to be analysed
% 'lowband' is the low cut of the freq band of interest
% 'highband' is the high cut of the freq band of interest
% 'forder' is the resolution of the filter window -- must be even
% 'avgfilorder' is the size of the smoothing window applied after filtering & rectification
% 'trialtypesbool' is a matrix determining which trial types are analysed
%   default = [1  0  1  0  0   0   0   0   0   0   0   0  0];
%             cr ir cl il crp irp clp ilp crb irb clb ilb xp
%   trial types are designated using sortatertrialtypes.m or sortcircletrialtypes.m
             
if ~exist('trialtypesbool')
    trialtypesbool = [1  0  1  0  0   0   0   0   0   0   0   0  0];
                    %cr ir cl il crp irp clp ilp crb irb clb ilb xp
end

videoxmax = 348;
videoymax = 240;
DBconversion = 0; % convert power to decibells after filtering & temporal smoothing

[numfiles n] = size(filebasemat);
pos_sum = zeros(ceil(videoxmax),ceil(videoymax));
pow_sum = zeros(ceil(videoxmax),ceil(videoymax), nchannels);

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

for i=1:numfiles

    filebase = filebasemat(i,:);
    fprintf('\nFile: %s,\n',filebase);
    whldat = load([filebase '.whl']);
    inname = [filebase '.eeg'];
    if exist([filebase '_whl_indexes.mat'],'file'),
        fprintf('Including: ');
        load([filebase '_whl_indexes.mat']);
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
        fprintf('total n=%i\n', numtrials);
        includedwhldat = -1*ones(size(whldat));
        includedwhldat(included,:) = whldat(included,:);
        whldat = includedwhldat;
    else
        fprintf('All trial types included\n');
    end
    if exist([filebase '_' num2str(lowband) '-' num2str(highband) '_Hz_sm_power.mat'],'file'),
        fprintf('Loading %s,\n',[filebase '_' num2str(lowband) '-' num2str(highband) '_Hz_sm_power.mat']);
        load([filebase '_' num2str(lowband) '-' num2str(highband) '_Hz_sm_power.mat']);
        if (lowband==6 & highband==14)
            powerdat = thetapower1;
            clear thetapower1;
        end
        if (lowband==30 & highband==80)
            powerdat = gammapower1;
            clear gammapower1;
        end
        
    else
        chan1 = channels(1:floor(length(channels)/2)); % break up number of channels for filtering to ease memory requirements
        chan2 = channels((floor(length(channels)/2)+1):end);
        powerdat = happyfilter(inname,numchannels,chan1,lowband,highband,forder,avefilorder,DBconversion);
        powerdat2 = happyfilter(inname,numchannels,chan2,lowband,highband,forder,avefilorder,DBconversion);
        powerdat = [powerdat powerdat2];
        clear powerdat2;
    end
      
    notminusones = find(whldat(:,1)~=-1);
    whldat = ceil(whldat); % bin size = 1 pixel
    
    accum_pos = Accumulate(whldat(notminusones,1:2), 1); % accumulate the number of frames spent in each position
    [fa fb] = find(accum_pos);
    pos_sum(fa,fb) = pos_sum(fa,fb) + accum_pos(fa,fb); 
    
    [whlm n] = size(whldat);
    avepowerdat = zeros(whlm, length(channels));
    
    fprintf('Channels: ');   
    for j=1:length(channels)
        avepowerdat(:,j) = avedownsize(powerdat(:,j), whldat); % average powdat to the size of whldat

        % accumulate power info for each channel into a spatial map
        fprintf('%d,', channels(j));
        
        accum_pow = Accumulate(whldat(notminusones,1:2), avepowerdat(notminusones,j)); %accumulate the power for each position
        pow_sum(fa,fb,channels(j)) = pow_sum(fa,fb,channels(j)) + accum_pow(fa,fb);
        
    end
    clear powerdat;
    clear avepowerdat;
end 

i == 'y'
if (~exist('autosave') | autosave == 0)
    while 1,
        i = input('Save to disk (yes/no)? ', 's');
        if strcmp(i,'yes') | strcmp(i,'no'), break; end
    end
end
if i(1) == 'n'
    return;
else
    outname = [filebasemat(1,7) filebasemat(1,10:12) filebasemat(1,14) filebasemat(1,17:19) ...
            'pos_pow' num2str(lowband) '-' num2str(highband) 'Hz_sum.mat'];
    fprintf('Saving %s\n', outname);
    save(outname,'pos_sum','pow_sum','numtrials',...
        'nxp','ncr', 'nir', 'ncl', 'nil', 'ncrp', 'nirp', 'nclp', 'nilp', 'ncrb', 'nirb', 'nclb', 'nilb');
end
return;