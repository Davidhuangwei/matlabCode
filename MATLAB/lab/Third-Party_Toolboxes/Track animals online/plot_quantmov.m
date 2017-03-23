function [distance]=plot_quantmov (file,distance,rdata)
% PLOT_QUANTMOV is a function in the automatic animal tracing toolbox.
%
% This function plots:
%   1. Distance travelled between two consequtive frames
%   2.Histogram of distance travelled per time bin
%   3. Speed of movement
%   4. Histogram of movement speed distribution
%   5. Velocity distribution
%   6. Histogram of velocity
%
% SEE ALSO 
% analyze_xydata

% All rights reserved
% Tansu Celikel
% v1 - 01.April.2004

set(gcf,'Name','Quantification of movement -Raw distributions-')
subtitle(['Raw data from ' file.name])
subplot(3,2,1); redimscreen
plot(distance.raw,'r')
xlabel('Time (1/Frame Acq rate)'); ylabel ('Distance (cm)');
title ('Distance travelled between two consequtive frames'); axis tight;

subplot(3,2,2); cla
bar([distance.min:distance.max], histc(distance.raw,distance.min:distance.max),'facecolor',[0.6 0.6 0.6]); hold on
plot([distance.min:distance.max], histc(distance.raw,distance.min:distance.max),'r.-'); hold on
title('Histogram of distance travelled per time bin')
xlabel('Distance (cm/bin)'); ylabel ('Number of times'); axis tight

subplot(3,2,3)
timeind=0:1:floor(rdata.duration);
for lp=1:size(timeind,2)-1
    temp2=((rdata.times>=timeind(lp)) & (rdata.times<timeind(lp+1)));
    tempdist(lp)=sum(distance.raw(temp2(1:size(distance.raw,2))));
end
clear lp

distance.secondbysecond=tempdist'; % second-by-second distance
bar(1:1:length(distance.secondbysecond),distance.secondbysecond);
ylabel ('Speed (cm/sec) | Distance (cm)'); xlabel('Time (sec/bin)');
title ('Distance travelled in second long bins'); 
axis tight;
clear timeind lp tempdist

subplot(3,2,4)
hist(distance.secondbysecond);
title ('Distance travelled in second long bins'); 
xlabel ('Speed (cm/sec) | Distance (cm)'); ylabel('Number of times'); axis tight;

subplot(3,2,5); 
distance.acc_dece=diff(distance.secondbysecond);
plot(diff(distance.secondbysecond),'b-'); 
title ('Acceleration of movement'); 
axis tight;
xlabel('Time (sec/bin)'); ylabel ('Velocity (Acc.(-) / Dec.(+))')

subplot(3,2,6)
hist(distance.acc_dece);
xlabel ('Velocity (Acc.(-) / Dec.(+))'); ylabel('Number of times'); axis tight;

print ([file.name '_Figure6.png'], '-dpng');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% smoothed distributions
figure
set(gcf,'Name','Quantification of movement -Smoothed distributions-')
subtitle(['Smoothed data from ' file.name]); subplot(3,2,1); redimscreen
distance.rawSmooth=smooth(distance.raw,5);
plot(distance.rawSmooth,'r')
xlabel('Time (1/Frame Acq rate)'); ylabel ('Distance (cm)');
title ('Distance travelled between two consequtive frames'); axis tight;

subplot(3,2,2)
plot([distance.min:distance.max], histc(distance.rawSmooth,distance.min:distance.max),'r');
title('Histogram of distance travelled per time bin')
xlabel('Distance (cm/bin)'); ylabel ('Number of times'); axis tight

subplot(3,2,3)
timeind=0:1:floor(rdata.duration);
for lp=1:size(timeind,2)-1
    temp2=((rdata.times>=timeind(lp)) & (rdata.times<timeind(lp+1)));
    tempdist(lp)=sum(distance.rawSmooth(temp2(1:size(distance.raw,2))));
end

clear lp

distance.secondbysecondSmooth=smooth(distance.secondbysecond',5);

distance.secondbysecondSmooth=tempdist'; % second-by-second distance
bar(1:1:length(distance.secondbysecondSmooth),distance.secondbysecondSmooth);
ylabel ('Speed (cm/sec) | Distance (cm)'); xlabel('Time (sec/bin)');
%title ('Distance travelled in second long bins'); 
axis tight;
clear timeind lp tempdist

subplot(3,2,4)
hist(distance.secondbysecondSmooth);
xlabel ('Speed (cm/sec) | Distance (cm)'); ylabel('Number of times'); axis tight;

subplot(3,2,5); 

distance.acc_dece=diff(distance.secondbysecondSmooth);
plot(diff(distance.secondbysecondSmooth),'b-'); 
%title ('Speed of movement'); 
axis tight;
xlabel('Time (sec/bin)'); ylabel ('Velocity (Acc.(-) / Dec.(+))')

distance.acc_deceSmooth=smooth(distance.acc_dece',5);
subplot(3,2,6)
hist(distance.acc_deceSmooth);
xlabel ('Velocity (Acc.(-) / Dec.(+))'); ylabel('Number of times'); axis tight;

print ([file.name '_Figure7.png'], '-dpng');


