function ExtractUnitCCGTimeLim01(fileBaseCell,winLen,spectAnalDir,timeLim,varargin)

[normalization,binSize] = DefaultArgs(varargin,{'hz',3});

for j=1:length(fileBaseCell)
    fileBase = fileBaseCell{j};

    inName = [fileBase '/' spectAnalDir 'unitCCGBin' num2str(binSize) normalization '.mat'];
    unitCCG = LoadVar(inName);

    unitCCG = mean(unitCCG.yo(:,:,:,abs(unitCCG.to)<timeLim(1),4);
%     eval([freqLimName 'CCG = outCCG;']);
%     unitCCG = [];
    
    outName = [fileBase '/' spectAnalDir 'unitCCG' num2str(timeLim) 'msBin' num2str(binSize) normalization '.mat'];
    fprintf('Saving: %s\n',outName)
    save(outName,SaveAsV6,'unitCCG');
end
