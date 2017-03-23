function dataCell = UnitExpSmoothHelper(dataCell,smoothKernel,smoothStep)

for j=1:size(dataCell,1)
    for k=1:size(dataCell{j,6},1)
        dataCell{j,6}(k,:) = ExpSmooth(dataCell{j,6}(k,:),smoothKernel,smoothStep);
    end
end