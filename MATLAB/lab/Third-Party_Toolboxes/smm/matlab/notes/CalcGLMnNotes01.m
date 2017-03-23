maxL = 0;
minL = 1000;

for j=1:length(dataStruct.coeffs.categ1_maze(:))
    maxL = max([maxL length(dataStruct.coeffs.categ1_maze{j})]);
    minL = min([minL length(dataStruct.coeffs.categ1_maze{j})]);
end

maxL
minL

mazeRegion_centerArm


maxL = 0;
minL = 1000;

for j=1:length(dataStruct.coeffs.mazeRegion_centerArm(:))
    maxL = max([maxL length(dataStruct.coeffs.mazeRegion_centerArm{j})]);
    minL = min([minL length(dataStruct.coeffs.mazeRegion_centerArm{j})]);
end

maxL
minL

