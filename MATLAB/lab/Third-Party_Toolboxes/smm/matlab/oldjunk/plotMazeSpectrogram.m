function plotMazeSpectrogram(taskType,chanMat,badchan,WinLength,NW,percentageBool,fileNameFormat,dbScale,samescale,minscale,maxscale,smoothFreq,smoothPos,plot_low_thresh)

if fileNameFormat == 2,
    fileName = [taskType '_' fileBaseMat(1,:) '-' fileBaseMat(end,8:10) ...
        fileext '_MazeSpectrogram_Win' num2str(WinLength) '_NW' num2str(NW) '.mat'];
end

if exist(fileName,'file')
    load(fileName)
else
    YOU_NEED_TO_RUN_CalcMazeSpectrogram
end

macalcSmooth = 1;
xFreq = 120;
freqIndexes = find(f<=maxFreq);


if ~exist('plot_low_thresh') | isempty(plot_low_thresh)
    plot_low_thresh = 0.1; % thresh to trim plotted values that were smeared by smoothing
end
if ~exist('samescale') | isempty(samescale)
    samescale = 0;
end
if ~exist('badchan') | isempty(badchan)
    badchan = 0;
end
if ~exist('smoothFreq') | isempty(smoothFreq)
    smoothFreq = 0;
end
if ~exist('smoothPos') | isempty(smoothPos)
    smoothPos = 4;
end



%[nFreq nPos nChan] = size(sumYFreqPos);

if calcSmooth
    fprintf('\nSmoothing Position...');
    smooth_pos_sum = Smooth(sumNperPos, [smoothPos]); % smooth position data
    norm_smooth_pos_sum = smooth_pos_sum/sum(sum(smooth_pos_sum));
    norm_plot_low_thresh = plot_low_thresh/sum(sum(smooth_pos_sum));
    [below_thresh_indexes] = find(norm_smooth_pos_sum<=norm_plot_low_thresh);
    %[above_thresh_x above_thresh_y] = find(norm_smooth_pos_sum>norm_plot_low_thresh);
    smooth_pos_sum_nan = smooth_pos_sum;
    smooth_pos_sum_nan(below_thresh_indexes)= NaN;
else
    sumNperPos(find(sumNperPos==0)) = NaN;
end

powmax = [];
powmin = [];

[chan_y chan_x chan_z] = size(chanMat);

fprintf('\nSmoothing & Plotting Channels:');
for z = 1:chan_z
    figure(z)
    clf
    colormap('default');
    cm = colormap;
    colormap([[1 1 1]; cm]);
    for y = 1:chan_y
        for x=1:chan_x
            if isempty(find(badchan==chanMat(y,x,z))), % if the channel isn't bad
                fprintf('%i,',chanMat(y,x,z));
                if calcSmooth
                    smoothAveYFreqPos = Smooth(squeeze(sumYFreqPos(freqIndexes,:,chanMat(y,x,z))),[smoothPos, smoothFreq]); % smooth power data
                    mazeSpectrogram = smoothAveYFreqPos./repmat(smooth_pos_sum_nan',[length(freqIndexes),1]);
                else
                    mazeSpectrogram = squeeze(sumYFreqPos(freqIndexes,:,chanMat(y,x,z)))./repmat(sumNperPos',[length(freqIndexes),1]);
                end
                    
                if percentageBool
                    meanMazeSpectrogram = mean(mazeSpectrogram(:,find(~isnan(mazeSpectrogram(1,:)))),2);
                    [m n] = size(mazeSpectrogram);
                    mazeSpectrogram = mazeSpectrogram./repmat(meanMazeSpectrogram,1,n);
                elseif dbScale == 1
                    mazeSpectrogram = 10.*log10(mazeSpectrogram);
                end
                
                % get rid of excess white space between maze regions
                closestNaNs = find(isnan(mazeSpectrogram(1,1:100-1)));
                lastExp = find(~isnan(mazeSpectrogram(1,1:closestNaNs(end))));
                closestNaNs = find(isnan(mazeSpectrogram(1,1:275-1)));
                lastRet = find(~isnan(mazeSpectrogram(1,1:closestNaNs(end))));
                closestNaNs = find(isnan(mazeSpectrogram(1,1:400-1)));
                lastDP = find(~isnan(mazeSpectrogram(1,1:closestNaNs(end))));
                closestNaNs = find(isnan(mazeSpectrogram(1,1:550-1)));
                lastCA = find(~isnan(mazeSpectrogram(1,1:closestNaNs(end))));
                closestNaNs = find(isnan(mazeSpectrogram(1,1:600-1)));
                lastCP = find(~isnan(mazeSpectrogram(1,1:closestNaNs(end))));
                closestNaNs = find(isnan(mazeSpectrogram(1,1:750-1)));
                lastRew = find(~isnan(mazeSpectrogram(1,1:closestNaNs(end))));
                closestNaNs = find(isnan(mazeSpectrogram(1,1:end)));
                lastWP = find(~isnan(mazeSpectrogram(1,1:closestNaNs(end))));
                
                if 1
                    spacer = 3;
                posIndexes = [1:lastExp(end)+spacer max(100,lastExp(end)+spacer):lastRet(end)+spacer max(275,lastRet(end)+spacer):lastDP(end)+spacer ...
                    max(400,lastDP(end)+spacer):lastCA(end)+spacer max(550,lastCA(end)+spacer):lastCP(end)+spacer max(600,lastCP(end)+spacer):lastRew(end)+spacer ...
                    max(750,lastRew(end)+spacer):lastWP(end)];
                else
                    posIndexes = 1:800;
                end
                
                mazeSpectrogram = mazeSpectrogram(:,posIndexes);
                
                subplot(chan_y,chan_x,(y-1)*chan_x+x);
                imagesc(posIndexes,f(freqIndexes),mazeSpectrogram(:,:));
                title(['Channel: ' num2str(chanMat(y,x,z))]);
                if ~samescale,
                    colorbar
                end
                powmax = max([max(max(mazeSpectrogram)) powmax]);
                powmin = min([min(min(mazeSpectrogram)) powmin]);
            end
        end
    end
end

fprintf('\nScaling...\n');
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

for i=1:size(chanMat,3)
    figure(i);
    text(-0,0,{fileBaseMat(1,1:6),[fileBaseMat(1,8:10) '-' fileBaseMat(end,8:10)],'rl,lr trials',tasktype,...
        'xp removed','',fileext,'red=center','green=chcpnt','gray=rewarm','blue=retarm','gold=rewports',...
        'cyan=delayports','','mtcsd','nOverlap=0',['window=' num2str(WinLength)],['NW=' num2str(NW)],...
        'One segment','per region','per trial'})
end

