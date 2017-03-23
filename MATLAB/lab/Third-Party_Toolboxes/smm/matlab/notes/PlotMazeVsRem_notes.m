


meanMazeYo = mean([mazeMeasStruct.returnArm.thetaNWYo; mazeMeasStruct.centerArm.thetaNWYo; mazeMeasStruct.Tjunction.thetaNWYo; mazeMeasStruct.goalArm.thetaNWYo],1);
meanRemYo = mean(remMeasStruct.thetaNWYo,1);

figure(3)
clf
plotChans = [1:96];
for i=1:length(plotChans)
    %subplot(length(plotChans),1,i)
    subplot(16,6,6*mod(i-1,16)+1+floor((i-1)/16))
    hold on
    plot(10.*log10(meanRemYo(:,:,plotChans(i))),'r')
    plot(10.*log10(meanMazeYo(:,:,plotChans(i))),'b')
    set(gca,'xlim',[0 100]);
end
