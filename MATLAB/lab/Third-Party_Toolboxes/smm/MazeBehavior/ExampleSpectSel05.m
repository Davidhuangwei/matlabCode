function  ExampleSpectSel05(filebasemat,fileext,nchannels,channel,lowband,highband)
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

N = winLength;
DJ = 1/18;
S0 = 4;
J1 = round(log2(N/S0)/(DJ)-1.3/DJ);
files = [1 2 3 4 5 6 8 9 ];
trials = {[2 5];...
         [2 3 7 8];...
         [1 2 5];...
         [1];...
         [1 2];...
         [1];...
         [];...
         [1 4];...
         [1 2];...
         };
figure(1)
set(gcf,'name',['GammaSpectExamplesSelected_' num2str(lowband) '-' num2str(highband) 'Hz_02'])
set(gcf,'DefaultAxesPosition',defaultAxesPosition);
%for i=files%1:numfiles
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
%    for j=trials{i}
    for j=1:size(eegTime.(fields{1}),1)
        figure(1)
        clf
        subplot(nSubplots,1,1:mazePlotSize)
        plot(whl(:,1),whl(:,2),'y.')
        hold on
        %plotColors = [1 0 0;0 1 0;0 0 1;0 0 0];
        for k=1:length(fields)
            rawEegTimes(k) = eegTime.(fields{k})(j);
        end
        beginRawEEG = min(rawEegTimes);
        endRawEEG = max(rawEegTimes)+winLength;
       
        beginRawWhl = round(beginRawEEG/eegSamp*whlSamp);
        endRawWhl = round(endRawEEG/eegSamp*whlSamp);
        [whlTrialTypes whlMazeLoc] = GetWhlInfoMat([fileBase '/' fileBase]);
        enterDelayWhl = beginRawWhl-1+find(whlMazeLoc(beginRawWhl:endRawWhl,3)==1,1,'first');
        exitDelayWhl = beginRawWhl-1+find(whlMazeLoc(beginRawWhl:endRawWhl,5)==1,1,'first');
        goodWhlInd = [beginRawWhl:enterDelayWhl-1 exitDelayWhl:endRawWhl];
                
        enterDelayEEG = round(enterDelayWhl*eegSamp/whlSamp);
        exitDelayEEG = min([rawEegTimes(2) round(exitDelayWhl*eegSamp/whlSamp)]);
        goodEEGInd = [beginRawEEG:enterDelayEEG-1 exitDelayEEG:endRawEEG];
        
        plot(whl(goodWhlInd,1),whl(goodWhlInd,2),'.','color',[0.8 0.8 0.8])

