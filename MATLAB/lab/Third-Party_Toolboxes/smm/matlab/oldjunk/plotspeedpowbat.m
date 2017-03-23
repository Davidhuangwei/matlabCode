function plotspeedpowbat(filebasemat,fileext,nchannels,chanmat,lowband,highband,samescale,badchannels)

if ~exist('trialtypesbool')
    trialtypesbool = [1  0  1  0  0   0   0   0   0   0   0   0  0  0  0  0  1  1  1   1   1   1];
                    %cr ir cl il crp irp clp ilp crb irb clb ilb xp rp lp dp cp ca rca lca rra lra
end

if ~exist('samescale')
    samescale = 0;
end
if ~exist('badchannels')
    badchannels = 0;
end


[numfiles n] = size(filebasemat);

powmax = [];
powmin = [];

[chan_y chan_x chan_z] = size(chanmat);  

for i=1:numfiles

    filebase = filebasemat(i,:);
    whldat = load([filebase '.whl']);
    [speed accel] = mazespeed(whldat);
    whldat = loadmazetrialtypes(filebase,trialtypesbool);
    
    dspowfilename = [filebase '_' num2str(lowband) '-' num2str(highband) 'Hz' fileext '.100DBdspow'];
    avepowerdat = bload(dspowfilename,[nchannels inf],0,'int16');
    avepowerdat = avepowerdat./100;
    notminusones = find(whldat(:,1)~=-1);
    notminusones = notminusones(find(speed(notminusones)~=-1));
    
    for z=1:chan_z
        figure(z)
        for y=1:chan_y
            for x=1:chan_x
                if isempty(find(badchannels==chanmat(y,x,z))), % if the channel isn't bad 
                    % now plot
                    subplot(chan_y,chan_x,(y-1)*chan_x+x);
                    plot(speed(notminusones),avepowerdat(chanmat(y,x,z),notminusones),'.','markersize',1);
                    hold on;
                    title(['channel ' num2str(chanmat(y,x,z))]);
                    %if ~samescale,
                    %    colorbar
                    %end
                    powmax = max([max(avepowerdat(chanmat(y,x,z),notminusones)) powmax]); 
                    powmin = min([min(avepowerdat(chanmat(y,x,z),notminusones)) powmin]);
                end
            end
        end
    end
end
xlimits = get(gca,'xlim');
i=input('xmin?');
if i~=[], xlimits(1)=i; end
i=input('xmax?');
if i~=[], xlimits(2)=i; end


for z=1:chan_z
    figure(z)
    for y=1:chan_y
        for x=1:chan_x
            if isempty(find(badchannels==chanmat(y,x,z))), % if the channel isn't bad       
                subplot(chan_y,chan_x,(y-1)*chan_x+x);
                set(gca, 'xlim', xlimits, 'xticklabel',[]);
                if samescale
                    set(gca, 'ylim', [powmin powmax]);
                end
            end
        end
    end
end

