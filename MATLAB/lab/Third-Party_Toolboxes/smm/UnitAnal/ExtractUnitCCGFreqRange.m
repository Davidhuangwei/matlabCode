function ExtractUnitCCGFreqRange(fileBaseCell,winLen,spectAnalDir,freqRange,freqRangeName,varargin

[normalization,binSize] = DefaultArgs(varargin,{'hz',3});
timeRange = 1./freqRange;

for j=1:length(fileBaseCell)
    fileBase = fileBaseCell{j};

    inName = [fileBase '/' spectAnalDir 'unitCCGBin' num2str(binSize) normalization '.mat'];
    unitCCG = LoadVar(inName);
    
    outCCG = unitCCG.yo(:,:,:,unitCCG.to>timeRange(2) & unitCCG.to<timeRange(1));
    eval([freqRangeName 'CCG = outCCG;']);
    
    save([fileBase '/' spectAnalDir freqRangeName num2str(freqRange(1)) '-' num2str(freqRange(12))...
        'HzCCGBin' num2str(binSize) normalization '.mat'],SaveAsV6,[freqRangeName 'CCG']);
end
