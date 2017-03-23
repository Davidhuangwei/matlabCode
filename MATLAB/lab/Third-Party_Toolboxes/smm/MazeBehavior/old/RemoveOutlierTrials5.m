function [outIndepCell outDep outliersInfo] = RemoveOutlierTrials5(regionIndepCell,regionDep,chan,varargin)
%function [outIndepCell outDep] = RemoveOutlierTrials5(regionIndepCell,regionDep,chan,varargin)
%[stdev,plotBool] = DefaultArgs(varargin,{3,0});
[stdev,plotBool] = DefaultArgs(varargin,{3,0});

%outIndepCell = {};
outDep = [];
outliersInfo = [];
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
        [returnIndepCell returnDep outlierTrials] = RemoveOutlierTrials5(decendIndepCell,decendDep,...
            chan,{stdev,plotBool});
        outDep = setfield(outDep,mazeRegionNames{i},returnDep);
        outliersInfo = setfield(outliersInfo,mazeRegionNames{i},outlierTrials);
        for j=1:length(regionIndepCell)
            outIndepCell{j} = setfield(outIndepCell{j},mazeRegionNames{i},returnIndepCell{j});
        end
    end
else
    outlierTrials = zeros(size(getfield(regionIndepCell{1},mazeRegionNames{1})));
    if plotBool
            fprintf('\nIndepCell Outliers:');
    end
    for j=1:length(regionIndepCell)
        outIndep = [];
        for i=1:length(mazeRegionNames)
            indepData = getfield(regionIndepCell{j},mazeRegionNames{i});
            upperLim = mean(indepData) + stdev*std(indepData);
            lowerLim = mean(indepData) - stdev*std(indepData);
            newOutliers = (indepData > upperLim) | (indepData < lowerLim);
            outlierTrials = outlierTrials | newOutliers;
            %outlierTrials = (indepData > upperLim) | (indepData < lowerLim);
            %temp = cat(2,temp, {find(outlierTrials)});
            if plotBool
                if ~isempty(find(newOutliers))
                    fprintf('\n%i_%s: ',j,mazeRegionNames{i});
                    fprintf('%i ',find(newOutliers));
                end
            end
            %indepData(outlierTrials) = NaN;
            %outIndep = setfield(outIndep,mazeRegionNames{i},indepData);
        end
        %outIndepCell{j} = outIndep;
    end
    if plotBool
        if isempty(outlierTrials)
            fprintf('\nNo Indep Outliers')
        end
    end
    outliers.trial = [];
    outliers.region = [];
    outliers.channel = [];
    %for j=1:length(goodChans)
    for i=1:length(mazeRegionNames)
        pow = getfield(regionDep,mazeRegionNames{i});
        %size(pow)
        %chan
        newOutliers = (pow(:,chan) > mean(pow(:,chan))+stdev*std(pow(:,chan))) | ...
            (pow(:,chan) < mean(pow(:,chan))-stdev*std(pow(:,chan)));
        %find(newOutliers)
        if ~isempty(find(newOutliers))
            %outlier;
            %mazeRegionNames(i);
            %j;
            outliers.trial = cat(1,outliers.trial, find(newOutliers));
            for k=1:length(find(newOutliers))
                outliers.region = cat(1,outliers.region,i);
                outliers.channel = cat(1,outliers.channel,chan);
            end
            %plot(pow(:,j),'.')
            %pause
        end
        outlierTrials = outlierTrials | newOutliers;
    end
    %end
    if isempty(outliers.trial)
        if plotBool
            fprintf('\n\nNo Dep outliers!\n');
        end
        outDep = regionDep;
    else
        if plotBool
            fprintf('\n\nDep outliers:')
            x__Trial_Chan_Region = [outliers.trial,outliers.channel,outliers.region]
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
        %outlierTrials = outlierTrials | Accumulate(outliers.trial,1,length(outlierTrials))>0;
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
    for j=1:length(regionIndepCell)
        outIndep = [];
        for i=1:length(mazeRegionNames)
            temp = getfield(regionIndepCell{j},mazeRegionNames{i});
            temp(outlierTrials) = [];
            outIndep = setfield(outIndep,mazeRegionNames{i},temp);
        end
        outIndepCell{j} = outIndep;
    end
    for j=1:length(mazeRegionNames)
        temp = getfield(regionDep,mazeRegionNames{j});
        temp = temp(:,chan);
        temp(outlierTrials,:) = [];
        %size(temp)
        outDep = setfield(outDep,mazeRegionNames{j},temp);
    end
    %fprintf('\n\n---------------------------------------\n');
    %fprintf('Removing trial: %i\n',find(outlierTrials));
    if plotBool
        fprintf('---------------------------------------\n');
    end
    outliersInfo = {find(outlierTrials)};
end
%%keyboard
return

