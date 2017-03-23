function [mazepow,mazesmooth] = plotpowmapsbat2(filebasemat,nchannels,channels,lowband,highband,forder,avgfilorder,binsize,numbinsmooth,smooth,samescale,minscale,maxscale)
% 3D channels matrix determines graphical output. x,y for each z determines page layout for each figure respectively.

trialtypesbool = [1  0  1  0  0   0   0   0   0   0   0   0];
                 %cr ir cl il crp irp clp ilp crb irb clb ilb
videoxmax = 348;
videoymax = 240;
numchaninpowmat = nchannels;

powmax = NaN;
powmin = NaN;
smoothmax = NaN;
smoothmin = NaN;
[numfiles n] = size(filebasemat);
[chan_y chan_x chan_z] = size(channels);  
pos_sum = zeros(ceil(videoxmax/binsize),ceil(videoymax/binsize));
pow_sum = zeros(ceil(videoxmax/binsize),ceil(videoymax/binsize), nchannels);

numtrials = 0; % for counting trials

for i=1:numfiles

    filebase = filebasemat(i,:);
    fprintf('\nFile: %s,\n',filebase);
    whldat = load([filebase '.whl']);
    inname = [filebase '.eeg'];
    if exist([filebase '_whl_indexes.mat'],'file'),
        fprintf('Including: ');
        load([filebase '_whl_indexes.mat']);
        included = [];
        if trialtypesbool(1), 
            included = [included correctright];
            numtrials = numtrials + cr;
            fprintf('cr n=%i, ', cr);
        end
        if trialtypesbool(2), 
            included = [included incorrectright];
            numtrials = numtrials + ir;
            fprintf('ir n=%i, ', ir);
        end
        if trialtypesbool(3), 
            included = [included correctleft];
            numtrials = numtrials + cl;
            fprintf('cl n=%i, ', cl);
        end
        if trialtypesbool(4), 
            included = [included incorrectleft];
            numtrials = numtrials + il;
            fprintf('il n=%i, ', il);
        end
        if trialtypesbool(5), 
            included = [included pondercorrectright];
            numtrials = numtrials + crp;
            fprintf('crp n=%i, ', crp);
        end
        if trialtypesbool(6), 
            included = [included ponderincorrectright];
            numtrials = numtrials + irp;
            fprintf('irp n=%i, ', irp);
        end
        if trialtypesbool(7), 
            included = [included pondercorrectleft];
            numtrials = numtrials + clp;
            fprintf('clp n=%i, ', clp);
        end
        if trialtypesbool(8), 
            included = [included ponderincorrectleft];
            numtrials = numtrials + ilp;
            fprintf('ilp n=%i, ', ilp);
        end
        if trialtypesbool(9), 
            included = [included badcorrectright];
            numtrials = numtrials + crb;
            fprintf('crb n=%i, ', crb);
        end
        if trialtypesbool(10), 
            included = [included badincorrectright];
            numtrials = numtrials + irb;
            fprintf('irb n=%i, ', irb);
        end
        if trialtypesbool(11), 
            included = [included badcorrectleft];
            numtrials = numtrials + clb;
            fprintf('clb n=%i, ', clb);
        end
        if trialtypesbool(12), 
            included = [included badincorrectleft];
            numtrials = numtrials + ilb;
            fprintf('ilb n=%i, ', ilb);
        end
        fprintf('total n=%i\n', numtrials);
        includedwhldat = -1*ones(size(whldat));
        includedwhldat(included,:) = whldat(included,:);
        whldat = includedwhldat;
    end
    if exist([filebase '_' num2str(lowband) '-' num2str(highband) '_Hz_power.mat'],'file'),
        fprintf('Loading %s,\n',[filebase '_' num2str(lowband) '-' num2str(highband) '_Hz_power.mat']);
        load([filebase '_' num2str(lowband) '-' num2str(highband) '_Hz_power.mat']);
        if (lowband==6 & highband==14)
            powerdat = thetapower;
            [tpm numchaninpowmat] = size(thetapower);
            clear thetapower;
        end
        if (lowband==30 & highband==80)
            powerdat = gammapower;
            [tpm numchaninpowmat] = size(gammapower);
            clear gammapower;
        end
        
    else
       error_no_power_mat_file
    end
      
    notminusones = find(whldat(:,1)~=-1);
    whldat = ceil(whldat./binsize);
    
    accum_pos = Accumulate(whldat(notminusones,1:2), 1); % accumulate the number of frames spent in each position
    [fa fb] = find(accum_pos);
    pos_sum(fa,fb) = pos_sum(fa,fb) + accum_pos(fa,fb);
    
    [whlm n] = size(whldat);
    avepowerdat = zeros(whlm, numchaninpowmat);
    for j=1:numchaninpowmat
        avepowerdat(:,j) = avedownsize(powerdat(:,j), whldat); % average powdat to the size of whldat
    end
    clear powerdat;
 
    %plothandles = zeros(chan_m,chan_n,2);
    fprintf('Channels: ');
    for z=1:chan_z
        for y=1:chan_y
            for x=1:chan_x
                % accumulate power info for each channel into a spatial map
                fprintf('%d, ', channels(y,x,z));
                
                accum_pow = Accumulate(whldat(notminusones,1:2), avepowerdat(notminusones,channels(y,x,z))); %accumulate the power for each position
                pow_sum(fa,fb,channels(y,x,z)) = pow_sum(fa,fb,channels(y,x,z)) + accum_pow(fa,fb);
            end
        end
    end
