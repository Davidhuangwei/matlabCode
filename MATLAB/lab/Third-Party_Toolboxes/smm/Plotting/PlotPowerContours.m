function PlotPowerContours(powerData,chanMat,powerLimits)
% function PlotPowerContours(powerData,chanMat,powerLimits)

[nChanY nChanX] = size(chanMat);
for x=1:nChanX
    plot(min(1,(max(0,powerData(chanMat(:,x))-powerLimits(1))./diff(powerLimits))+x-0.5,1:nChanY)
end
