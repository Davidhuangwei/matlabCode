function

cwd = pwd;
for j=1:length(analDirs)
    cd(analDirs{j})
    sleepFiles = LoadVar('FileInfo/SleepFiles');
    for k=1:length(sleepFiles)
        inFile = [sleepFiles{j} '/RippTrigAveSpec_' segRestriction num2str(segLen) fileExt '.mat'];
        %             inFile = [sleepFiles{j} '/' fileBase fileExt '.mat'];
        fprintf('Loading %s\n',inFile);
        inSpec = LoadVar(inFile);
        
        if j==1 & k==1;
            meanSpec = zeros(size(inSpec.yo));
            numSegs = 0;
        end
        meanSpec = meanSpec + inSpec.yo * inSpec.numSeg;
        numSegs = numSegs + inSpec.numSeg;
    end
end
meanSpec = meanSpec / numSegs;
fo = inSpec.fo;
to = inSpec.to;
coi = inSpec.coi;


cwd = pwd;
for j=1:length(analDirs)
    cd(analDirs{j})
    sleepFiles = LoadVar('FileInfo/SleepFiles');
    for k=1:length(sleepFiles)
        inFile = [sleepFiles{j} '/RippTrigStdSpec_' segRestriction num2str(segLen) fileExt '.mat'];
        %             inFile = [sleepFiles{j} '/' fileBase fileExt '.mat'];
        fprintf('Loading %s\n',inFile);
        inSpec = LoadVar(inFile);
        
        if j==1 & k==1;
            stdSpec = zeros(size(inSpec.yo));
            numSegs = 0;
        end
        stdSpec = stdSpec + (inSpec.yo).^2 * inSpec.numSeg;
        numSegs = numSegs + inSpec.numSeg;
    end
end
stdSpec = sqrt(stdSpec / numSegs);
fo = inSpec.fo;
to = inSpec.to;
coi = inSpec.coi;


cd(cwd)


% return


fo = fliplr(fo);
    meanSpec = flipdim(meanSpec,2);
    stdSpec = flipdim(stdSpec,2);    

chanLocCell = Struct2CellArray(LoadVar(['ChanInfo/' 'ChanLoc_' chanLocVersion fileExt '.mat']),[],1);
% chanLocCell = Struct2CellArray(LoadVar(['ChanInfo/' 'ChanLoc_' 'Full' fileExt '.mat']),[],1);
badChan = load(['ChanInfo/BadChan' fileExt '.txt']);
chanMat = LoadVar(['ChanInfo/ChanMat' fileExt '.mat']);
screenHeight = 11;
xyFactor = 1.5;
titleBase = {'Ripple Triggered Ave Spectrogram',[segRestriction,num2str(segLen),fileExt],sleepFiles{:}};
figTitleBase = ['RippTrigSeg_' sleepFiles{1}(1:6) '_' segRestriction num2str(segLen) fileExt];

for j=1:size(chanMat,2)
    figure(j)
    set(gcf,'units','inches')
    set(gcf,'position',[0.5,0.5,screenHeight*xyFactor,screenHeight])
    set(gcf,'paperposition',get(gcf,'position'))
    set(gcf,'name',figTitleBase)
    
    for k=1:size(chanMat,1)
        subplot(size(chanMat,1),1,k)
        if isempty(find(badChan == chanMat(k,j)))
        plotSpec = squeeze((meanSpec(chanMat(k,j),:,:) ...
            - repmat(mean(meanSpec(chanMat(k,j),:,:),3),[1 1 size(meanSpec,3)])) ...
            ./ stdSpec(chanMat(k,j),:,:));
            imagesclogy(to,fo,plotSpec);
        hold on
    plot(to,eegSamp./coi,'k')
        end
%     set(gca,'ylim',[0 250])
    set(gca,'clim',[-1 1])

    yLabelText = {};
    for m=1:size(chanLocCell,1)
        if ~isempty(find(chanMat(k,j) == [chanLocCell{m,2}{:}]))
            yLabelText = cat(2,yLabelText, chanLocCell{m,1});
%         else
%             yLabelText = {yLabelText, ' '};
        end
    end
    yLabelText = cat(2,yLabelText,['ch ' num2str(chanMat(k,j))]);
    ylabel(yLabelText)
    grid on
    colorbar
%     if j==1
%         title(cat(2,titleBase,'x - mean(timeWin)'))
%     end
    if k==1
        title(SaveTheUnderscores(cat(2,titleBase,'x - mean(timeWin)/std(trials)')))
    end
end
    end

        
