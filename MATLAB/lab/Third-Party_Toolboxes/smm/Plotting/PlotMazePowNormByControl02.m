function PlotMazePowNormByControl02(expTaskType,expFileBaseCell,controlTaskType,controlFileBaseMat,fileNameFormat,fileExt,lowCut,highCut,fOrder,chanMat,badchan,dbBool,samescale,colorLimits,textBool,plotRes,plot_low_thresh)
% function plotpowmapsbat9(taskType,fileBaseMat,fileNameFormat,fileExt,lowCut,highCut,fOrder,chanMat,badchan,saveMazePow,calcZ,percentageBool,DB,samescale,minscale,maxscale,textBool,plotRes,plot_low_thresh)
%
% Smooths position data and power data for each channel and calculates the
% average power for each position pixel for exp and control trials
% separately. The exp power/pixel is then divided by the control
% power/pixel and maze plots are generated for each channel to show the
% relative differences in theta power between the two tasks at each point
% on the maze.
%
% 'posSumExp' and 'posSumControl' are 2D matrices containing the number of
%     video frames the animals spent in each spatial position
% 'powSumExp' and 'powSumControl' are 2D by nchannels matrices containing
%     the sum a variable of interest (e.g. power) for each position
% 'chanMat' is a 3D matrix that determines graphical output. x,y for each z
%     determines page layout for each figure respectively.
% 'badchannels' decribes those channels that should be ignored.
% 'samescale' if samescale=1 all graphs will be scaled to the same values
% if 'scaleBounds' 'minscale' and 'maxscale'
% 'pos_sum' is a 2D matrix containing the number of video frames the animals spent in each spatial position
% 'pow_sum' is a 2D by nchanMat matrix containing the sum a variable of interest (e.g. power) for each position
% 'chanMat' is a 3D matrix that determines graphical output. x,y for each z determines page layout for each figure respectively.
% 'DB' if DB=1 the variable of interes will be transformed 10*log10 after spatial smoothing before plotting
%   default = 0
% 'samescale' if samescale=1 all graphs will be scaled to the same values 'minscale' and 'maxscale'
%   default = 0
% 'calcZ' if calcZ=1 the power will be expressed as a
%   percentage of the mean power for that channel
%   default = 0
%
% plotpowmapsbat7 can plot the percentage changes in power from the mean
% rather than the raw power or the mean power (can have same scaling)

if ~exist('plot_low_thresh') | isempty(plot_low_thresh)
    plot_low_thresh = 0.1; % thresh to trim ploted values that were smeared by smoothing
end
smoothpixels = 4; % how many pixels to smooth over

if ~exist('dbBool') | isempty(dbBool)
    dbBool = 0;
end
if ~exist('calcZ') | isempty(calcZ)
    calcZ = 0;
end
if ~exist('samescale') | isempty(samescale)
    samescale = 0;
end
if ~exist('badchan') | isempty(badchan)
    badchan = 0;
end
if ~exist('textBool') | isempty(textBool)
    textBool = 1;
end
if ~exist('plotRes') | isempty(plotRes)
   plotRes  = 3;
end
if ~exist('colorLimits') | isempty(colorLimits)
    colorLimits = [];
end

[chan_y chan_x chan_z] = size(chanMat);

if dbBool
    DB = 'DB';
else
    DB = [];
