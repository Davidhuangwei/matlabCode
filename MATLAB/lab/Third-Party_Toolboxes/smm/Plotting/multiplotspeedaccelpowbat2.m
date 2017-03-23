function multiplotspeedaccelpowbat2(taskType,fileBaseMat,fileext,nchannels,chanMat,badchannels,lowband,highband,depvariable,fileNameFormat,samescale,xlimits)
% function multiplotspeedpowbat(fileBaseMat,fileext,nchannels,chanMat,lowband,highband,samescale,badchannels,xlimits)

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
whldat4 = [];

[numfiles n] = size(fileBaseMat);
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

[chan_y chan_x chan_z] = size(chanMat);  
for z=1:chan_z
    figure(z)
    clf
end
for i=1:numfiles

    filebase = fileBaseMat(i,:);
    whldat = load([filebase '.whl']);
    [tmpspeed tmpaccel] = MazeSpeedAccel(whldat);
    speed = [speed; tmpspeed];
    accel = [accel; tmpaccel];
    trialtypesbool = [1 0 1 0 0 0 0 0 0 0 0 0 0];
    whldat1 = [whldat1; LoadMazeTrialTypes(filebase,trialtypesbool, [0 0 0 0 0 0 0 1 1])];%blue
    whldat2 = [whldat2; LoadMazeTrialTypes(filebase,trialtypesbool, [0 0 0 0 1 0 0 0 0])]; %red
    whldat3 = [whldat3; LoadMazeTrialTypes(filebase,trialtypesbool, [0 0 0 1 0 0 0 0 0])]; %green   
    whldat4 = [whldat4; LoadMazeTrialTypes(filebase,trialtypesbool, [0 0 0 0 0 1 1 0 0])]; %gray
    
    dspowfilename = [filebase '_' num2str(lowband) '-' num2str(highband) 'Hz' fileext '.100DBdspow'];
    avepowerdat = [avepowerdat bload(dspowfilename,[nchannels inf],0,'int16')];
    
end
if ~isempty(speed~=-1)
    if ~isempty(whldat1(:,1)~=-1)
        notminusones1 = whldat1(:,1)~=-1 & speed~=-1;
    end
    if ~isempty(whldat2(:,1)~=-1)
        notminusones2 = whldat2(:,1)~=-1 & speed~=-1;
    end
    if ~isempty(whldat3(:,1)~=-1)
        notminusones3 = whldat3(:,1)~=-1 & speed~=-1;
    end
    if ~isempty(whldat4(:,1)~=-1)
        notminusones4 = whldat4(:,1)~=-1 & speed~=-1;
    end
end
%randomized = randperm(length(notminusones1));

avepowerdat = (avepowerdat./100);

colors = -1*ones(length(notminusones1),3);

colors(notminusones1,:) = repmat([0 0 1],length(find(notminusones1)),1);
colors(notminusones2,:) = repmat([1 0 0],length(find(notminusones2)),1);
colors(notminusones3,:) = repmat([0 1 0],length(find(notminusones3)),1);
colors(notminusones4,:) = repmat([0.5 0.5 0.5],length(find(notminusones4)),1);

notminusones = notminusones1 | notminusones2 | notminusones3 | notminusones4;
%blue = repmat([0 0 1], size(notminusones1,1),1);
%red = repmat([1 0 0], size(notminusones2,1),1);
%green = repmat([0 1 0], size(notminusones3,1),1);
%gray = repmat([0.5 0.5 0.5], size(notminusones4,1),1);

%mazeRegions = [notminusones1;notminusones2;notminusones3;notminusones4];
%colors = [blue; red; green; gray];
%speed = [speed;speed;speed;speed];
%avepowerdat = [avepowerdat avepowerdat avepowerdat avepowerdat];
%randomized = randperm(length(mazeRegions));

