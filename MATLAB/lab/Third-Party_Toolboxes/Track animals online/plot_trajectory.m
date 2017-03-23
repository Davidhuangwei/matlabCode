function plot_trajectory (rdata,file)
% PLOT_TRAJECTORY is a function in the automatic animal tracing toolbox.
%
% This function plots the trajectory of animal movement.
%
% SEE ALSO 
% analyze_xydata

% All rights reserved
% Tansu Celikel
% v1 - 02.April.2004

set(gcf,'Name','Raw data of animal TRAJECTORY in the apparatus')
plot3 (rdata.y,rdata.x,rdata.times,'b-');
xlabel('X coordinate'); ylabel('Y coordinate'); zlabel('Time'); 
title(['Raw data:' file.name]); zoom on; redimscreen

