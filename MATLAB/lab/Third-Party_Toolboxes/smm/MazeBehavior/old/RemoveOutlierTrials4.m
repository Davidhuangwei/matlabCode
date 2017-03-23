function [outIndepCell outDep] = RemoveOutlierTrials4(regionIndepCell,regionDep,nChan,badChans,varargin)
%function outDep = RemoveOutlierTrials2(regionIndepCell,regionDep,nChan,badChans,varargin)
%[stdev,nOutliersThresh,plotBool] = DefaultArgs(varargin,{3,1,0});

[stdev,plotBool] = DefaultArgs(varargin,{3,0});

%outIndepCell = {};
outDep = [];
for j=1:length(regionIndepCell)
    outIndepCell{j} = [];
end
mazeRegionNames = fieldnames(regionDep);
if isstruct(eval(['regionDep.' mazeRegionNames{1}]));
    for i=1:length(mazeRegionNames)
        for j=1:length(regionIndepCell)
            decendIndepCell{j} = getfield(regionIndepCell{j},mazeRegionNames{i});
        end
        decendDep = getfield(regionDep,mazeRegionNames{i});
        [returnIndepCell returnDep] = RemoveOutlierTrials4(decendIndepCell,decendDep,...
            nChan,badChans,{stdev,plotBool});
        outDep = setfield(outDep,mazeRegionNames{i},returnDep);
        for j=1:length(regionIndepCell)
            outIndepCell{j} = setfield(outIndepCell{j},mazeRegionNames{i},returnIndepCell{j});
        end
    end
else
    %outlierTrials = zeros(size(getfield(regionIndepCell{1},mazeRegionNames{1})));
    for j=1:length(regionIndepCell)
        outIndep = [];
        for i=1:length(mazeRegionNames)
            indepData = getfield(regionIndepCell{j},mazeRegionNames{i});
            upperLim = mean(indepData) + stdev*std(indepData);
            lowerLim = mean(indepData) - stdev*std(indepData);
            %outlierTrials = outlierTrials | (indepData > upperLim) | (indepData < lowerLim);
            outlierTrials = (indepData > upperLim) | (indepData < lowerLim);
            %temp = cat(2,temp, {find(outlierTrials)});
            fprintf('\nIndepCell_%i_%s: ',j,mazeRegionNames{i});
            fprintf('%i,',find(outlierTrials));
            indepData(outlierTrials) = NaN;
            outIndep = setfield(outIndep,mazeRegionNames{i},indepData);
        end
        outIndepCell{j} = outIndep;
    end

    goodChans = FindNonMatches(1:nChan,badChans);
    outliers.trial = [];
    outliers.region = [];
    outliers.channel = [];
    for j=1:length(goodChans)
        for i=1:length(mazeRegionNames)
            pow = getfield(regionDep,mazeRegionNames{i});
            outlier = find((pow(:,goodChans(j)) > mean(pow(:,goodChans(j)))+stdev*std(pow(:,goodChans(j)))) | ...
                (pow(:,goodChans(j)) < mean(pow(:,goodChans(j)))-stdev*std(pow(:,goodChans(j)))));
            if ~isempty(outlier)
                %outlier;
                %mazeRegionNames(i);
                %j;
                outliers.trial = cat(1,outliers.trial, outlier);
                for k=1:length(outlier)
                    outliers.region = cat(1,outliers.region,i);
                    outliers.channel = cat(1,outliers.channel,goodChans(j));
                end
                %plot(pow(:,j),'.')
                %pause
            end
        end
    end
    if isempty(outliers.trial)
        fprintf('\n\n\nNo Dep outliers!\n');
        outDep = regionDep;
    else
        fprintf('\n\n\nDep:\n')
        outliers_Trial_Chan_Region = [outliers.trial,outliers.channel,outliers.region]
        if plotBool
            figure(10)
            size(pow,1);
            hist(outliers.trial,size(pow,1))
            title('trials')
            figure(11)
            hist(outliers.channel,size(pow,2))
            title('channels')
        end
        %figure(12)
        %clf
        %hold on
        %plot(regionDep.centerArm(:,65),'.b')
        %aboveThresh = Accumulate(outliers.trial,1,length(outlierTrials))>nOutliersThresh;
        %fprintf('Above Threshold: %i\n',find(aboveThresh));
        %outlierTrials = outlierTrials | aboveThresh;
    end
    for j=1:length(mazeRegionNames)
        %outlierIndex = find(outliers.region==j);
        %if ~isempty(outlierIndex)
            temp = getfield(regionDep,mazeRegionNames{j});
            temp(sub2ind(size(temp),outliers.trial,outliers.channel)) = NaN;
            outDep = setfield(outDep,mazeRegionNames{j},temp);
        %end
    end
    %fprintf('\n\n---------------------------------------\n');
    %fprintf('Removing trial: %i\n',find(outlierTrials));
    %fprintf('---------------------------------------\n\n');

    %figure(12)
    %plot(regionDep.centerArm(:,65),'.r')
end
%%keyboard
return

