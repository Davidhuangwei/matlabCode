
measurements = struct('speed',[],'accel',[],'thetaPowPeak',[],'thetaPowIntg',[],'gammaPowPeak',[],'gammaPowIntg',[]);
mazeMeasStruct2 = struct('returnArm',measurements,'centerArm',measurements,'Tjunction',measurements,'goalArm',measurements);

nchan = 97;
mazeRegionNames = fieldnames(mazeMeasStruct(1));
vars = fieldnames(measurements);
for i=1:38
    for k=1:4
        for j=1:6
            if j==1 | j==2
                mazeMeasStruct2 = setfield(mazeMeasStruct2,mazeRegionNames{k},vars{j},{i},getfield(mazeMeasStruct(i),mazeRegionNames{k},vars{j}));
            else
                mazeMeasStruct2 = setfield(mazeMeasStruct2,mazeRegionNames{k},vars{j},{i,1:nchan},getfield(mazeMeasStruct(i),mazeRegionNames{k},vars{j})');
            end
        end
    end
end
