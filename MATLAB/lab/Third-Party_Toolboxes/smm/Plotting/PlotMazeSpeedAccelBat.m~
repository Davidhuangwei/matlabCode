function PlotMazeSpeedAccelBat(tasktype,fileBaseCell,autosave,speedColorScale,accelColorScale,...
    smoothlen,plot_low_thresh,trialtypesbool,mazelocationsbool)
% function PlotMazeSpeedAccelBat(tasktype,fileBaseCell,autosave,speedColorScale,accelColorScale,...
%     smoothlen,plot_low_thresh,trialtypesbool,mazelocationsbool)
% % 'fileBaseCell' has a list of filebase names in a cell array
% 'autosave' 1=automatically save variables, default=ask before save
% 'smoothlen' is the number of points from which to create a gausian smooth to smooth position over time.
%   default = 21
% 'trialtypesbool' is a matrix determining which trial types are analysed
%   default = [1  0  1  0  0   0   0   0   0   0   0   0  0  0  0  1];
%             cr ir cl il crp irp clp ilp crb irb clb ilb xp rp lp dp
%   trial types are designated using sortatertrialtypes.m or sortcircletrialtypes.m

videoxmax = 368;
videoymax = 240;

if ~exist('plot_low_thresh') | isempty(plot_low_thresh)
    plot_low_thresh = 0.05; % thresh to trim ploted values that were smeared by smoothing
end
smoothpixels = 4; % how many pixels to smooth over


if ~exist('smoothlen','var') | isempty(smoothlen),
    smoothlen = 21; %default
end
if ~exist('fileNameFormat','var') | isempty(fileNameFormat)
    fileNameFormat = 1;
end
 if ~exist('speedColorScale','var') | isempty(speedColorScale),
   speedColorScale  = [0 110]; %default
end
 if ~exist('accelColorScale','var') | isempty(accelColorScale),
    accelColorScale = [-130 130]; %default
end
          
if ~exist('trialtypesbool','var') | isempty(trialtypesbool)
    trialtypesbool = [1  0  1  0  0   0   0   0   0   0   0   0  0];
                    %cr ir cl il crp irp clp ilp crb irb clb ilb xp
end
if ~exist('mazelocationsbool','var') | isempty(mazelocationsbool)
    mazelocationsbool = [0  0  0  1  1  1   1   1   1];
                       %rp lp dp cp ca rca lca rra lra
end

numfiles = length(fileBaseCell);
pos_sum = zeros(ceil(videoymax),ceil(videoxmax));
speed_sum = zeros(ceil(videoymax),ceil(videoxmax));
accel_sum = zeros(ceil(videoymax),ceil(videoxmax));

for i=1:numfiles
    filebase = fileBaseCell{i};
    cd(filebase)
    whldat = load([filebase '.whl']); 
    
    % calculate speed & accleration
    [speeddat acceldat] = MazeSpeedAccel(whldat,[],[],[],smoothlen);
    
    whldat = LoadMazeTrialTypes(filebase,trialtypesbool,mazelocationsbool,1);
     
    notminusones = find(whldat(:,1)~=-1);
    if size(notminusones,1) ~=0
        whldat = ceil(whldat); % bin size = 1 pixel

        accum_pos = Accumulate(whldat(notminusones,2:-1:1), 1); % accumulate the number of frames spent in each position
        [fa fb] = find(accum_pos);
        pos_sum(fa,fb) = pos_sum(fa,fb) + accum_pos(fa,fb);

        accum_speed = Accumulate(whldat(notminusones,2:-1:1), speeddat(notminusones)); % accumulate speed at each position
        speed_sum(fa,fb) = speed_sum(fa,fb) + accum_speed(fa,fb);

        accum_accel = Accumulate(whldat(notminusones,2:-1:1), acceldat(notminusones)); % accumulate accleration at each position
        accel_sum(fa,fb) = accel_sum(fa,fb) + accum_accel(fa,fb);
    else
        fprintf('\nFile: %s has no specified trials!\n',filebase)
    end
    cd ..
end 



% now smooth & plot
fprintf('Smoothing & Plotting');
smooth_pos_sum = Smooth(pos_sum, smoothpixels); % smooth position data
norm_smooth_pos_sum = smooth_pos_sum/sum(sum(smooth_pos_sum));
norm_plot_low_thresh = plot_low_thresh/sum(sum(smooth_pos_sum));
[below_thresh_indexes] = find(norm_smooth_pos_sum<=norm_plot_low_thresh);
%[above_thresh_x above_thresh_y] = find(norm_smooth_pos_sum>norm_plot_low_thresh);
smooth_pos_sum_nan = smooth_pos_sum;
smooth_pos_sum_nan(below_thresh_indexes)= NaN;


