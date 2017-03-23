function PlotRippTrigSpec(fileBaseCell,fileName,eegExt,varargin)

chanInfoDir = 'ChanInfo/';
chanMat = LoadVar([chanInfoDir 'ChanMat.eeg.mat']);
%nVertChan = size(chanMat,1);
eegOffset = load([chanInfoDir 'Offset' eegExt '.txt']);

[eegOffset,firstFig,plotSize] = DefaultArgs(varargin,...
    {eegOffset,1,[10 8]});

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
        sampRate = getfield(infoStruct,'sampRate');
        freqRange = getfield(infoStruct,'rippFiltFreqRange');
        eegChanMat = LoadVar([chanInfoDir 'ChanMat' eegExt '.mat']);
        eegChansPerShank = size(eegChanMat,1);
        eegNShanks = size(eegChanMat,2);
        eegBadChan = load([chanInfoDir 'BadChan' eegExt '.txt']);
        %         eegChansPerShank = getfield(infoStruct,'chansPerShank');
        %         eegNShanks  = getfield(infoStruct,'nShanks');
        %         eegBadChan = getfield(infoStruct,'badChans');
        eegSamp = getfield(infoStruct,'sampRate');
        segLen = getfield(infoStruct,'segLen');
 firfiltb = fir1(odd(sampRate*10/freqRange(1))+1,[freqRange(1)/sampRate*2,freqRange(2)/sampRate*2]);
% for j=1:size(selectedSegs,1)
% filtSegs(j,:,:) = filter0(firfiltb,squeeze(selectedSegs(j,:,:)));
% end
%%%% parameters optimized for winLength = 626 %%%%
% N = winLength;
% DJ = 1/18;
% S0 = 4;
% J1 = round(log2(N/S0)/(DJ)-1.3/DJ);
% [temp xSpecPeriod]= xwt(eegData(selectedChannels(k),:),eegData(m,:),'Pad',1,'DJ',DJ,'S0',S0,'J1',J1);

wave =[];
aveWave = [];
for k=1:size(selectedSegs,3)/2
    for j=1:size(selectedSegs,1)
        [temp period] = xwt(selectedSegs(j,:,k),selectedSegs(j,:,k));
        wave(j,:,:) = temp;
    end
    if isempty(aveWave)
        aveWave = wave/(size(selectedSegs,3)/2);
    else
        aveWave = aveWave + wave/(size(selectedSegs,3)/2);
    end
end
%aveWave = mean(wave,4);
clear wave
clear selectedSegs
clear segs
keyboard

fo = 1./period.*sampRate;
xPlotBuff = round(0.1*size(aveWave,3));
yPlotBuff = round(0.1*size(aveWave,2));

plotWave = NaN*ones(size(eegChanMat,1)*(size(aveWave,2)+yPlotBuff),...
    size(eegChanMat,2)*(size(aveWave,3)+xPlotBuff));
for j=1:size(eegChanMat,1)
    for k=1:size(eegChanMat,2)
        plotWave((j-1)*(size(aveWave,2)+yPlotBuff)+round(yPlotBuff/2)+1:...
            (j-1)*(size(aveWave,2)+yPlotBuff)+round(yPlotBuff/2)+...
            size(aveWave,2),...
            (k-1)*(size(aveWave,3)+xPlotBuff)+round(xPlotBuff/2)+1:...
            (k-1)*(size(aveWave,3)+xPlotBuff)+round(xPlotBuff/2)+...
            size(aveWave,3)) = aveWave(eegChanMat(j,k),:,:).*repmat(fo.^2,[1,1,size(aveWave,3)]);
    end
end
pcolor(1:size(plotWave,2),-1:-1:-size(plotWave,1),10*log10(plotWave))
shading interp
set(gca,'clim',[80 100])
PlotAnatCurves([chanInfoDir 'AnatCurves.mat'],[-size(plotWave,1)/size(eegChanMat,1)*size(chanMat,1) size(plotWave,2)],[-0.5+eegOffset(1)*(size(plotWave,1)/size(eegChanMat,1)) 0.5]);
colorbar
set(gcf,'PaperPosition',[(8.5-plotSize(1))/2,(11-plotSize(2))/2,plotSize(1),plotSize(2)]);
set(gcf, 'Units', 'inches')
set(gcf, 'Position', [(8.5-plotSize(1))/2,(11-plotSize(2))/2,plotSize(1),plotSize(2)])

%ImageScRmNaN(Make2DPlotMat(rippPow,eegChanMat,eegBadChan),[38 46]);

figure(3)
chan = 50;
pcolor(1:size(aveWave,3),fo,10*log10(squeeze(aveWave(chan,:,:).*repmat(fo.^2,[1,1,size(aveWave,3)]))))
shading interp
