function trialMidRegionsStruct = CalcTrialMidPoints(allMazeRegions,waterPorts,mazeRegionsStruct,plotFig)
% function trialMidRegionsStruct = CalcTrialMidPoints(allMazeRegions,waterPorts,mazeRegionsStruct,plotFig)


if ~exist('plotFig','var')
    plotFig = 0;
end



%[whlm n] = size(whlDat);
mazeRegionNames = fieldnames(mazeRegionsStruct);

trialMazeRegionsStruct = [];
trialMidRegionsStruct = [];
%plot(allMazeRegions(:,1),allMazeRegions(:,2))
trialbegin = find(allMazeRegions(:,1)~=-1);
while ~isempty(trialbegin),
    trialend = trialbegin(1) + find(waterPorts((trialbegin(1)+1):end,1)~=-1);
    if isempty(trialend),
        breaking = 1
        break;
    end

    for i=1:length(mazeRegionNames)
        mazeRegion = getfield(mazeRegionsStruct,mazeRegionNames{i},'data');
        trialMazeRegion = trialbegin(1)-1+find(mazeRegion(trialbegin(1):(trialend(1)-1),1)~=-1);
        trialMazeRegionsStruct = setfield(trialMazeRegionsStruct,mazeRegionNames{i},trialMazeRegion);
        if isempty(trialMazeRegion)
            fprintf('MazeRegion: %s missing measurements, SKIPPING TRIAL\n', mazeRegionNames{i});
            skipTrial = 1;
            %keyboard
        else
            skipTrial = 0;
        end
    end
    trialbegin = trialend(1)-1+find(allMazeRegions(trialend(1):end,1)~=-1);
    if ~skipTrial
        %trialMazeRegionsStruct.returnArm = trialbegin(1)-1+find(mazeRegionsStruct.returnArm(trialbegin(1):(trialend(1)-1),1)~=-1);
        %trialMazeRegionsStruct.centerArm = trialbegin(1)-1+find(centerarm(trialbegin(1):(trialend(1)-1),1)~=-1);
        %trialMazeRegionsStruct.Tjunction = trialbegin(1)-1+find(choicepoint(trialbegin(1):(trialend(1)-1),1)~=-1);
        %trialMazeRegionsStruct.returnArm = trialbegin(1)-1+find(goalarm(trialbegin(1):(trialend(1)-1),1)~=-1);

        

        %if ~isempty(trialreturnarm) & ~isempty(trialcenterarm) & ~isempty(trialchoicepoint) & ~isempty(trialgoalarm)
        if plotFig
            figure(plotFig)
            clf
            hold on
            plotColors = [0 0 1; 1 0 0; 0 0 0; 0 1 1;1 0 1];
            for i=1:length(mazeRegionNames)
                mazeRegion = getfield(mazeRegionsStruct,mazeRegionNames{i},'data');
                trialMazeRegion = getfield(trialMazeRegionsStruct,mazeRegionNames{i});
                try
                    plot(mazeRegion(trialMazeRegion,1),mazeRegion(trialMazeRegion,2),'.','color',plotColors(i,:),'markersize',7);
                catch
                    keyboard
                end
                %plot(returnarm(trialreturnarm,1),returnarm(trialreturnarm,2),'.','color',[0 0 1],'markersize',7);
                %plot(centerarm(trialcenterarm,1),centerarm(trialcenterarm,2),'.','color',[1 0 0],'markersize',7);
                %plot(choicepoint(trialchoicepoint,1),choicepoint(trialchoicepoint,2),'.','color',[0 0 0],'markersize',7);
                %plot(goalarm(trialgoalarm,1),goalarm(trialgoalarm,2),'.','color',[0 1 1],'markersize',7);
                set(gca,'xlim',[0 368],'ylim',[0 240]);
            end
        end
        for i=1:length(mazeRegionNames)
            mazeRegion = getfield(mazeRegionsStruct,mazeRegionNames{i},'data');
            trialMazeRegion = getfield(trialMazeRegionsStruct,mazeRegionNames{i});
            midCalc = getfield(mazeRegionsStruct,mazeRegionNames{i},'midCalc');
            if ~isempty(trialMazeRegion)
                if midCalc == 0
                    midPoint = (mazeRegion(trialMazeRegion,1) - mean([max(mazeRegion(trialMazeRegion,1)) min(mazeRegion(trialMazeRegion,1))])).^2 + ...
                        (mazeRegion(trialMazeRegion,2) - mean([max(mazeRegion(trialMazeRegion,2)) min(mazeRegion(trialMazeRegion,2))])).^2;
                    midPoint = find(midPoint == min(midPoint));
                elseif midCalc == -1
                    xmid = mean(allMazeRegions(allMazeRegions(:,1)~=-1,1));
                    midPoint = find(abs(mazeRegion(trialMazeRegion,1)-xmid)==max(abs(mazeRegion(trialMazeRegion,1)-xmid)));
                    midPoint = midPoint(1);
                else
                    
                    midPointX = min(mazeRegion(trialMazeRegion,1)) + (max(mazeRegion(trialMazeRegion,1)) - min(mazeRegion(trialMazeRegion,1)))*midCalc;
                    midPoint = find(abs(mazeRegion(trialMazeRegion,1) - midPointX) == min(abs(mazeRegion(trialMazeRegion,1) - midPointX)));
                end

                if ~isfield(trialMidRegionsStruct,mazeRegionNames{i})
                    trial = 0;
                else
                    trial = length(getfield(trialMidRegionsStruct,mazeRegionNames{i}));
                end
                trialMidRegionsStruct = setfield(trialMidRegionsStruct,mazeRegionNames{i},{trial+1},trialMazeRegion(midPoint(1)));
            else
                trialMidRegionsStruct = setfield(trialMidRegionsStruct,mazeRegionNames{i},{trial+1},NaN);
            end
        end

        if plotFig
            for i=1:length(mazeRegionNames)

                midPoint = getfield(trialMidRegionsStruct,mazeRegionNames{i},{trial+1});
                if ~isnan(midPoint)
                    plot(allMazeRegions(midPoint,1),allMazeRegions(midPoint,2),'.','color',[0 1 0],'markersize',20);
                end
            end
            answer = 'junk';
            while ~strcmp(answer,'s') & ~strcmp(answer,'') & ~strcmp(answer,'d')
                answer = input('Save (s) or delete (d)? ','s');
                if strcmp(answer,'d')
                    for i=1:length(mazeRegionNames)
                        trialMidRegionsStruct = setfield(trialMidRegionsStruct,mazeRegionNames{i},{trial+1},[]);
                    end
                end
            end
        end
    end
end
return