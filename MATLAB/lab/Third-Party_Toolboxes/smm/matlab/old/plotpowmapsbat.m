function [mazepow,mazesmooth] = plotpowmapsbat(filebasemat,nchannels,channels,lowband,highband,forder,avgfilorder,binsize,numbinsmooth,smooth,samescale,minscale,maxscale)
% 3D channels matrix determines graphical output. x,y for each z determines page layout for each figure respectively.

videoxmax = 348;
videoymax = 240;
powmax = NaN;
powmin = NaN;
smoothmax = NaN;
smoothmin = NaN;
[numfiles n] = size(filebasemat);
[chan_y chan_x chan_z] = size(channels);
pow_sum = zeros(ceil(videoxmax/binsize),ceil(videoymax/binsize));
pos_sum = zeros(ceil(videoxmax/binsize),ceil(videoymax/binsize));
%plothandles = zeros(chan_m,chan_n,2);
for z=1:chan_z
    figure(z)
    for y=1:chan_y
        for x=1:chan_x
            % accumulate power and positional info from each file
            for i=1:numfiles
                filebase = filebasemat(i,:);
                whldat = load([filebase '.whl']);
                inname = [filebase '.eeg'];
                fprintf('File: %s, Channel %d: ',filebase, channels(y,x,z));
                powdat = happyfilter(inname,nchannels,channels(y,x,z),lowband,highband,forder,avgfilorder);
                powdat = avedownsize(powdat, whldat); % average powdat to the size of whldat
                if (size(powdat)~=size(whldat)),
                    error_powdat_whldat_not_same_size
                end
                notminusones = find(whldat(:,1)~=-1);
                whldat = ceil(whldat./binsize);
                
                accum_pos = Accumulate(whldat(notminusones,1:2), 1); % accumulate the number of frames spent in each position
                [fa fb] = find(accum_pos);
                pos_sum(fa,fb) = pos_sum(fa,fb) + accum_pos(fa,fb);
                
                accum_pow = Accumulate(whldat(notminusones,1:2), powdat(notminusones)); %accumulate the power for each position
                pow_sum(fa,fb) = pow_sum(fa,fb) + accum_pow(fa,fb);

            end
            
            % calculate the average power for each position
            zerosum = find(pos_sum==0);
            [fa fb] = find(pos_sum); % we'll get rid of positions that were outside the rat's trajectory
            pos_sum(zerosum)= NaN;
            mazepow = pow_sum(min(fa):max(fa),min(fb):max(fb))./pos_sum(min(fa):max(fa),min(fb):max(fb)); 
            
            pow_sum = zeros(ceil(videoxmax/binsize),ceil(videoymax/binsize));
            pos_sum = zeros(ceil(videoxmax/binsize),ceil(videoymax/binsize));
            %clear pow_sum;
            %clear pos_sum;
            
            %now smooth
            [mpm mpn] = size(mazepow);
            mazesmooth = mazepow;
            tempmat = zeros(numbinsmooth, numbinsmooth);   
            for a=numbinsmooth:mpm
                for b=numbinsmooth:mpn
                    if ~isnan(mazepow(a,b)),
                        tempmat = mazepow((a-(numbinsmooth-1)):a, (b-(numbinsmooth-1)):b);
                        mazesmooth(a,b) = mean(tempmat(find(~isnan(tempmat))));
                    end
                end
            end


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
                    set(gca, 'clim', [minscale maxscale]);
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
return