data = [];
mazeRegions = fieldnames(mazeMeasStruct);
for i=1:size(mazeRegions,1)
    data = [data; getfield(mazeMeasStruct,mazeRegions{i,:},'thetaPowPeak')];
end
data = [];
mazeRegions = fieldnames(mazeMeasStruct);
for i=1:size(mazeRegions,1)
    data = [data; getfield(mazeMeasStruct,mazeRegions{i,:},'gammaPowIntg')];
end

data = getfield(remMeasStruct,'thetaPowPeak');
data = getfield(remMeasStruct,'gammaPowIntg');

data(:,[badchan 97]) = 0;

[coef,score,latent,tsquare] = princomp(data); 
junk = data*coef;

addpath /u24/antsiro/toolboxes/DimReduction/FastICA
[icasig, A, W] = fastica(data','firstEig',1,'lastEig',10);
[icasig, A, W] = fastica(data','firstEig',1,'lastEig',10,  'maxNumIterations',1000,'maxFinetune' ,1000);



 clf;h=XYFImageScRmNaN({Make2DPlotMat(A(:,i), MakeChanMat(6,16),0)},[-1 1],[],3);PlotAnatCurves('sm9603AnatCurvScaled.mat');i=i+1
clf;h=XYFImageScRmNaN({Make2DPlotMat(A(:,i), MakeChanMat(6,16),0)},[-1 1],[],3);PlotAnatCurves('sm9603AnatCurvScaled.mat');figure(1);clf;hold on;for j=1:4,plot(((j-1)*38+1):j*38,icasig(i,((j-1)*38+1):j*38),'.','color',plotColors(j,:));end;i=i+1
 clf;h=XYFImageScRmNaN({Make2DPlotMat(coef(:,i), MakeChanMat(6,16),0)},[-0.3 0.3],[],20);PlotAnatCurves('sm9603AnatCurvScaled.mat');figure(21);clf;hold on;for j=1:4,plot(((j-1)*38+1):j*38,junk(((j-1)*38+1):j*38,i),'.','color',plotColors(j,:));end;i=i+1
 clf;h=XYFImageScRmNaN({Make2DPlotMat(data(:,i), MakeChanMat(6,16),0)},[-0.3 0.3],[],20);PlotAnatCurves('sm9603AnatCurvScaled.mat');figure(21);clf;hold on;for j=1:4,plot(((j-1)*38+1):j*38,data(((j-1)*38+1):j*38,i),'.','color',plotColors(j,:));end;i=i+1
 
 %for REM
 clf;h=XYFImageScRmNaN({Make2DPlotMat(coef(:,i), MakeChanMat(6,16),0)},[-0.3 0.3],[],20);PlotAnatCurves('sm9603AnatCurvScaled.mat');figure(21);clf;hold on;plot(junk(:,i),'.');i=i+1
 clf;h=XYFImageScRmNaN({Make2DPlotMat(A(:,i), MakeChanMat(6,16),0)},[-1 1],[],3);PlotAnatCurves('sm9603AnatCurvScaled.mat');figure(1);clf;hold on;plot(icasig(i,:),'.');i=i+1
  


imagesc({Make2DPlotMat(coef(:,i), MakeChanMat(6,16),0)})

average = mean(data,1);
mazeRegions = fieldnames(mazeMeasStruct);
getfield(mazeMeasStruct,mazeRegions{j,:},'thetaPowPeak')

for j=1:4,figure(j+10);clf;XYFImageScRmNaN({Make2DPlotMat(getfield(mazeMeasStruct,mazeRegions{j,:},'gammaPowIntg',{i,1:97})-average,MakeChanMat(6,16),0)},[-4 4],[],gcf);PlotAnatCurves('sm9603AnatCurvScaled.mat');title(mazeRegions{j,:});end;i=i+1
    
 for j=1:4,figure(j+10);clf;XYFImageScRmNaN({Make2DPlotMat(getfield(mazeMeasStruct,mazeRegions{j,:},'gammaPowIntg',{i,1:97})-trialAverage(i,:),MakeChanMat(6,16),0)},[-4 4],[],gcf);PlotAnatCurves('sm9603AnatCurvScaled.mat');title(mazeRegions{j,:});end;i=i+1
   
for i=1:38
trialAverage(i,:) = mean(cat(3,data(i,:),data(i+38,:),data(i+76,:),data(i+114,:)),3);
end

