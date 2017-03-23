function [pos_sum, pow_sum] = CalcPosPowSum(tasktype,fileBaseCell,fileNameFormat,fileext,nchannels,channels,...
    lowband,highband,forder,avgfilorder,dbBool,savepowsum,savefilt,savepow,savedspow,trialtypesbool,mazelocationsbool)
%function [pos_sum, pow_sum] = CalcPosPowSum(tasktype,fileBaseCell,fileNameFormat,fileext,nchannels,channels,lowband,highband,forder,avgfilorder,dbBool,savepowsum,savefilt,savepow,savedspow,trialtypesbool,mazelocationsbool)
% 
% 'pos_sum' is a 2D matrix containing the number of video frames the animals spent in each spatial position
% 'pow_sum' is a 2D by nchannels matrix containing the sum of the power in the given freq band for each position
% 'fileBaseCell' has a list of filebase names in each row of a 2D matrix
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
%           % lr rr rl ll lrp rrp rlp llp lrb rrb rlb llb xp
% 'mazelocationsbool' is a matrix determining which maze locations are analysed
%   default = [0  0  0  1  1  1   1   1   1];
%           % rp lp dp cp ca rca lca rra lra
%   trial types are designated using sortatertrialtypes.m or sortcircletrialtypes.m


sampl = 1250; % eeg sampling rate
 
videoxmax = 368;
videoymax = 240;
            
if ~exist('trialtypesbool','var') | isempty(trialtypesbool)
    trialtypesbool = [1  0  1  0  0   0   0   0   0   0   0   0  0];
                   % lr rr rl ll lrp rrp rlp llp lrb rrb rlb llb xp
end
if ~exist('mazelocationsbool','var') | isempty(mazelocationsbool)
    mazelocationsbool = [0  0  0  1  1  1   1   1   1];
                      % rp lp dp cp ca rca lca rra lra
end
if ~exist('fileNameFormat','var') | isempty(fileNameFormat)
    fileNameFormat = 1;
end
if ~exist('dbBool','var') | isempty(dbBool)
    dbBool = 0;
end
if ~exist('savepowsum','var') | isempty(savepowsum)
    savepowsum = 0;
end
if ~exist('savepow','var') | isempty(savepow)
    savepow = 0;
end
if ~exist('savedspow','var') | isempty(savedspow)
    savedspow = 0;
end
if ~exist('savefilt','var') | isempty(savefilt)
    savefilt = 0;
end
if ~exist('savememory','var') | isempty(savememory)
    savememory = 0;
end

[numfiles] = length(fileBaseCell);
pos_sum = zeros(ceil(videoxmax),ceil(videoymax));
pow_sum = zeros(ceil(videoxmax),ceil(videoymax), nchannels);

for i=1:numfiles
    fprintf('\n')
    cd(fileBaseCell{i})
    filebase = fileBaseCell{i};
    whldat = LoadMazeTrialTypes(filebase,trialtypesbool,mazelocationsbool);

    notminusones = find(whldat(:,1)~=-1);
    whldat = ceil(whldat); % bin size = 1 pixel

    if ~isempty(notminusones)
        accum_pos = Accumulate(whldat(notminusones,1:2), 1); % accumulate the number of frames spent in each position
        [fa fb] = find(accum_pos);
        pos_sum(fa,fb) = pos_sum(fa,fb) + accum_pos(fa,fb);

        dspowfilename = [filebase '_' num2str(lowband) '-' num2str(highband) 'Hz' fileext '.100DBdspow'];
        if exist(dspowfilename,'file')
            powerdat = 10.^(bload(dspowfilename, [nchannels inf])'./1000);
        else
            powerdat = FiltRectSmoothDS3(filebase,fileext,nchannels,lowband,highband,forder,avgfilorder,savefilt,savepow,savedspow);
        end
        if dbBool
            powerdat = 10*log10(powerdat);
        end
        fprintf('Calculating spatial map of power...\n');
        fprintf('Channels: ');
        for j=1:length(channels)
            % accumulate power info for each channel into a spatial map
            fprintf('%d,', channels(j));

            accum_pow = Accumulate(whldat(notminusones,1:2), powerdat(notminusones,j)); %accumulate the power for each position
            pow_sum(fa,fb,channels(j)) = pow_sum(fa,fb,channels(j)) + accum_pow(fa,fb);

        end
    end
    cd ..
end 

if dbBool
    DB = 'DB';
else
    DB = [];
end
i = 'y';
if (savepowsum == 0)
    while 1,
        i = input('Save to disk (yes/no)? ', 's');
        if strcmp(i,'yes') | strcmp(i,'no'), break; end
    end
end
if i(1) == 'n'
    CountTrialTypes(fileBaseCell,1);
    return;
else
    trialsmat = CountTrialTypes(fileBaseCell,1);     
    outname = [tasktype '_' GetFileNamesInfo(fileBaseCell,fileNameFormat) fileext ...
        '_' num2str(lowband) '-' num2str(highband) 'Hz_pos_pow_sum' DB '.mat'];
%     if fileNameFormat == 1,
%         outname = [tasktype '_' fileBaseCell(1,1) fileBaseCell(1,2:4) fileBaseCell(1,5) fileBaseCell(1,6:8) ...
%             '-' fileBaseMat(end,1) fileBaseMat(end,2:4) fileBaseMat(end,5) fileBaseMat(end,6:8)...
%             fileext '_' num2str(lowband) '-' num2str(highband) 'Hz_pos_pow_sum' DB '.mat'];
%     end
%     if fileNameFormat == 0,
%         outname = [tasktype '_' fileBaseMat(1,[1:7 10:12 14 17:19]) '-' fileBaseMat(end,[7 10:12 14 17:19])...
%             fileext '_' num2str(lowband) '-' num2str(highband) 'Hz_pos_pow_sum' DB '.mat'];
%     end
%     if fileNameFormat == 2,
%                 outname = [tasktype '_' fileBaseMat(1,:) '-' fileBaseMat(end,8:10) ...
%                     fileext '_' num2str(lowband) '-' num2str(highband) 'Hz_pos_pow_sum' DB '.mat'];
%     end
    fprintf('Saving %s\n', outname);
    matlabVersion = version;
    if str2num(matlabVersion(1)) > 6
        save(outname,'-V6','pos_sum','pow_sum','trialsmat','fileBaseCell');
    else
        save(outname,'pos_sum','pow_sum','trialsmat','fileBaseCell');
    end
end
return;