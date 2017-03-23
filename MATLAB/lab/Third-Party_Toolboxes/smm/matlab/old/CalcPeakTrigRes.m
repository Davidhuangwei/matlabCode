% function CalcPeakTrigRes(fileBaseCell,fileExt,filtFreqRange,maxFreq,varargin)
% [nChan selChan eegSamp] = DefaultArgs(varargin,...
%     {load(['ChanInfo/NChan' fileExt '.txt']),LoadVar(['ChanInfo/SelChan' fileExt]),1250});

function CalcPeakTrigRes(fileBaseCell,fileExt,filtFreqRange,maxFreq,varargin)
[nChan selChan eegSamp] = DefaultArgs(varargin,...
    {load(['ChanInfo/NChan' fileExt '.txt']),LoadVar(['ChanInfo/SelChan' fileExt]),1250});

firfiltb = fir1(odd(3/filtFreqRange(1)*eegSamp)-1,[filtFreqRange(1)/eegSamp*2,filtFreqRange(2)/eegSamp*2]);

for j=1:length(fileBaseCell)
    for k=1:size(selChan,1)
        eeg = readmulti([SC(fileBaseCell{j}) fileBaseCell{j} fileExt],nChan,selChan{k,2});
        filt = Filter0(firfiltb, eeg);
        minima = LocalMinima(-filt,eegSamp/maxFreq,0);
        msave([SC(fileBaseCell{j}) fileBaseCell{j} GenFieldName(fileExt) '_' selChan{k,1} '_PeakTrigRes_' ...
             num2str(filtFreqRange(1)) '-' num2str(filtFreqRange(2)) '_maxFreq' num2str(maxFreq) '.res']...
             minima);
         figure
         subplot(size(selChan,1),1,k)
         plot(eeg)
         plot(filt,'g')
         PlotVertLines(minima,[-5000 5000],'r')
    end
end
        
