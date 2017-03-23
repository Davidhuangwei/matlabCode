%%%%%%%% GLM analysis batch %%%%%%%%%
fileExt = '_LinNear.eeg';
chanDir = 'ChanInfo/';
chanMat = LoadVar([chanDir 'ChanMat' fileExt '.mat']);
nchan = max(max(chanMat));
selChans = load([chanDir 'SelectedChannels' fileExt '.txt']);
analProgName = 'CalcRunningSpectra9_noExp';
nameNote = 'firstRun';
files = LoadVar('AlterFiles');
indepVarCell = {'speed.p0','accel.p0'};
GlmWholeModel01(analProgName,nameNote,files,fileExt,'thetaPowPeak6-12Hz',indepVarCell,nchan,0)
GlmWholeModel01(analProgName,nameNote,files,fileExt,'thetaPowIntg6-12Hz',indepVarCell,nchan,0)
GlmWholeModel01(analProgName,nameNote,files,fileExt,'gammaPowPeak65-100Hz',indepVarCell,nchan,0)
GlmWholeModel01(analProgName,nameNote,files,fileExt,'gammaPowIntg65-100Hz',indepVarCell,nchan,0)
for j=1:length(selChans)
    selChanName = ['.ch' num2str(selChans(j))]
    GlmWholeModel01(analProgName,nameNote,files,fileExt,['thetaCohMedian6-12Hz' selChanName],indepVarCell,nchan,0)
    GlmWholeModel01(analProgName,nameNote,files,fileExt,['gammaCohMedian65-100Hz' selChanName],indepVarCell,nchan,0)
end
GlmWholeModel01(analProgName,nameNote,files,fileExt,'powSpec.yo',indepVarCell,nchan,1)
for j=1:length(selChans)
    selChanName = ['.ch' num2str(selChans(j))]
    GlmWholeModel01(analProgName,nameNote,files,fileExt,['cohSpec.yo' selChanName],indepVarCell,nchan,1)
end






fileExt = '_LinNear.eeg';
chanDir = 'ChanInfo/';
chanMat = LoadVar([chanDir 'ChanMat' fileExt '.mat']);
nchan = max(max(chanMat));
selChans = load([chanDir 'SelectedChannels' fileExt '.txt']);
GlmPartialModel01('CalcRunningSpectra9_noExp','firstRun',LoadVar('AlterFiles'),fileExt,'thetaPowPeak6-12Hz',{'speed.p0','accel.p0'},nchan,0)
GlmPartialModel01('CalcRunningSpectra9_noExp','firstRun',LoadVar('AlterFiles'),fileExt,'gammaPowPeak65-100Hz',{'speed.p0','accel.p0'},nchan,0)
GlmPartialModel01('CalcRunningSpectra9_noExp','firstRun',LoadVar('AlterFiles'),fileExt,'gammaPowIntg65-100Hz',{'speed.p0','accel.p0'},nchan,0)
for j=1:length(selChans)
    selChanName = ['.ch' num2str(selChans(j))]
    GlmPartialModel01('CalcRunningSpectra9_noExp','firstRun',LoadVar('AlterFiles'),fileExt,['thetaCohMedian6-12Hz' selChanName],{'speed.p0','accel.p0'},nchan,0)
    GlmPartialModel01('CalcRunningSpectra9_noExp','firstRun',LoadVar('AlterFiles'),fileExt,['gammaCohMedian65-100Hz' selChanName],{'speed.p0','accel.p0'},nchan,0)
end
GlmPartialModel01('CalcRunningSpectra9_noExp','firstRun',LoadVar('AlterFiles'),fileExt,'powSpec.yo',{'speed.p0','accel.p0'},nchan,1)
for j=1:length(selChans)
    selChanName = ['.ch' num2str(selChans(j))]
    GlmPartialModel01('CalcRunningSpectra9_noExp','firstRun',LoadVar('AlterFiles'),fileExt,['cohSpec.yo' selChanName],{'speed.p0','accel.p0'},nchan,1)
