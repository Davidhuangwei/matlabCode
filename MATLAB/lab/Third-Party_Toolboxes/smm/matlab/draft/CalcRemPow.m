function CalcRemPow(filebase,startTime,endTime)
eegSamp=1250;
winLength = 626;
totalTime = endTime-startTime-winLength/eegSamp; %sec
nPoints = 80;
thetaNW=2;
gammaNW=4;
thetaFreqRange = [5 12];
gammaFreqRange = [65 85];
plotChan = 33;
plotbool = 1;
nchannels = 97;
rem = bload([filebase '.eeg'],[nchannels (endTime-startTime)*eegSamp],startTime*eegSamp*nchannels*2,'int16');

remMeasStruct = struct('thetaPowPeak',[],'thetaPowIntg',[],'gammaPowPeak',[],'gammaPowIntg',[],'thetaNWYo',[],'gammaNWYo',[]);

samplPoints = [1:ceil(totalTime/nPoints*eegSamp):round(totalTime*eegSamp)] + winLength/2;


figure(1)
clf
hold on
plot(rem(plotChan,:))
for i=1:length(samplPoints)
    figure(1)
    eegPos = samplPoints(i);
    plot([eegPos-winLength/2+1 eegPos-winLength/2+1],[min(rem(plotChan,:)) max(rem(plotChan,:))],'--r');
    plot([eegPos+winLength/2 eegPos+winLength/2],[min(rem(plotChan,:)) max(rem(plotChan,:))],'--k');
    figure(2)
    clf
    %%%% for theta %%%%
    [yo, fo] = mtpsd_sm(rem(:,eegPos-winLength/2+1:eegPos+winLength/2),winLength*2,eegSamp,winLength,0,thetaNW);
    remMeasStruct = setfield(remMeasStruct,'thetaNWYo',{i,1:length(fo),1:nchannels},yo);
    powPeak = 10.*log10(max(yo(find(fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2)),:)));
    powIntg = 10.*log10(sum(yo(find(fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2)),:)));
    remMeasStruct = setfield(remMeasStruct,'thetaPowPeak',{i,1:nchannels},powPeak);
    remMeasStruct = setfield(remMeasStruct,'thetaPowIntg',{i,1:nchannels},powIntg);
    %mazeMeasStruct = setfield(mazeMeasStruct,mazeRegionNames{k},'power',{nPoints + 1,1:nchannels}, power);
    if plotbool
        subplot(2,1,1)
        hold on
        plot([0 100],[powPeak(plotChan) powPeak(plotChan)],'--r');
        plot([0 100],[powIntg(plotChan) powIntg(plotChan)]-7,'--g');
        plot(fo(find(fo<=100)),10.*log10(yo(find(fo<=100),plotChan)))
        plot([thetaFreqRange(1) thetaFreqRange(1)],[40 80],':k')
        plot([thetaFreqRange(2) thetaFreqRange(2)],[40 80],':k')
        set(gca,'ylim',[30 80]);
        title('rem');
            ylabel('theta');
    end

    %%%%% for gamma %%%%%%
    [yo, fo] = mtpsd_sm(rem(:,eegPos-winLength/2+1:eegPos+winLength/2),winLength*2,eegSamp,winLength,0,gammaNW);
    remMeasStruct = setfield(remMeasStruct,'gammaNWYo',{i,1:length(fo),1:nchannels},yo);
    powPeak = 10.*log10(max(yo(find(fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2)),:)));
    powIntg = 10.*log10(sum(yo(find(fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2)),:)));
    remMeasStruct = setfield(remMeasStruct,'gammaPowPeak',{i,1:nchannels},powPeak);
    remMeasStruct = setfield(remMeasStruct,'gammaPowIntg',{i,1:nchannels},powIntg);
    if plotbool
        subplot(2,1,2)
        hold on
        plot([0 100],[powPeak(plotChan) powPeak(plotChan)],'--r');
        plot([0 100],[powIntg(plotChan) powIntg(plotChan)]-12,'--g');
        plot(fo(find(fo<=100)),10.*log10(yo(find(fo<=100),plotChan)))
        plot([gammaFreqRange(1) gammaFreqRange(1)],[40 80],':k')
        plot([gammaFreqRange(2) gammaFreqRange(2)],[40 80],':k')
        %plot([0 100],[power(plotChan) power(plotChan)],'r');
        %plot(fo(find(fo<=100)),10.*log10(max(yo(find(fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2)),plotChan))),'g');
        set(gca,'ylim',[30 80]);
            legend('peak','intg')
            ylabel('gamma');
    end
end
keyboard
save('rem-test3_sm9603m211s254-m244s290.eeg_Win626_thetaNW2_gammaNW4_RemMeasStruct',...
    'winLength','thetaNW','gammaNW','thetaFreqRange','gammaFreqRange','fo','remMeasStruct')
