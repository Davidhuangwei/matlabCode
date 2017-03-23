%sm9603
rippDetChans = [8 9 10 19 20 21 34 35 50 51 67 68 85];
rippTrigChan = 9;
swTrigChan = 37;

alterFiles = LoadVar('AlterFiles');
sleepFiles = LoadVar('SleepFiles');
datFiles = LoadVar('DatFiles');
ppStimFiles = LoadVar('PPStimFiles');
StimTrigSegs('sm9603m2_227_s1_273',5,25,3,97,33,PP3V);
StimTrigSegs('sm9603m2_227_s1_273',25,45,3,97,33,PP10V);
StimTrigSegs('sm9603m2_227_s1_273',45,65,3,97,33,PP40V);
TroughTrigSegs(alterFiles,40,[6 30],15,'.eeg',97);
TroughTrigSegs(alterFiles,40,[6 30],15,'_NearAveCSD1.csd',84);
TroughTrigSegs(alterFiles,40,[6 30],15,'_LinNearCSD121.csd',72);
RippTrigSegs(sleepFiles,97,rippDetChans,rippTrigChan,swTrigChan,'.eeg',97);
RippTrigSegs(sleepFiles,97,rippDetChans,rippTrigChan,swTrigChan,'_NearAveCSD1.csd',84);
RippTrigSegs(sleepFiles,97,rippDetChans,rippTrigChan,swTrigChan,'_LinNearCSD121.csd',72);
CalcSpikeChanDist(datFiles,97,20000);


%sm9601
cd /BEEF01/smm/sm9601_Analysis/analysis03/
datFiles = LoadVar('DatFiles.mat');
CalcSpikeChanDist(datFiles,81,20000);

%sm9608
cd /BEEF02/smm/sm9608_Analysis/analysis02/
datFiles = LoadVar('DatFiles.mat');
CalcSpikeChanDist(datFiles,97,20000);

%sm9614
cd /BEEF02/smm/sm9614_Analysis/analysis02/
datFiles = LoadVar('DatFiles.mat');
CalcSpikeChanDist(datFiles,97,20000);


