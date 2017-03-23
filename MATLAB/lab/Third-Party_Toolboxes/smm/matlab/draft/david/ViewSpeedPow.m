function ViewSpeedPow(files1,files2,nChan,channels)

markersize = 3;
mazemarkersize = 15;
lowCut = 5;
highCut = 12;
for j=1:length(channels)
    figure(j)
    clf
    figure(j+length(channels))
    clf
end
figure(1000)
clf;
set(gcf,'name','cp55_vs_control_speed_accel_theta_pow')
pos=0;
trialTypesBool = [1 1 1 1 1 1 1 1 1 1 1 1 1];
mazeLocationsBool = [1 1 1 1 1 1 1 1 1];
%trialTypesBool = [1 1 1 1 0 0 0 0 0 0 0 0 0];
%cd /BEEF4/smm/sm9608_analysis/maze_301-328/analysis/
cd /BEEF6/smm/drugs/sm9614_496-509/analysis01
for i=1:size(files1,1)
    whldat = load([files1(i,:) '.whl']);
    dspow = log(10.^(readmulti([files1(i,:) '_' num2str(lowCut) '-' num2str(highCut) 'Hz.eeg.100DBdspow'],nChan,channels)./1000));
    [speed accel] = MazeSpeedAccel(whldat);
    whldat = LoadMazeTrialTypes(files1(i,:),trialTypesBool,mazeLocationsBool);
    figure(1000)
    hold on
    plot(whldat(whldat(:,1)~=-1,1),whldat(whldat(:,1)~=-1,2),'k.','markersize',mazemarkersize)
    %figure(1)
    %hold on
    for j=1:length(channels)
        %plot([1:length(speed(whldat(:,1)~=-1))]+pos,speed(whldat(:,1)~=-1))
        %  figure(2)
        %  plot([1:length(speed(whldat(:,1)~=-1))]+pos,accel(whldat(:,1)~=-1))
        %     pos = pos + 10 + length(speed(whldat(:,1)~=-1));
        %    hold on
        %    figure(3)
        %    hold on
        %   plot(whldat(whldat(:,1)~=-1,1),whldat(whldat(:,1)~=-1,2),'.')
        
        figure(j)
        hold on
        plot(speed(whldat(:,1)~=-1),dspow(whldat(:,1)~=-1,j),'k.','markersize',markersize)

        figure(j+length(channels))
        hold on
        plot(accel(whldat(:,1)~=-1),dspow(whldat(:,1)~=-1,j),'k.','markersize',markersize)
    end
end

%cd /BEEF6/smm/drugs/sm9608_556-566/analysis01/
cd /BEEF6/smm/drugs/sm9614_510-519/analysis01
for i=1:size(files2,1)
    whldat = load([files2(i,:) '.whl']);
    dspow = log(10.^(readmulti([files2(i,:) '_' num2str(lowCut) '-' num2str(highCut) 'Hz.eeg.100DBdspow'],nChan,channels)./1000));

    [speed accel] = MazeSpeedAccel(whldat);
    whldat = LoadMazeTrialTypes(files2(i,:),trialTypesBool,mazeLocationsBool);
    figure(1000)
    hold on
    plot(whldat(whldat(:,1)~=-1,1),whldat(whldat(:,1)~=-1,2),'g.','markersize',mazemarkersize)
    set(gca,'xtick',[],'ytick',[])

    %plot([1:length(speed(whldat(:,1)~=-1))]+pos,speed(whldat(:,1)~=-1))
    %    figure(2)
    %    plot([1:length(speed(whldat(:,1)~=-1))]+pos,accel(whldat(:,1)~=-1))
    %        pos = pos + 10 + length(speed(whldat(:,1)~=-1));
    %       hold on
    %       figure(3)
    %       hold on
    %       plot(whldat(whldat(:,1)~=-1,1),whldat(whldat(:,1)~=-1,2),'.')
    
    for j=1:length(channels)
        figure(j)
        hold on
        plot(speed(whldat(:,1)~=-1),dspow(whldat(:,1)~=-1,j),'g.','markersize',markersize)
        %title(['Channel: ' num2str(channels(j))])
        xlabel('Speed (cm/s)')
        ylabel(['Log Theta Power (' num2str(lowCut) '-' num2str(highCut) 'Hz)'])
        %set(gca,'ylim',[41 55.9])
        set(gca,'ylim',[8.9 12.85])
        set(gca,'xlim',[0 85])
        set(gca,'ytick',[])
        
        figure(j+length(channels))
        hold on
        plot(accel(whldat(:,1)~=-1),dspow(whldat(:,1)~=-1,j),'g.','markersize',markersize)
        %title(['Channel: ' num2str(channels(j))])
        xlabel('Acceleration (cm/s/s)')
        ylabel(['Log Theta Power (' num2str(lowCut) '-' num2str(highCut) 'Hz)'])
        %set(gca,'ylim',[41 55.9])
        set(gca,'ylim',[8.9 12.85])
        set(gca,'xlim',[-325 325])
        set(gca,'ytick',[])
    end
end

for j=1:length(channels)*2
    figure(j)
    set(gcf,'name','cp55_vs_control_speed_accel_theta_pow')
end
figure(1000)
set(gcf,'name','cp55_vs_control_speed_accel_theta_pow')


%ViewSpeedPow('dr103_066','dr103_069',33,[4,8,12,16,20,24,28,32])