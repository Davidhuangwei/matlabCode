% function sumTime = SumSpectraTime(fileBaseCell,spectAnalDir)
% Returns the summed length of time files
function sumTime = SumSpectraTime(fileBaseCell,spectAnalDir)

sumTime = 0;
for j=1:length(fileBaseCell)
    sumTime = sumTime + length(LoadVar([fileBaseCell{j} '/' spectAnalDir 'time']));
end
