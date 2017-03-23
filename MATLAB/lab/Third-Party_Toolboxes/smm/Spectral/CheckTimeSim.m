% function CheckTimeSim(fileBaseCell,spectAnalDir1,spectAnalDir2)
% tag:check
% tag:time
% tag:sim

function CheckTimeSim(fileBaseCell,spectAnalDir1,spectAnalDir2)

for j=1:length(fileBaseCell)
    time1 = LoadVar([SC(fileBaseCell{j}) SC(spectAnalDir1) 'time']);
    time2 = LoadVar([SC(fileBaseCell{j}) SC(spectAnalDir2) 'time']);
end
