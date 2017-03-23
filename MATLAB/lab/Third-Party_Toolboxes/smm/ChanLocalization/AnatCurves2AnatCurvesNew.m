function AnatCurves2AnatCurvesNew(analDirs)
for j=1:length(analDirs)
    if ~exist('AnatCurvesNew.mat','file')
        if analDirs{j}(end) ~= '/'
            analDirs{j} = [analDirs{j} '/'];
        end
        cd([analDirs{j} 'ChanInfo'])
        anatCurves = LoadVar('AnatCurves.mat');

        for a=1:size(anatCurves,1)
            anatCurves2{a,2} = (anatCurves{a,2}*16.5-0.5)/16;
            anatCurves2{a,1} = (anatCurves{a,1}*6.5-0.5)/6;
        end
        anatCurves = anatCurves2;
        save('AnatCurvesNew.mat',SaveAsV6,'anatCurves');
    end
end
