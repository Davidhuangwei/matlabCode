% function CalcThetaFreqPercentile(analDirs,spectAnalDir,thetaFreqFileName,outName,analRoutine,varargin)
% [glmVersion,plotBool] = DefaultArgs(varargin,{'GlmWholeModel08',1});
% tag:theta
% tag:freq
% tag:percentile

function CalcThetaFreqPercentile(analDirs,spectAnalBase,inFileExt,outFileExt,thetaFreqFileName,outName,analRoutine,varargin)
[glmVersion,plotBool] = DefaultArgs(varargin,{'GlmWholeModel08',1});


cwd = pwd;
for m=1:length(analDirs)
    cd(analDirs{m})
load(['TrialDesig/' glmVersion '/' analRoutine '.mat']);

depCell = Struct2CellArray(LoadDesigVar(fileBaseCell,[spectAnalBase inFileExt],thetaFreqFileName,trialDesig),[],1);

catDepMat = [];
for j=1:size(depCell,1)
    catDepMat = cat(1,catDepMat,depCell{j,end});
end
for j=1:length(fileBaseCell)
    thetaFreq = LoadVar([SC(fileBaseCell{j}) SC([spectAnalBase inFileExt]) thetaFreqFileName] );
    thetaFreqPct = [];
    for k=1:size(thetaFreq,1)
        thetaFreqPct(k,1) = length(find(catDepMat <= thetaFreq(k)))/size(catDepMat,1);
    end
%     eval([outName '=thetaFreqPct
if plotBool
    figure
    hold on
    plot(thetaFreqPct,'.')
    plot(get(gca,'xlim'),[.95 .95],'r')
    s = sort(catDepMat);
    text(mean(get(gca,'xlim')),0.85,...
        ['0.95% = ' num2str(s(round(size(catDepMat,1)*0.95)),3) 'Hz'],...
        'color','r');
    title(SaveTheUnderscores([SC(fileBaseCell{j}) SC([spectAnalBase inFileExt]) thetaFreqFileName]))
end
    fprintf('Saving: %s\n',[SC(fileBaseCell{j}) SC([spectAnalBase outFileExt]) outName])
    save([SC(fileBaseCell{j}) SC([spectAnalBase outFileExt]) outName],...
        SaveAsV6,'thetaFreqPct')
end
end
cd(cwd);