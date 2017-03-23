function timeText = Sampl2TimeText(sampl,samplingRate,nDecimals)
% function timeText = Samp2TimeText(sampl,samplingRate,nDecimals)

timeMin = floor(sampl/samplingRate/60);
timeSec = floor(sampl/samplingRate-timeMin*60);
timeSubSec = floor(10^nDecimals*(sampl/samplingRate-timeSec-timeMin*60));
if timeSec >= 10
    secPlaceHolder = '';
else
    secPlaceHolder = '0';
end
subSecPlaceHolder = '';
for i = 1:nDecimals-1
    if timeSubSec < 10^(i)
        subSecPlaceHolder = [subSecPlaceHolder '0'];
    end
end
timeText = [num2str(timeMin) ':' secPlaceHolder num2str(timeSec) '.' subSecPlaceHolder num2str(timeSubSec)];
return