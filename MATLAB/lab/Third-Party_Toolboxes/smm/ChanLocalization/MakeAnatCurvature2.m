function MakeAnatCurvature(curvesFile,overlayFile,animal,anatCurvesFile)
n = 10;
gifData = imread(curvesFile) ;
figure(n);
clf
imagesc(gifData);

gifData = imread(overlayFile) ;
figure(n+2);
clf
imagesc(gifData);

figure(n+1)
clf
chanMat = zeros(16,6);
for i=1:96
    chanMat(i) = mod(i,14);
end
imagesc(chanMat)
set(gca,'xtick',[0.5:0.25:6.5],'ytick',[1:16]);
grid on
hold on

if exist('anatCurvesFile','var') & ~isempty(anatCurvesFile) & exist(anatCurvesFile,'file')
    load(anatCurvesFile);
    CAx = anatCurves{1,1};
    CAy = anatCurves{1,2};
    DGGx = anatCurves{2,1};
    DGGy = anatCurves{2,2};
    LMx = anatCurves{3,1};
    LMy = anatCurves{3,2};
    fissureX = anatCurves{4,1};
    fissureY = anatCurves{4,2};
else
    figure(n)
    fprintf('\nOutline CA1/CA3\n');
    [CAx,CAy] = ginput;
    
    figure(n)
    fprintf('\nOutline the DGG\n');
    [DGGx,DGGy] = ginput;
    
    figure(n)
    fprintf('\nOutline the dorsal LM border\n');
    [LMx,LMy] = ginput;
    
    figure(n)
    fprintf('\nOutline the fissure\n');
    [fissureX,fissureY] = ginput;

    CAx = CAx.*6./max([CAx DGGx LMx fissureX]);
    DGGx = DGGx.*6./max([CAx DGGx LMx fissureX]);
    LMx = LMx.*6./max([CAx DGGx LMx fissureX]);
    fissureX = fissureX.*6./max([CAx DGGx LMx fissureX]);
     
    CAy = CAy.*16./max([CAy DGGy LMy fissureY]);
    DGGy = DGGy.*16./max([CAy DGGy LMy fissureY]);
    LMy = LMy.*16./max([CAy DGGy LMy fissureY]);
    fissureY = fissureY.*16./max([CAy DGGy LMy fissureY]);

end

figure(n+1)    
plot(CAx,CAy,'color',[0.75,0.75,0.75],'linewidth',2)
plot(DGGx,DGGy,'color',[0.75,0.75,0.75],'linewidth',2)
plot(LMx,LMy,'color',[0.75,0.75,0.75],'linewidth',2)
plot(fissureX,fissureY,'color',[0.75,0.75,0.75],'linewidth',2)

notYetCorrect = 1;
while notYetCorrect
    fprintf('Enter new xMag (currently 1/%i):', 1/xMag)
    i = input('');
    if ~isempty(i)
        xMag = i;
    end
    
     fprintf('Enter new yMag (currently 1/%i):', 1/yMag)
    i = input('');    
    if ~isempty(i)
        yMag = i;
    end
    
     fprintf('Enter new xOffset (currently %i):', xOffset)
    i = input('');    
    if ~isempty(i)
        xOffset = i;
    end

     fprintf('Enter new yOffset (currently %i):', yOffset)
    i = input(''); 
    if ~isempty(i)
        yOffset = i;
    end
    
    figure(n+1)
    clf
    imagesc(chanMat)
    set(gca,'xtick',[0.5:0.25:6.5],'ytick',[1:16]);
    grid on
    hold on
    plot(CAx.*xMag+xOffset,CAy.*yMag+yOffset,'color',[0.75,0.75,0.75],'linewidth',2)
    plot(DGGx.*xMag+xOffset,DGGy.*yMag+yOffset,'color',[0.75,0.75,0.75],'linewidth',2)
    plot(LMx.*xMag+xOffset,LMy.*yMag+yOffset,'color',[0.75,0.75,0.75],'linewidth',2)
    plot(fissureX.*xMag+xOffset,fissureY.*yMag+yOffset,'color',[0.75,0.75,0.75],'linewidth',2)
    i = input('beyouhappywitchdat y/[n]:','s');
    if ~isempty(i) & strcmp(i,'y')
        notYetCorrect = 0;
    end
end
i = 0;
while ~strcmp(i,'y') & ~strcmp(i,'y')
    i = input('Save Anatomy Curves y/n:','s');
    if strcmp(i,'y')
        filename = [animal 'AnatCurvScaled.mat'];
        fprintf('Saving %s ...\n', filename)
        anatCurves = {CAx.*xMag+xOffset,CAy.*yMag+yOffset;DGGx.*xMag+xOffset,DGGy.*yMag+yOffset;LMx.*xMag+xOffset,LMy.*yMag+yOffset;fissureX.*xMag+xOffset,fissureY.*yMag+yOffset};
        save(filename,'anatCurves');
    end
end

return
