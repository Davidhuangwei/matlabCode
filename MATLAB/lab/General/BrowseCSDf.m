%function BrowseCSD(filename,nChannels,WhichChannels,win, start)
% browses csd and dat(or eeg if no dat) of the filename files
% of WhichChannels and stepping by win (in msec)
function BrowseCSD(filename,nChannels, WhichChannels,win, start)

if (nargin<2 | isempty(nChannels))
    Par =LoadPar([filename '.par']);
    nChannels = Par.nChannels;
end
if (nargin<3 | isempty(WhichChannels))
    WhichChannels = [1:nChannels];
end
if (nargin<4 | isempty(win))
    win = 1000;
end

figure
finfo = dir([filename '.fil']);

flength = finfo.bytes/2/nChannels;


if nargin<5 | isempty(start) 
    start = 1;
end
    
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
    ViewSegCSDf(filename,nChannels,WhichChannels,segment);
    pause
end
