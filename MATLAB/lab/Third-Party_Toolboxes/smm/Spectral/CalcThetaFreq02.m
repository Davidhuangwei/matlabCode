function CalcThetaFreq02(saveDir,fileBaseCell,fileExt,thetaFreqRange,varargin);
chanInfoDir = 'ChanInfo/';
[selChansStruct,plotBool,figHandleCell,subPlotLoc,batchModeBool] = ...
    DefaultArgs(varargin,{LoadVar([chanInfoDir 'SelChan' fileExt '.mat']),...
    1,{},{2,2,2},1});

selChanNames = fieldnames(selChansStruct);
for j=1:length(selChanNames)
    selectedChannels(j) = selChansStruct.(selChanNames{j});
end

infoStruct = [];
infoStruct = setfield(infoStruct,'fileExt',fileExt);
infoStruct = setfield(infoStruct,mfilename,mfilename);
infoStruct = setfield(infoStruct,'saveDir',saveDir);

for j=1:size(fileBaseCell)
    fileBase = fileBaseCell{j};
    infoStruct = setfield(infoStruct,'fileBase',fileBase);

    if exist([saveDir '/infoStruct.mat'],'file')
        infoStruct = MergeStructs(LoadVar([saveDir '/infoStruct.mat']),infoStruct);
    end
    
    fprintf('Processing: %s; %s%s\n',mfilename,fileBase,fileExt);
    dirName = [fileBase '/' saveDir '/' ];
    load([dirName 'powSpec.mat'],'-mat')

    fs = powSpec.fo;
    keyboard
    peakFreq = FindSpectPeak01(yo,fo,spectRange,'max')
    
    thetaFreq = zeros(size(powSpec.yo,1),size(powSpec.yo,2));
    fRange = find(fs>=thetaFreqRange(1) & fs<=thetaFreqRange(2));
    for t=1:size(powSpec.yo,1)
        for c=1:size(powSpec.yo,2)
            temp = LocalMinima(-powSpec.yo(t,c,fRange),length(fRange));
            if isempty(temp)
                %temp = NaN;
                [junk temp] = max(powSpec.yo(t,c,fRange));
            end
            if isnan(temp)
                thetaFreq(t,c) = NaN;
            else
                thetaFreq(t,c) = fs(temp-1+fRange(1));
            end
        end
    end
    if plotBool
        if ~isempty(figHandleCell)
            figure(figHandleCell{j})
        else
            figure
        end
        subplot(subPlotLoc{:})
        hold on
        plot(1:size(thetaFreq,1),thetaFreq(:,selectedChannels(2)),'k')
    end

    fprintf('Saving: %s, %i trials\n',saveDir,size(thetaFreq,1))

    save([dirName '/infoStruct.mat'],SaveAsV6,'infoStruct');
    save([dirName 'thetaFreq' ...
        num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.mat'],...
        SaveAsV6,'thetaFreq');
    clear thetaFreq
end

return

%%%%%%% testing code %%%%%%%% 
baseNames = {'thetaPowPeak6-12Hz','thetaPowIntg6-12Hz','gammaPowPeak65-100Hz','gammaPowIntg65-100Hz'};
for j=1:length(baseNames)
    test = LoadVar(['Test_' baseNames{j} '.mat']);
    old = LoadVar([baseNames{j} '.mat']);
    if abs(test-old) > 10e-10
        fprintf('ERROR: %s failed 10e-10',baseNames{j});
    else
        fprintf('aok\n')
    end
end
baseNames = {'thetaCohMedian6-12Hz','thetaCohMean6-12Hz','thetaPhaseMean6-12Hz','gammaCohMedian65-100Hz','gammaCohMean65-100Hz','gammaPhaseMean65-100Hz'};
for j=1:length(baseNames)
    test = LoadVar(['Test_' baseNames{j} '.mat']);
    old = LoadVar([baseNames{j} '.mat']);
    fields = fieldnames(test);
    for k=1:length(fields)
        if test.(fields{k}) ~= old.(fields{k})
            fprintf('ERROR: %s failed 10e-10',baseNames{j});
        else
            fprintf('aok:%s%s\n',baseNames{j},fields{k})
        end
    end
end



