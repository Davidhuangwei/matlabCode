function PlotPowMapsBat(taskType,fileBaseCell,fileNameFormat,fileExt,freqRange,winLength,NW,peakBool,chanMat,varargin)
% function PlotPowMapsBat(taskType,fileBaseCell,fileNameFormat,fileExt,freqRange,winLength,NW,peakBool,chanMat,...
% badchan,saveMazePow,calcZ,percentageBool,DB,samescale,colorLimits,textBool,plotRes,plot_low_thresh)
%
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

[badchan, saveMazePow, calcZ, percentageBool, DB, samescale, colorLimits, textBool, plotRes, plot_low_thresh] = ...
    DefaultArgs(varargin,{0, 0, 0, 0, 0, 0, [], 1, 3, 0.01});
smoothpixels = 4; % how many pixels to smooth over


[chan_y chan_x chan_z] = size(chanMat);

fileNamesInfo = GetFileNamesInfo(fileBaseCell,fileNameFormat);
peak = [];
if peakBool
    peak = '_peak';
end
pos_pow_sumFile = [taskType '_' fileNamesInfo ...
    fileExt '_' num2str(freqRange(1)) '-' num2str(freqRange(2)) 'Hz_Win' num2str(winLength) '_NW' num2str(NW) peak '_pos_pow_sum.mat'];

smoothMazePowFile = [taskType '_' fileNamesInfo ...
    fileExt '_' num2str(freqRange(1)) '-' num2str(freqRange(2)) 'Hz_Win' num2str(winLength) '_NW' num2str(NW) peak '_SmoothMazePow.mat'];

i = 0;
fromFile = 0;
while exist(smoothMazePowFile,'file') & ~strcmp(i,'y') & ~strcmp(i,'n') & ~strcmp(i,'') 
    i = input('Would you like to load smoothMazePowFile? [y]/n: ','s');
end
if strcmp(i,'y') | strcmp(i,'')
    fprintf('loading %s\n',smoothMazePowFile);
    load(smoothMazePowFile);
    fromFile = 1;
else
    if exist(pos_pow_sumFile,'file')
        fprintf('loading %s\n',pos_pow_sumFile);
        load(pos_pow_sumFile);
        pos_sum = getfield(sumPerPosStruct,'posSum');
        pow_sum = getfield(sumPerPosStruct,'powSum');

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

powmax = [];
powmin = [];

