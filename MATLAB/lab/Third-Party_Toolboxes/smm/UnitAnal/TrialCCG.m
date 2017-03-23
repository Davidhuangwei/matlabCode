% function [CCGyo CCGto unitRate] = TrialCCG(varargin)
% [T, G, BinSize, HalfBins, SampleRate, GSubset, Normalization, Epochs, biasCorrBool] = ...
%     DefaultArgs(varargin,{[],[],[],[],[],[],[],[],[]});
function [CCGyo CCGto unitRate] = TrialCCG(varargin)
try
[T, G, BinSize, HalfBins, SampleRate, GSubset, Normalization, Epochs, biasCorrBool] = ...
    DefaultArgs(varargin,{[],[],[],[],[],[],[],[],[]});

CCGyo = [];
CCGto = [];
unitRate = [];
for n=1:size(Epochs,1)
        tempInd = find(T>=Epochs(n,1)...
            & T<=Epochs(n,2));    
    if biasCorrBool
%         [ccgTemp CCGto] = CCG(T,G,...
%             BinSize,HalfBins,...
         [ccgTemp CCGto] = CCG(T(tempInd),G(tempInd),...
            BinSize,HalfBins,...
           SampleRate,GSubset,Normalization,...
            Epochs(n,:));
    else
%         tempInd = find(T>=Epochs(n,1)...
%             & T<=Epochs(n,2));
        [ccgTemp CCGto] = CCG(T(tempInd),G(tempInd),...
            BinSize,HalfBins,...
            SampleRate,GSubset,Normalization);
    end
    if isempty(unitRate)
        unitRate = zeros([size(Epochs,1) size(ccgTemp,2)]);
    end
    if isempty(CCGyo)
        CCGyo = zeros([size(Epochs,1) size(permute(ccgTemp,[2,3,1]))]);
    end
    CCGyo(n,:,:,:) = permute(ccgTemp,[2,3,1]);
    % calculate rate
    for k=1:size(unitRate,2)
        selInd = find(G==k & T>=Epochs(n,1) & T<=Epochs(n,2));
        unitRate(n,k) = length(selInd)/diff(Epochs(n,:))*SampleRate;
    end
end
return
catch
    junk = lasterror
    keyboard
end