end 

% calculate the average power for each position
zerosum = find(pos_sum==0);
[fa fb] = find(pos_sum); % we'll get rid of positions that were outside the rat's trajectory
pos_sum(zerosum)= NaN;
for z=1:chan_z
    figure(z)
    for y=1:chan_y
        for x=1:chan_x
            mazepow(:,:,channels(y,x,z)) = pow_sum(min(fa):max(fa),min(fb):max(fb),channels(y,x,z))./pos_sum(min(fa):max(fa),min(fb):max(fb)); 
           
            %now smooth
            [mpm mpn] = size(mazepow(:,:,channels(y,x,z)));
            mazesmooth(1:(mpm-(numbinsmooth-1)),1:(mpn-(numbinsmooth-1)),channels(y,x,z)) = NaN;
            tempmat = zeros(numbinsmooth, numbinsmooth);   
            for a=numbinsmooth:mpm
                for b=numbinsmooth:mpn
                    if ~isnan(mazepow(a,b,channels(y,x,z))),
                        tempmat = mazepow((a-(numbinsmooth-1)):a, (b-(numbinsmooth-1)):b,channels(y,x,z));
                        mazesmooth(a-(numbinsmooth-1),b-(numbinsmooth-1),channels(y,x,z)) = mean(tempmat(find(~isnan(tempmat))));
                    end
                end
            end 
            % now plot
            if ~smooth,
                subplot(chan_y,chan_x,(y-1)*chan_x+x);
                %plothandles(j, i,1) = gca;
                imagesc(mazepow(:,:,channels(y,x,z)));
                set(gca, 'xticklabel', [], 'yticklabel', []);
                title(['channel ' num2str(channels(y,x,z))]);
                if ~samescale,
                    colorbar
                end
                powmax = max([max(mazepow(:,:,channels(y,x,z))) powmax]);
                powmin = min([min(mazepow(:,:,channels(y,x,z))) powmin]);
            else
                subplot(chan_y,chan_x,(y-1)*chan_x+x);
                %plothandles(j, i,2) = gca;
                imagesc(mazesmooth(:,:,channels(y,x,z)));
                if ~samescale,
                    colorbar    
                end
                set(gca, 'xticklabel', [], 'yticklabel', []);
                title(['channel ' num2str(channels(y,x,z))]);
                smoothmax = max([max(mazesmooth(:,:,channels(y,x,z))) smoothmax]); 
                smoothmin = min([min(mazesmooth(:,:,channels(y,x,z))) smoothmin]);
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