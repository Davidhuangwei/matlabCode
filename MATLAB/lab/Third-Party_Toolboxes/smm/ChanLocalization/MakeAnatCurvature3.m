function MakeAnatCurvature3(curvesFile,animal,anatCurvesFile)
nShanks = 6;
nSitePerShank = 16;

THIS_FUNCTION_NEEDS_TO_BE_FIXED_TO_SCALE_CORRECTLY
% for j=1:length(analDirs)
%     if ~exist('AnatCurvesNew.mat','file')
%         cd([analDirs{j} 'ChanInfo'])
%         anatCurves = LoadVar('AnatCurves.mat');
% 
%         for a=1:size(anatCurves,1)
%             anatCurves2{a,2} = (anatCurves{a,2}*16.5-0.5)/16;
%             anatCurves2{a,1} = (anatCurves{a,1}*6.5-0.5)/6;
%         end
%         anatCurves = anatCurves2;
%         save('AnatCurvesNew.mat',SaveAsV6,'anatCurves');
%     end
% end
n = 10;
gifData = imread(curvesFile) ;
figure(n);
clf
imagesc(gifData);

%gifData = imread(overlayFile) ;
%figure(n+2);
%clf
%imagesc(gifData);

figure(n+1)
clf
chanMat = zeros(nSitePerShank,nShanks);
for i=1:nSitePerShank*nShanks
    chanMat(i) = mod(i,nSitePerShank-2);
end
imagesc(chanMat)
set(gca,'xtick',[0.5:0.25:nShanks+0.5],'ytick',[1:nSitePerShank]);
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
    
    figure(n+2)
    hold on
    plot(CAx,CAy,'color',[0.75,0.75,0.75],'linewidth',2)
    plot(DGGx,DGGy,'color',[0.75,0.75,0.75],'linewidth',2)
    plot(LMx,LMy,'color',[0.75,0.75,0.75],'linewidth',2)
    plot(fissureX,fissureY,'color',[0.75,0.75,0.75],'linewidth',2)
end

in = [];
while ~strcmp(in,'y') & ~strcmp(in,'n')
    in = input('Do you want to outline anatomical regions? (y/n): ','s');
end
if strcmp(in,'y')
    in = [];
    while ~strcmp(in,'y') & ~strcmp(in,'n')
        in = input('Do you want to outline CA1/Ca3? (y/n): ','s');
    end
    if strcmp(in,'y')
        figure(n)
        fprintf('\nOutline CA1/CA3 and then hit enter\n');
        [CAx,CAy] = ginput;
    end

    in = [];
    while ~strcmp(in,'y') & ~strcmp(in,'n')
        in = input('Do you want to outline DGG? (y/n): ','s');
    end
    if strcmp(in,'y')
        figure(n)
        fprintf('\nOutline the DGG and then hit enter\n');
        [DGGx,DGGy] = ginput;
    end

    in = [];
    while ~strcmp(in,'y') & ~strcmp(in,'n')
        in = input('Do you want to outline the dorsal LM border? (y/n): ','s');
    end
    if strcmp(in,'y')
        figure(n)
        fprintf('\nOutline the dorsal LM border and then hit enter\n');
        [LMx,LMy] = ginput;
    end

    in = [];
    while ~strcmp(in,'y') & ~strcmp(in,'n')
        in = input('Do you want to outline the fissure? (y/n): ','s');
    end
    if strcmp(in,'y')
        figure(n)
        fprintf('\nOutline the fissure and then hit enter\n');
        [fissureX,fissureY] = ginput;
    end
    
    i = 0;
    while ~strcmp(i,'yes') & ~strcmp(i,'no')
        i = input('Do you want save AnatCurvesRaw.mat?: (yes/no)','s');
        if strcmp(i,'yes')
            filename = [animal 'AnatCurvesRaw.mat'];
            fprintf('Saving %s ...\n', filename)
            anatCurves = {CAx,CAy;DGGx,DGGy;LMx,LMy;fissureX,fissureY};
            matlabVersion = version;
            if str2num(matlabVersion(1)) > 6
                save(filename,'-V6','anatCurves');
            else
                save(filename,'anatCurves');
            end
        end
    end

    maxX = max([CAx; DGGx; LMx; fissureX]);
    maxY = max([CAy; DGGy; LMy; fissureY]);
    CAx = CAx.*nShanks./maxX;
    DGGx = DGGx.*nShanks./maxX;
    LMx = LMx.*nShanks./maxX;
    fissureX = fissureX.*nShanks./maxX;
     
    CAy = CAy.*nSitePerShank./maxY;
    DGGy = DGGy.*nSitePerShank./maxY;
    LMy = LMy.*nSitePerShank./maxY;
    fissureY = fissureY.*nSitePerShank./maxY;