% plan:
% wavlet/log/smooth on full 15 seconds
% chop
% normalize
% plot
% plot limits
        saveCutWave = [];
        saveWave = [];
        saveCutFilt = [];
        for m=1:length(chans)
                [wave period scale coi] = xwt(eeg(beginRawEEG-winLength:endRawEEG+winLength,m),eeg(beginRawEEG-winLength:endRawEEG+winLength,m),'Pad',1,'DJ',DJ,'S0',S0,'J1',J1);
                fo = 1./period.*eegSamp;
                freqLim = [fo(find(fo>=lowband,1,'last')) fo(find(fo<=highband,1,'first'))];
                logWave = wave(fo>=lowband & fo<=highband,:);
                smoothWave = [];
                for n=1:size(logWave,1)
                    smoothWave(n,:) = 10.*log10(smooth(logWave(n,:),212));
                end
                cutWave = smoothWave(:,goodEEGInd-beginRawEEG+1+winLength);
                tempFilt = filt(beginRawEEG-winLength:endRawEEG+winLength,m);
                saveCutFilt(m,:) = tempFilt(goodEEGInd-beginRawEEG+1+winLength,:)';
                saveCutWave(m,:,:) = cutWave;
                saveWave(m,:,:) = wave(fo>=lowband & fo<=highband,:);
                subplot(nSubplots,nHorzSubplots,(mazePlotSize+m)*nHorzSubplots-tracePlotWidth:(mazePlotSize+m)*nHorzSubplots-1)
                hold on
                %pcolor(1:size(cutWave,2),fo(fo>=lowband & fo<=highband),cutWave-repmat(mean(cutWave,2),1,size(cutWave,2)))
                %pcolor(1:size(cutWave,2),fo(fo>=lowband & fo<=highband),cutWave)
                pcolor(1:size(cutWave,2),fo(fo>=lowband & fo<=highband),cutWave.*repmat(fo(fo>=lowband & fo<=highband)'.^0.15,1,size(cutWave,2)))
                shading interp
                plot((saveCutFilt(m,:)-mean(saveCutFilt(m,:)))/std(saveCutFilt(m,:))*8+mean([lowband highband]),'color',[0.5 0.5 0.5])
                set(gca,'ylim',freqLim)
        end

        plotColors = 'brgc';
        yLimits = [-500 500;-1000 1000;-1000 1000;-1500 1500;-1500 1500;-1500 1500];
        for k=1:length(fields)
            %fprintf([fields{k} '\n'])
            figure(1)
            subplot(nSubplots,nHorzSubplots,1:mazePlotSize*nHorzSubplots)
            beginWhl = round((eegTime.(fields{k})(j))/eegSamp*whlSamp);
            endWhl = round((eegTime.(fields{k})(j)+winLength)/eegSamp*whlSamp);
            plot(whl(beginWhl:endWhl,1),whl(beginWhl:endWhl,2),[plotColors(k) '.']);

            beginEEG = round(eegTime.(fields{k})(j));
            endEEG = round(eegTime.(fields{k})(j)+winLength-1);

            if k==1
                time = round((eegTime.(fields{k})(j))/eegSamp);
                %fprintf([num2str(time) '\n'])
            end
%             integPow(k,:) = 10*log10(sum(filt(beginEEG:endEEG,:).^2));
            for m=1:length(chans)
               figure(1)
                subplot(nSubplots,nHorzSubplots,(mazePlotSize+m)*nHorzSubplots-tracePlotWidth:(mazePlotSize+m)*nHorzSubplots-1)
                hold on
                if k==1
                    plot([beginEEG-beginRawEEG+1 beginEEG-beginRawEEG+1],freqLim,['--' plotColors(k)],'linewidth',4)
                    plot([endEEG-beginRawEEG+1 endEEG-beginRawEEG+1],freqLim,['--' plotColors(k)],'linewidth',4)
                    integPow(k,m) = 10*log10(sum(sum(10.^(saveCutWave(m,:,beginEEG-beginRawEEG+1:endEEG-beginRawEEG+1)/10),3),2));
                    integPow2(k,m) = 10*log10(sum(sum(saveWave(m,:,beginEEG-beginRawEEG+1:endEEG-beginRawEEG+1),3),2));
                    integPow3(k,m) = 25+10*log10(sum(saveCutFilt(m,beginEEG-beginRawEEG+1:endEEG-beginRawEEG+1).^2));
               else
                    plot([beginEEG-exitDelayEEG+2+enterDelayEEG-beginRawEEG  beginEEG-exitDelayEEG+2+enterDelayEEG-beginRawEEG],freqLim,['--' plotColors(k)],'linewidth',4)
                    plot([endEEG-exitDelayEEG+2+enterDelayEEG-beginRawEEG  endEEG-exitDelayEEG+2+enterDelayEEG-beginRawEEG],freqLim,['--' plotColors(k)],'linewidth',4)
                    integPow(k,m) = 10*log10(sum(sum(10.^(saveCutWave(m,:,beginEEG-exitDelayEEG+2+enterDelayEEG-beginRawEEG:endEEG-exitDelayEEG+2+enterDelayEEG-beginRawEEG)/10),3),2));
                    integPow2(k,m) = 10*log10(sum(sum(saveWave(m,:,beginEEG-exitDelayEEG+2+enterDelayEEG-beginRawEEG:endEEG-exitDelayEEG+2+enterDelayEEG-beginRawEEG),3),2));
                    integPow3(k,m) = 25+10*log10(sum(saveCutFilt(m,beginEEG-exitDelayEEG+2+enterDelayEEG-beginRawEEG:endEEG-exitDelayEEG+2+enterDelayEEG-beginRawEEG).^2));
                end                
%                 plot([plotStart plotStart],freqLim,['--' plotColors(k)])
%                 plot([plotStart+endEEG-beginEEG plotStart+endEEG-beginEEG],freqLim,['--' plotColors(k)])
                set(gca,'ylim',freqLim)
%                 shading interp
                subplot(nSubplots,nHorzSubplots,(mazePlotSize+m)*nHorzSubplots)
                hold on
                bar([k k+length(fields)+1 k+(length(fields)+1)*2],[integPow(k,m) integPow2(k,m) integPow3(k,m)],0.2,[plotColors(k)])
                set(gca,'ylim',[85 110],'xlim',[0 (length(fields)+1)*3])
             end
%                 keyboard
        end
%         keyboard
%         reportFigBool = [];
%         if      (integPow(2,2) > integPow(1,2)) &...
%                 (integPow(2,2) > integPow(3,2)) &...
%                 (integPow(2,2) > integPow(4,2))
%             reportFigBool = [reportFigBool 1];
%         else
%             reportFigBool = [reportFigBool 0];
%         end
%         if      (integPow(4,4) > integPow(1,4)) &...
%                 (integPow(4,4) > integPow(2,4)) &...
%                 (integPow(4,4) > integPow(3,4))
%             reportFigBool = [reportFigBool 1];
%         else
%             reportFigBool = [reportFigBool 0];
%         end
%         if      (integPow(3,5) < integPow(1,5)) &...
%                 (integPow(3,5) < integPow(2,5))
%             reportFigBool = [reportFigBool 1];
%         else
%             reportFigBool = [reportFigBool 0];
%         end
%         if      (integPow(3,6) < integPow(1,6)) &...
%                 (integPow(3,6) < integPow(2,6))
%             reportFigBool = [reportFigBool 1];
%         else
%             reportFigBool = [reportFigBool 0];
%         end
%         if      (integPow(4,6) < integPow(1,6)) &...
%                 (integPow(4,6) < integPow(2,6))
%             reportFigBool = [reportFigBool 1];
%         else
%             reportFigBool = [reportFigBool 0];
%         end
%         fprintf([num2str(reportFigBool) ' ' num2str(time) '\n'])
%         if reportFigBool(1) & sum(reportFigBool)>=3
%           ReportFigSM(1,[pwd '/NewFigs/GammaTrialExamples/'],[],[],{[fileBase], ['time=' num2str(time)],num2str(reportFigBool)});
           ReportFigSM(1,[pwd '/NewFigs/GammaTrialExamples/'],[],[],{[fileBase], ['time=' num2str(time)]});
%         end
%             keyboard
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