%jump = floor(length(notminusones1)/10)
%for i=jump:jump:length(notminusones1)
for z=1:chan_z
    figure(z)
    clf
    for y=1:chan_y
        for x=1:chan_x
            if isempty(find(badchannels==chanMat(y,x,z))), % if the channel isn't bad 
                % now plot

                subplot(chan_y,chan_x,(y-1)*chan_x+x);
                hold on;
                 jump = 50;
                if depvariable == 'speed'
                   if 0 % old code
                       if ~isempty(find(notminusones))
                           %set(gcf,'DefaultAxesColorOrder',colors(notminusones,:));
                           jump = 1000;
                           for i=1:jump:length(notminusones)
                               keyboard
                               plot(speed(notminusones(i:min(length(notminusones),i+jump-1))),avepowerdat(chanMat(y,x,z),notminusones(i:min(length(notminusones),i+jump-1))),'.','markersize',4,'color',colors(i:min(length(notminusones),i+jump-1),:));
                           end
                       end
                       if ~isempty(find(notminusones1))
                           plot(speed(find(notminusones1)),avepowerdat(chanMat(y,x,z),find(notminusones1)),'.','markersize',4,'color',[0 0 1]); %blue
                       end
                       if ~isempty(find(notminusones2))
                           plot(speed(find(notminusones2)),avepowerdat(chanMat(y,x,z),find(notminusones2)),'.','markersize',4,'color',[1 0 0]); %red
                       end
                       if ~isempty(find(notminusones3))
                           plot(speed(find(notminusones3)),avepowerdat(chanMat(y,x,z),find(notminusones3)),'.','markersize',4,'color',[0 1 0]); %green
                       end
                       if ~isempty(find(notminusones4))
                           plot(speed(find(notminusones4)),avepowerdat(chanMat(y,x,z),find(notminusones4)),'.','markersize',4,'color',[0.5 0.5 0.5]); %green
                       end
                   end
                   
                  
                   for i=1:jump:length(notminusones1)
                       
                       if ~isempty(find(notminusones1))
                           plot(speed(i-1+find(notminusones1(i:min(length(notminusones),i+jump-1)))),avepowerdat(chanMat(y,x,z),i-1+find(notminusones1(i:min(length(notminusones),i+jump-1)))),'.','markersize',4,'color',[0 0 1]); %blue
                       end
                       if ~isempty(find(notminusones2))
                           plot(speed(i-1+find(notminusones2(i:min(length(notminusones),i+jump-1)))),avepowerdat(chanMat(y,x,z),i-1+find(notminusones2(i:min(length(notminusones),i+jump-1)))),'.','markersize',4,'color',[1 0 0]); %red
                       end
                       if ~isempty(find(notminusones3))
                           plot(speed(i-1+find(notminusones3(i:min(length(notminusones),i+jump-1)))),avepowerdat(chanMat(y,x,z),i-1+find(notminusones3(i:min(length(notminusones),i+jump-1)))),'.','markersize',4,'color',[0 1 0]); %green
                       end
                       if ~isempty(find(notminusones4))
                           plot(speed(i-1+find(notminusones4(i:min(length(notminusones),i+jump-1)))),avepowerdat(chanMat(y,x,z),i-1+find(notminusones4(i:min(length(notminusones),i+jump-1)))),'.','markersize',4,'color',[0.65 0.65 0.65]); %green
                       end
                   end

                    
                end
                
                if depvariable == 'accel'
                    if 0
                        if ~isempty(find(notminusones1))
                            plot(accel(find(notminusones1)),avepowerdat(chanMat(y,x,z),find(notminusones1)),'.','markersize',1,'color',[0 0 1]); %blue
                        end
                        if ~isempty(find(notminusones2))
                            plot(accel(find(notminusones2)),avepowerdat(chanMat(y,x,z),find(notminusones2)),'.','markersize',2,'color',[1 0 0]); %red
                        end
                        if ~isempty(find(notminusones3))
                            plot(accel(find(notminusones3)),avepowerdat(chanMat(y,x,z),find(notminusones3)),'.','markersize',2,'color',[0 1 0]); %green
                        end
                        if ~isempty(find(notminusones4))
                            plot(accel(find(notminusones4)),avepowerdat(chanMat(y,x,z),find(notminusones4)),'.','markersize',2,'color',[0 1 0]); %green
                        end
                    end
                   for i=1:jump:length(notminusones1)
                       
                       if ~isempty(find(notminusones1))
                           plot(accel(i-1+find(notminusones1(i:min(length(notminusones),i+jump-1)))),avepowerdat(chanMat(y,x,z),i-1+find(notminusones1(i:min(length(notminusones),i+jump-1)))),'.','markersize',4,'color',[0 0 1]); %blue
                       end
                       if ~isempty(find(notminusones2))
                           plot(accel(i-1+find(notminusones2(i:min(length(notminusones),i+jump-1)))),avepowerdat(chanMat(y,x,z),i-1+find(notminusones2(i:min(length(notminusones),i+jump-1)))),'.','markersize',4,'color',[1 0 0]); %red
                       end
                       if ~isempty(find(notminusones3))
                           plot(accel(i-1+find(notminusones3(i:min(length(notminusones),i+jump-1)))),avepowerdat(chanMat(y,x,z),i-1+find(notminusones3(i:min(length(notminusones),i+jump-1)))),'.','markersize',4,'color',[0 1 0]); %green
                       end
                       if ~isempty(find(notminusones4))
                           plot(accel(i-1+find(notminusones4(i:min(length(notminusones),i+jump-1)))),avepowerdat(chanMat(y,x,z),i-1+find(notminusones4(i:min(length(notminusones),i+jump-1)))),'.','markersize',4,'color',[0.5 0.5 0.5]); %green
                       end
                   end
                end
                hold on;
                title(['chan ' num2str(chanMat(y,x,z))]);
                %if ~samescale,
                %    colorbar
                %end
                powmax = max([max(avepowerdat(chanMat(y,x,z),find(notminusones1))) max(avepowerdat(chanMat(y,x,z),find(notminusones2))) max(avepowerdat(chanMat(y,x,z),find(notminusones3))) max(avepowerdat(chanMat(y,x,z),find(notminusones4))) powmax]); 
                powmin = min([min(avepowerdat(chanMat(y,x,z),find(notminusones1))) min(avepowerdat(chanMat(y,x,z),find(notminusones2))) min(avepowerdat(chanMat(y,x,z),find(notminusones3))) min(avepowerdat(chanMat(y,x,z),find(notminusones4))) powmin]);
            end
        end
    end
