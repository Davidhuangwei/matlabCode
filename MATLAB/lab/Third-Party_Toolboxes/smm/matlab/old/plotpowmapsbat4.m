function [mazepow,mazesmooth] = plotpowmapsbat4(filebasemat,nchannels,channels,lowband,highband,forder,avgfilorder,samescale,minscale,maxscale)
% 3D channels matrix determines graphical output. x,y for each z determines page layout for each figure respectively.

trialtypesbool = [1  0  1  0  0   0   0   0   0   0   0   0];
                 %cr ir cl il crp irp clp ilp crb irb clb ilb
videoxmax = 348;
videoymax = 240;
numchaninpowmat = nchannels;
plot_low_thresh = 0.1; % thresh to trim ploted values that were smeared by smoothing
smoothpixels = 4; % how many pixels to smooth over

powmax = NaN;
powmin = NaN;
smoothmax = NaN;
smoothmin = NaN;
[numfiles n] = size(filebasemat);
[chan_y chan_x chan_z] = size(channels);  
pos_sum = zeros(ceil(videoxmax),ceil(videoymax));
pow_sum = zeros(ceil(videoxmax),ceil(videoymax), nchannels);

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
    if exist([filebase '_' num2str(lowband) '-' num2str(highband) '_Hz_sm_power.mat'],'file'),
        fprintf('Loading %s,\n',[filebase '_' num2str(lowband) '-' num2str(highband) '_Hz_sm_power.mat']);
        load([filebase '_' num2str(lowband) '-' num2str(highband) '_Hz_sm_power.mat']);
        if (lowband==6 & highband==14)
            powerdat = thetapower1;
            [tpm numchaninpowmat] = size(thetapower1);
            clear thetapower1;
        end
        if (lowband==30 & highband==80)
            powerdat = gammapower1;
            [tpm numchaninpowmat] = size(gammapower1);
            clear gammapower1;
        end
        
    else
       error_no_power_mat_file
    end
      
    notminusones = find(whldat(:,1)~=-1);
    whldat = ceil(whldat);
    
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
                fprintf('%d,', channels(y,x,z));
                
                accum_pow = Accumulate(whldat(notminusones,1:2), avepowerdat(notminusones,channels(y,x,z))); %accumulate the power for each position
                pow_sum(fa,fb,channels(y,x,z)) = pow_sum(fa,fb,channels(y,x,z)) + accum_pow(fa,fb);
            end
        end
    end
end 

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
            
            pow_sum(:,:,channels(y,x,z)) = (Smooth(pow_sum(:,:,channels(y,x,z)), smoothpixels)); % smooth power data
            
            mazepow(:,:,channels(y,x,z)) = (pow_sum(:,:,channels(y,x,z))./smooth_pos_sum_nan); % average pow/pixel
            
            % now plot
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
        end
    end
end
if samescale,
    for z=1:chan_z
        figure(z)
        for y=1:chan_y
            for x=1:chan_x
                subplot(chan_y,chan_x,(y-1)*chan_x+x);
                set(gca, 'clim', [minscale maxscale]);
                %set(plothandles(chan_m, i,1), 'clim', [powmin powmax]);
                colorbar
            end
        end
    end
end
return