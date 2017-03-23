save('ChanInfo/RippDetChans.eeg.txt','-ascii','rippDetChans')
save('ChanInfo/RippTrigChan.eeg.txt','-ascii','rippTrigChan')
save('ChanInfo/SWTrigChan.eeg.txt','-ascii','swTrigChan')
tmp = molChans.('NearAveCSD1');
save('ChanInfo/DSDetMolChans_NearAveCSD1.csd.txt','-ascii','tmp')
tmp = hilChans.('NearAveCSD1');
save('ChanInfo/DSDetHilChans_NearAveCSD1.csd.txt','-ascii','tmp')
tmp = molChans.('LinNearCSD121');
save('ChanInfo/DSDetMolChans_LinNearCSD121.csd.txt','-ascii','tmp')
tmp = hilChans.('LinNearCSD121');
save('ChanInfo/DSDetHilChans_LinNearCSD121.csd.txt','-ascii','tmp')
save('ChanInfo/ThetaTrigChan.txt','-ascii','thetaTrigChan')
save('ChanInfo/NChan.eeg.txt','-ascii','eegNChan')
save('ChanInfo/NChan_NearAveCSD1.csd.txt','-ascii','csd1NChan')
save('ChanInfo/NChan_LinNearCSD121.csd.txt','-ascii','csd121NChan')

%sm9601
cd /BEEF01/smm/sm9601_Analysis/
cd /BEEF01/smm/sm9601_Analysis/2-13-04/analysis/
cd /BEEF01/smm/sm9601_Analysis/2-14-04/analysis/
cd /BEEF01/smm/sm9601_Analysis/2-15-04/analysis/
cd /BEEF01/smm/sm9601_Analysis/2-16-04/analysis/
rippDetChans = [1 2 3 17 18 19 20 33 34 35 36 51 52 53 54 55 69 70 71 72 73];
rippTrigChan = 29;
swTrigChan = 2;
molChans.('NearAveCSD1') = [7 9 36 50 51 67];
hilChans.('NearAveCSD1') = [12 13 38 41 53 55];
molChans.('LinNearCSD121') = [6 8 31 43 44 58];
hilChans.('LinNearCSD121') = [11 12 33 36 46 48];
thetaTrigChan = 5;
eegNChan = 81;
csd1NChan = 84;
csd121NChan = 72;

fileInfoDir = 'FileInfo/';
alterFiles = LoadVar([fileInfoDir 'AlterFiles']);
sleepFiles = LoadVar([fileInfoDir 'SleepFiles']);
datFiles = LoadVar([fileInfoDir 'DatFiles']);

RippTrigSegs(sleepFiles,eegNChan,rippDetChans,rippTrigChan,swTrigChan,'.eeg',eegNChan);
RippTrigSegs(sleepFiles,eegNChan,rippDetChans,rippTrigChan,swTrigChan,'_NearAveCSD1.csd',csd1NChan);
RippTrigSegs(sleepFiles,eegNChan,rippDetChans,rippTrigChan,swTrigChan,'_LinNearCSD121.csd',csd121NChan);
DetateSpikeTrigSegs(sleepFiles,'_NearAveCSD1.csd',csd1NChan,molChans.('NearAveCSD1'),hilChans.('NearAveCSD1'),'.eeg',eegNChan,0)
DetateSpikeTrigSegs(sleepFiles,'_NearAveCSD1.csd',csd1NChan,molChans.('NearAveCSD1'),hilChans.('NearAveCSD1'),'_NearAveCSD1.csd',csd1NChan,0)
DetateSpikeTrigSegs(sleepFiles,'_NearAveCSD1.csd',csd1NChan,molChans.('NearAveCSD1'),hilChans.('NearAveCSD1'),'_LinNearCSD121.csd',csd121NChan,0)
DetateSpikeTrigSegs(sleepFiles,'_LinNearCSD121.csd',csd121NChan,molChans.('LinNearCSD121'),hilChans.('LinNearCSD121'),'.eeg',eegNChan)
DetateSpikeTrigSegs(sleepFiles,'_LinNearCSD121.csd',csd121NChan,molChans.('LinNearCSD121'),hilChans.('LinNearCSD121'),'_NearAveCSD1.csd',csd1NChan)
DetateSpikeTrigSegs(sleepFiles,'_LinNearCSD121.csd',csd121NChan,molChans.('LinNearCSD121'),hilChans.('LinNearCSD121'),'_LinNearCSD121.csd',csd121NChan)
TroughTrigSegs(alterFiles,eegNChan,thetaTrigChan,[6 30],15,'.eeg',eegNChan,[],[],[],[1 1 1 1 0 0 0 0 0 0 0 0 0]);
TroughTrigSegs(alterFiles,eegNChan,thetaTrigChan,[6 30],15,'_NearAveCSD1.csd',csd1NChan,[],[],[],[1 1 1 1 0 0 0 0 0 0 0 0 0]);
TroughTrigSegs(alterFiles,eegNChan,thetaTrigChan,[6 30],15,'_LinNearCSD121.csd',csd121NChan,[],[],[],[1 1 1 1 0 0 0 0 0 0 0 0 0]);
CalcSpikeChanDist(datFiles,eegNChan,20000);


