%BrowseCSD2(filename,WhichShanks,nChannels, WhichChannels,win, start)
% browses csd and dat(or eeg if no dat) of the filename files
% of WhichChannels and stepping by win (in msec) starting from start sec
function BrowseCSD2(filename,WhichShanks,nChannels, WhichChannels,win, start)
global CSDSTEP;
CSDSTEP=2;
if (nargin<2 | isempty(WhichShanks))
    WhichShanks = [1 2];
end
nShanks=length(WhichShanks);
WhichShanksV=WhichShanks(:)';
for sh=WhichShanksV
    if (exist([filename '.' num2str(sh)]) == 7 & exist([filename '.' num2str(sh) '/' filename '.' num2str(sh) '.eeg'])==2 )
        ShanksFileName{sh} = [filename '.' num2str(sh) '/' filename '.' num2str(sh)];
    elseif (exist([filename '.' num2str(sh) '.eeg']) == 2)
        ShanksFileName{sh} = [filename '.' num2str(sh)];
    end
    if (exist([ShanksFileName{sh} '.eeg']) ~= 2)
        error('EEG file does not exist');
        exit;
    end
end


if (nargin<3 | isempty(nChannels))
    for sh=WhichShanksV
        Par =LoadPar([ShanksFileName{sh}  '.par']);
        nChannels(sh) = Par.nChannels;
    end
end
if (nargin<4 | isempty(WhichChannels))
   for sh=WhichShanksV
        WhichChannels{sh} = [1:nChannels(sh)];
    end
end
if (nargin<5 | isempty(win))
    win = 1000;
end
if (nargin<6 | isempty(start))
    start =0;
end

fprintf('Here are the files to be browsed: \n');
for sh=WhichShanksV
    fprintf('%s, %d channels, for %d, in windows of %f msec \n ',ShanksFileName{sh},nChannels(sh),WhichChannels{sh},win);
end
fprintf('press any key for next sweep ..\n');
% keyboard



figure

finfo = dir([ShanksFileName{1} '.eeg']);
flength = finfo.bytes/2/nChannels(1);

if (length(start)>1) % if start indicates the times of windows
    WinsStart = start - round(win/2/1000);
    nWins = length(start);
else
    nWins = round((flength/1.25- start)/win);
    WinsStart = 1:nWins;
    WinsStart = start+(WinsStart-1)*win/1000;
end

% keyboard

for i=1:nWins
    clf
    segment = [WinsStart(i), 0, win];
    for j=1:nShanks
        subplot(size(WhichShanks,1),size(WhichShanks,2),j)
        sh = WhichShanks(j);
        ViewSegCSD(ShanksFileName{sh},nChannels(sh),WhichChannels{sh},segment);
    end
    pause
end
    
    