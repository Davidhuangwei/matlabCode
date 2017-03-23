function multiplotspeedfreqbat2(filebasemat,fileext,nchannels,chanmat,highcut,maxfreq,indepvariable,samescale,badchannels,xlimits)
% function multiplotspeedfreqbat2(filebasemat,fileext,nchannels,chanmat,lowband,highband,samescale,badchannels,xlimits)
% modified from multiplotspeedpowbat2

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
if ~exist('indepvariable')
    indepvariable = 'speed';
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
    whldat2 = [whldat2; loadmazetrialtypes(filebase,trialtypesbool, [0 0 0 0 0 0 0 0 0])]; %red
    whldat3 = [whldat3; loadmazetrialtypes(filebase,trialtypesbool, [0 0 0 0 0 0 0 0 0])]; %green   

    %load([filebase '_highcut_' num2str(highcut) '_maxfreq_' num2str(maxfreq) 'Hz_freq' fileext '.mat'])
    load([filebase '_highcut_' num2str(highcut) 'Hz_maxfreq_' num2str(maxfreq) 'Hz_freq' fileext '.mat'])
    catfreqdat = [catfreqdat freqdat'];
    
end
if ~isempty(speed~=-1)
    if ~isempty(whldat1(:,1)~=-1)
        notminusones1 = whldat1(:,1)~=-1 & speed~=-1;
    end
    if ~isempty(whldat2(:,1)~=-1)
        notminusones2 = whldat2(:,1)~=-1 & speed~=-1;
    end
    if ~isempty(whldat2(:,1)~=-1)
        notminusones3 = whldat3(:,1)~=-1 & speed~=-1;
    end
end
randomized = randperm(length(notminusones1));

size(notminusones1)
size(notminusones2)
size(notminusones3)

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
                if indepvariable == 'speed'
                    if ~isempty(find(notminusones1))
                        plot(speed(find(notminusones1)),catfreqdat(chanmat(y,x,z),find(notminusones1)),'.','markersize',2,'color',[0 0 1]); %blue
                    end
                    if ~isempty(find(notminusones2))
                        plot(speed(find(notminusones2)),catfreqdat(chanmat(y,x,z),find(notminusones2)),'.','markersize',2,'color',[1 0 0]); %red
                    end
                    if ~isempty(find(notminusones3))
                        plot(speed(find(notminusones3)),catfreqdat(chanmat(y,x,z),find(notminusones3)),'.','markersize',2,'color',[0 1 0]); %green
                    end
                end
                
                if indepvariable == 'accel'
                    if ~isempty(find(notminusones1))
                        plot(accel(find(notminusones1)),catfreqdat(chanmat(y,x,z),find(notminusones1)),'.','markersize',2,'color',[0 0 1]); %blue
                    end
                    if ~isempty(find(notminusones2))
                        plot(accel(find(notminusones2)),catfreqdat(chanmat(y,x,z),find(notminusones2)),'.','markersize',2,'color',[1 0 0]); %red
                    end
                    if ~isempty(find(notminusones3))
                        plot(accel(find(notminusones3)),catfreqdat(chanmat(y,x,z),find(notminusones3)),'.','markersize',2,'color',[0 1 0]); %green
                    end
                end
                hold on;
                title(['chan ' num2str(chanmat(y,x,z))]);
                %if ~samescale,
                %    colorbar
                %end
                powmax = max([max(catfreqdat(chanmat(y,x,z),find(notminusones1))) max(catfreqdat(chanmat(y,x,z),find(notminusones2))) max(catfreqdat(chanmat(y,x,z),find(notminusones3))) powmax]); 
                powmin = min([min(catfreqdat(chanmat(y,x,z),find(notminusones1))) min(catfreqdat(chanmat(y,x,z),find(notminusones2))) min(catfreqdat(chanmat(y,x,z),find(notminusones3))) powmin]);
            end
        end
    end
end
%end
powmax = 12;
powmin = 3;

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
