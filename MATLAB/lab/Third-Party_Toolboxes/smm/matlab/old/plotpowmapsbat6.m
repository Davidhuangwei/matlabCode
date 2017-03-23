function plotpowmapsbat6(pos_sum,pow_sum,channels,DB,badchan,plot_low_thresh,samescale,minscale,maxscale)
% function plotpowmapsbat5(pos_sum,pow_sum,channels,DB,samescale,minscale,maxscale)
% 'pos_sum' is a 2D matrix containing the number of video frames the animals spent in each spatial position
% 'pow_sum' is a 2D by nchannels matrix containing the sum a variable of interest (e.g. power) for each position
% 'channels' is a 3D matrix that determines graphical output. x,y for each z determines page layout for each figure respectively.
% 'DB' if DB=1 the variable of interes will be transformed 10*log10 after spatial smoothing before plotting
%   default = 0
% 'samescale' if samescale=1 all graphs will be scaled to the same values 'minscale' and 'maxscale'
% ************************************************************************************************
% plotpowmapsbat6 adds functionality to set the center point of the colorscale according to the mean
%   or median of each channel individually while keeping the range of the colorscale constant (may need
%   some tuning up before it will work well 
% ************************************************************************************************

if ~exist('plot_low_thresh')
    plot_low_thresh = 0.1; % thresh to trim ploted values that were smeared by smoothing
end
smoothpixels = 4; % how many pixels to smooth over

if ~exist('DB')
    DB = 0;
end
if ~exist('samescale')
    samescale = 0;
end
if ~exist('badchan')
    badchan = 0;
end

%powmax = NaN;
%powmin = NaN;
[chan_y chan_x chan_z] = size(channels);  

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

for z=1:chan_z
    figure(z)
    for y=1:chan_y
        for x=1:chan_x
            
            if isempty(find(badchan==channels(y,x,z))), % if the channel isn't bad
                pow_sum(:,:,channels(y,x,z)) = (Smooth(pow_sum(:,:,channels(y,x,z)), smoothpixels)); % smooth power data
                
                if DB,   % decibel conversion after averaging 
                    mazepow(:,:,channels(y,x,z)) = 10*log10(pow_sum(:,:,channels(y,x,z))./smooth_pos_sum_nan); % average pow/pixel
                else
                    mazepow(:,:,channels(y,x,z)) = (pow_sum(:,:,channels(y,x,z))./smooth_pos_sum_nan); % average pow/pixel
                end
             end
        end
    end
end

for i=1:96
    mazejunk = mazepow(:,:,i);
    medianpow(i) = median(mazejunk(find(~isnan(mazejunk))));
end
for i=1:96
    mazejunk = mazepow(:,:,i);
    meanpow(i) = mean(mazejunk(find(~isnan(mazejunk(:,:)))));
end

%colorrange = median(range(range(mazepow(

while input('quit?')~='q'
    keyboard
for z=1:chan_z
    figure(z)
    for y=1:chan_y
        for x=1:chan_x    
            if isempty(find(badchan==channels(y,x,z))), % if the channel isn't bad

                % now plot
                subplot(chan_y,chan_x,(y-1)*chan_x+x);
                %plothandles(j, i,1) = gca;
                imagesc(mazepow(1:3:end,1:3:end,channels(y,x,z)));
                set(gca, 'xticklabel', [], 'yticklabel', []);
                set(gca, 'clim', [minscale(channels(y,x,z)) maxscale(channels(y,x,z))]);
                title(['channel ' num2str(channels(y,x,z))]);
                if ~samescale,
                    %colorbar
                end
                %powmax = max([max(mazepow(:,:,channels(y,x,z))) powmax]); 
                %powmin = min([min(mazepow(:,:,channels(y,x,z))) powmin]);
            end
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
                if isempty(find(badchan==chanmat(y,x,z))), % if the channel isn't bad       
                    subplot(chan_y,chan_x,(y-1)*chan_x+x);
                    set(gca, 'clim', [minscale maxscale]);
                    %set(plothandles(chan_m, i,1), 'clim', [powmin powmax]);
                    colorbar
                end
            end
        end
    end
end
return