fprintf('Plotting Channel: ');
for z=1:chan_z
    figure(z)
    clf
    %colormap('default');
    %cm = colormap;
    %load('ColorMapSean3.mat')
    %colormap(ColorMapSean3);
    for y=1:chan_y
        for x=1:chan_x
            fprintf('%i,',chanMat(y,x,z));
            if isempty(find(badchan==chanMat(y,x,z))), % if the channel isn't bad
                if ~fromFile
                    try
                    pow_sum(:,:,chanMat(y,x,z)) = (Smooth(pow_sum(:,:,chanMat(y,x,z)), smoothpixels)); % smooth power data
                    catch
                        junk = lasterror
                        junk.message
                        junk.stack(1)
                        keyboard
                    end
                    %keyboard
                    mazePow(:,:,chanMat(y,x,z)) = (pow_sum(:,:,chanMat(y,x,z))./smooth_pos_sum_nan); % average pow/pixel
                end
                
                subplot(chan_y,chan_x,(y-1)*chan_x+x);
                
                if calcZ
                    thisChanMazePow = mazePow(:,:,chanMat(y,x,z));
                    meanPowthisChan = mean(thisChanMazePow(find(~isnan(thisChanMazePow))));
                    sdPowthisChan = std(thisChanMazePow(find(~isnan(thisChanMazePow))));
                    zMazePow(:,:,chanMat(y,x,z)) = (mazePow(:,:,chanMat(y,x,z))-meanPowthisChan)./sdPowthisChan;
                    
                    [toPlotY toPlotX] = find(~isnan(zMazePow(:,:,chanMat(y,x,z))));
                    ImageScRmNaN_old(zMazePow(1:plotRes:end,1:plotRes:end,chanMat(y,x,z)),colorLimits,[1 0 1]);
                    
                    powmax = max([max(zMazePow(:,:,chanMat(y,x,z))) powmax]);
                    powmin = min([min(zMazePow(:,:,chanMat(y,x,z))) powmin]);

                else
                    if percentageBool
                        thisChanMazePow = mazePow(:,:,chanMat(y,x,z));
                        meanPowthisChan = median(thisChanMazePow(find(~isnan(thisChanMazePow))));
                        percentageMazePow(:,:,chanMat(y,x,z)) = mazePow(:,:,chanMat(y,x,z))./meanPowthisChan;
                        if DB % decibel conversion after averaging
                            percentageMazePow(:,:,chanMat(y,x,z)) = 10*log10(percentageMazePow(:,:,chanMat(y,x,z)));
                        end
                        
                        [toPlotY toPlotX] = find(percentageMazePow(:,:,chanMat(y,x,z)) > -1);
                        ImageScRmNaN_old(percentageMazePow(1:plotRes:end,1:plotRes:end,chanMat(y,x,z)),colorLimits,[1 0 1]);
                        
                        powmax = max([max(percentageMazePow(:,:,chanMat(y,x,z))) powmax]);
                        powmin = min([min(percentageMazePow(:,:,chanMat(y,x,z))) powmin]);

                    else
                        
                        if DB % decibel conversion after averaging
                            DbMazePow(:,:,chanMat(y,x,z)) = 10*log10(mazePow(:,:,chanMat(y,x,z))); % average pow/pixel
                            [toPlotY toPlotX] = find(DbMazePow(:,:,chanMat(y,x,z)) > -1);
                            ImageScRmNaN_old(DbMazePow(1:plotRes:end,1:plotRes:end,chanMat(y,x,z)),colorLimits,[1 0 1]);

                            powmax = max([max(DbMazePow(:,:,chanMat(y,x,z))) powmax]);
                            powmin = min([min(DbMazePow(:,:,chanMat(y,x,z))) powmin]);

                        else
                            [toPlotY toPlotX] = find(mazePow(:,:,chanMat(y,x,z)) > -1);
                            ImageScRmNaN_old(mazePow(1:plotRes:end,1:plotRes:end,chanMat(y,x,z)),colorLimits,[1 0 1]);
                            powmax = max([max(mazePow(:,:,chanMat(y,x,z))) powmax]);
                            powmin = min([min(mazePow(:,:,chanMat(y,x,z))) powmin]);
                        end
                    end
                end
                toPlotX = [min(toPlotX)/plotRes-2 max(toPlotX)/plotRes+2];
                toPlotY = [min(toPlotY)/plotRes-2 max(toPlotY)/plotRes+2];

                set(gca, 'xlim',toPlotX,'ylim',toPlotY,'xticklabel', [], 'yticklabel', []);
                if calcZ
                    title([num2str(chanMat(y,x,z)) ': ' num2str(meanPowthisChan,3)]);
                else
                    title(['Channel: ',num2str(chanMat(y,x,z))])
                end
                if ~samescale,
                    %colorbar
                end
            end
        end
    end
end
fprintf('\n');
%for z=1:chan_z
 %   figure(z)
 %   gtext({'sm9603',[filebasemat(1,7) filebasemat(1,10:12) filebasemat(1,14) filebasemat(1,17:19) '-'], ...
 if 0
     if samescale,
         for z=1:chan_z
             figure(z)
             for y=1:chan_y
                 for x=1:chan_x
                     if isempty(find(badchan==chanMat(y,x,z))), % if the channel isn't bad
                         subplot(chan_y,chan_x,(y-1)*chan_x+x);
                         if ~exist('minscale', 'var') | isempty(minscale)
                             set(gca, 'clim', [powmin powmax]);
                         else
                             set(gca, 'clim', [minscale maxscale]);
                         end
                         %set(plothandles(chan_m, i,1), 'clim', [powmin powmax]);
                         colorbar
                     end
                 end
             end
         end
     end
 end

if saveMazePow
    
    fileNamesInfo = GetFileNamesInfo(fileBaseCell,fileNameFormat);
    peak = [];
    if peakBool
        peak = '_peak';
    end
    outname = [taskType '_' fileNamesInfo ...
        fileExt '_' num2str(freqRange(1)) '-' num2str(freqRange(2)) 'Hz_Win' num2str(winLength) '_NW' num2str(NW) peak 'SmoothMazePow.mat'];
    fprintf('Saving %s\n', outname);
    matlabVersion = version;
    if str2num(matlabVersion(1)) > 6
        save(outname,'-V6','mazePow');
    else
        save(outname,'mazePow');
    end
end

if textBool
    if 1
        for i=1:size(chanMat,3)
            figure(i);
            fileNamesInfo = GetFileNamesInfo(fileBaseCell,fileNameFormat);

            text(0,0,{[num2str(freqRange(1)) '-' num2str(freqRange(2)) 'Hz Power'],fileExt,'',...
                taskType,fileNamesInfo,...
                ['ssm pix=' num2str(smoothpixels)],...
                ['thresh=' num2str(plot_low_thresh)]})

        end
    end
end
return
