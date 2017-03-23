% function peakFreq = FindSpectPeak01(yo,fo,spectRange,varargin)
% altPeakMethod = DefaultArgs(varargin,{'max'});
% yo = [time x channels x freq]
function [peakFreq peakIndex] = FindSpectPeak01(yo,fo,spectRange,varargin)
[altPeakMethod smoothKrnl]= DefaultArgs(varargin,{'max',[]});

if ~isempty(smoothKrnl)
    for j=1:size(yo,2)
        yo(:,j,:) = Conv2Trim(1,smoothKrnl,squeeze(yo(:,j,:)));
    end
end

peakFreq = zeros(size(yo,1),size(yo,2));
fRange = find(fo>=spectRange(1) & fo<=spectRange(2));
for t=1:size(yo,1)
    for c=1:size(yo,2)
        temp = LocalMinima(-yo(t,c,fRange),length(fRange));
        if isempty(temp)
            switch lower(altPeakMethod)
                case 'max'
                    [junk temp] = max(yo(t,c,fRange));
                otherwise
                    temp = NaN;
            end
        end
        if isnan(temp)
            peakFreq(t,c) = NaN;
            peakIndex(t,c) = NaN;
        else
            peakFreq(t,c) = fo(temp-1+fRange(1));
            peakIndex(t,c) = temp-1+fRange(1);
        end
    end
end
return