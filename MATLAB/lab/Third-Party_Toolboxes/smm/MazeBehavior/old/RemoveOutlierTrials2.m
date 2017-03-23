function outData = RemoveOutlierTrials2(regionPow,nChan,badChans,varargin)
%function outData = RemoveOutlierTrials2(regionPow,nChan,badChans,varargin)
%[stdev,nOutliersThresh,plotBool] = DefaultArgs(varargin,{3,1,0});

[stdev,nOutliersThresh,plotBool] = DefaultArgs(varargin,{3,1,0});

outData = [];
mazeRegionNames = fieldnames(regionPow);
if isstruct(eval(['regionPow.' mazeRegionNames{1}]));
    for i=1:length(mazeRegionNames)
        outData = setfield(outData,mazeRegionNames{i},...
            RemoveOutlierTrials2(getfield(regionPow,mazeRegionNames{i}),...
            nChan,badChans,stdev,nOutliersThresh,plotBool));
    end
else
    goodChans = FindNonMatches(1:nChan,badChans);
    outliers.trial = [];
    outliers.region = [];
    outliers.channel = [];
    for j=1:length(goodChans)
        for i=1:length(mazeRegionNames)
            pow = getfield(regionPow,mazeRegionNames{i});
            outlier = find((pow(:,goodChans(j)) > mean(pow(:,goodChans(j)))+stdev*std(pow(:,goodChans(j)))) | ...
                (pow(:,goodChans(j)) < mean(pow(:,goodChans(j)))-stdev*std(pow(:,goodChans(j)))));
            if ~isempty(outlier)
                outlier;
                mazeRegionNames(i);
                j;
                outliers.trial = cat(1,outliers.trial, outlier);
                for k=1:length(outlier)
                    outliers.region = cat(1,outliers.region,i);
                    outliers.channel = cat(1,outliers.channel,j);
                end
                %plot(pow(:,j),'.')
                %pause
            end
        end
    end
    if isempty(outliers.trial)
        fprintf('no outliers!\n');
        outData = regionPow;
    else
        outliers_Trial_Chan_Region = [outliers.trial,outliers.channel,outliers.region]
        if plotBool
            figure(10)
            size(pow,1);
            hist(outliers.trial,size(pow,1))
            figure(11)
            hist(outliers.channel,size(pow,2))
        end
        %figure(12)
        %clf
        %hold on
        %plot(regionPow.centerArm(:,65),'.b')
        outlierTrials = find(Accumulate(outliers.trial,1)>nOutliersThresh);
        for j=1:length(mazeRegionNames)
            temp = getfield(regionPow,mazeRegionNames{j});
            temp(outlierTrials,:) = [];
            outData = setfield(outData,mazeRegionNames{j},temp);
        end
        fprintf('Removing trial: %i\n',outlierTrials);
        %figure(12)
        %plot(regionPow.centerArm(:,65),'.r')
    end
end
return

