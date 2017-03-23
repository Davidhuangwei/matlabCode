function [pos_sum, pow_sum] = calcpospowsum2(filebasemat,fileext,nchannels,channels,lowband,highband,forder,avgfilorder,tasktype,savepowsum,savefilt,savepow,savedspow,shortfilename,savememory,trialtypesbool,mazelocationsbool)
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


sampl = 1250; % eeg sampling rate
             
if ~exist('trialtypesbool','var')
    trialtypesbool = [1  0  1  0  0   0   0   0   0   0   0   0  0];
                    %cr ir cl il crp irp clp ilp crb irb clb ilb xp
end
if ~exist('mazelocationsbool','var')
    mazelocationsbool = [0  0  0  1  1  1   1   1   1];
                       %rp lp dp cp ca rca lca rra lra
end
if ~exist('shortfilename','var')
    shortfilename = 1;
end
if ~exist('savepowsum','var')
    savepowsum = 0;
end

if ~exist('savepow','var')
    savepow = 0;
end
if ~exist('savedspow','var')
    savedspow = 0;
end
if ~exist('savefilt','var')
    savefilt = 0;
end
if ~exist('savememory','var')
    savememory = 0;
end

videoxmax = 348;
videoymax = 240;
DBconversion = 0; % convert power to decibells after filtering & temporal smoothing

[numfiles n] = size(filebasemat);
pos_sum = zeros(ceil(videoxmax),ceil(videoymax));
pow_sum = zeros(ceil(videoxmax),ceil(videoymax), nchannels);

for i=1:numfiles

    filebase = filebasemat(i,:);
    whldat = loadmazetrialtypes(filebase,trialtypesbool,mazelocationsbool);
    
    inname = [filebase fileext];
    firfiltb = fir1(forder,[lowband/sampl*2,highband/sampl*2]);
    avgfiltb = ones(avgfilorder,1)/avgfilorder;

    %eegdata = bload(inname, [nchannels inf], 0, 'int16');
    fprintf('Loading data and filtering...\n'); 
    filtered_data = [];
    for j=1:length(channels)
        fprintf('Channel %d, ',channels(j));
        eegdata = readmulti(inname, nchannels, channels(j));
        filtered_data = [filtered_data Filter0(firfiltb,eegdata)]; % filtering
    end
    clear eegdata;
    
    if savefilt,
        outname = [filebase '_' num2str(lowband) '-' num2str(highband) 'Hz' fileext '.filt'];
        fprintf('Saving %s\n', outname);
        bsave(outname,filtered_data','int16');
    end
    
    power = filtered_data.^2; 
    clear filtered_data;
    powerdat = zeros(size(power));
    fprintf('Smoothing...\n');
    fprintf('Channels: '); 
    for j=1:length(channels)
        fprintf('%d, ',channels(j));
        powerdat(:,j) = Filter0(avgfiltb,power(:,channels(j))); % smoothing
    end
    clear power;
      
    notminusones = find(whldat(:,1)~=-1);
    whldat = ceil(whldat); % bin size = 1 pixel
    
    accum_pos = Accumulate(whldat(notminusones,1:2), 1); % accumulate the number of frames spent in each position
    [fa fb] = find(accum_pos);
    pos_sum(fa,fb) = pos_sum(fa,fb) + accum_pos(fa,fb); 
    
    [whlm n] = size(whldat);
    avepowerdat = zeros(whlm, length(channels));
    
    fprintf('\nCalculating spatial map of power...\n');
    fprintf('Channels: ');   
    for j=1:length(channels)
        avepowerdat(:,j) = avedownsize(powerdat(:,j), whldat); % average powdat to the size of whldat

        % accumulate power info for each channel into a spatial map
        fprintf('%d,', channels(j));
        
        accum_pow = Accumulate(whldat(notminusones,1:2), avepowerdat(notminusones,j)); %accumulate the power for each position
        pow_sum(fa,fb,channels(j)) = pow_sum(fa,fb,channels(j)) + accum_pow(fa,fb);
        
    end
    
    if savedspow,
        outname = [filebase '_' num2str(lowband) '-' num2str(highband) 'Hz' fileext '.100DBdspow'];
        fprintf('\nSaving %s\n', outname);
        bsave(outname,1000*log10(avepowerdat'),'int16');
    end
    clear avepowerdat;
     
    DB100powerdat = zeros(size(powerdat));
    for j=1:length(channels)
        DB100powerdat(:,j) = 1000*log10(powerdat(:,j));
    end
    if savepow,
        outname = [filebase '_' num2str(lowband) '-' num2str(highband) 'Hz' fileext '.100DBpow'];
        fprintf('Saving %s\n', outname);
        bsave(outname,DB100powerdat','int16');
    end
    clear powerdat;
end 

i = 'y';
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
    trialsmat = counttrialtypes(filebasemat,1,trialtypesbool);     
    if shortfilename,
        outname = [tasktype '_' filebasemat(1,1) filebasemat(1,2:4) filebasemat(1,5) filebasemat(1,6:8) ...
            '-' filebasemat(end,1) filebasemat(end,2:4) filebasemat(end,5) filebasemat(end,6:8)...
            fileext '_pos_pow' num2str(lowband) '-' num2str(highband) 'Hz_sum.mat'];
    else
        outname = [tasktype '_' filebasemat(1,7) filebasemat(1,10:12) filebasemat(1,14) filebasemat(1,17:19) ...
            '-' filebasemat(end,7) filebasemat(end,10:12) filebasemat(end,14) filebasemat(end,17:19) ...
            fileext '_pos_pow' num2str(lowband) '-' num2str(highband) 'Hz_sum.mat'];
    end
    fprintf('Saving %s\n', outname);
    save(outname,'pos_sum','pow_sum','trialsmat');
end    



return;