%sm9603
cd /BEEF01/smm/sm9603_Analysis/analysis04/
cd /BEEF01/smm/sm9603_Analysis/3-20-04/analysis/
cd /BEEF01/smm/sm9603_Analysis/3-21-04/analysis/
rippDetChans = [8 9 10 19 20 21 34 35 50 51 67 68 85];
rippTrigChan = 9;
swTrigChan = 37;
molChans.('NearAveCSD1') = [27 28 36 37 38 39 49 50 64 65 80 81];
hilChans.('NearAveCSD1') = [42 53 54 56 69 68 67];
molChans.('LinNearCSD121') = [24 31 32 33 34 42 43 55 56 69 70];
hilChans.('LinNearCSD121') = [36 46 47 59 60 72];
thetaTrigChan = 40;
eegNChan = 97;
csd1NChan = 84;
csd121NChan = 72;

fileInfoDir = 'FileInfo/';
alterFiles = LoadVar([fileInfoDir 'AlterFiles']);
sleepFiles = LoadVar([fileInfoDir 'SleepFiles']);
datFiles = LoadVar([fileInfoDir 'DatFiles']);
ppStimFiles = LoadVar([fileInfoDir 'PPStimFiles']);

StimTrigSegs('sm9603m2_227_s1_273',5,25,3,eegNChan,33,'PP3V');
StimTrigSegs('sm9603m2_227_s1_273',25,45,3,eegNChan,33,'PP10V');
StimTrigSegs('sm9603m2_227_s1_273',45,65,3,eegNChan,33,'PP40V');
StimTrigSegs('sm9603m2_252_s1_298',5,30,3,eegNChan,33,'PP10V');
StimTrigSegs('sm9603m2_252_s1_298',25,45,3,eegNChan,33,'PP40V');
RippTrigSegs(sleepFiles,eegNChan,rippDetChans,rippTrigChan,swTrigChan,'.eeg',eegNChan);
RippTrigSegs(sleepFiles,eegNChan,rippDetChans,rippTrigChan,swTrigChan,'_NearAveCSD1.csd',csd1NChan);
RippTrigSegs(sleepFiles,eegNChan,rippDetChans,rippTrigChan,swTrigChan,'_LinNearCSD121.csd',csd121NChan);
DetateSpikeTrigSegs(sleepFiles,'_NearAveCSD1.csd',csd1NChan,molChans.('NearAveCSD1'),hilChans.('NearAveCSD1'),'.eeg',eegNChan,0)
DetateSpikeTrigSegs(sleepFiles,'_NearAveCSD1.csd',csd1NChan,molChans.('NearAveCSD1'),hilChans.('NearAveCSD1'),'_NearAveCSD1.csd',csd1NChan,0)
DetateSpikeTrigSegs(sleepFiles,'_NearAveCSD1.csd',csd1NChan,molChans.('NearAveCSD1'),hilChans.('NearAveCSD1'),'_LinNearCSD121.csd',csd121NChan,0)
DetateSpikeTrigSegs(sleepFiles,'_LinNearCSD121.csd',csd121NChan,molChans.('LinNearCSD121'),hilChans.('LinNearCSD121'),'.eeg',eegNChan)
DetateSpikeTrigSegs(sleepFiles,'_LinNearCSD121.csd',csd121NChan,molChans.('LinNearCSD121'),hilChans.('LinNearCSD121'),'_NearAveCSD1.csd',csd1NChan)
DetateSpikeTrigSegs(sleepFiles,'_LinNearCSD121.csd',csd121NChan,molChans.('LinNearCSD121'),hilChans.('LinNearCSD121'),'_LinNearCSD121.csd',csd121NChan)
TroughTrigSegs(alterFiles,eegNChan,thetaTrigChan,[6 30],15,'.eeg',eegNChan);
TroughTrigSegs(alterFiles,eegNChan,thetaTrigChan,[6 30],15,'_NearAveCSD1.csd',csd1NChan);
TroughTrigSegs(alterFiles,eegNChan,thetaTrigChan,[6 30],15,'_LinNearCSD121.csd',csd121NChan);
CalcSpikeChanDist(datFiles,eegNChan,20000);

