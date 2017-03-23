function blah(fileExtCell)
% fileExt = '.eeg'
% fileExt = '_LinNearCSD121.csd'
%fileExtCell = {'.eeg','_LinNearCSD121.csd'};
for k=1:length(fileExtCell)
    fileExt = (fileExtCell{k})
spectAnalBase = 'CalcRemSpectra03_allTimes_Win1250';
selChanCell = Struct2CellArray(LoadVar(['../ChanInfo/SelChan' fileExt]));
figure(1)
clf
for j=1:size(selChanCell,1)
    freqFactor = 1;
    tFreq = LoadVar([spectAnalBase fileExt '/thetaFreq4-12Hz'])*freqFactor;
    tPow = LoadVar([spectAnalBase fileExt '/thetaPowIntg4-12Hz']);
%     accum = Accumulate(round([tPow(:,selChanCell{j,2}) tFreq(:,selChanCell{j,2})]));
     subplot(size(selChanCell,1),1,j);
     xLimits = [min(tFreq(:,selChanCell{j,2})) max(tFreq(:,selChanCell{j,2}))];
     yLimits = [min(tPow(:,selChanCell{j,2})) max(tPow(:,selChanCell{j,2}))];
%     filtFactor = 5;
%     xFilt = hamming(diff(xLimits)/filtFactor)/sum(hamming(diff(xLimits)/filtFactor));
%     yFilt = hamming(diff(yLimits)/filtFactor)/sum(hamming(diff(yLimits)/filtFactor));
%     accum = Conv2Trim(xFilt,yFilt,accum);
%     pcolor([1:size(accum,2)]/freqFactor,[1:size(accum,1)],accum);
%     shading interp
    plot(tFreq(:,selChanCell{j,2}),tPow(:,selChanCell{j,2}),'.')
    
    set(gca,'ylim',yLimits,...
        'xlim',xLimits/freqFactor)
    %colorbar
    
end
%ReportFigSM(1,['/u12/smm/public_html/NewFigs/REMPaper/PhasicRemNotes/sm9603_3-21' fileExt '/'])

end