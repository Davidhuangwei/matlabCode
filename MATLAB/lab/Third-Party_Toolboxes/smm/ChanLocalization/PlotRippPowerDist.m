function PlotRippPowerDist(fileBaseCell,fileName,eegExt,varargin)

chanInfoDir = 'ChanInfo/';
eegChanMat = LoadVar([chanInfoDir 'ChanMat.eeg.mat']);
%nVertChan = size(chanMat,1);
offset = load([chanInfoDir 'Offset' eegExt '.txt']);

[firstFig,plotSize,offset,colorLimits] = DefaultArgs(varargin,...
    {1,[10 8],offset,[]});

        selectedSegs = [];
        for j=1:length(fileBaseCell)
            fileBase = fileBaseCell{j};
            inName = [fileBase '/' fileName eegExt '.mat'];
            fprintf('Loading: %s\n',inName)
            load(inName);

            try
                selectedTrials = zeros(length(taskType),1);
                selectedTrials = selectedTrials | ...
                    (strcmp(trialDesigCell{i,1},taskType) & trialType*trialDesigCell{i,2}'>trialDesigCell{i,3}...
                    & mazeRegion*trialDesigCell{i,4}'>trialDesigCell{i,5});
                selectedTrials = find(selectedTrials);
                selectedSegs = cat(3,selectedSegs,segs(:,:,selectedTrials));
            catch
                fprintf('Trial Designation Failed. All Segs Included.\n')
                selectedSegs = cat(3,selectedSegs,segs);
            end
        end
        try sampRate = getfield(infoStruct,'sampRate');
        catch
            sampRate = getfield(infoStruct,'eegSamp');
        end
        freqRange = getfield(infoStruct,'rippFiltFreqRange');
        chanMat = LoadVar([chanInfoDir 'ChanMat' eegExt '.mat']);
        chansPerShank = size(chanMat,1);
        nShanks = size(chanMat,2);
        badChan = load([chanInfoDir 'BadChan' eegExt '.txt']);
        %         chansPerShank = getfield(infoStruct,'chansPerShank');
        %         nShanks  = getfield(infoStruct,'nShanks');
        %         badChan = getfield(infoStruct,'badChans');
%         eegSamp = getfield(infoStruct,'eegSamp');
        segLen = getfield(infoStruct,'segLen');
 firfiltb = fir1(odd(sampRate*10/freqRange(1))+1,[freqRange(1)/sampRate*2,freqRange(2)/sampRate*2]);
% for j=1:size(selectedSegs,1)
% filtSegs(j,:,:) = filter0(firfiltb,squeeze(selectedSegs(j,:,:)));
% end
for j=1:size(selectedSegs,1)
    rippPow(j) = 10.*log10(mean(mean(filter0(firfiltb,squeeze(selectedSegs(j,:,:))).^2,1),2));
end
figure(firstFig)
clf
set(gcf,'name',['RippPower_' fileName eegExt])
% keyboard
try interpData = InterpLinExtrapNear(rippPow',chanMat,badChan,1)';
catch interpData = InterpLinExtrapNear(rippPow',chanMat,badChan,0)';
end
colormap(LoadVar('ColorMapSean6.mat'));
pcolor(1:size(chanMat,2)',-1:-1:-size(chanMat,1)',Make2DPlotMat(interpData,chanMat))
shading interp
PlotAnatCurves([chanInfoDir 'AnatCurves.mat'],[-size(eegChanMat,1) size(eegChanMat,2)],[-0.5+offset(1) 0.5+offset(2)]);
% imagesc(Make2DPlotMat(rippPow,chanMat,badChan))
% PlotAnatCurvesNew([chanInfoDir 'AnatCurvesNew.mat'],size(chanMat),0.5-offset);
set(gca,'xtick',[1:size(chanMat,2)],'ytick',[-size(chanMat,1):-1])
set(gca,'xtick',[1:size(chanMat,2)],'ytick',[-size(chanMat,1):-1])
%set(gca,'yticklabel',abs([-size(chanMat,1):-1]));
PlotGrid
        set(gcf,'PaperPosition',[(8.5-plotSize(1))/2,(11-plotSize(2))/2,plotSize(1),plotSize(2)]);
set(gcf, 'Units', 'inches')
set(gcf, 'Position', [(8.5-plotSize(1))/2,(11-plotSize(2))/2,plotSize(1),plotSize(2)])
if ~isempty(colorLimits)
    set(gca,'clim',colorLimits)
end
colorbar
%ImageScRmNaN(Make2DPlotMat(rippPow,chanMat,badChan),[38 46]);
