fileBaseCell = LoadVar('FileInfo/AlterFiles');

nChan = load('ChanInfo/NChan.eeg.txt');
badChan = load('ChanInfo/BadChan.eeg.txt');
anatPlotSize = size(LoadVar('ChanInfo/ChanMat.eeg.mat'));
trialTypesBool = [1  0  1  0  0   0   0   0   0   0   0   0  0];
mazeLocationsBool = [0   0   1  1  1   1   1   1   1];

data = [];
whlData = [];
cwd = pwd;
for j=1:length(fileBaseCell);
    cd([cwd '/' fileBaseCell{j}])
    whlData = cat(1,whlData,LoadMazeTrialTypes([fileBaseCell{j}],trialTypesBool,mazeLocationsBool));
    data = cat(1,data,readmulti([fileBaseCell{j} '_50-120Hz.eeg.100DBdspow'],nChan));
end
cd(cwd)

data(:,[badChan 97]) = 0;

[coef,score,latent,tsquare] = princomp(data); 
junk = data*coef;

addpath /u12/antsiro/matlab/toolboxes/DimReduction/FastICA
[icasig, A, W] = fastica(data','firstEig',1,'lastEig',10);
[icasig, A, W] = fastica(data','firstEig',1,'lastEig',10,  'maxNumIterations',1000,'maxFinetune' ,1000);

i=0;
i=i+1; clf;h=XYFImageScRmNaN({Make2DPlotMat(A(:,i), MakeChanMat(6,16),badChan,'linear')},[],[],3);PlotAnatCurves('ChanInfo/AnatCurves.mat',anatPlotSize);
clf;h=XYFImageScRmNaN({Make2DPlotMat(A(:,i), MakeChanMat(6,16),0)},[-1 1],[],3);PlotAnatCurves('sm9603AnatCurvScaled.mat');figure(1);clf;hold on;for j=1:4,plot(((j-1)*38+1):j*38,icasig(i,((j-1)*38+1):j*38),'.','color',plotColors(j,:));end;i=i+1
 
plot(cumsum(latent/sum(latent)));

i=i+1;clf;h=XYFImageScRmNaN({Make2DPlotMat(coef(:,i), MakeChanMat(6,16),badChan,'linear')},[-0.3 0.3],[],20);PlotAnatCurves('ChanInfo/AnatCurves.mat',anatPlotSize);
 clf;h=XYFImageScRmNaN({Make2DPlotMat(data(:,i), MakeChanMat(6,16),0)},[-0.3 0.3],[],20);PlotAnatCurves('sm9603AnatCurvScaled.mat');figure(21);clf;hold on;for j=1:4,plot(((j-1)*38+1):j*38,data(((j-1)*38+1):j*38,i),'.','color',plotColors(j,:));end;i=i+1

[powMap occupancyMap] = PowField(score(:,i),whlData(:,1:2));
[powMap occupancyMap] = PowField(icasig(i,:)',whlData(:,1:2));
figure(21)
[powMap occupancyMap] = PowField(score(:,i),whlData(:,1:2));
PlotPowField(powMap,occupancyMap); colorbar
imagesc(powMap./occupancyMap);
 