end
%end


if ~exist('xlimits')
    xlimits = get(gca,'xlim');
    i=input('xmin?');
    if ~isempty(i), xlimits(1)=i; end
    i=input('xmax?');
    if ~isempty(i), xlimits(2)=i; end
end

if 1
    powmin = 39;
    powmax = 65;
end
for z=1:chan_z
    figure(z)
    for y=1:chan_y
        for x=1:chan_x
            if isempty(find(badchannels==chanMat(y,x,z))), % if the channel isn't bad       
                subplot(chan_y,chan_x,(y-1)*chan_x+x);
                set(gca, 'xlim', xlimits, 'xtick',xlimits,'fontsize', 8);
                if samescale
                    set(gca, 'ylim', [powmin powmax]);
                end
            end
        end
    end
end

for i=1:size(chanMat,3)
    figure(i);
    if fileNameFormat == 0
    gtext({[num2str(lowband) '-' num2str(highband) 'Hz Power'],'Vs',depvariable,'',fileext,'',...
        taskType,fileBaseMat(1,1:6),[fileBaseMat(1,[7 10:12 14 17:19]) '-'],fileBaseMat(end,[7 10:12 14 17:19]),...
        'rl,lr trials','','red=center','green=chcpnt','gray=goalarm','blue=retarm','gold=rewports','cyan=delayports'});
    end
    if fileNameFormat == 2
    gtext({[num2str(lowband) '-' num2str(highband) 'Hz Power'],'Vs',depvariable,'',fileext,'',...
        taskType,fileBaseMat(1,1:6),[fileBaseMat(1,8:10) '-' fileBaseMat(end,8:10)],'rl,lr trials','',...
        'red=center','green=chcpnt','gray=goalarm','blue=retarm','gold=rewports','cyan=delayports'});
    end
    set(gcf,'name',[taskType '_multiplotspeedaccelpowbat2'])

end


CountTrialTypes(fileBaseMat,1);