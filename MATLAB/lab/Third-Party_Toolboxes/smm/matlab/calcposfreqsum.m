function [pos_sum, freq_sum] = calcposfreqsum(filebasemat,fileext,nchannels,channels,highcut,forder,maxfreq,tasktype,saveposfreqsum,savefilt,saveminima,savefreq,shortfilename,smoothlen,trialtypesbool,mazelocationsbool)
% function [pos_sum, pow_sum] = calcposfreqsumposfreqsum(filebasemat,nchannels,channels,lowband,highband,forder,avefilorder,tasktype,autosave,savedspow,trialtypesbool)
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

sampl = 1250; % eeg sampling rate
minimadist = sampl/maxfreq;
minamplitude = 0;
     
if ~exist('smoothlen', 'var'),
    smoothlen = 13; %default
end
if ~exist('shortfilename', 'var'),
    shortfilename = 0; %default
end

            
if ~exist('trialtypesbool','var')
    trialtypesbool = [1  0  1  0  0   0   0   0   0   0   0   0  0];
                    %cr ir cl il crp irp clp ilp crb irb clb ilb xp
end
if ~exist('mazelocationsbool','var')
    mazelocationsbool = [0  0  0  1  1  1   1   1   1];
                       %rp lp dp cp ca rca lca rra lra
end
if ~exist('saveposfreqsum','var')
    savepowsum = 0;
end
if ~exist('savefreq','var')
    savepow = 0;
end
if ~exist('saveminima','var')
    savedspow = 0;
end
if ~exist('savefilt','var')
    savefilt = 0;
end

videoxmax = 348;
videoymax = 240;

[numfiles n] = size(filebasemat);
pos_sum = zeros(ceil(videoxmax),ceil(videoymax));
freq_sum = zeros(ceil(videoxmax),ceil(videoymax), nchannels);

for i=1:numfiles

    filebase = filebasemat(i,:);
    fprintf('\nfile: %s\n', filebase);
    whldat = LoadMazeTrialTypes(filebase,trialtypesbool,mazelocationsbool);
    [whlm n] = size(whldat);

    fprintf('Calculating frequency ...\n')
    freqdat = zeros(whlm,length(channels));
    minima_cell = cell(1,length(channels));
    for j=1:length(channels)
        filename = [filebase fileext];
        fprintf('Channel %d, ', channels(j));
        eegdata = readmulti(filename,nchannels,channels(j));
        lowpassfilt = fir1(forder,highcut/sampl*2,'low');
        filtered_data = Filter0(lowpassfilt,eegdata);
        [eegm n] = size(eegdata);
        clear eegdata;
        
        minima = LocalMinima(filtered_data,minimadist,minamplitude);
        clear filtered_data;
        minima_cell{1,channels(j)} = minima;
        
        factor = eegm/whlm; % used to translate minima from eeg samples to whl samples
        avediff = zeros(whlm, 1);
        minimadiff = (diff([minima(1); minima]) + diff([minima; minima(end)]))./2; % average diff to nearby minima
        for k=1:(whlm) % for each point in whl file
            eegindex = k*factor-factor/2; % get corresponding point in eeg file
            minimaindex = find(abs(minima-eegindex) == min(abs(minima-eegindex))); % fcd B  ind the nearest minima
            avediff(k) = minimadiff(minimaindex(1)); % assign a minimadiff for that point in the whlfile
        end
        
        % smooth with a hanning window
        hanfilter = hanning(smoothlen);
        hanfilter = hanfilter./sum(hanfilter);
        smoothavediff = Filter0(hanfilter,avediff);
        clear avediff;
        freqdat(:,j) = sampl./smoothavediff;
        clear smoothavediff
    end
    if saveminima,
        outname = [filebase '_highcut_' num2str(highcut) 'Hz_maxfreq_' num2str(maxfreq) 'Hz_minima' fileext '.mat'];
        fprintf('\nSaving %s\n', outname);
        save(outname,'minima_cell');
    end
    if savefreq,     
        outname = [filebase '_highcut_' num2str(highcut) 'Hz_maxfreq_' num2str(maxfreq) 'Hz_freq' fileext '.mat'];
        fprintf('\nSaving %s\n', outname);
        save(outname,'freqdat');
    end
    
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

i = 'y';
if (saveposfreqsum == 0)
    while 1,
        i = input('/nSave to disk (yes/no)? ', 's');
        if strcmp(i,'yes') | strcmp(i,'no'), break; end
    end
end
if i(1) == 'n'
    counttrialtypes(filebasemat,1,trialtypesbool);
    return;
else
    trialsmat = counttrialtypes(filebasemat,1,trialtypesbool);     
    if shortfilename,
        outname = [tasktype '_' filebasemat(1,1) filebasemat(1,2:4) filebasemat(1,5) filebasemat(1,6:8) ...
                '-' filebasemat(end,1) filebasemat(end,2:4) filebasemat(end,5) filebasemat(end,6:8)...
                fileext '_pos_freq_' num2str(highcut) 'Hz_maxfreq_' num2str(maxfreq) 'Hz_sum.mat'];
    else
        outname = [tasktype '_' filebasemat(1,7) filebasemat(1,10:12) filebasemat(1,14) filebasemat(1,17:19) ...
                '-' filebasemat(end,7) filebasemat(end,10:12) filebasemat(end,14) filebasemat(end,17:19)...
                fileext '_pos_freq_highcut_' num2str(highcut) 'Hz_maxfreq_' num2str(maxfreq) 'Hz_sum.mat'];
    end
    fprintf('Saving %s\n', outname);
    save(outname,'pos_sum','freq_sum','trialsmat');
end    

return;