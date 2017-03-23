function plotpowmapsbat7(pos_sum,pow_sum,chanMat,badchan,percentageBool,DB,samescale,minscale,maxscale,plot_low_thresh)
% function plotpowmapsbat7(pos_sum,pow_sum,chanMat,DB,samescale,minscale,maxscale)
% 'pos_sum' is a 2D matrix containing the number of video frames the animals spent in each spatial position
% 'pow_sum' is a 2D by nchanMat matrix containing the sum a variable of interest (e.g. power) for each position
% 'chanMat' is a 3D matrix that determines graphical output. x,y for each z determines page layout for each figure respectively.
% 'DB' if DB=1 the variable of interes will be transformed 10*log10 after spatial smoothing before plotting
%   default = 0
% 'samescale' if samescale=1 all graphs will be scaled to the same values 'minscale' and 'maxscale'
%   default = 0
% 'percentageBool' if percentageBool=1 the power will be expressed as a
%   percentage of the mean power for that channel
%   default = 0
%
% plotpowmapsbat7 can plot the percentage changes in power from the mean
% rather than the raw power or the mean power (can have same scaling)

if ~exist('plot_low_thresh') | isempty(plot_low_thresh)
    plot_low_thresh = 0.1; % thresh to trim ploted values that were smeared by smoothing
end
smoothpixels = 4; % how many pixels to smooth over

if ~exist('DB') | isempty(DB)
    DB = 0;
end
if ~exist('percentageBool') | isempty(percentageBool)
    percentageBool = 0;
end
if ~exist('samescale') | isempty(samescale)
    samescale = 0;
end
if ~exist('badchan') | isempty(badchan)
    badchan = 0;
end



[chan_y chan_x chan_z] = size(chanMat);  

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



powmax = [];
powmin = [];

for z=1:chan_z
    figure(z)
    %colormap('default');
    %cm = colormap;
    load('ColorMapSean.mat')
    colormap(ColorMapSean);
    for y=1:chan_y
        for x=1:chan_x
            
            if isempty(find(badchan==chanMat(y,x,z))), % if the channel isn't bad
                pow_sum(:,:,chanMat(y,x,z)) = (Smooth(pow_sum(:,:,chanMat(y,x,z)), smoothpixels)); % smooth power data
                
                if DB,   % decibel conversion after averaging
                    mazepow(:,:,chanMat(y,x,z)) = 10*log10(pow_sum(:,:,chanMat(y,x,z))./smooth_pos_sum_nan); % average pow/pixel
                else
                    mazepow(:,:,chanMat(y,x,z)) = (pow_sum(:,:,chanMat(y,x,z))./smooth_pos_sum_nan); % average pow/pixel
                end
                if percentageBool
                    thisChanMazePow = mazepow(:,:,chanMat(y,x,z));
                    meanPowthisChan = mean(thisChanMazePow(find(~isnan(thisChanMazePow))));
                    mazepow(:,:,chanMat(y,x,z)) = mazepow(:,:,chanMat(y,x,z))./meanPowthisChan;
                end
                % now plot
                subplot(chan_y,chan_x,(y-1)*chan_x+x);
                %plothandles(j, i,1) = gca;
                imagesc(mazepow(1:3:end,1:3:end,chanMat(y,x,z)));
                set(gca, 'xticklabel', [], 'yticklabel', []);
                if percentageBool
                    title([num2str(chanMat(y,x,z)) ': ' num2str(meanPowthisChan,3)]);
                else
                    title(['Channel: ',num2str(chanMat(y,x,z))])
                end
                if ~samescale,
                    colorbar
                end
                powmax = max([max(mazepow(:,:,chanMat(y,x,z))) powmax]); 
                powmin = min([min(mazepow(:,:,chanMat(y,x,z))) powmin]);
            end
        end
    end
end
%for z=1:chan_z
 %   figure(z)
 %   gtext({'sm9603',[filebasemat(1,7) filebasemat(1,10:12) filebasemat(1,14) filebasemat(1,17:19) '-'], ...
 %           'correct trials'
if samescale,
    for z=1:chan_z
        figure(z)
        for y=1:chan_y
            for x=1:chan_x
                if isempty(find(badchan==chanMat(y,x,z))), % if the channel isn't bad       
                    subplot(chan_y,chan_x,(y-1)*chan_x+x);
                    if ~exist('minscale', 'var')
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
return