function PlotLinearizedWhl(fileBaseMat)
xOffset = 0;
figure
for j = 1:7
    for i=1:size(fileBaseMat,1)
        load([fileBaseMat(i,:) '_LinearizedWhl.mat']);
        subplot(7,1,j)
        hold on
        plot(linearRLaverageCell{j,2},'.');
        xOffset = xOffset + length(linearRLaverageCell{j,2});
        title(linearRLaverageCell{j,1})
    end
end