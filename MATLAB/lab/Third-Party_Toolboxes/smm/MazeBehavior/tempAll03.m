function  tempAll01(filebasemat,fileext,nchannels,channel,lowband,highband)
analDir = 'CalcRunningSpectra9_noExp_MidPoints_MinSpeed0Win626.eeg';
%Fs = 1250;
lowband = 40;
highband = 120;
forder = 626;
winLength = 626;
eegSamp = 1250;
whlSamp = 39.065;
analRoutine = 'AlterGood_S0_A0_MR';
numfiles = size(filebasemat,1);
load(['TrialDesig/' 'GlmWholeModel05' '/' analRoutine '.mat'])
chanInfoDir = 'ChanInfo/';
chans = load([chanInfoDir 'SelectedChannels' fileext '.txt']);
filtExt = '_40-120Hz.eeg.filt';
mazePlotSize = 3;
tracePlotWidth = 5;
nHorzSubplots = tracePlotWidth+1;
nSubplots = length(chans)+mazePlotSize;
defaultAxesPosition = [0.1,0.05,0.80,0.90];
firfiltb = fir1(forder,[lowband/eegSamp*2,highband/eegSamp*2]); % band-pass filter

% files = [1 2 3 4 5 6 8 9 ];
% trials = {[2 5];...
%          [2 3 7 8];...
%          [1 2 5];...
%          [1];...
%          [1 2];...
%          [1];...
%          [];...
%          [1 4];...
%          [1 2];...
%          };
figure(1)
set(gcf,'name',['GammaTrialExamplesSelected_' num2str(lowband) '-' num2str(highband) 'Hz_01'])
set(gcf,'DefaultAxesPosition',defaultAxesPosition);
for i=1:numfiles
    fileBase = filebasemat(i,:);
    fprintf([fileBase '\n'])
    eegTime = LoadDesigVar(fileBase,analDir,'eegSegTime',trialDesig);
    whl = load([fileBase '/' fileBase '.whl']);
    eeg = readmulti([fileBase '/' fileBase fileext],nchannels,chans);
    %filt = readmulti([fileBase '/' fileBase filtExt],nchannels,chans);
    %rawTrace = LoadDesigVar(fileBase,analDir,'rawTrace',trialDesig);
    filt = Filter0(firfiltb, eeg); % filter

    fields = fieldnames(eegTime);
    for j=1:size(eegTime.(fields{1}),1)
        figure(1)
        clf
        subplot(nSubplots,1,1:mazePlotSize)
        plot(whl(:,1),whl(:,2),'.','color',[0.85 0.85 0.85])
        hold on
        %plotColors = [1 0 0;0 1 0;0 0 1;0 0 0];
        for k=1:length(fields)
            beginRawEEG(k) = round(eegTime.(fields{k})(j));
            endRawEEG(k) = round(eegTime.(fields{k})(j)+winLength);
        end
        beginRawEEG = min(beginRawEEG);
        endRawEEG = max(endRawEEG);
        beginRawWhl = round(beginRawEEG/eegSamp*whlSamp);
        endRawWhl = round(endRawEEG/eegSamp*whlSamp);
        [whlTrialTypes whlMazeLoc] = GetWhlInfoMat([fileBase '/' fileBase]);
        keyboard
        goodWhlInd = zeros(size(whl,1),1);
        goodWhlInd([1:length(goodWhlInd)<=endRawWhl]' & [1:length(goodWhlInd)>=beginRawWhl]' & ~whlMazeLoc(:,3)) = 1;
        goodWhlInd = logical(goodWhlInd);
        
        goodWhl = beginRawWhl:endRawWhl;
        goodWhlInd = ~whlMazeLoc(beginRawWhl:endRawWhl,3);
        goodEEGInd = resample(goodWhlInd,eegSamp*1000,whlSamp*1000);
        goodEEGInd = goodWhlInd(1)/whlSamp*eegSamp:goodWhlInd(end)/whlSamp*eegSamp;
