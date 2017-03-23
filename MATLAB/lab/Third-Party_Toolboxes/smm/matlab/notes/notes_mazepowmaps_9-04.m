function plotpowmapsbatNormByControl(normMazePow,chanMat,badchannels,samescale,scaleBounds)

samescale = 1;
scaleBounds = [0.5 1.5];

if ~exist('samescale','var')
    samescale = 0;
end
if ~exist('badchannels','var')
    badchannels = 0;
end

[chan_y chan_x chan_z] = size(chanMat);
powmax = []; % for autoscaling
powmin = []; % for autoscaling


for z=1:chan_z
    figure(z)
    for y=1:chan_y'
        for x=1:chan_x

            if isempty(find(badchannels==chanMat(y,x,z))), % if the channel isn't bad
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

