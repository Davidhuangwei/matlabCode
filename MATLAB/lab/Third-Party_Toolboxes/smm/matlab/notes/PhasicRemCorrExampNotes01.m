function [b stats]= blah(fileExtCell)
% fileExt = '.eeg'
% fileExt = '_LinNearCSD121.csd'
%fileExtCell = {'.eeg','_LinNearCSD121.csd'};
for k=1:length(fileExtCell)
    fileExt = (fileExtCell{k})
spectAnalBase = 'CalcRemSpectra03_allTimes_Win1250';
selChanCell = Struct2CellArray(LoadVar(['../ChanInfo/SelChan' fileExt]));
figure(1)
clf
for j=4:4%size(selChanCell,1)
    freqFactor = 1;
    tFreq = LoadVar([spectAnalBase fileExt '/thetaFreq4-12Hz'])*freqFactor;
    tPow = LoadVar([spectAnalBase fileExt '/thetaPowIntg4-12Hz']);
%     accum = Accumulate(round([tPow(:,selChanCell{j,2}) tFreq(:,selChanCell{j,2})]));
     %subplot(size(selChanCell,1),1,j);
    xVar = tFreq(:,selChanCell{j,2});
    yVar = tPow(:,selChanCell{j,2});
    stDev = 3;
    goodIndexes = (yVar<median(yVar)+stDev*std(yVar)) & (yVar>median(yVar)-stDev*std(yVar))...
        & ((xVar<median(xVar)+stDev*std(xVar)) & (xVar>median(xVar)-stDev*std(xVar)));
    xVar = xVar(goodIndexes);
    yVar = yVar(goodIndexes);
    xLimits = [min(xVar) max(xVar)];
     yLimits = [min(yVar) max(yVar)];
%     filtFactor = 5;
%     xFilt = hamming(diff(xLimits)/filtFactor)/sum(hamming(diff(xLimits)/filtFactor));
%     yFilt = hamming(diff(yLimits)/filtFactor)/sum(hamming(diff(yLimits)/filtFactor));
%     accum = Conv2Trim(xFilt,yFilt,accum);
%     pcolor([1:size(accum,2)]/freqFactor,[1:size(accum,1)],accum);
%     shading interp
%     b = regress(yVar,[ones(size(xVar)), xVar]);
    [b{j} stats{j}]= robustfit([xVar],yVar);
    plot(xVar,yVar,'.')
    hold on
    plot([xLimits(1) xLimits(2)],[b{j}(2)*xLimits(1) b{j}(2)*xLimits(2)]+b{j}(1),'r')
    
    set(gca,'ylim',yLimits,...
        'xlim',xLimits/freqFactor)
    %colorbar
    
end
%ReportFigSM(1,['/u12/smm/public_html/NewFigs/REMPaper/PhasicRemNotes/sm9603_3-21' fileExt '/'])

end