function multiplotspeedpowbat(filebasemat,fileext,nchannels,chanmat,lowband,highband,depvariable,samescale,badchannels,xlimits)
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
    [speed accel] = mazespeed(whldat);
    trialtypesbool = [1 0 1 0 0 0 0 0 0 0 0 0 0];
    whldat1 = loadmazetrialtypes(filebase,trialtypesbool, [0  0  0  1  1  0   0   1   1]);%blue
    whldat2 = loadmazetrialtypes(filebase,trialtypesbool, [0  0  0  0  0  1   1   0   0]); %red
    whldat3 = loadmazetrialtypes(filebase,trialtypesbool, [0  0  0  0  0  0   0   0   0]); %green   
                                                          %rp lp dp cp ca rca lca rra lra
    
    dspowfilename = [filebase '_' num2str(lowband) '-' num2str(highband) 'Hz' fileext '.100DBdspow'];
    avepowerdat = bload(dspowfilename,[nchannels inf],0,'int16');
    avepowerdat = avepowerdat./100;
    notminusones1 = find(whldat1(:,1)~=-1);
    if ~isempty(notminusones1)
        notminusones1 = notminusones1(find(speed(notminusones1)~=-1));
    end
    notminusones2 = find(whldat2(:,1)~=-1);
    if ~isempty(notminusones2)
        notminusones2 = notminusones2(find(speed(notminusones2)~=-1));
    end
    notminusones3 = find(whldat3(:,1)~=-1);
    if ~isempty(notminusones3)
        notminusones3 = notminusones3(find(speed(notminusones3)~=-1));
    end
    for z=1:chan_z
        figure(z)
        for y=1:chan_y
            for x=1:chan_x
                if isempty(find(badchannels==chanmat(y,x,z))), % if the channel isn't bad 
                    % now plot
                    subplot(chan_y,chan_x,(y-1)*chan_x+x);
                    if depvariable == 'speed'
                        if ~isempty(notminusones1)
                            plot(speed(notminusones1),avepowerdat(chanmat(y,x,z),notminusones1),'.','markersize',8,'color',[0 0 1]); %blue
                        end
                        hold on;
                        if ~isempty(notminusones2)
                            plot(speed(notminusones2),avepowerdat(chanmat(y,x,z),notminusones2),'.','markersize',8,'color',[1 0 0]); %red
                        end
                        if ~isempty(notminusones3)
                            plot(speed(notminusones3),avepowerdat(chanmat(y,x,z),notminusones3),'.','markersize',2,'color',[0 1 0]); %green
                        end
                    end
                    
                    if depvariable == 'accel'
                        if ~isempty(notminusones1)
                            plot(accel(notminusones1),avepowerdat(chanmat(y,x,z),notminusones1),'.','markersize',1,'color',[0 0 1]); %blue
                        end
                        hold on;
                        if ~isempty(notminusones2)
                            plot(accel(notminusones2),avepowerdat(chanmat(y,x,z),notminusones2),'.','markersize',2,'color',[1 0 0]); %red
                        end
                        if ~isempty(notminusones3)
                            plot(accel(notminusones3),avepowerdat(chanmat(y,x,z),notminusones3),'.','markersize',2,'color',[0 1 0]); %green
                        end
                    end
                    hold on;
                    title(['chan ' num2str(chanmat(y,x,z))]);
                    %if ~samescale,
                    %    colorbar
                    %end
                    powmax = max([max(avepowerdat(chanmat(y,x,z),notminusones1)) max(avepowerdat(chanmat(y,x,z),notminusones2)) max(avepowerdat(chanmat(y,x,z),notminusones3)) powmax]); 
                    powmin = min([min(avepowerdat(chanmat(y,x,z),notminusones1)) min(avepowerdat(chanmat(y,x,z),notminusones2)) min(avepowerdat(chanmat(y,x,z),notminusones3)) powmin]);
                end
            end
        end
    end
end
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