whl = load('sm9603m2_209_s1_252.whl');
[speed accel] = MazeSpeedAccel(whl);

j=find(whl>-1,1)
step = 39-1;
hannWin = hanning(step+1)/mean(hann(step+1));
speedThresh = 1;
meanSpdThresh = 5;
accelThresh = 10;
while j<size(whl,1)-step
    clf
    subplot(3,1,1)
    hold on
    plot(whl(:,1),whl(:,2),'y.')
    plot(whl(j:j+step,1),whl(j:j+step,2),'.')
    subplot(3,1,2)
    hold on
    if ~(speed(j:j+step)<speedThresh & speed(j:j+step)~=-1)
        plot(speed(j:j+step),'r')
    else
        plot(speed(j:j+step))
    end
    mnSpd = mean(speed(j:j+step).*hannWin);
    if mnSpd>meanSpdThresh
        plot(20,mnSpd,'r*','markersize',20)
    else
        plot(20,mnSpd,'*','markersize',20)
    end
    set(gca,'ylim',[0 50],'xlim',[1 step+1])
    subplot(3,1,3)
    hold on
    if ~(abs(accel(j:j+step))<accelThresh & speed(j:j+step)~=-1)
        plot(accel(j:j+step),'r')
    else
        plot(accel(j:j+step))
    end
    plot(20,mean(accel(j:j+step)),'*','markersize',20)
    j = j + step + 1;
    set(gca,'ylim',[-100 100],'xlim',[1 step+1])
    pause
end


