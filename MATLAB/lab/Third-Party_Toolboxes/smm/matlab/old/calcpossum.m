function [pos_sum, freq_sum] = calcposfreqsum(filebasemat,fileext,nchannels,channels,highcut,forder,smoothlen,tasktype,savepowsum,savefilt,savepow,savedspow,trialtypesbool,mazelocationsbool)
% function [pos_sum, pow_sum] = calcpospowsum2(filebasemat,nchannels,channels,lowband,highband,forder,avefilorder,tasktype,autosave,savedspow,trialtypesbool)
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
% 'savepowsum' 1=save pow_sum pos_sum etc. matrices, default=ask before save
% 'savefilt' 1=save filtered_data  matrix to file, default=0
% 'savepow' 1=save power matrix to file, default=0
% 'savedspow' 1=save downsampled (to video sampling freq) power matrix, default=0
% 'trialtypesbool' is a matrix determining which trial types are analysed
%   default = [1  0  1  0  0   0   0   0   0   0   0   0  0];
%             cr ir cl il crp irp clp ilp crb irb clb ilb xp
% 'mazelocationsbool' is a matrix determining which maze locations are analysed
%   default = [0  0  0  1  1  1   1   1   1];
%             rp lp dp cp ca rca lca rra lra
%   trial types are designated using sortatertrialtypes.m or sortcircletrialtypes.m

maxfreq = 15;
samp = 1250;
minimadist = samp/maxfreq;
minamplitude = 0;
highcut = 35;
forder = 500;
fileext = '.eeg';
tasktype = 'alter';

sampl = 1250; % eeg sampling rate
     
if ~exist('smoothlen', 'var'),
    smoothlen = 13; %default
end

            
if ~exist('trialtypesbool')
    trialtypesbool = [1  0  1  0  0   0   0   0   0   0   0   0  0];
                    %cr ir cl il crp irp clp ilp crb irb clb ilb xp
end
if ~exist('mazelocationsbool')
    mazelocationsbool = [0  0  0  1  1  1   1   1   1];
                       %rp lp dp cp ca rca lca rra lra
end
if ~exist('savepowsum')
    savepowsum = 0;
end
if ~exist('savepow')
    savepow = 0;
end
if ~exist('savedspow')
    savedspow = 0;
end
if ~exist('savefilt')
    savefilt = 0;
end

videoxmax = 348;
videoymax = 240;

[numfiles n] = size(filebasemat);
pos_sum = zeros(ceil(videoxmax),ceil(videoymax));
freq_sum = zeros(ceil(videoxmax),ceil(videoymax), nchannels);

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
    whldat = loadmazetrialtypes(filebase,trialtypesbool,mazelocationsbool);
    

    
    filename = [filebase fileext];
    eegdata = readmulti(filename,nchannels,channel);
    lowpassfilt = fir1(forder,highcut/samp*2,'low');
    filtered_data = Filter0(lowpassfilt,eegdata);
    [eegm n] = size(eegdata);
    clear eegdata;
    
    minima = LocalMinima(filtered_data,minimadist,minamplitude);
    clear filtered_data;
    
    whldat = load([filebase '.whl']);
    [whlm n] = size(whldat);
    
    
    factor = eegm/whlm;
    avefreq = zeros(whlm, 1);
    minimadiff = (diff([minima(1); minima]) + diff([minima; minima(end)]))./2;
    for i=1:(whlm)
        eegindex = i*factor-factor/2;      
        minimaindex = find(abs(minima-eegindex) == min(abs(minima-eegindex)));
        avefreq(i) = minimadiff(minimaindex(1));
    end
    
    % filter with a hanning window
    hanfilter = hanning(smoothlen);
    freqdat = Filter0(hanfilter,avefreq);
    clear avefreq;

    
         
    notminusones = find(whldat(:,1)~=-1);
    whldat = ceil(whldat); % bin size = 1 pixel
    
    accum_pos = Accumulate(whldat(notminusones,1:2), 1); % accumulate the number of frames spent in each position
    [fa fb] = find(accum_pos);
    pos_sum(fa,fb) = pos_sum(fa,fb) + accum_pos(fa,fb); 
    
    [whlm n] = size(whldat);
    
    fprintf('\nCalculating spatial map of freq...\n');
    fprintf('Channels: ');   
    for j=1:length(channels)
        % accumulate freq info for each channel into a spatial map
        fprintf('%d,', channels(j));
        
        accum_freq = Accumulate(whldat(notminusones,1:2), freqdat(notminusones,j)); %accumulate the freq for each position
        freq_sum(fa,fb,channels(j)) = freq_sum(fa,fb,channels(j)) + accum_freq(fa,fb);
        
    end 
    clear freqdat;
end 

i == 'y'
if (savepowsum == 0)
    while 1,
        i = input('Save to disk (yes/no)? ', 's');
        if strcmp(i,'yes') | strcmp(i,'no'), break; end
    end
end
if i(1) == 'n'
    counttrialtypes(filebasemat,1,trialtypesbool);
    return;
else
    [ncr, nir, ncl, nil, ncrp, nirp, nclp, nilp, ncrb, nirb, nclb, nilb, nxp] = counttrialtypes(filebasemat,1,trialtypesbool);     
    numtrials = ncr + nir + ncl + nil + ncrp + nirp + nclp + nilp + ncrb + nirb + nclb + nilb + nxp;
    outname = [tasktype '_' filebasemat(1,7) filebasemat(1,10:12) filebasemat(1,14) filebasemat(1,17:19) ...
            '-' filebasemat(end,7) filebasemat(end,10:12) filebasemat(end,14) filebasemat(end,17:19)...
            fileext '_pos_pow' num2str(lowband) '-' num2str(highband) 'Hz_sum.mat'];
    fprintf('Saving %s\n', outname);
    save(outname,'pos_sum','freq_sum','numtrials',...
            'nxp','ncr', 'nir', 'ncl', 'nil', 'ncrp', 'nirp', 'nclp', 'nilp', 'ncrb', 'nirb', 'nclb', 'nilb');
end    



return;