%sm9608
cd /BEEF02/smm/sm9608_Analysis/analysis02/
cd /BEEF02/smm/sm9608_Analysis/7-15-04/analysis/
cd /BEEF02/smm/sm9608_Analysis/7-16-04/analysis/
cd /BEEF02/smm/sm9608_Analysis/7-17-04/analysis/
rippDetChans = [17 18 19 20 21 22 49 50 51 65 66 67 68 82 83 85];
rippTrigChan = 50;
swTrigChan = 52;
molChans.('NearAveCSD1') = [35 36 48 49 63 79];
hilChans.('NearAveCSD1') = [40 41 42 52 53 56 79 81];
molChans.('LinNearCSD121') = [30 31 41 42 54 68];
hilChans.('LinNearCSD121') = [35 36 45 46 70];
thetaTrigChan = 29;
eegNChan = 97;
csd1NChan = 84;
csd121NChan = 72;

alterFiles = LoadVar('FileInfo/AlterFiles');
sleepFiles = LoadVar('FileInfo/SleepFiles');
datFiles = LoadVar('FileInfo/DatFiles');
ppStimFiles = LoadVar('FileInfo/PPStimFiles');
commStimFiles = LoadVar('FileInfo/CommStimFiles');

StimTrigSegs('sm9608_332',6*60,7*60,8,eegNChan,33,'COMM30V');
StimTrigSegs('sm9608_334',7*60+20,8*60+20,8,eegNChan,33,'PP100V');
RippTrigSegs(sleepFiles,eegNChan,rippDetChans,rippTrigChan,swTrigChan,'.eeg',eegNChan);
RippTrigSegs(sleepFiles,eegNChan,rippDetChans,rippTrigChan,swTrigChan,'_NearAveCSD1.csd',csd1NChan);
RippTrigSegs(sleepFiles,eegNChan,rippDetChans,rippTrigChan,swTrigChan,'_LinNearCSD121.csd',csd121NChan);
DetateSpikeTrigSegs(sleepFiles,'_NearAveCSD1.csd',csd1NChan,molChans.('NearAveCSD1'),hilChans.('NearAveCSD1'),'.eeg',eegNChan,0)
DetateSpikeTrigSegs(sleepFiles,'_NearAveCSD1.csd',csd1NChan,molChans.('NearAveCSD1'),hilChans.('NearAveCSD1'),'_NearAveCSD1.csd',csd1NChan,0)
DetateSpikeTrigSegs(sleepFiles,'_NearAveCSD1.csd',csd1NChan,molChans.('NearAveCSD1'),hilChans.('NearAveCSD1'),'_LinNearCSD121.csd',csd121NChan,0)
DetateSpikeTrigSegs(sleepFiles,'_LinNearCSD121.csd',csd121NChan,molChans.('LinNearCSD121'),hilChans.('LinNearCSD121'),'.eeg',eegNChan)
DetateSpikeTrigSegs(sleepFiles,'_LinNearCSD121.csd',csd121NChan,molChans.('LinNearCSD121'),hilChans.('LinNearCSD121'),'_NearAveCSD1.csd',csd1NChan)
DetateSpikeTrigSegs(sleepFiles,'_LinNearCSD121.csd',csd121NChan,molChans.('LinNearCSD121'),hilChans.('LinNearCSD121'),'_LinNearCSD121.csd',csd121NChan)
TroughTrigSegs(alterFiles,eegNChan,thetaTrigChan,[6 30],15,'.eeg',eegNChan);
TroughTrigSegs(alterFiles,eegNChan,thetaTrigChan,[6 30],15,'_NearAveCSD1.csd',csd1NChan);
TroughTrigSegs(alterFiles,eegNChan,thetaTrigChan,[6 30],15,'_LinNearCSD121.csd',csd121NChan);
CalcSpikeChanDist(datFiles,eegNChan,20000);