end

fileExt = '_LinNearCSD121.csd';
chanDir = 'ChanInfo/';
chanMat = LoadVar([chanDir 'ChanMat' fileExt '.mat']);
nchan = max(max(chanMat));
selChans = load([chanDir 'SelectedChannels' fileExt '.txt']);
GlmPartialModel01('CalcRunningSpectra9_noExp','firstRun',LoadVar('AlterFiles'),fileExt,'thetaPowPeak6-12Hz',{'speed.p0','accel.p0'},nchan,0)
GlmPartialModel01('CalcRunningSpectra9_noExp','firstRun',LoadVar('AlterFiles'),fileExt,'gammaPowPeak65-100Hz',{'speed.p0','accel.p0'},nchan,0)
GlmPartialModel01('CalcRunningSpectra9_noExp','firstRun',LoadVar('AlterFiles'),fileExt,'gammaPowIntg65-100Hz',{'speed.p0','accel.p0'},nchan,0)
for j=1:length(selChans)
    selChanName = ['.ch' num2str(selChans(j))]
    GlmPartialModel01('CalcRunningSpectra9_noExp','firstRun',LoadVar('AlterFiles'),fileExt,'thetaCohMedian6-12Hz' selChanName],{'speed.p0','accel.p0'},nchan,0)
    GlmPartialModel01('CalcRunningSpectra9_noExp','firstRun',LoadVar('AlterFiles'),fileExt,'gammaCohMedian65-100Hz' selChanName],{'speed.p0','accel.p0'},nchan,0)
end
GlmPartialModel01('CalcRunningSpectra9_noExp','firstRun',LoadVar('AlterFiles'),fileExt,'powSpec.yo',{'speed.p0','accel.p0'},nchan,1)
for j=1:length(selChans)
    selChanName = ['.ch' num2str(selChans(j))]
    GlmPartialModel01('CalcRunningSpectra9_noExp','firstRun',LoadVar('AlterFiles'),fileExt,['cohSpec.yo' selChanName],{'speed.p0','accel.p0'},nchan,1)
end











fileExt = '_LinNear.eeg';
chanDir = 'ChanInfo/';
chanMat = LoadVar([chanDir 'ChanMat' fileExt '.mat']);
nchan = max(max(chanMat));
selChans = load([chanDir 'SelectedChannels' fileExt '.txt']);
GlmWholeModel01('CalcRunningSpectra9_noExp','firstRun',LoadVar('AlterFiles'),fileExt,'thetaPowPeak6-12Hz',{'speed.p0','accel.p0'},nchan,0)
GlmWholeModel01('CalcRunningSpectra9_noExp','firstRun',LoadVar('AlterFiles'),fileExt,'gammaPowPeak65-100Hz',{'speed.p0','accel.p0'},nchan,0)
GlmWholeModel01('CalcRunningSpectra9_noExp','firstRun',LoadVar('AlterFiles'),fileExt,'gammaPowIntg65-100Hz',{'speed.p0','accel.p0'},nchan,0)
for j=1:length(selChans)
    selChanName = ['.ch' num2str(selChans(j))]
    GlmWholeModel01('CalcRunningSpectra9_noExp','firstRun',LoadVar('AlterFiles'),fileExt,['thetaCohMedian6-12Hz' selChanName],{'speed.p0','accel.p0'},nchan,0)
    GlmWholeModel01('CalcRunningSpectra9_noExp','firstRun',LoadVar('AlterFiles'),fileExt,['gammaCohMedian65-100Hz' selChanName],{'speed.p0','accel.p0'},nchan,0)