end

figure(n+1)    
plot(CAx,CAy,'color',[0.75,0.75,0.75],'linewidth',2)
plot(DGGx,DGGy,'color',[0.75,0.75,0.75],'linewidth',2)
plot(LMx,LMy,'color',[0.75,0.75,0.75],'linewidth',2)
plot(fissureX,fissureY,'color',[0.75,0.75,0.75],'linewidth',2)

notYetCorrect = 1;
while notYetCorrect
    xMag = 1;
    yMag = 1;
    xOffset = 0;
    yOffset = 0;
    
    i = input('Enter new xMag: ');
    if ~isempty(i)
        xMag = i;
    end
    
        i = input('Enter new xOffset: ');    
    if ~isempty(i)
        xOffset = i;
    end

    i = input('Enter new yMag: ');    
    if ~isempty(i)
        yMag = i;
    end

    i = input('Enter new yOffset: '); 
    if ~isempty(i)
        yOffset = i;
    end
    CAx = CAx.*xMag+xOffset;
    CAy = CAy.*yMag+yOffset;
    DGGx = DGGx.*xMag+xOffset;
    DGGy = DGGy.*yMag+yOffset;
    LMx = LMx.*xMag+xOffset;
    LMy = LMy.*yMag+yOffset;
    fissureX = fissureX.*xMag+xOffset;
    fissureY = fissureY.*yMag+yOffset;
    
    figure(n+1)
    clf
    imagesc(chanMat)
    set(gca,'xtick',[0.5:0.25:nShanks+0.5],'ytick',[1:nSitePerShank]);
    grid on
    hold on
    plot(CAx,CAy,'color',[0.75,0.75,0.75],'linewidth',2)
    plot(DGGx,DGGy,'color',[0.75,0.75,0.75],'linewidth',2)
    plot(LMx,LMy,'color',[0.75,0.75,0.75],'linewidth',2)
    plot(fissureX,fissureY,'color',[0.75,0.75,0.75],'linewidth',2)
    i = input('beyouhappywitchdat y/[n]:','s');
    if ~isempty(i) & strcmp(i,'y')
        notYetCorrect = 0;
    end
end
i = 0;
while ~strcmp(i,'yes') & ~strcmp(i,'no')
    i = input('Save Anatomy Curves yes/no:','s');
    if strcmp(i,'yes')
        filename = [animal 'AnatCurvScaled.mat'];
        fprintf('Saving %s ...\n', filename)
        anatCurves = {CAx,CAy;DGGx,DGGy;LMx,LMy;fissureX,fissureY};
        matlabVersion = version;
        if str2num(matlabVersion(1)) > 6
            save(filename,'-V6','anatCurves');
        else
            save(filename,'anatCurves');
        end
        
        filename = [animal 'AnatCurves.mat'];
        fprintf('Saving %s ...\n', filename)

        CAx = CAx./(nShanks+0.5);
        DGGx = DGGx./(nShanks+0.5);
        LMx = LMx./(nShanks+0.5);
        fissureX = fissureX./(nShanks+0.5);
        CAy = CAy./(nSitePerShank+0.5);
        DGGy = DGGy./(nSitePerShank+0.5);
        LMy = LMy./(nSitePerShank+0.5);
        fissureY = fissureY./(nSitePerShank+0.5);
        
        anatCurves = {CAx,CAy;DGGx,DGGy;LMx,LMy;fissureX,fissureY};
        matlabVersion = version;
        if str2num(matlabVersion(1)) > 6
            save(filename,'-V6','anatCurves');
        else
            save(filename,'anatCurves');
        end

    end
end

return
