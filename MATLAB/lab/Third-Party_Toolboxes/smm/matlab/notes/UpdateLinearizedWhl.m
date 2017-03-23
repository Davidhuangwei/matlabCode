for i=1:size(fileBaseMat,1)
    if exist([fileBaseMat(i,:) '/' fileBaseMat(i,:) '_LinearizedWhl.mat'],'file')
        trialInfo = load([fileBaseMat(1,:) '/' fileBaseMat(1,:) '_whl_indexes.mat']);
        switch trialInfo.taskType
            case 'alter'
                load([fileBaseMat(i,:) '/' fileBaseMat(i,:) '_LinearizedWhl.mat'])
                %fields = fieldnames(linearRLaverageStruct)
                exploration = linearRLaverageStruct.exploration;
                returnArms = linearRLaverageStruct.returnArms;
                delayArea = linearRLaverageStruct.delayArea;
                centerArm  = linearRLaverageStruct.centerArm;
                Tjunction = linearRLaverageStruct.Tjunction;
                goalArms = linearRLaverageStruct.goalArms;
                waterPorts = linearRLaverageStruct.waterPorts;

                fprintf('%s\n',['!mv ' fileBaseMat(i,:) '/' fileBaseMat(i,:) '_LinearizedWhl.mat ' ...
                    fileBaseMat(i,:) '/' fileBaseMat(i,:) '_LinearizedWhl.mat.old ']);
                %fprintf('%s\n',['!rm ' fileBaseMat(i,:) '/*_LinearizedWhl.mat.new']);

                eval(['!mv ' fileBaseMat(i,:) '/' fileBaseMat(i,:) '_LinearizedWhl.mat ' ...
                    fileBaseMat(i,:) '/' fileBaseMat(i,:) '_LinearizedWhl.mat.old ']);
                %eval(['!rm ' fileBaseMat(i,:) '/*_LinearizedWhl.mat.new']);

                save([fileBaseMat(i,:) '/' fileBaseMat(i,:) '_LinearizedWhl.mat'],'-mat',SaveAsV6,'exploration','returnArms','delayArea',...
                    'centerArm','Tjunction','goalArms','waterPorts')
            case 'circle'
                load([fileBaseMat(i,:) '/' fileBaseMat(i,:) '_LinearizedWhl.mat'])
                %fields = fieldnames(linearRLaverageStruct)
                exploration = linearRLaverageStruct.exploration;
                delayAreas = linearRLaverageStruct.delayAreas;
                quad1 = linearRLaverageStruct.quad1;
                quad2  = linearRLaverageStruct.quad2;
                quad3 = linearRLaverageStruct.quad3;
                quad4 = linearRLaverageStruct.quad4;

                fprintf('%s\n',['!mv ' fileBaseMat(i,:) '/' fileBaseMat(i,:) '_LinearizedWhl.mat ' ...
                    fileBaseMat(i,:) '/' fileBaseMat(i,:) '_LinearizedWhl.mat.old ']);
                %fprintf('%s\n',['!rm ' fileBaseMat(i,:) '/*_LinearizedWhl.mat.new']);

                eval(['!mv ' fileBaseMat(i,:) '/' fileBaseMat(i,:) '_LinearizedWhl.mat ' ...
                    fileBaseMat(i,:) '/' fileBaseMat(i,:) '_LinearizedWhl.mat.old ']);
                %eval(['!rm ' fileBaseMat(i,:) '/*_LinearizedWhl.mat.new']);

                save([fileBaseMat(i,:) '/' fileBaseMat(i,:) '_LinearizedWhl.mat'],'-mat',SaveAsV6,'exploration','delayAreas','quad1',...
                    'quad2','quad3','quad4')
            otherwise
        end
    end
end


