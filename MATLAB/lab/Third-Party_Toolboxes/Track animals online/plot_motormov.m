function [distance]=plot_motormov (distance,file)
% PLOT_MOTORMOV is a function in the automatic animal tracing toolbox.
%
% This function calculates and plots the motor activity of an animal as cumulative
% distribution and minute-wise bins.
%
% SEE ALSO 
% analyze_xydata

% All rights reserved
% Tansu Celikel
% v1 - 01.April.2004

distance.cumulative_raw=cumsum(distance.secondbysecond);
distance.cumulative_normalized=cumsum(distance.secondbysecond)/sum(distance.secondbysecond);
distance.minutebyminute_timestamps=[1:1:floor(size(distance.secondbysecond,1)/60)];

for lp=1:max(distance.minutebyminute_timestamps)
    temp=[1+(60*(lp-1)):1:lp*60];
    distance.minutebyminute(lp,1)=sum(distance.secondbysecond(temp));
    templabels{lp,1}=([num2str(lp-1) '-' num2str(lp)]);
end
distance.minutebyminute_ratio=distance.minutebyminute/sum(distance.minutebyminute);

clear lp temp 

set(gcf,'Name','Cumulative and minute-wise distribution of motor movement');
subplot(10,4,[1:28]);
plot(distance.cumulative_normalized); hold on; plot([0 size(distance.cumulative_normalized,1)], [0 1], 'r')
title (['Cumulative distribution of travel distance of data from ' file.name]); axis tight;
ylabel('Ratio'); xlabel('Time (sec/bin)'); redimscreen; grid on;
legend('Raw Data','Linear prediction',4)

subplot(10,4,[33:40]);
bar (distance.minutebyminute_timestamps,distance.minutebyminute_ratio); 
axis tight; set(gca,'YLim',[0 (max(distance.minutebyminute_ratio)*1.1)]); hold on
title (['Minute-by-minute distribution of travel distance of data from ' file.name]); 
ylabel('Ratio'); xlabel('Time (minutes)'); 
set(gca,'XTickLabel',templabels);
x= get(gca,'Xlim');
tempmean=mean(distance.minutebyminute_ratio);
tempstd=std(distance.minutebyminute_ratio);
plot (x,[tempmean tempmean],'r','LineWidth',2);
plot (x,[tempmean+(2*tempstd) tempmean+(2*tempstd)],'r-.','LineWidth',1);
plot (x,[tempmean-(2*tempstd) tempmean-(2*tempstd)],'r-.','LineWidth',1);

