function ExtractUnitCCGFreqRange01(fileBaseCell,winLen,spectAnalDir,freqRange,freqRangeName,varargin)

[normalization,binSize] = DefaultArgs(varargin,{'hz',3});
timeRange = 1./freqRange*1000;

for j=1:length(fileBaseCell)
    fileBase = fileBaseCell{j};

    inName = [fileBase '/' spectAnalDir 'unitCCGBin' num2str(binSize) normalization '.mat'];
    unitCCG = LoadVar(inName);

    outCCG = mean(unitCCG.yo(:,:,:,abs(unitCCG.to)>timeRange(2) & abs(unitCCG.to)<timeRange(1)),4);
    eval([freqRangeName 'CCG = outCCG;']);
    
    outName = [fileBase '/' spectAnalDir freqRangeName num2str(freqRange(1)) '-' num2str(freqRange(2))...
        'HzCCGBin' num2str(binSize) normalization '.mat'];
    fprintf('Saving: %s\n',outName)
    save(outName,SaveAsV6,[freqRangeName 'CCG']);
end
