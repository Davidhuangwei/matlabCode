function multiplotspeedaccelpowbat(filebasemat,fileext,nchannels,chanmat,lowband,highband,samescale,badchannels,xlimits)
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
numtrials = 0; % for counting trials
nxp = 0;
ncr = 0;
nir = 0;
ncl = 0;
nil = 0;
ncrp = 0;
nirp = 0;
nclp = 0;
nilp = 0;
ncrb = 0;
nirb = 0;
nclb = 0;
nilb = 0;

powmax = [];
powmin = [];

[chan_y chan_x chan_z] = size(chanmat);  
for z=1:chan_z
    figure(z)
    clf
end
for i=1:numfiles

    filebase = filebasemat(i,:);
    whldat = load([filebase '.whl']);
    [tmpspeed tmpaccel] = mazespeed(whldat);
    speed = [speed; tmpspeed];
    accel = [accel; tmpaccel];
    trialtypesbool = [1 0 1 0 0 0 0 0 0 0 0 0 0];
    whldat1 = [whldat1; loadmazetrialtypes(filebase,trialtypesbool, [0 0 0 1 1 1 1 1 1])];%blue
    dspowfilename = [filebase '_' num2str(lowband) '-' num2str(highband) 'Hz' fileext '.100DBdspow'];
    avepowerdat = [avepowerdat bload(dspowfilename,[nchannels inf],0,'int16')];
    
end
if ~isempty(speed~=-1)
    if ~isempty(whldat1(:,1)~=-1)
        accelerating = whldat1(:,1)~=-1 & speed~=-1 & accel >1;
        decelerating = whldat1(:,1)~=-1 & speed~=-1 & accel <1;
    end
end

avepowerdat = avepowerdat./100;

%jump = floor(length(notminusones1)/10)
%for i=jump:jump:length(notminusones1)
for z=1:chan_z
    figure(z)
    for y=1:chan_y
        for x=1:chan_x
            if isempty(find(badchannels==chanmat(y,x,z))), % if the channel isn't bad 
                % now plot

                subplot(chan_y,chan_x,(y-1)*chan_x+x);
                hold on;
                if depvariable == 'speed'
                    if ~isempty(find(accelerating))
                        plot(speed(find(accelerating)),avepowerdat(chanmat(y,x,z),find(accelerating)),'.','markersize',2,'color',[0 0 1]); %blue
                    end
                    if ~isempty(find(decelerating))
                        plot(speed(find(decelerating)),avepowerdat(chanmat(y,x,z),find(decelerating)),'.','markersize',2,'color',[1 0 0]); %red
                    end
                end
                hold on;
                title(['chan ' num2str(chanmat(y,x,z))]);
                %if ~samescale,
                %    colorbar
                %end
                powmax = max([max(avepowerdat(chanmat(y,x,z),find(accelerating))) max(avepowerdat(chanmat(y,x,z),find(decelerating))) powmax]); 
                powmin = min([min(avepowerdat(chanmat(y,x,z),find(accelerating))) min(avepowerdat(chanmat(y,x,z),find(decelerating))) powmin]);
            end
        end
    end
end
%end


if ~exist('xlimits')
    xlimits = get(gca,'xlim');
    i=input('xmin?');
    if i~=[], xlimits(1)=i; end
    i=input('xmax?');
    if i~=[], xlimits(2)=i; end
end

for z=1:chan_z
    figure(z)
    for y=1:chan_y
        for x=1:chan_x
            if isempty(find(badchannels==chanmat(y,x,z))), % if the channel isn't bad       
                subplot(chan_y,chan_x,(y-1)*chan_x+x);
                set(gca, 'xlim', xlimits, 'xtick',xlimits,'fontsize', 8);
                if samescale
                    set(gca, 'ylim', [powmin powmax]);
                end
            end
        end
    end
end
counttrialtypes(filebasemat,1);
