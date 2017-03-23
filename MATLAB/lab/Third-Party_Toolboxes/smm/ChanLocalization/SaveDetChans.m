

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
