function plotpowmapsbat10(taskType,fileBaseCell,fileNameFormat,fileExt,lowCut,highCut,fOrder,chanMat,badchan,...
    saveMazePow,calcZ,percentageBool,DB,samescale,minscale,maxscale,textBool,plotRes,plot_low_thresh)
% function plotpowmapsbat10(taskType,fileBaseCell,fileNameFormat,fileExt,lowCut,highCut,fOrder,chanMat,badchan,saveMazePow,calcZ,percentageBool,DB,samescale,minscale,maxscale,textBool,plotRes,plot_low_thresh)
%
% 'pos_sum' is a 2D matrix containing the number of video frames the animals spent in each spatial position
% 'pow_sum' is a 2D by nchanMat matrix containing the sum a variable of interest (e.g. power) for each position
% 'chanMat' is a 3D matrix that determines graphical output. x,y for each z determines page layout for each figure respectively.
% 'DB' if DB=1 the variable of interes will be transformed 10*log10 after spatial smoothing before plotting
%   default = 0
% 'samescale' if samescale=1 all graphs will be scaled to the same values 'minscale' and 'maxscale'
%   default = 0
% 'calcZ' if calcZ=1 the power will be expressed as a
%   percentage of the mean power for that channel
%   default = 0
%
% plotpowmapsbat7 can plot the percentage changes in power from the mean
% rather than the raw power or the mean power (can have same scaling)

if ~exist('plot_low_thresh') | isempty(plot_low_thresh)
    plot_low_thresh = 0.1 % thresh to trim ploted values that were smeared by smoothing
end
smoothpixels = 4; % how many pixels to smooth over

if ~exist('DB') | isempty(DB)
    DB = 0;
end
if ~exist('calcZ') | isempty(calcZ)
    calcZ = 0;
end
if ~exist('percentageBool') | isempty(percentageBool)
    percentageBool = 0;
end
if ~exist('samescale') | isempty(samescale)
    samescale = 0;
end
if ~exist('badchan') | isempty(badchan)
    badchan = 0;
end
if ~exist('textBool') | isempty(textBool)
    textBool = 1;
end
if ~exist('plotRes') | isempty(plotRes)
   plotRes  = 3;
end