end
GlmWholeModel01('CalcRunningSpectra9_noExp','firstRun',LoadVar('AlterFiles'),fileExt,'powSpec.yo',{'speed.p0','accel.p0'},nchan,1)
for j=1:length(selChans)
    selChanName = ['.ch' num2str(selChans(j))]
    GlmWholeModel01('CalcRunningSpectra9_noExp','firstRun',LoadVar('AlterFiles'),fileExt,['cohSpec.yo' selChanName],{'speed.p0','accel.p0'},nchan,1)
end

fileExt = '_LinNearCSD121.csd';
chanDir = 'ChanInfo/';
chanMat = LoadVar([chanDir 'ChanMat' fileExt '.mat']);
nchan = max(max(chanMat));
selChans = load([chanDir 'SelectedChannels' fileExt '.txt']);
GlmWholeModel01('CalcRunningSpectra9_noExp','firstRun',LoadVar('AlterFiles'),fileExt,'thetaPowPeak6-12Hz',{'speed.p0','accel.p0'},nchan,0)
GlmWholeModel01('CalcRunningSpectra9_noExp','firstRun',LoadVar('AlterFiles'),fileExt,'gammaPowPeak65-100Hz',{'speed.p0','accel.p0'},nchan,0)
GlmWholeModel01('CalcRunningSpectra9_noExp','firstRun',LoadVar('AlterFiles'),fileExt,'gammaPowIntg65-100Hz',{'speed.p0','accel.p0'},nchan,0)
for j=1:length(selChans)
    selChanName = ['.ch' num2str(selChans(j))]
    GlmWholeModel01('CalcRunningSpectra9_noExp','firstRun',LoadVar('AlterFiles'),fileExt,'thetaCohMedian6-12Hz' selChanName],{'speed.p0','accel.p0'},nchan,0)
    GlmWholeModel01('CalcRunningSpectra9_noExp','firstRun',LoadVar('AlterFiles'),fileExt,'gammaCohMedian65-100Hz' selChanName],{'speed.p0','accel.p0'},nchan,0)
end
GlmWholeModel01('CalcRunningSpectra9_noExp','firstRun',LoadVar('AlterFiles'),fileExt,'powSpec.yo',{'speed.p0','accel.p0'},nchan,1)
for j=1:length(selChans)
    selChanName = ['.ch' num2str(selChans(j))]
    GlmWholeModel01('CalcRunningSpectra9_noExp','firstRun',LoadVar('AlterFiles'),fileExt,['cohSpec.yo' selChanName],{'speed.p0','accel.p0'},nchan,1)
end











fileExt = '_LinNearCSD121.csd';
chanDir = 'ChanInfo/';
chanMat = LoadVar([chanDir 'ChanMat' fileExt '.mat']);
nchan = max(max(chanMat));
selChans = load([chanDir 'SelectedChannels' fileExt '.txt']);
glmtrial13('CalcRunningSpectra9_noExp','firstRun',LoadVar('AlterFiles'),fileExt,'powSpec.yo',{'speed.p0','accel.p0'},nchan,1)
for j=1:length(selChans)
    selChanName = ['.ch' num2str(selChans(j))]
    glmtrial13('CalcRunningSpectra9_noExp','firstRun',LoadVar('AlterFiles'),fileExt,['cohSpec.yo' selChanName],{'speed.p0','accel.p0'},nchan,1)
end

fileExt = '_NearAveCSD1.csd';
chanDir = 'ChanInfo/';
chanMat = LoadVar([chanDir 'ChanMat' fileExt '.mat']);
nchan = max(max(chanMat));
selChans = load([chanDir 'SelectedChannels' fileExt '.txt']);
glmtrial13('CalcRunningSpectra9_noExp','firstRun',LoadVar('AlterFiles'),fileExt,'powSpec.yo',{'speed.p0','accel.p0'},nchan,1)
for j=1:length(selChans)
    selChanName = ['.ch' num2str(selChans(j))]
    glmtrial13('CalcRunningSpectra9_noExp','firstRun',LoadVar('AlterFiles'),fileExt,['cohSpec.yo' selChanName],{'speed.p0','accel.p0'},nchan,1)