%sm9614
cd /BEEF02/smm/sm9614_Analysis/analysis02/
cd /BEEF02/smm/sm9614_Analysis/4-16-05/analysis/
cd /BEEF02/smm/sm9614_Analysis/4-17-05/analysis/
rippDetChans = [2 3 4 5 17 18 19 20 33 34 35 36 51 52 53 67 68 69 70 85 86 87];
rippTrigChan = 3;
swTrigChan = 6;
molChans.('NearAveCSD1') = [11 22 23 35 36 50 65 80];
hilChans.('NearAveCSD1') = [25 26 38 41 55 56 67 68 70];
molChans.('LinNearCSD121') = [10 18 19 20 30 31 43 55 56 69];
hilChans.('LinNearCSD121') = [22 33 36 45 48 58 59];
thetaTrigChan = 18;
eegNChan = 97;
csd1NChan = 84;
csd121NChan = 72;

alterFiles = LoadVar('AlterFiles');
sleepFiles = LoadVar('SleepFiles');
datFiles = LoadVar('DatFiles');
ppStimFiles = LoadVar('PPStimFiles');
commStimFiles = LoadVar('CommStimFiles');

StimTrigSegs('sm9614_371',5,35,10,eegNChan,33,'COMM5V');
StimTrigSegs('sm9614_371',35,65,10,eegNChan,33,'COMM10V');
StimTrigSegs('sm9614_371',65,95,10,eegNChan,33,'COMM20V');
StimTrigSegs('sm9614_371',95,125,10,eegNChan,33,'COMM40V');
StimTrigSegs('sm9614_371',125,155,10,eegNChan,33,'COMM60V');
StimTrigSegs('sm9614_371',2*60+45,3*60+15,10,eegNChan,33,'PP5V');
StimTrigSegs('sm9614_371',3*60+15,3*60+45,10,eegNChan,33,'PP10V');
StimTrigSegs('sm9614_371',3*60+45,4*60+15,10,eegNChan,33,'PP20V');
StimTrigSegs('sm9614_371',4*60+15,4*60+45,10,eegNChan,33,'PP40V');
StimTrigSegs('sm9614_371',4*60+45,5*60+15,10,eegNChan,33,'PP60V');
StimTrigSegs('sm9614_389',20,50,10,eegNChan,33,'PP5V');
StimTrigSegs('sm9614_389',50,60+20,10,eegNChan,33,'PP10V');
StimTrigSegs('sm9614_389',60+20,60+50,10,eegNChan,33,'PP20V');
StimTrigSegs('sm9614_389',60+50,2*60+20,10,eegNChan,33,'PP40V');
StimTrigSegs('sm9614_389',2*60+30,3*60,10,eegNChan,33,'COMM5V');
StimTrigSegs('sm9614_389',3*60,3*60+30,10,eegNChan,33,'COMM10V');
StimTrigSegs('sm9614_389',3*60+30,4*60,10,eegNChan,33,'COMM20V');
StimTrigSegs('sm9614_389',4*60,4*60+30,10,eegNChan,33,'COMM40V');

StimTrigSegs('sm9614_371',6*60,7*60,8,eegNChan,33,'COMM30V');
StimTrigSegs('sm9614_389',7*60+20,8*60+20,8,eegNChan,33,'PP100V');

StimTrigSegsBat(stimFiles,eegNChan,stimTrigChan)
RippTrigSegs(sleepFiles,eegNChan,rippDetChans,rippTrigChan,swTrigChan,'.eeg',eegNChan);
RippTrigSegs(sleepFiles,eegNChan,rippDetChans,rippTrigChan,swTrigChan,'_NearAveCSD1.csd',csd1NChan);
RippTrigSegs(sleepFiles,eegNChan,rippDetChans,rippTrigChan,swTrigChan,'_LinNearCSD121.csd',csd121NChan);
DetateSpikeTrigSegs(sleepFiles,'_NearAveCSD1.csd',csd1NChan,molChans.('NearAveCSD1'),hilChans.('NearAveCSD1'),'.eeg',eegNChan,0)
DetateSpikeTrigSegs(sleepFiles,'_NearAveCSD1.csd',csd1NChan,molChans.('NearAveCSD1'),hilChans.('NearAveCSD1'),'_NearAveCSD1.csd',csd1NChan,0)
DetateSpikeTrigSegs(sleepFiles,'_NearAveCSD1.csd',csd1NChan,molChans.('NearAveCSD1'),hilChans.('NearAveCSD1'),'_LinNearCSD121.csd',csd121NChan,0)
DetateSpikeTrigSegs(sleepFiles,'_LinNearCSD121.csd',csd121NChan,molChans.('LinNearCSD121'),hilChans.('LinNearCSD121'),'.eeg',eegNChan)
DetateSpikeTrigSegs(sleepFiles,'_LinNearCSD121.csd',csd121NChan,molChans.('LinNearCSD121'),hilChans.('LinNearCSD121'),'_NearAveCSD1.csd',csd1NChan)
DetateSpikeTrigSegs(sleepFiles,'_LinNearCSD121.csd',csd121NChan,molChans.('LinNearCSD121'),hilChans.('LinNearCSD121'),'_LinNearCSD121.csd',csd121NChan)
TroughTrigSegs(alterFiles,eegNChan,thetaTrigChan,[6 30],15,'.eeg',eegNChan);
TroughTrigSegs(alterFiles,eegNChan,thetaTrigChan,[6 30],15,'_NearAveCSD1.csd',csd1NChan);
TroughTrigSegs(alterFiles,eegNChan,thetaTrigChan,[6 30],15,'_LinNearCSD121.csd',csd121NChan);
CalcSpikeChanDist(datFiles,eegNChan,20000);