%         plot(whl(goodWhl(goodWhlInd),1),whl(goodWhlInd),2),'m.')
        plot(whl(goodWhlInd,1),whl(goodWhlInd,2),'m.')
        plotColors = 'rgbk';
        yLimits = [-500 500;-1000 1000;-1000 1000;-1500 1500;-1500 1500;-1500 1500];
        for m=1:length(chans)
            figure(1)

            subplot(nSubplots,nHorzSubplots,(mazePlotSize+m)*nHorzSubplots-tracePlotWidth:(mazePlotSize+m)*nHorzSubplots-1)
            hold on
            plot(filt(goodWhlInd,m),'m')
        end

            
        for k=1:length(fields)
            %fprintf([fields{k} '\n'])
            figure(1)
            subplot(nSubplots,nHorzSubplots,1:mazePlotSize*nHorzSubplots)
            beginWhl = round((eegTime.(fields{k})(j))/eegSamp*whlSamp);
            endWhl = round((eegTime.(fields{k})(j)+winLength)/eegSamp*whlSamp);
            plot(whl(beginWhl:endWhl,1),whl(beginWhl:endWhl,2),[plotColors(k) '.']);

            beginEEG = round(eegTime.(fields{k})(j));
            endEEG = round(eegTime.(fields{k})(j)+winLength);

            if k==1
                time = round((eegTime.(fields{k})(j))/eegSamp);
                %fprintf([num2str(time) '\n'])
            end
            integPow(k,:) = 10*log10(sum(filt(beginEEG:endEEG,:).^2));
            for m=1:length(chans)
                figure(1)

                subplot(nSubplots,nHorzSubplots,(mazePlotSize+m)*nHorzSubplots-tracePlotWidth:(mazePlotSize+m)*nHorzSubplots-1)
                hold on
                %plot([winLength*(k-1):winLength*k],eeg(beginEEG:endEEG,m),'color',[0.8 0.8 0.8]);
                %plot([winLength*(k-1)+1:winLength*k],squeeze(rawTrace.(fields{k})(j,chans(m),:)),'color',plotColors(k,:));
                %plot([winLength*(k-1):winLength*k],filt(beginEEG:endEEG,m)*2,'color',plotColors(k,:));
                plot(beginEEG-goodEEGInd(1),filt(beginEEG:endEEG,m),[plotColors(k)]);
                set(gca,'ytick',[yLimits(m,1):(yLimits(m,2)-yLimits(m,1))/4:yLimits(m,2)],'ylim',yLimits(m,:))
                grid on
                %figure(2)
                subplot(nSubplots,nHorzSubplots,(mazePlotSize+m)*nHorzSubplots)
                hold on
                bar(k,integPow(k,m),[plotColors(k)])
                set(gca,'ylim',[65 85])
            end


        end
        reportFigBool = [];
        if      (integPow(2,2) > integPow(1,2)) &...
                (integPow(2,2) > integPow(3,2)) &...
                (integPow(2,2) > integPow(4,2))
            reportFigBool = [reportFigBool 1];
        else
            reportFigBool = [reportFigBool 0];
        end
        if      (integPow(4,4) > integPow(1,4)) &...
                (integPow(4,4) > integPow(2,4)) &...
                (integPow(4,4) > integPow(3,4))
            reportFigBool = [reportFigBool 1];
        else
            reportFigBool = [reportFigBool 0];
        end
        if      (integPow(3,5) < integPow(1,5)) &...
                (integPow(3,5) < integPow(2,5))
            reportFigBool = [reportFigBool 1];
        else
            reportFigBool = [reportFigBool 0];
        end
        if      (integPow(3,6) < integPow(1,6)) &...
                (integPow(3,6) < integPow(2,6))
            reportFigBool = [reportFigBool 1];
        else
            reportFigBool = [reportFigBool 0];
        end
        if      (integPow(4,6) < integPow(1,6)) &...
                (integPow(4,6) < integPow(2,6))
            reportFigBool = [reportFigBool 1];
        else
            reportFigBool = [reportFigBool 0];
        end
        fprintf([num2str(reportFigBool) ' ' num2str(time) '\n'])
        if reportFigBool(1) & sum(reportFigBool)>=3
           % ReportFigSM(1,[pwd '/NewFigs/GammaTrialExamples/'],[],[],{[fileBase], ['time=' num2str(time)],num2str(reportFigBool)});
        end
            keyboard
    end
end

return


    
    dspowname = [filebasemat(i,:) '_' num2str(lowband) '-' num2str(highband) 'Hz' fileext '.100DBdspow'];
    dspow = ((bload(dspowname,[nchannels inf],0,'int16')')/100);
    [dspm n] = size(dspow);
    eegdat = readmulti([filebasemat(i,:) '.eeg'],nchannels,channel);
    filtname = [filebasemat(i,:) '_' num2str(lowband) '-' num2str(highband) 'Hz' fileext '.filt'];
    filtdat = readmulti(filtname,nchannels,channel);
    powname = [filebasemat(i,:) '_' num2str(lowband) '-' num2str(highband) 'Hz' fileext '.100DBpow'];
    powdat = readmulti(powname,nchannels,channel)/100;