end

for j=1:length(selChans)
    selChanName = ['.ch' num2str(selChans(j))]
    PlotGLMResults01('GlmPartialModel01','Alter_firstRun_',['gammaCohMedian65-100Hz' selChanName],'_LinNear.eeg',0,[],1)
end
PlotGLMResults01('GlmPartialModel01','Alter_firstRun_','gammaPowPeak65-100Hz','_LinNear.eeg',0,[],1)
PlotGLMResults01('GlmPartialModel01','Alter_firstRun_','powSpec.yo','_LinNear.eeg',1,[],1)
PlotGLMResults01('WholeModelGlm01','Alter_Vs_Circle_EachRegion_WholeModel_firstRun_','thetaPowPeak6-12Hz','_LinNear.eeg',0,[])
glmtrial13test('CalcRunningSpectra9_noExp','firstRun',[LoadVar('AlterFiles');LoadVar('CircleFiles')],fileExt,'thetaPowPeak6-12Hz',{'speed.p0','accel.p0'},nchan)


N = winLength;
DT = 1/eegSamp;
DJ = 1/(2^4);
S0 = 4/eegSamp;
J1 = round(log2(N*DT/S0)/(DJ)-22);

for m=1:nChan
    [temp period2] = wavelet(eegData(m,:)',DT,1,DJ,S0,J1);
    pow2(1,m,:) = mean(abs(temp').^2.*[repmat([hanning(winLength)./mean(hanning(winLength))],1,size(temp,1))],1);
end

for m=1:nChan
    figure(1)
    clf
    title(num2str(m))
    hold on
    plot(1./period.*eegSamp,log10(squeeze(pow(1,m,:))))
    plot(1./period2,log10(squeeze(pow2(1,m,:))),'r')
    in = input('keep going','s')
    if ~isempty(in)
        break
    end
end



fileExt = '_LinNear.eeg';
chanDir = 'ChanInfo/';
chanMat = LoadVar([chanDir 'ChanMat' fileExt '.mat']);
nchan = max(max(chanMat));
selChans = load([chanDir 'SelectedChannels' fileExt '.txt']);
GlmWholeModel02('CalcRunningSpectra10_noExp','win750K8firstRun',LoadVar('AlterFiles'),fileExt,'thetaPowPeak6-12Hz',{'speed.p0','accel.p0'},nchan,0,150,1,3,0,0,1,0,750)
GlmWholeModel02('CalcRunningSpectra10_noExp','win750K8firstRun',LoadVar('AlterFiles'),fileExt,'gammaPowPeak65-100Hz',{'speed.p0','accel.p0'},nchan,0,150,1,3,0,0,1,0,750)
GlmWholeModel02('CalcRunningSpectra10_noExp','win750K8firstRun',LoadVar('AlterFiles'),fileExt,'gammaPowIntg65-100Hz',{'speed.p0','accel.p0'},nchan,0,150,1,3,0,0,1,0,750)
for j=1:length(selChans)
    selChanName = ['.ch' num2str(selChans(j))]
    GlmWholeModel02('CalcRunningSpectra10_noExp','win750K8firstRun',LoadVar('AlterFiles'),fileExt,['thetaCohMedian6-12Hz' selChanName],{'speed.p0','accel.p0'},nchan,0,150,1,3,0,0,1,0,750)
    GlmWholeModel02('CalcRunningSpectra10_noExp','win750K8firstRun',LoadVar('AlterFiles'),fileExt,['gammaCohMedian65-100Hz' selChanName],{'speed.p0','accel.p0'},nchan,0,150,1,3,0,0,1,0,750)
end
GlmWholeModel02('CalcRunningSpectra10_noExp','win750K8firstRun',LoadVar('AlterFiles'),fileExt,'powSpec.yo',{'speed.p0','accel.p0'},nchan,1,150,1,3,0,0,1,0,750)
for j=1:length(selChans)
    selChanName = ['.ch' num2str(selChans(j))]
    GlmWholeModel02('CalcRunningSpectra10_noExp','win750K8firstRun',LoadVar('AlterFiles'),fileExt,['cohSpec.yo' selChanName],{'speed.p0','accel.p0'},nchan,1,150,1,3,0,0,1,0,750)
end

fileExt = '_LinNearCSD121.csd';
chanDir = 'ChanInfo/';
chanMat = LoadVar([chanDir 'ChanMat' fileExt '.mat']);
nchan = max(max(chanMat));
selChans = load([chanDir 'SelectedChannels' fileExt '.txt']);
GlmWholeModel02('CalcRunningSpectra10_noExp','win750K8firstRun',LoadVar('AlterFiles'),fileExt,'thetaPowPeak6-12Hz',{'speed.p0','accel.p0'},nchan,0,150,1,3,0,0,1,0,750)
GlmWholeModel02('CalcRunningSpectra10_noExp','win750K8firstRun',LoadVar('AlterFiles'),fileExt,'gammaPowPeak65-100Hz',{'speed.p0','accel.p0'},nchan,0,150,1,3,0,0,1,0,750)
GlmWholeModel02('CalcRunningSpectra10_noExp','win750K8firstRun',LoadVar('AlterFiles'),fileExt,'gammaPowIntg65-100Hz',{'speed.p0','accel.p0'},nchan,0,150,1,3,0,0,1,0,750)
for j=1:length(selChans)
    selChanName = ['.ch' num2str(selChans(j))]
    GlmWholeModel02('CalcRunningSpectra10_noExp','win750K8firstRun',LoadVar('AlterFiles'),fileExt,'thetaCohMedian6-12Hz' selChanName],{'speed.p0','accel.p0'},nchan,0,150,1,3,0,0,1,0,750)
    GlmWholeModel02('CalcRunningSpectra10_noExp','win750K8firstRun',LoadVar('AlterFiles'),fileExt,'gammaCohMedian65-100Hz' selChanName],{'speed.p0','accel.p0'},nchan,0,150,1,3,0,0,1,0,750)
end
GlmWholeModel02('CalcRunningSpectra10_noExp','win750K8firstRun',LoadVar('AlterFiles'),fileExt,'powSpec.yo',{'speed.p0','accel.p0'},nchan,1,150,1,3,0,0,1,0,750)
for j=1:length(selChans)
    selChanName = ['.ch' num2str(selChans(j))]
    GlmWholeModel02('CalcRunningSpectra10_noExp','win750K8firstRun',LoadVar('AlterFiles'),fileExt,['cohSpec.yo' selChanName],{'speed.p0','accel.p0'},nchan,1,150,1,3,0,0,1,0,750)
end







%%%%%%%%%%%%% plot batch %%%%%%%%%%%%
fileExt = '_LinNearCSD121.csd';
chanDir = 'ChanInfo/';
chanMat = LoadVar([chanDir 'ChanMat' fileExt '.mat']);
nchan = max(max(chanMat));
selChans = load([chanDir 'SelectedChannels' fileExt '.txt']);
analProgName = 'GlmWholeModel01';
nameNote = 'Alter_firstRun_';
interpFunc = 'linear';
PlotGLMResults01(analProgName,nameNote,'thetaPowPeak6-12Hz',fileExt,0,interpFunc,1,[-1.5 1.5])
PlotGLMResults01(analProgName,nameNote,'thetaPowIntg6-12Hz',fileExt,0,interpFunc,1,[-1.5 1.5])
PlotGLMResults01(analProgName,nameNote,'gammaPowIntg65-100Hz',fileExt,0,interpFunc,1,[-0.75 0.75])
PlotGLMResults01(analProgName,nameNote,'gammaPowPeak65-100Hz',fileExt,0,interpFunc,1,[-0.75 0.75])
for j=1:length(selChans)
    selChanName = ['.ch' num2str(selChans(j))]
    PlotGLMResults01(analProgName,nameNote,['thetaCohMedian6-12Hz' selChanName],'_LinNear.eeg',0,interpFunc,1,[-1 1])
    PlotGLMResults01(analProgName,nameNote,['gammaCohMedian65-100Hz' selChanName],'_LinNear.eeg',0,interpFunc,1,[-1 1])
end
PlotGLMResults01(analProgName,nameNote,'powSpec.yo',fileExt,1,interpFunc,1,[-1.5 1.5])
for j=2:2length(selChans)
    selChanName = ['.ch' num2str(selChans(j))]
     PlotGLMResults01(analProgName,nameNote,['cohSpec.yo' selChanName],'_LinNear.eeg',1,interpFunc,1,[-.7 .7])
end



for j=1:length(selChans)
    selChanName = ['.ch' num2str(selChans(j))]
    PlotGLMResults01('GlmPartialModel01','Alter_firstRun_',['gammaCohMedian65-100Hz' selChanName],'_LinNear.eeg',0,[],1)
end
PlotGLMResults01('GlmPartialModel01','Alter_firstRun_','gammaPowPeak65-100Hz','_LinNear.eeg',0,[],1)
PlotGLMResults01('GlmPartialModel01','Alter_firstRun_','powSpec.yo','_LinNear.eeg',1,[],1)
PlotGLMResults01('WholeModelGlm01','Alter_Vs_Circle_EachRegion_WholeModel_firstRun_','thetaPowPeak6-12Hz','_LinNear.eeg',0,[])
glmtrial13test('CalcRunningSpectra9_noExp','firstRun',[LoadVar('AlterFiles');LoadVar('CircleFiles')],fileExt,'thetaPowPeak6-12Hz',{'speed.p0','accel.p0'},nchan)


fileExt = '_LinNear.eeg';
chanDir = 'ChanInfo/';
chanMat = LoadVar([chanDir 'ChanMat' fileExt '.mat']);
nchan = max(max(chanMat));
selChans = load([chanDir 'SelectedChannels' fileExt '.txt']);
GlmWholeModel01('CalcRunningSpectra9_noExp','firstRun',LoadVar('AlterFiles'),fileExt,'thetaPowPeak6-12Hz',{'speed.p0','accel.p0'},nchan,0)
GlmWholeModel01('CalcRunningSpectra9_noExp','firstRun',LoadVar('AlterFiles'),fileExt,'gammaPowPeak65-100Hz',{'speed.p0','accel.p0'},nchan,0)
GlmWholeModel01('CalcRunningSpectra9_noExp','firstRun',LoadVar('AlterFiles'),fileExt,'gammaPowIntg65-100Hz',{'speed.p0','accel.p0'},nchan,0)
for j=1:length(selChans)
    selChanName = ['.ch' num2str(selChans(j))]
    GlmWholeModel01('CalcRunningSpectra9_noExp','firstRun',LoadVar('AlterFiles'),fileExt,['thetaCohMedian6-12Hz' selChanName],{'speed.p0','accel.p0'},nchan,0)
    GlmWholeModel01('CalcRunningSpectra9_noExp','firstRun',LoadVar('AlterFiles'),fileExt,['gammaCohMedian65-100Hz' selChanName],{'speed.p0','accel.p0'},nchan,0)
end
GlmWholeModel01('CalcRunningSpectra9_noExp','firstRun',LoadVar('AlterFiles'),fileExt,'powSpec.yo',{'speed.p0','accel.p0'},nchan,1)
for j=1:length(selChans)
    selChanName = ['.ch' num2str(selChans(j))]
    GlmWholeModel01('CalcRunningSpectra9_noExp','firstRun',LoadVar('AlterFiles'),fileExt,['cohSpec.yo' selChanName],{'speed.p0','accel.p0'},nchan,1)
end


                