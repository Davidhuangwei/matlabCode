
function happy'asdf'
figure(1)
imagesc(Make2DPlotMat(mean(mazeMeasStruct.thetaFreq(find(mazeMeasStruct.mazeLocation*[0 0 0 1 0 0 0 0 0]'>.5 & mazeMeasStruct.trialType*[1 0 1 0 0 0 0 0 0 0 0 0 0]'>0.7),:),1),MakeChanMat(6,16),badchan))
set(gca,'clim',[8.6 9.6]); colorbar

figure(2)
imagesc(Make2DPlotMat(mean(mazeMeasStruct.thetaFreq(find(mazeMeasStruct.mazeLocation*[0 0 0 0 1 0 0 0 0]'>.5 & mazeMeasStruct.trialType*[1 0 1 0 0 0 0 0 0 0 0 0 0]'>0.7),:),1),MakeChanMat(6,16),badchan))
set(gca,'clim',[8.6 9.6]); colorbar

figure(3)
imagesc(Make2DPlotMat(mean(mazeMeasStruct.thetaFreq(find(mazeMeasStruct.mazeLocation*[0 0 0 0 0 1 1 0 0]'>.5 & mazeMeasStruct.trialType*[1 0 1 0 0 0 0 0 0 0 0 0 0]'>0.7),:),1),MakeChanMat(6,16),badchan))
set(gca,'clim',[8.6 9.6]); colorbar

figure(4)
imagesc(Make2DPlotMat(mean(mazeMeasStruct.thetaFreq(find(mazeMeasStruct.mazeLocation*[0 0 0 0 0 0 0 1 1]'>.5 & mazeMeasStruct.trialType*[1 0 1 0 0 0 0 0 0 0 0 0 0]'>0.7),:),1),MakeChanMat(6,16),badchan))
set(gca,'clim',[8.6 9.6]); colorbar