dayCell = Struct2CellArray(LoadVar('DayStruct.mat'));
days = unique(dayCell(:,2));
for j=1:length(days)
dayName = days{j}
alterFiles = LoadVar('AlterFiles');
sleepFiles = LoadVar('SleepFiles');
datFiles = LoadVar('DatFiles');
ppStimFiles = LoadVar('PPStimFiles');
commStimFiles = LoadVar('CommStimFiles');
dayCell = Struct2CellArray(LoadVar('DayStruct.mat'));
day = dayCell(strcmp(dayCell(:,2),dayName),1);
alterFiles = cell2mat(intersect(alterFiles,day))
sleepFiles = cell2mat(intersect(sleepFiles,day))
datFiles = cell2mat(intersect(datFiles,day))
ppStimFiles = cell2mat(intersect(ppStimFiles,day))
commStimFiles = cell2mat(intersect(commStimFiles,day))
figNums = [];

try PlotTrigSegs(alterFiles,'TroughTrigSegs_trigCh40_freq6-30_maxFreq15','_LinNearCSD121.csd','.eeg',1,[-2000 2000]); figNums = [figNums gcf]; end
%PlotTrigSegs(alterFiles(2,:),'TroughTrigSegs_trigCh40_freq6-30_maxFreq15','_NearAveCSD1.csd','.eeg',[],[],[],2,[-1000 1000])

%PlotTrigSegs(ppStimFiles,'StimTrigSegs_PP40V_TrigChan33','_NearAveCSD1.csd','.dat',1,[-3000 3000])
try PlotTrigSegs(ppStimFiles,'StimTrigSegs_PP40V_TrigChan33','_LinNearCSD121.csd','.dat',2,[-6000 6000]); figNums = [figNums gcf]; end
try PlotTrigSegs(ppStimFiles,'StimTrigSegs_PP40V_TrigChan33','_NearAveCSD1.csd','_NearAveCSD1.csd',3,[-3000 3000],[],[],LoadVar('ChanInfo/ChanMat.eeg')); figNums = [figNums gcf]; end
try PlotTrigSegs(ppStimFiles,'StimTrigSegs_PP40V_TrigChan33','_LinNearCSD121.csd','_LinNearCSD121.csd',4,[-6000 6000],[],[],LoadVar('ChanInfo/ChanMat.eeg')); figNums = [figNums gcf]; end

%PlotTrigSegs(sleepFiles(1,:),'RippTrigSegs_RippTrigChan9_SwTrigChan37','_NearAveCSD1.csd','.eeg',3,[-2000 2000])
try PlotTrigSegs(sleepFiles,'RippTrigSegs_RippTrigChan9_SwTrigChan37','_LinNearCSD121.csd','.eeg',5,[-4000 4000]); figNums = [figNums gcf]; end
try PlotTrigSegs(sleepFiles,'RippTrigSegs_RippTrigChan9_SwTrigChan37','_NearAveCSD1.csd','_NearAveCSD1.csd',6,[-2000 2000],[],[],LoadVar('ChanInfo/ChanMat.eeg')); figNums = [figNums gcf]; end
try PlotTrigSegs(sleepFiles,'RippTrigSegs_RippTrigChan9_SwTrigChan37','_LinNearCSD121.csd','_LinNearCSD121.csd',7,[-4000 4000],[],[],LoadVar('ChanInfo/ChanMat.eeg')); figNums = [figNums gcf]; end

