function MeanUnitCCGTimeLim01(fileBaseCell,spectAnalDir,timeLim,varargin)

[normalization,binSize] = DefaultArgs(varargin,{'scale',3});


for j=1:length(fileBaseCell)
    fileBase = fileBaseCell{j};

    inName = [fileBase '/' spectAnalDir 'unitCCGBin' num2str(binSize) normalization '.mat'];
    unitCCG = LoadVar(inName);

    unitCCG = mean(unitCCG.yo(:,:,:,abs(unitCCG.to)<=timeLim(1)),4);
%     eval([freqLimName 'CCG = outCCG;']);
%     unitCCG = [];
    
    outName = [fileBase '/' spectAnalDir 'unitMeanCCG' num2str(timeLim) 'msBin' num2str(binSize) normalization '.mat'];
    fprintf('Saving: %s\n',outName)
    save(outName,SaveAsV6,'unitCCG');
end