[chan_y chan_x chan_z] = size(chanMat);
smoothMazePowFile = [taskType '_' GetFileNamesInfo(fileBaseCell,fileNameFormat)...
    fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_SmoothMazePow.mat'];
pos_pow_sumFile = [taskType '_' GetFileNamesInfo(fileBaseCell,fileNameFormat)...
    fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_pos_pow_sumDB.mat'];
% if fileNameFormat == 0,
%     smoothMazePowFile = [taskType '_' fileBaseMat(1,[1:7 10:12 14 17:19]) '-' fileBaseMat(end,[7 10:12 14 17:19]) ...
%         fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_SmoothMazePow.mat'];
% 
%     pos_pow_sumFile = [taskType '_' fileBaseMat(1,[1:7 10:12 14 17:19]) '-' fileBaseMat(end,[7 10:12 14 17:19]) ...
%         fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_pos_pow_sumDB.mat'];
% end
% if fileNameFormat == 2,
%     smoothMazePowFile = [taskType '_' fileBaseMat(1,:) '-' fileBaseMat(end,[8:10]) ...
%         fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_SmoothMazePow.mat'];
% 
%     pos_pow_sumFile = [taskType '_' fileBaseMat(1,:) '-' fileBaseMat(end,[8:10]) ...
%         fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_pos_pow_sumDB.mat'];
% end

i = 0;
fromFile = 0;
while exist(smoothMazePowFile,'file') & ~strcmp(i,'y') & ~strcmp(i,'n') & ~strcmp(i,'') 
    i = input('Would you like to load smoothMazePowFile? [y]/n: ','s');
end
if strcmp(i,'y') | strcmp(i,'')
    fprintf('loading %s\n',smoothMazePowFile);
    load(smoothMazePowFile);
    fromFile = 1;
else
    if exist(pos_pow_sumFile,'file')
        fprintf('loading %s\n',pos_pow_sumFile);
        load(pos_pow_sumFile);
    else
        pos_pow_sumFile
        YOU_NEED_TO_RUN_calcpospowsum
    end
    fprintf('Smoothing Position\n');
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
end

powmax = [];
powmin = [];

fprintf('Plotting Channel: ');
for z=1:chan_z
    figure(z)
    clf
    %colormap('default');
    %cm = colormap;
    %load('ColorMapSean3.mat')
    %colormap(ColorMapSean3);
    for y=1:chan_y
        for x=1:chan_x
            fprintf('%i,',chanMat(y,x,z));
            if isempty(find(badchan==chanMat(y,x,z))), % if the channel isn't bad
                if ~fromFile
                    pow_sum(:,:,chanMat(y,x,z)) = (Smooth(pow_sum(:,:,chanMat(y,x,z)), smoothpixels)); % smooth power data
                    mazePow(:,:,chanMat(y,x,z)) = (pow_sum(:,:,chanMat(y,x,z))./smooth_pos_sum_nan); % average pow/pixel
                end
                
                subplot(chan_y,chan_x,(y-1)*chan_x+x);
                
                if calcZ
                    thisChanMazePow = mazePow(:,:,chanMat(y,x,z));
                    meanPowthisChan = mean(thisChanMazePow(find(~isnan(thisChanMazePow))));
                    sdPowthisChan = std(thisChanMazePow(find(~isnan(thisChanMazePow))));
                    zMazePow(:,:,chanMat(y,x,z)) = (mazePow(:,:,chanMat(y,x,z))-meanPowthisChan)./sdPowthisChan;
                    
                    [toPlotY toPlotX] = find(~isnan(zMazePow(:,:,chanMat(y,x,z))));
                    ImageScRmNaN(zMazePow(1:plotRes:end,1:plotRes:end,chanMat(y,x,z)),[minscale maxscale],[1 0 1]);
                    
                    powmax = max([max(zMazePow(:,:,chanMat(y,x,z))) powmax]);
                    powmin = min([min(zMazePow(:,:,chanMat(y,x,z))) powmin]);

                else
                    if percentageBool
                        thisChanMazePow = mazePow(:,:,chanMat(y,x,z));
                        meanPowthisChan = mean(thisChanMazePow(find(~isnan(thisChanMazePow))));
                        percentageMazePow(:,:,chanMat(y,x,z)) = mazePow(:,:,chanMat(y,x,z))./meanPowthisChan;
                        [toPlotY toPlotX] = find(percentageMazePow(:,:,chanMat(y,x,z)) > -1);
                        ImageScRmNaN(percentageMazePow(1:plotRes:end,1:plotRes:end,chanMat(y,x,z)),[minscale maxscale],[1 0 1]);
                        
                        powmax = max([max(percentageMazePow(:,:,chanMat(y,x,z))) powmax]);
                        powmin = min([min(percentageMazePow(:,:,chanMat(y,x,z))) powmin]);

                    else
                        
                        if DB % decibel conversion after averaging
                            DbMazePow(:,:,chanMat(y,x,z)) = 10*log10(mazePow(:,:,chanMat(y,x,z))); % average pow/pixel
                            [toPlotY toPlotX] = find(DbMazePow(:,:,chanMat(y,x,z)) > -1);
                            ImageScRmNaN(DbMazePow(1:plotRes:end,1:plotRes:end,chanMat(y,x,z)),[minscale maxscale],[1 0 1]);

                            powmax = max([max(DbMazePow(:,:,chanMat(y,x,z))) powmax]);
                            powmin = min([min(DbMazePow(:,:,chanMat(y,x,z))) powmin]);

                        else
                            [toPlotY toPlotX] = find(mazePow(:,:,chanMat(y,x,z)) > -1);
                            ImageScRmNaN(mazePow(1:plotRes:end,1:plotRes:end,chanMat(y,x,z)),[minscale maxscale],[1 0 1]);
                            powmax = max([max(mazePow(:,:,chanMat(y,x,z))) powmax]);
                            powmin = min([min(mazePow(:,:,chanMat(y,x,z))) powmin]);
                        end
                    end
                end
                toPlotX = [min(toPlotX)/plotRes-2 max(toPlotX)/plotRes+2];
                toPlotY = [min(toPlotY)/plotRes-2 max(toPlotY)/plotRes+2];

                set(gca, 'xlim',toPlotX,'ylim',toPlotY,'xticklabel', [], 'yticklabel', []);
                if calcZ
                    title([num2str(chanMat(y,x,z)) ': ' num2str(meanPowthisChan,3)]);
                else
                    title(['Channel: ',num2str(chanMat(y,x,z))])
                end
                if ~samescale,
                    %colorbar
                end
            end
        end
    end
end
fprintf('\n');
%for z=1:chan_z
 %   figure(z)
 %   gtext({'sm9603',[filebasemat(1,7) filebasemat(1,10:12) filebasemat(1,14) filebasemat(1,17:19) '-'], ...
if 0
 if samescale,
    for z=1:chan_z
        figure(z)
        for y=1:chan_y
            for x=1:chan_x
                if isempty(find(badchan==chanMat(y,x,z))), % if the channel isn't bad       
                    subplot(chan_y,chan_x,(y-1)*chan_x+x);
                    if ~exist('minscale', 'var') | isempty(minscale)
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
end

if saveMazePow
    outname = [tasktype '_' GetFileNamesInfo(fileBaseCell,fileNameFormat) ...
        fileExt '_' num2str(lowband) '-' num2str(highband) 'Hz_pos_pow_sum.mat'];
%     if fileNameFormat == 1,
%         ERROR_fileNameFormat_NOT_READY
%         outname = [tasktype '_' filebasemat(1,1) filebasemat(1,2:4) filebasemat(1,5) filebasemat(1,6:8) ...
%             '-' filebasemat(end,1) filebasemat(end,2:4) filebasemat(end,5) filebasemat(end,6:8)...
%             fileExt '_' num2str(lowband) '-' num2str(highband) 'Hz_pos_pow_sum.mat'];
%     end
%     if fileNameFormat == 2,
%         outname = [taskType '_' fileBaseMat(1,:) '-' fileBaseMat(end,[8:10]) ...
%             fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_SmoothMazePow.mat'];
%     end
%     if fileNameFormat == 0,
%         outname = [taskType '_' fileBaseMat(1,[1:7 10:12 14 17:19]) '-' fileBaseMat(end,[7 10:12 14 17:19]) ...
%             fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_SmoothMazePow.mat'];
%     end
    fprintf('Saving %s\n', outname);
    matlabVersion = version;
    if str2num(matlabVersion(1)) > 6
        save(outname,'-V6','mazePow');
    else
        save(outname,'mazePow');
    end
end

if textBool
    if 1
        for i=1:size(chanMat,3)
            figure(i);
            text(0,0,{[num2str(lowCut) '-' num2str(highCut) 'Hz Power'],fileExt,'',...
                    taskType,GetFileNamesInfo(fileBaseCell,fileNameFormat),...
                    '','rl,lr trials','',['forder=' num2str(fOrder)],'ssm(tsm(filt))',['ssm pix=' num2str(smoothpixels)],...
                    ['thresh=' num2str(plot_low_thresh)]})
%             if fileNameFormat == 0
%                 text(0,0,{[num2str(lowCut) '-' num2str(highCut) 'Hz Power'],fileExt,'',...
%                     taskType,fileBaseMat(1,1:6),[fileBaseMat(1,[7 10:12 14 17:19]) '-'],fileBaseMat(end,[7 10:12 14 17:19]),...
%                     '','rl,lr trials','',['forder=' num2str(fOrder)],'ssm(tsm(filt))',['ssm pix=' num2str(smoothpixels)],...
%                     ['thresh=' num2str(plot_low_thresh)]})
%             end
%             if fileNameFormat == 2
%                 text(0,0,{[num2str(lowCut) '-' num2str(highCut) 'Hz Power'],fileExt,'',...
%                     taskType,[fileBaseMat(1,1:10) '-'],fileBaseMat(end,[8:10]),...
%                     '','rl,lr trials','',['forder=' num2str(fOrder)],'ssm(tsm(filt))',['ssm pix=' num2str(smoothpixels)],...
%                     ['thresh=' num2str(plot_low_thresh)]})
%             end
%             
        end
    end
end
return