try PlotTrigSegs(sleepFiles,'DentateSpikeTrigSegs_TrigExt_NearAveCSD1.csd','_LinNearCSD121.csd','.eeg',8,[-2000 1500]); figNums = [figNums gcf]; end
try PlotTrigSegs(sleepFiles,'DentateSpikeTrigSegs_TrigExt_NearAveCSD1.csd','_NearAveCSD1.csd','_NearAveCSD1.csd',9,[-1500 1000],[],[],LoadVar('ChanInfo/ChanMat.eeg')); figNums = [figNums gcf]; end
try PlotTrigSegs(sleepFiles,'DentateSpikeTrigSegs_TrigExt_NearAveCSD1.csd','_LinNearCSD121.csd','_LinNearCSD121.csd',10,[-2000 1500],[],[],LoadVar('ChanInfo/ChanMat.eeg')); figNums = [figNums gcf]; end

try PlotTrigSegs(sleepFiles,'DentateSpikeTrigSegs_TrigExt_LinNearCSD121.csd','_LinNearCSD121.csd','.eeg',11,[-2000 1500]); figNums = [figNums gcf]; end
try PlotTrigSegs(sleepFiles,'DentateSpikeTrigSegs_TrigExt_LinNearCSD121.csd','_NearAveCSD1.csd','_NearAveCSD1.csd',12,[-1500 1000],[],[],LoadVar('ChanInfo/ChanMat.eeg')); figNums = [figNums gcf]; end
try PlotTrigSegs(sleepFiles,'DentateSpikeTrigSegs_TrigExt_LinNearCSD121.csd','_LinNearCSD121.csd','_LinNearCSD121.csd',13,[-2000 1500],[],[],LoadVar('ChanInfo/ChanMat.eeg')); figNums = [figNums gcf]; end

try PlotRippPowerDist(sleepFiles,'RippTrigSegs_RippTrigChan9_SwTrigChan37','.eeg',14,[],[36 44]); figNums = [figNums gcf]; end
try PlotRippPowerDist(sleepFiles,'RippTrigSegs_RippTrigChan9_SwTrigChan37','_NearAveCSD1.csd',15,[],[30 42]); figNums = [figNums gcf]; end

try PlotSpikeChanDist(datFiles,'SpikeChanDist',16); figNums = [figNums gcf-1 gcf]; end

%figNums = [1:16];
ReportFigSM(figNums,['NewFigs/ChannelLocalization/'],repmat({['Day_' dayName]},size(figNums)),[10 8],repmat({{'GCFNAME'}},size(figNums)))
ReportFigSM([1:16],['NewFigs/ChannelLocalization/Day_' dayName '/'],[],[10 8])

end





alterFiles = LoadVar('AlterFiles');
function TroughTrigSegs(fileBaseMat,eegTrigChan,filtFreqRange,maxFreq,fileExt,nChan,varargin)
[eegNChan,chanMat,badChans,peakTrigBool,trialTypesBool,mazeRegionsBool,plotBool] = DefaultArgs(varargin,...
    {97,LoadVar([chanInfoDir 'ChanMat' fileExt '.mat']),load([chanInfoDir 'BadChan.eeg.txt']),...
RippTrigSegs(fileBaseMat,fileExt,trigNChan,nChan,nShanks,chansPerShank,badChans)
StimTrigSegs(filebase,beginTime,endTime,stimLag,nchannels,trigChan,notes)
CalcSpikeChanDist(fileBaseMat,nchannels,Fs)



TroughTrigSegs(alterFiles(1,:),40,[6 30],15,'.eeg',97);
TroughTrigSegs(alterFiles(1,:),40,[6 30],15,'_NearAveCSD1.csd',84);
TroughTrigSegs(alterFiles(1,:),40,[6 30],15,'_LinNearCSD121.csd',72);
RippTrigSegs(sleepFiles(1,:),97,rippDetChans,rippTrigChan,swTrigChan,'.eeg',97);
RippTrigSegs(sleepFiles(1,:),97,rippDetChans,rippTrigChan,swTrigChan,'_NearAveCSD1.csd',84);
RippTrigSegs(sleepFiles(1,:),97,rippDetChans,rippTrigChan,swTrigChan,'_LinNearCSD121.csd',72);
