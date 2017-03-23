%function BrowseCSD(filename,nChannels,WhichChannels,win, start,csdstep,filter)
% browses csd and dat(or eeg if no dat) of the filename files
% of WhichChannels and stepping by win (in msec)
function BrowseCSD(filename,varargin)

Par =LoadPar([filename '.par']);
[nChannels, WhichChannels,win, start, csdstep,filter] = ...
    DefaultArgs(varargin, {Par.nChannels,Par.ElecGp,  1000, 1, 2,[1 100]});
    
figure
finfo = dir([filename '.eeg']);

flength = finfo.bytes/2/nChannels;
    
if (length(start)>1) % if start indicates the times of windows
    WinsStart = start - round(win/2/1000);
    nWins = length(start);
    ii=1;
else
    nWins = round((flength/1.25- win)/win);
    WinsStart = 1:nWins;
    WinsStart = (WinsStart-1)*win/1000;
    [dummy ii ] = min(abs(WinsStart-start));
end

% keyboard
%gBrowseCSD = struct;
%gBrowseCSD.cwin = 1;
%for i=1:nWins
%ii=1;
clf
segment = [WinsStart(ii), 0, win];
ViewSegCSD(filename,nChannels,WhichChannels,segment,csdstep,filter);

while (ii>1 && ii<nWins)
 
    result = waitforbuttonpress;
    switch result
        case 0 %mouse
            mclick = get(gcf,'SelectionType');
            if  strcmp(mclick,'alt')
                ii=ii+1;
            elseif strcmp(mclick,'normal')
                ii=ii-1;
            end
        case 1
            key = double(get(gcf,'CurrentCharacter'));
            if key==29
                ii=ii+1;
            elseif key==28
                ii=ii-1;
            elseif key==double('z')
                win = win/2;
            elseif key==double('x')
                win = win*2;
            end    
    end
    clf
    segment = [WinsStart(ii), 0, win];
    ViewSegCSD(filename,nChannels,WhichChannels,segment,csdstep,filter);
 %   pause
end