end
if fileNameFormat == 0,
    NOT_YET_READY
    smoothMazePowFile = [taskType '_' fileBaseMat(1,[1:7 10:12 14 17:19]) '-' fileBaseMat(end,[7 10:12 14 17:19]) ...
        fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_SmoothMazePow' DB '.mat'];

    pos_pow_sumFile = [taskType '_' fileBaseMat(1,[1:7 10:12 14 17:19]) '-' fileBaseMat(end,[7 10:12 14 17:19]) ...
        fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_pos_pow_sum' DB '.mat'];
end
if fileNameFormat == 2,
    expFileNamesInfo = GetFileNamesInfo(expFileBaseCell,2);
    expSmoothMazePowFile = [expTaskType '_' expFileNamesInfo ...
        fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_SmoothMazePow' DB '.mat'];

    expPos_pow_sumFile = [expTaskType '_' expFileNamesInfo ...
        fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_pos_pow_sum' DB '.mat'];
   
    controlFileNamesInfo = GetFileNamesInfo(controlFileBaseCell,2);
    controlSmoothMazePowFile = [controlTaskType '_' controlFileNamesInfo ...
        fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_SmoothMazePow' DB '.mat'];

    controlPos_pow_sumFile = [controlTaskType '_' controlFileNamesInfo ...
        fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_pos_pow_sum' DB '.mat'];

end
if fileNameFormat == 1,
    fileNameFormat_NOT_SUPPORTED
end

i = 'y';
fromFile = 1;
%while exist(expSmoothMazePowFile,'file') & exist(controlSmoothMazePowFile,'file') & ~strcmp(i,'y') & ~strcmp(i,'n') & ~strcmp(i,'') 
%    i = input('Would you like to load smoothMazePowFile? [y]/n: ','s');
%end
if strcmp(i,'y') | strcmp(i,'')
    fprintf('loading %s\n',expSmoothMazePowFile);
    load(expSmoothMazePowFile);
    expMazePow = mazePow;
    clear mazePow;
    fprintf('loading %s\n',controlSmoothMazePowFile);
    load(controlSmoothMazePowFile);
    controlMazePow = mazePow;
    clear mazePow;    
    fromFile = 1;
else
    YOU_MUST_LOAD_smoothMazePowFile_FILE
    if exist(pos_pow_sumFile,'file')
        fprintf('loading %s\n',pos_pow_sumFile);
        load(pos_pow_sumFile);
    else
        pos_pow_sumFile
        YOU_NEED_TO_RUN_calcpospowsum
    end
    fprintf('Smoothing Position\n');
    % now smooth & plot
    smooth_pos_sum = Smooth(pos_sum, smoothpixels); % smooth position data
    norm_smooth_pos_sum = smooth_pos_sum/sum(sum(smooth_pos_sum));
    norm_plot_low_thresh = plot_low_thresh/sum(sum(smooth_pos_sum));
    [below_thresh_indexes] = find(norm_smooth_pos_sum<=norm_plot_low_thresh);
    %[above_thresh_x above_thresh_y] = find(norm_smooth_pos_sum>norm_plot_low_thresh);
    smooth_pos_sum_nan = smooth_pos_sum;
    smooth_pos_sum_nan(below_thresh_indexes)= NaN;
    %minxborder = max(1,above_thresh_x(1)-1);
    %minyborder = max(1,above_thresh_y(1)-1);
    %maxxborder = min(videoxmax,above_thresh_x(end)+1);
    %minyborder = min(videoymax,above_thresh_y(end)+1);
end


for z=1:chan_z
    figure(z);
    clf;
    for y=1:chan_y
        for x=1:chan_x
            fprintf('%i,',chanMat(y,x,z));
            if isempty(find(badchan==chanMat(y,x,z))), % if the channel isn't bad
                if ~fromFile
                    %pow_sum(:,:,chanMat(y,x,z)) = Smooth(pow_sum(:,:,chanMat(y,x,z)), smoothpixels); % smooth power data
                    %mazePow(:,:,chanMat(y,x,z)) = pow_sum(:,:,chanMat(y,x,z))./smooth_pos_sum_nan; % average pow/pixel
                end
                if dbBool
                    normMazePow(:,:,chanMat(y,x,z)) = expMazePow(:,:,chanMat(y,x,z))-controlMazePow(:,:,chanMat(y,x,z)); % normalize by control
                else
                    normMazePow(:,:,chanMat(y,x,z)) = expMazePow(:,:,chanMat(y,x,z))./controlMazePow(:,:,chanMat(y,x,z)); % normalize by control
                end
                subplot(chan_y,chan_x,(y-1)*chan_x+x);
                
                ImageScRmNaN(normMazePow(1:plotRes:end,1:plotRes:end,chanMat(y,x,z)),colorLimits,[1 0 1]);
                [toPlotY toPlotX] = find(~isnan(normMazePow(:,:,chanMat(y,x,z))));
                toPlotX = [min(toPlotX)/plotRes-2 max(toPlotX)/plotRes+2];
                toPlotY = [min(toPlotY)/plotRes-2 max(toPlotY)/plotRes+2];

                set(gca, 'xlim',toPlotX,'ylim',toPlotY,'xticklabel', [], 'yticklabel', []);
                title(['Channel: ',num2str(chanMat(y,x,z))])
                if ~samescale,
                    %colorbar
                end
            end
        end
    end
end
fprintf('\n');

if 0
    if fileNameFormat == 1,
        ERROR_fileNameFormat_NOT_READY
        outname = [tasktype '_' filebasemat(1,1) filebasemat(1,2:4) filebasemat(1,5) filebasemat(1,6:8) ...
            '-' filebasemat(end,1) filebasemat(end,2:4) filebasemat(end,5) filebasemat(end,6:8)...
            fileExt '_' num2str(lowband) '-' num2str(highband) 'Hz_pos_pow_sum' DB '.mat'];
    end
    if fileNameFormat == 2,
        outname = [taskType '_' fileBaseMat(1,:) '-' fileBaseMat(end,[8:10]) ...
            fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_SmoothMazePow' DB '.mat'];
    end
    if fileNameFormat == 0,
        ERROR_fileNameFormat_NOT_READY
        outname = [taskType '_' fileBaseMat(1,[1:7 10:12 14 17:19]) '-' fileBaseMat(end,[7 10:12 14 17:19]) ...
            fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_SmoothMazePow' DB '.mat'];
    end

    if ~fromFile
        if saveMazePow
            fprintf('Saving %s\n', outname);
            matlabVersion = version;
            if str2num(matlabVersion(1)) > 6
                save(outname,'-V6','mazePow');
            else
                save(outname,'mazePow');
            end
        end
    end
end
return
if fileNameFormat == 1,
    ERROR_fileNameFormat_NOT_READY
    outname = [expTasktype '_' expFilebasemat(1,1) expFilebasemat(1,2:4) expFilebasemat(1,5) expFilebasemat(1,6:8) ...
        '-' expFilebasemat(end,1) expFilebasemat(end,2:4) expFilebasemat(end,5) expFilebasemat(end,6:8)...
        fileExt '_' num2str(lowband) '-' num2str(highband) 'Hz_pos_pow_sum' DB '.mat'];
end
if fileNameFormat == 2,
    outname = [expTaskType '_' expFileBaseMat(1,:) '-' expFileBaseMat(end,[8:10]) ...
        fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_SmoothMazePow' DB '.mat'];
end
if fileNameFormat == 0,
    ERROR_fileNameFormat_NOT_READY
    outname = [taskType '_' fileBaseMat(1,[1:7 10:12 14 17:19]) '-' fileBaseMat(end,[7 10:12 14 17:19]) ...
        fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_SmoothMazePow' DB '.mat'];
end

if textBool
    if 1
        for i=1:size(chanMat,3)
            figure(i);
            if fileNameFormat == 0
                NOT_YET_READY
                text(-625,-500,{[num2str(lowCut) '-' num2str(highCut) 'Hz Power'], [DB],fileExt,'',...
                    taskType,SaveTheUnderscores(fileBaseMat(1,1:6)),[SaveTheUnderscores(fileBaseMat(1,[7 10:12 14 17:19])) '-'],SaveTheUnderscores(fileBaseMat(end,[7 10:12 14 17:19])),...
                    '','rl,lr trials','',['forder=' num2str(fOrder)],'ssm(tsm(filt))',['ssm pix=' num2str(smoothpixels)],...
                    ['thresh=' num2str(plot_low_thresh)]})
            end
            if fileNameFormat == 2
                text(-625,-500,{[num2str(lowCut) '-' num2str(highCut) 'Hz Power'],[DB],fileExt,'',...
                    expTaskType,[SaveTheUnderscores(expFileBaseMat(1,1:10)) '-' SaveTheUnderscores(expFileBaseMat(end,[8:10]))],...
                    ['Normalized by'], controlTaskType,...
                    [SaveTheUnderscores(controlFileBaseMat(1,1:10)) '-' SaveTheUnderscores(controlFileBaseMat(end,[8:10]))],...
                    '','rl,lr trials','',['forder=' num2str(fOrder)],'ssm(tsm(filt))',['ssm pix=' num2str(smoothpixels)],...
                    ['thresh=' num2str(plot_low_thresh)]})
            end
            set(gcf,'name',outname(1:end-4))
        end
    end
end
return


