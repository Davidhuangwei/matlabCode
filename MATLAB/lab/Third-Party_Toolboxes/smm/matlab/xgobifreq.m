function gobimat=xgbitest(filebasemat,fileext,nchannels,highcut,maxfreq)
% function multiplotspeedpowbat(filebasemat,fileext,nchannels,chanmat,lowband,highband,samescale,badchannels,xlimits)

if ~exist('trialtypesbool')
    trialtypesbool = [1  0  1  0  0   0   0   0   0   0   0   0  0];
                    %cr ir cl il crp irp clp ilp crb irb clb ilb xp
end
if ~exist('mazelocationsbool')
    mazelocationsbool = [0  0  0  1  1  1   1   1   1];
                       %rp lp dp cp ca rca lca rra lra
end
% [1 0 1 0 0 0 0 0 0 0 0 0 0]
% [0 0 0 1 1 1 1 1 1]
if ~exist('depvariable')
    depvariable = 'speed';
end
if ~exist('samescale')
    samescale = 0;
end
if ~exist('badchannels')
    badchannels = 0;
end
avepowerdat = [];
speed = [];
accel = [];
whldat1 = [];
whldat2 = [];
whldat3 = [];

[numfiles n] = size(filebasemat);

powmax = [];
powmin = [];
catfreqdat = [];

for i=1:numfiles

    filebase = filebasemat(i,:);
    whldat = load([filebase '.whl']);
    [tmpspeed tmpaccel] = mazespeed(whldat);
    speed = [speed; tmpspeed];
    accel = [accel; tmpaccel];
    trialtypesbool = [1 0 1 0 0 0 0 0 0 0 0 0 0];
    whldat1 = [whldat1; loadmazetrialtypes(filebase,trialtypesbool, [0 0 0 1 1 1 1 1 1])];%blue

    load([filebase '_highcut_' num2str(highcut) '_maxfreq_' num2str(maxfreq) 'Hz_freq' fileext '.mat'])
    %load([filebase '_highcut_' num2str(highcut) 'Hz_maxfreq_' num2str(maxfreq) 'Hz_freq' fileext '.mat'])
    catfreqdat = [catfreqdat freqdat'];
    
end
gobimat = [speed accel whldat1 catfreqdat'];