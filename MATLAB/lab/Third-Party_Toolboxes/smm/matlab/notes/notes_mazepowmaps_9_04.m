function notes_mazepowmaps_9_04(normMazePow,chanMat,badchannels,samescale,scaleBounds,DB)

if ~exist('samescale') | isempty(samescale)
    samescale = 0;
end
if ~exist('badchannels','var') | isempty(badchannels)
    badchannels = 0;
end
if ~exist('DB') | isempty (DB)
    DB = 0;
end

[chan_y chan_x chan_z] = size(chanMat);
powmax = []; % for autoscaling
powmin = []; % for autoscaling

colormap('default');
map = colormap;
size(map)
map = [[1 1 1]; map];
size(map)
for z=1:chan_z
    figure(z)
    colormap(map);
    for y=1:chan_y'
        for x=1:chan_x

            if isempty(find(badchannels==chanMat(y,x,z))), % if the channel isn't bad
                % now plot
                subplot(chan_y,chan_x,(y-1)*chan_x+x);
                %plothandles(j, i,1) = gca;
                if DB,   % decibel conversion after averaging
                    imagesc(10*log10(normMazePow(1:3:end,1:3:end,chanMat(y,x,z))));
                else
                    imagesc(normMazePow(1:3:end,1:3:end,chanMat(y,x,z)));
                end
                set(gca, 'xticklabel', [], 'yticklabel', []);
                title(['channel ' num2str(chanMat(y,x,z))]);
                if ~samescale
                    colorbar
                end
                powmax = max([max(normMazePow(:,:,chanMat(y,x,z))) powmax]);
                powmin = min([min(normMazePow(:,:,chanMat(y,x,z))) powmin]);
            end
        end
    end
end

%   gtext({'sm9603',[filebasemat(1,7) filebasemat(1,10:12)  filebasemat(1,14) filebasemat(1,17:19) '-'], 


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

