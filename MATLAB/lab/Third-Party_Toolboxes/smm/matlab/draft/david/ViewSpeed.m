function ViewSpeed(files1,files2,nChan,channel)
figure(1)
clf
figure(2)
clf
figure(3)
clf
figure(4)
clf
figure(5)
clf
markersize = 4;

lowCut = 5;
highCut = 12;

pos=0;
trialTypesBool = [1 1 1 1 1 1 1 1 1 1 1 1 1];
%trialTypesBool = [1 1 1 1 0 0 0 0 0 0 0 0 0];
%cd /BEEF4/smm/sm9608_analysis/maze_301-328/analysis/
for i=1:size(files1,1)
    whldat = load([files1(i,:) '.whl']);
    dspow = readmulti([files1(i,:) '_' num2str(lowCut) '-' num2str(highCut) 'Hz.eeg.100DBdspow'],nChan,channel)./100;
    [speed accel] = MazeSpeedAccel(whldat);
    whldat = LoadMazeTrialTypes(files1(i,:),trialTypesBool);
    figure(1)
    hold on

plot([1:length(speed(whldat(:,1)~=-1))]+pos,speed(whldat(:,1)~=-1))
    figure(2)
    plot([1:length(speed(whldat(:,1)~=-1))]+pos,accel(whldat(:,1)~=-1))
        pos = pos + 10 + length(speed(whldat(:,1)~=-1));
       hold on
       figure(3)
       hold on
       plot(whldat(whldat(:,1)~=-1,1),whldat(whldat(:,1)~=-1,2),'.')
       
       figure(4)
       hold on
       plot(speed(whldat(:,1)~=-1),dspow(whldat(:,1)~=-1,1),'k.','markersize',markersize)
             
       figure(5)
       hold on
       plot(accel(whldat(:,1)~=-1),dspow(whldat(:,1)~=-1,1),'k.','markersize',markersize)

end

%cd /BEEF6/smm/drugs/sm9608_556-566/analysis01/
for i=1:size(files2,1)
    whldat = load([files2(i,:) '.whl']);
    dspow = readmulti([files2(i,:) '_' num2str(lowCut) '-' num2str(highCut) 'Hz.eeg.100DBdspow'],nChan,channel)./100;
  
    [speed accel] = MazeSpeedAccel(whldat);
    whldat = LoadMazeTrialTypes(files2(i,:),trialTypesBool);
    figure(1)
    hold on

plot([1:length(speed(whldat(:,1)~=-1))]+pos,speed(whldat(:,1)~=-1))
    figure(2)
    plot([1:length(speed(whldat(:,1)~=-1))]+pos,accel(whldat(:,1)~=-1))
        pos = pos + 10 + length(speed(whldat(:,1)~=-1));
       hold on
       figure(3)
       hold on
       plot(whldat(whldat(:,1)~=-1,1),whldat(whldat(:,1)~=-1,2),'.')
       
       figure(4)
       hold on
       plot(speed(whldat(:,1)~=-1),dspow(whldat(:,1)~=-1,1),'g.','markersize',markersize)
       xlabel('Speed (cm/s)')
       ylabel(['Theta Power (' num2str(lowCut) '-' num2str(highCut) 'Hz)'])
             
       figure(5)
       hold on
       plot(accel(whldat(:,1)~=-1),dspow(whldat(:,1)~=-1,1),'g.','markersize',markersize)
       xlabel('Accel (cm/s/s)')
       ylabel(['Theta Power (' num2str(lowCut) '-' num2str(highCut) 'Hz)'])

end