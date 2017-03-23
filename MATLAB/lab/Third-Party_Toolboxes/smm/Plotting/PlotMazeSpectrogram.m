function PlotMazeSpectrogram(taskType,fileBaseMat,fileext,fileNameFormat,chanMat,badchan,WinLength,NW,percentageBool,multByF,dbBool,colorLimits,freqRange,smoothPos,plot_low_thresh)


if ~exist('plot_low_thresh') | isempty(plot_low_thresh)
    plot_low_thresh = .1; % thresh to trim plotted values that were smeared by smoothing
end
if ~exist('dbBool') | isempty(dbBool)
   dbBool = 1; 
end
if ~exist('samescale') | isempty(samescale)
    samescale = 0;
end
if ~exist('badchan') | isempty(badchan)
    badchan = 0;
end
if ~exist('smoothFreq') | isempty(smoothFreq)
    smoothFreq = 0.1;
end
if ~exist('smoothPos') | isempty(smoothPos)
    smoothPos = 2;
end
if ~exist('colorLimits') | isempty(colorLimits)
    colorLimits = [];
end
if ~exist('freqRange') | isempty(freqRange)
    freqRange = [0.01 120];
end

DB = '';
%if dbBool
%    DB = '_DB';
%end
if fileNameFormat == 0,
    fileName = [taskType '_' fileBaseMat(1,7) fileBaseMat(1,10:12) fileBaseMat(1,14) fileBaseMat(1,17:19) ...
        '-' fileBaseMat(end,7) fileBaseMat(end,10:12) fileBaseMat(end,14) fileBaseMat(end,17:19) ...
        fileext '_MazeSpectrogram_Win' num2str(WinLength) '_NW' num2str(NW) DB '.mat'];
end
if fileNameFormat == 1,
    fileName = [taskType '_' fileBaseMat(1,1:8) ...
        '-' fileBaseMat(end,1:8) ...
        fileext '_MazeSpectrogram_Win' num2str(WinLength) '_NW' num2str(NW) DB '.mat'];
end
if fileNameFormat == 2,
    fileName = [taskType '_' fileBaseMat(1,:) '-' fileBaseMat(end,8:10) ...
        fileext '_MazeSpectrogram_Win' num2str(WinLength) '_NW' num2str(NW) DB '.mat'];
end

if exist(fileName,'file')
    fprintf('\nloading: %s',fileName);
    load(fileName);
else
    fprintf('\nNo such file: %s\n',fileName);

    YOU_NEED_TO_RUN_CalcMazeSpectrogram
end

freqIndexes = find(fo>=0.01 & fo<=120);
mazeRegionsToPlot = [1 1 1 1 1 1 1];
spacer = 3;

fullSumNPerPos = [];
fullSumFreqPos = [];
mazeRegionBreaks = [];
% position data from different maze regions are concatenated for smoothing
mazeRegionNames = fieldnames(sumPerPosStruct);
for i=1:size(mazeRegionNames,1)
    if mazeRegionsToPlot(i)
        fullSumNPerPos = cat(1,fullSumNPerPos, getfield(sumPerPosStruct,mazeRegionNames{i},'nPerPos'));
        fullSumFreqPos = cat(2,fullSumFreqPos, getfield(sumPerPosStruct,mazeRegionNames{i},'yFreqPos'));
        mazeRegionBreaks = [mazeRegionBreaks size(fullSumNPerPos,1)];
    end
end

% spectrum data from different maze regions are concatenated for smoothing

if smoothPos ~= 0
    fprintf('\nSmoothing Position...');
    smooth_pos_sum = Smooth(fullSumNPerPos, [smoothPos]); % smooth position data
    norm_smooth_pos_sum = smooth_pos_sum/sum(sum(smooth_pos_sum));
    norm_plot_low_thresh = plot_low_thresh/sum(sum(smooth_pos_sum));
    [below_thresh_indexes] = find(norm_smooth_pos_sum<=norm_plot_low_thresh);
    %[above_thresh_x above_thresh_y] = find(norm_smooth_pos_sum>norm_plot_low_thresh);
    smooth_pos_sum_nan = smooth_pos_sum;
    smooth_pos_sum_nan(below_thresh_indexes)= NaN;
else
    fullSumNPerPos(find(fullSumNPerPos==0)) = NaN;
end    

powmax = [];
powmin = [];

[chan_y chan_x chan_z] = size(chanMat);

fprintf('\nSmoothing & Plotting Channels:');
for z = 1:chan_z
    figure(z)
    clf
