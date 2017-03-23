function CalcSpectAnalRemDesig01(fileBaseCell,spectAnalDir,fileExt,
inNameBlurb,freqRange,numSD,refrac

winLen = LoadField([fileBaseCell{1} '/' spectAnalDir 'InfoStruct.winLength');
eegSamp = LoadField([fileBaseCell{1} '/' spectAnalDir 'InfoStruct.eegSamp');
winLen = winLen/eegSamp;

for j=1:length(fileBaseCell)
    pRemTimes = load([fileBaseCell{j} '/PhasicRemTimes_' inNameBlurb...
        '_' num2str(freqRange(1)) '-' num2str(freqRange(2)) 'Hz_SD' ...
        num2str(numSD) '_Refrac' num2str(refrac) fileExt '.txt']);
    time = LoadVar([fileBaseCell{j} '/' spectAnalDir 'time.mat']);
    
    tRemBool = ones(size(time));
    for k=1:length(pRemTimes)
        tRemBool(time>=pRemTimes(k)-winLen & time<=pRemTimes(k)+winLen) = 0;
    end
    phasic