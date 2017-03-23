function plotpowmapsbatNormByControl(posSumExp,powSumExp,posSumControl,powSumControl,chanMat,badchannels,samescale,scaleBounds,saveMazePow,fileNameFormat,animal,fileNumbers,freqBand,plot_low_thresh)
% function plotpowmapsbatNormByControl(posSumExp,powSumExp,posSumControl,powSumControl,chanMat,badchannels,plot_low_thresh,samescale,minscale,maxscale)
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

if ~exist('plot_low_thresh','var')
    plot_low_thresh = 0.1; % thresh to trim ploted values that were smeared by smoothing
end
smoothpixels = 4; % how many pixels to smooth over

if ~exist('samescale','var')
    samescale = 0;
end
if ~exist('badchannels','var')
    badchannels = 0;
end
if ~exist('saveMazePow','var')
    saveMazePow = 0;
end

% now smooth control position
smooth_pos_sum = Smooth(posSumControl, smoothpixels); % smooth position data
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
smooth_pos_sum_nan_control = smooth_pos_sum_nan;


% now smooth exp position
smooth_pos_sum = Smooth(posSumExp, smoothpixels); % smooth position data
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
smooth_pos_sum_nan_exp = smooth_pos_sum_nan;


powmax = []; % for autoscaling
powmin = []; % for autoscaling

colormap('default');
cm = colormap;
colormap([[1 1 1]; cm]);

[chan_y chan_x chan_z] = size(chanMat);

for z=1:chan_z
    figure(z)
    for y=1:chan_y'
        for x=1:chan_x

            if isempty(find(badchannels==chanMat(y,x,z))), % if the channel isn't bad
                powSumExp(:,:,chanMat(y,x,z)) = (Smooth(powSumExp(:,:,chanMat(y,x,z)), smoothpixels)); % smooth power data
                powSumControl(:,:,chanMat(y,x,z)) = (Smooth(powSumControl(:,:,chanMat(y,x,z)), smoothpixels)); % smooth power data
                mazePowExp(:,:,chanMat(y,x,z)) = (powSumExp(:,:,chanMat(y,x,z))./smooth_pos_sum_nan_exp); % average pow/pixel
                mazePowControl(:,:,chanMat(y,x,z)) = (powSumControl(:,:,chanMat(y,x,z))./smooth_pos_sum_nan_control); % average pow/pixel
                normMazePow(:,:,chanMat(y,x,z)) = mazePowExp(:,:,chanMat(y,x,z))./mazePowControl(:,:,chanMat(y,x,z)); % normalize by control

                % now plot
                subplot(chan_y,chan_x,(y-1)*chan_x+x);
                %plothandles(j, i,1) = gca;
                imagesc(normMazePow(1:3:end,1:3:end,chanMat(y,x,z)));
                set(gca, 'xticklabel', [], 'yticklabel', []);
                title(['channel ' num2str(chanMat(y,x,z))]);
                if ~samescale,
                    colorbar
                end
                powmax = max([max(normMazePow(:,:,chanMat(y,x,z))) powmax]);
                powmin = min([min(normMazePow(:,:,chanMat(y,x,z))) powmin]);
            end
        end
    end
end

%   gtext({'sm9603',[filebasemat(1,7) filebasemat(1,10:12)  filebasemat(1,14) filebasemat(1,17:19) '-'], 

if saveMazePow
    if fileNameFormat == 1,
        ERROR_fileNameFormat_NOT_READY
        outname = [tasktype '_' filebasemat(1,1) filebasemat(1,2:4) filebasemat(1,5) filebasemat(1,6:8) ...
            '-' filebasemat(end,1) filebasemat(end,2:4) filebasemat(end,5) filebasemat(end,6:8)...
            fileext '_' num2str(lowband) '-' num2str(highband) 'Hz_pos_pow_sum.mat'];
    end
    if fileNameFormat == 0,
        ERROR_fileNameFormat_NOT_READY
        outname = [tasktype '_' filebasemat(1,7) filebasemat(1,10:12) filebasemat(1,14) filebasemat(1,17:19) ...
            '-' filebasemat(end,7) filebasemat(end,10:12) filebasemat(end,14) filebasemat(end,17:19) ...
            fileext '_' num2str(lowband) '-' num2str(highband) 'Hz_pos_pow_sum.mat'];
    end
    if fileNameFormat == 2,
        outname = ['NormMazePow' '_' animal '_' num2str(fileNumbers(1)) '-' num2str(fileNumbers(end)) '_'  ...
            num2str(freqBand(1)) '-' num2str(freqBand(2)) 'Hz.mat'];
    end
    fprintf('Saving %s\n', outname);
    save(outname,'normMazePow','mazePowExp','mazePowControl');
end

if samescale,
    for z=1:chan_z
        figure(z)
        for y=1:chan_y
            for x=1:chan_x
                if isempty(find(badchannels==chanMat(y,x,z))), % if the channel isn't bad
                    subplot(chan_y,chan_x,(y-1)*chan_x+x);
                    if ~exist('scaleBounds','var') | isempty(scaleBounds)
                        set(gca, 'clim', [powmin powmax]);
                    else
                        set(gca, 'clim', [scaleBounds(1) scaleBounds(2)]);
                    end
                    %set(plothandles(chan_m, i,1), 'clim', [powmin powmax]);
                    colorbar
                end
            end
        end
    end
end

return