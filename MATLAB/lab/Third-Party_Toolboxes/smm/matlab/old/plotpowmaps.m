function plotpowmaps(filebase,nchannels,channels,lowband,highband,forder,avgfilorder,binsize,numbinsmooth,smooth,samescale,minscale,maxscale)
% 3D channels matrix determines graphical output. x,y for each z determines page layout for each figure respectively.

powmax = NaN;
powmin = NaN;
smoothmax = NaN;
smoothmin = NaN;

whldat = load([filebase '.whl']);
inname = [filebase '.eeg'];
[chan_y chan_x chan_z] = size(channels);
%plothandles = zeros(chan_m,chan_n,2);
for z=1:chan_z
    figure(z)
    for y=1:chan_y
        for x=1:chan_x
            fprintf('Channel %d: ', channels(y,x,z));
            powdat = happyfilter(inname,nchannels,channels(y,x,z),lowband,highband,forder,avgfilorder);
            avepowdat = avedownsize(powdat, whldat); % average powdat to the size of whldat
            [mazepow, mazesmooth] = mazepowmap3(avepowdat, whldat, binsize, numbinsmooth, 0);
            if ~smooth,
                subplot(chan_y,chan_x,(y-1)*chan_x+x);
                %plothandles(j, i,1) = gca;
                imagesc(mazepow)
                set(gca, 'xticklabel', [], 'yticklabel', []);
                title(['channel ' num2str(channels(y,x,z))]);
                if ~samescale,
                    colorbar
                end
                powmax = max([max(mazepow) powmax]);
                powmin = min([min(mazepow) powmin]);
            else
                subplot(chan_y,chan_x,(y-1)*chan_x+x);
                %plothandles(j, i,2) = gca;
                imagesc(mazesmooth)
                if ~samescale,
                    colorbar    
                end
                set(gca, 'xticklabel', [], 'yticklabel', []);
                title(['channel ' num2str(channels(y,x,z))]);
                smoothmax = max([max(mazesmooth) smoothmax]); 
                smoothmin = min([min(mazesmooth) smoothmin]);
            end
        end
    end
end

if samescale,
    for z=1:chan_z
        figure(z)
        for y=1:chan_y
            for x=1:chan_x
                if ~smooth,
                    subplot(chan_y,chan_x,(y-1)*chan_x+x);
                    set(gca, 'clim', [powmin maxscale]);
                    %set(plothandles(chan_m, i,1), 'clim', [powmin powmax]);
                    colorbar
                else
                    subplot(chan_y,chan_x,(y-1)*chan_x+x);
                    set(gca, 'clim', [minscale maxscale]);
                    %set(plothandles(chan_m, i,2), 'clim', [smoothmin smoothmax]);
                    colorbar
                end
            end
        end
    end
end