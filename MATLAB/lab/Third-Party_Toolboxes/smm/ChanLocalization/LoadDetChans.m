rippDetChans = load('ChanInfo/RippDetChans.eeg.txt');
rippTrigChan = load('ChanInfo/RippTrigChan.eeg.txt');
swTrigChan = load('ChanInfo/SWTrigChan.eeg.txt');
molChans.('NearAveCSD1') = load('ChanInfo/DSDetMolChans_NearAveCSD1.csd.txt');
hilChans.('NearAveCSD1') = load('ChanInfo/DSDetHilChans_NearAveCSD1.csd.txt');
molChans.('LinNearCSD121') = load('ChanInfo/DSDetMolChans_LinNearCSD121.csd.txt');
hilChans.('LinNearCSD121') = load('ChanInfo/DSDetHilChans_LinNearCSD121.csd.txt');
thetaTrigChan = load('ChanInfo/ThetaTrigChan.txt');
eegNChan = load('ChanInfo/NChan.eeg.txt');
csd1NChan = load('ChanInfo/NChan_NearAveCSD1.csd.txt');
csd121NChan = load('ChanInfo/NChan_LinNearCSD121.csd.txt');
stimTrigChan = load('ChanInfo/StimTrigChan.txt');

fileInfoDir = 'FileInfo/';
alterFiles = LoadVar([fileInfoDir 'AlterFiles']);
sleepFiles = LoadVar([fileInfoDir 'SleepFiles']);
datFiles = LoadVar([fileInfoDir 'DatFiles']);
stimFiles = LoadVar([fileInfoDir 'StimFiles']);