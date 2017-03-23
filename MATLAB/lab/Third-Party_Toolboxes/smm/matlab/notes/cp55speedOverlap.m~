 
figure(1)
clf
figure(2)
clf
cd /BEEF4/smm/sm9614_510-519/analysis01
files = GetFileNames('*.whl')
for i=1:3
    figure(1)
    hold on
    whldat = load([files(i,:) '.whl']);
    [speed accel] = MazeSpeedAccel(whldat);
    running = LoadMazeTrialTypes(files(i,:),[1 1 1 1 1 1 1 1 1 1 1 1 0],[0 0 0 1 1 1 1 1 1]);
    plot(speed(running(:,1)~=-1),accel(running(:,1)~=-1),'.','markersize',5)
    figure(2)
    plot(running(speed>1.4 & speed<2.0,1),running(speed>1.4 & speed<2.0,2),'g.')
    hold on
end


cd /BEEF4/smm/sm9614_496-509/analysis01
files = GetFileNames('*.whl')
for i=1:3
    figure(1)
    hold on
whldat = load([files(i,:) '.whl']);
[speed accel] = MazeSpeedAccel(whldat);
running = LoadMazeTrialTypes(files(i,:),[1 1 1 1 1 1 1 1 1 1 1 1 0],[0 0 0 1 1 1 1 1 1]);            
plot(speed(running(:,1)~=-1),accel(running(:,1)~=-1),'r.','markersize',5)
    figure(2)
    plot(running(speed>1.4 & speed<2.0,1),running(speed>1.4 & speed<2.0,2),'r.')
    hold on

end
figure(1)