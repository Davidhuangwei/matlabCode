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
                