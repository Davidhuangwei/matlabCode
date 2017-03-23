% function RippTrigSegsBat01(analDirs,varargin)
% [fileExtCell segLen] = DefaultArgs(varargin,{{'.eeg','_NearAveCSD1.csd','_LinNearCSD121.csd'},160});
function RippTrigSegsBat01(analDirs,varargin)
[fileExtCell segLen segRestrictionCell] = ...
    DefaultArgs(varargin,{{'.eeg','_NearAveCSD1.csd','_LinNearCSD121.csd'},160,{'single','first','last','all'}});

cwd = pwd;
fileInfoDir = 'FileInfo/';
for j=1:length(analDirs)
    cd(analDirs{j})
    sleepFiles = LoadVar([fileInfoDir 'SleepFiles']);
    rippDetChans = load('ChanInfo/RippDetChans.eeg.txt');
    rippTrigChan = load('ChanInfo/RippTrigChan.eeg.txt');
    swTrigChan = load('ChanInfo/SWTrigChan.eeg.txt');
    eegNChan = load('ChanInfo/NChan.eeg.txt');
    for k=1:length(fileExtCell)
        fileExt = fileExtCell{k};
        nChan = load(['ChanInfo/NChan' fileExt '.txt']);
        for m=1:length(segRestrictionCell)
            RippTrigSegs(sleepFiles,eegNChan,rippDetChans,rippTrigChan,swTrigChan,fileExt,nChan,segLen,segRestrictionCell{m});
        end
    end
end

cd(cwd);