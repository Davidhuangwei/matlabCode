function AddDay(regEx1,regEx2)

dayStruct = LoadVar('DayStruct.mat');
infoStruct1 = dir(regEx1);
for j=1:length(infoStruct1)
    dayInfo = dayStruct.(infoStruct1(j).name);
    cd(infoStruct1(j).name);
    infoStruct2 = dir(regEx2);
    for k=1:length(infoStruct2);
         cd(infoStruct2(k).name);
         time = LoadVar('time.mat');
         day = mat2Cell(repmat(dayInfo, size(time)),ones(length(time),1),length(dayInfo));
         save('day.mat',SaveAsV6,'day');
         cd ..
    end
    cd ..
end
         

    