%    load('ColorMapSean3.mat')
 %   colormap(ColorMapSean3);
    for y = 1:chan_y
        for x=1:chan_x
            if isempty(find(badchan==chanMat(y,x,z))), % if the channel isn't bad
                fprintf('%i,',chanMat(y,x,z));
                %keyboard
                if smoothPos ~=0
                    smoothAveYFreqPos = Smooth(squeeze(fullSumFreqPos(freqIndexes,:,chanMat(y,x,z))),[smoothPos, smoothFreq]); % smooth power data
                    fullMazeSpectrogram = smoothAveYFreqPos./repmat(smooth_pos_sum_nan',[length(freqIndexes),1]);
                else
                    fullMazeSpectrogram = squeeze(fullSumFreqPos(freqIndexes,:,chanMat(y,x,z)))./repmat(fullSumNPerPos',[length(freqIndexes),1]);
                end

                
                %fullMazeSpectrogram(:,end-2:end) = [];
                
                if percentageBool
                    meanFullMazeSpectrogram = mean(fullMazeSpectrogram(:,find(~isnan(fullMazeSpectrogram(1,:)))),2);
                    %if dbBool
                        %fullMazeSpectrogram = fullMazeSpectrogram - repmat(meanFullMazeSpectrogram,1,size(fullMazeSpectrogram,2));
                    %else
                        fullMazeSpectrogram = fullMazeSpectrogram./repmat(meanFullMazeSpectrogram,1,size(fullMazeSpectrogram,2));
                    %end
                else
                    if multByF>0
                        fullMazeSpectrogram = fullMazeSpectrogram.*repmat((fo(freqIndexes).^multByF),[1 size(fullMazeSpectrogram,2)]);
                    end
                    %keyboard
                    %fullMazeSpectrogram = 10.*log10(fullMazeSpectrogram);
                end
               
                if dbBool
                    fullMazeSpectrogram = 10.*log10(fullMazeSpectrogram);
                end
                % put spaces in between maze regions
                for i=1:length(mazeRegionBreaks)-1
                    fullMazeSpectrogram = [fullMazeSpectrogram(:,1:mazeRegionBreaks(i)+(i-1)*spacer) NaN*zeros(size(fullMazeSpectrogram,1),spacer) fullMazeSpectrogram(:,mazeRegionBreaks(i)+1+(i-1)*spacer:end)];
                end

                subplot(chan_y,chan_x,(y-1)*chan_x+x);
                ImageScRmNaN2(1:size(fullMazeSpectrogram,2),fo(freqIndexes),fullMazeSpectrogram,colorLimits,[1 0 1]);
                title(['Channel: ' num2str(chanMat(y,x,z))]);
                set(gca,'ylim',freqRange);
                                %if ~samescale,
                %    try, colorbar, catch, end
                %end
                %powmax = max([max(max(mazeSpectrogram(~isnan(mazeSpectrogram)))) powmax]);
                %powmin = min([min(min(mazeSpectrogram(~isnan(mazeSpectrogram)))) powmin]);
            end
        end
    end
end
fprintf('\n')
for i=1:size(chanMat,3)
    figure(i);
    set(gcf,'name',['Spectrogram_' taskType fileext '_Win' num2str(WinLength) '_NW' num2str(NW)]);
    yLimits = get(gca,'ylim');
    xLimits = get(gca,'xlim');
    if fileNameFormat == 0
        text(yLimits(1)-100,yLimits(2)-100,{fileBaseMat(1,[7 10:12 14 17:19]),fileBaseMat(1,1:6),[fileBaseMat(1,8:10) '-' fileBaseMat(end,8:10)],'rl,lr trials',taskType,...
            '',fileext,'Position','Spectrogram','','mtcsd','nOverlap=0',['window=' num2str(WinLength)],['NW=' num2str(NW)],...
            '',['multByF=' num2str(multByF)],['Decibell=' num2str(dbBool)],['smoothFreq=' num2str(smoothFreq)],...
            ['smoothPos=' num2str(smoothPos)]})
    end
    if fileNameFormat == 1
        text(yLimits(1)-100,yLimits(2)-100,{fileBaseMat(1,1:8), ['-' fileBaseMat(end,1:8)],'rl,lr trials',taskType,...
            '',fileext,'Position','Spectrogram','','mtcsd','nOverlap=0',['window=' num2str(WinLength)],['NW=' num2str(NW)],...
            '',['multByF=' num2str(multByF)],['Decibell=' num2str(dbBool)],['smoothFreq=' num2str(smoothFreq)],...
            ['smoothPos=' num2str(smoothPos)]})
    end

    if fileNameFormat == 2
        text(yLimits(1)-100,yLimits(2)-100,{fileBaseMat(1,1:6),[fileBaseMat(1,8:10) '-' fileBaseMat(end,8:10)],'rl,lr trials',taskType,...
            '',fileext,'Position','Spectrogram','','mtcsd','nOverlap=0',['window=' num2str(WinLength)],['NW=' num2str(NW)],...
            '',['multByF=' num2str(multByF)],['Decibell=' num2str(dbBool)],['smoothFreq=' num2str(smoothFreq)],...
            ['smoothPos=' num2str(smoothPos)]})
    end
end


return

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
                    try, colorbar, catch, end 
                end
            end
        end
    end
end