figure
clf
%load('ColorMapSean3.mat')
%colormap(ColorMapSean3);

speed_sum = (Smooth(speed_sum, smoothpixels)); % smooth power data
maze_speed = (speed_sum./smooth_pos_sum_nan); % average pow/pixel
accel_sum = (Smooth(accel_sum, smoothpixels)); % smooth power data
maze_accel = (accel_sum./smooth_pos_sum_nan); % average pow/pixel

if 0
    fprintf('Smoothing & Plotting');
    smoothSize = 10;
    smooth_pos_sum_nan = SmoothSkipNaN(pos_sum,smoothSize,0);
    speed_sum = SmoothSkipNaN(speed_sum,smoothSize,0);
    accel_sum = SmoothSkipNaN(accel_sum,smoothSize,0);
    maze_speed = (speed_sum./smooth_pos_sum_nan); % average pow/pixel
    maze_accel = (accel_sum./smooth_pos_sum_nan); % average pow/pixel
    figure
    subplot(1,2,1)
    imagesc(pos_sum)
    subplot(1,2,2)
    imagesc(smooth_pos_sum_nan)
end




if strcmp(tasktype(1:5),'Zmaze')
   maze_speed = flipud(fliplr(maze_speed));
   maze_accel = flipud(fliplr(maze_accel));
   happy = 1
elseif strcmp(tasktype(1:5),'circl')   
    maze_speed = flipud(maze_speed);
    maze_accel = flipud(maze_accel);
else
    maze_speed = maze_speed(end:-1:1,:)';
    maze_accel = maze_accel(end:-1:1,:)';
end

[toPlotY toPlotX] = find(maze_speed(:,:) > -1);
toPlotX = [min(toPlotX)-2 max(toPlotX)+2];
toPlotY = [min(toPlotY)-2 max(toPlotY)+2];

subplot(1,2,1);
ImageScRmNaN_old(maze_speed(1:end,1:end),speedColorScale,[1 0 1]);
set(gca,'xlim',toPlotX,'ylim',toPlotY,'xtick', [], 'ytick', []);
title(SaveTheUnderscores([GetFileNamesInfo(fileBaseCell) ' Speed (cm/sec)']));
%title(SaveTheUnderscores([filebasemat(1,1:6) '_' filebasemat(1,8:10) '-' filebasemat(end,8:10) ' Speed (cm/sec)']));
%if exist('speedColorScale', 'var') & ~isempty(speedColorScale)
%    set(gca, 'clim', [speedColorScale(1) speedColorScale(2)]);
%end
%colorbar

subplot(1,2,2);
ImageScRmNaN_old(maze_accel(1:end,1:end),accelColorScale,[1 0 1]);
set(gca,'xlim',toPlotX,'ylim',toPlotY,'xtick', [], 'ytick', []);

title(SaveTheUnderscores([GetFileNamesInfo(fileBaseCell) ' Acceleration (cm/sec)']));
%title(SaveTheUnderscores([filebasemat(1,1:7) filebasemat(1,8:10) '-' filebasemat(end,8:10) ' Acceleration (cm/sec)']));

%if exist('accelColorScale', 'var') & ~isempty(accelColorScale)
%    set(gca, 'clim', [accelColorScale(1) accelColorScale(2)]);
%end
%set(plothandles(chan_m, i,1), 'clim', [powmin powmax]);
%colorbar



i == 'y';
if (~exist('autosave') | autosave == 0)
    while 1,
        i = input('Save to disk (yes/no)? ', 's');
        if strcmp(i,'yes') | strcmp(i,'no'), break; end
    end
end
if i(1) == 'n'
    CountTrialTypes(fileBaseCell,0);
    return;
else
    trialsmat = CountTrialTypes(fileBaseCell,0);
        outname = [tasktype '_' GetFileNamesInfo(fileBaseCell) '_pos_speed_accel_sum.mat'];
        %outname = [tasktype '_' filebasemat(1,:) '-' filebasemat(end,8:10) '_pos_speed_accel_sum.mat'];
    set(gcf,'name',outname(1:end-4));
    
    fprintf('\nSaving %s\n', outname);
    matlabVersion = version;
    if str2num(matlabVersion(1)) > 6
        save(outname,'-V6','pos_sum','speed_sum','accel_sum','trialsmat','fileBaseCell');
    else
        save(outname,'pos_sum','speed_sum','accel_sum','trialsmat','fileBaseCell');
    end

end


    return;