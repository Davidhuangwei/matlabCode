function plot_rawmotdata (rdata,file)
% PLOT_RAWMOTDATA is a function in the automatic animal tracing toolbox.
%
% This function plots the XY coordinates of animal movement in a given environment over time.
%
% SEE ALSO 
% analyze_xydata

% All rights reserved
% Tansu Celikel
% v1 - 02.April.2004

set(gcf,'Name','Raw data of animal POSITION in the apparatus')
plot3 (rdata.y,rdata.x,rdata.times,'b.'); view(0,90); %top
xlabel('X coordinate'); ylabel('Y coordinate'); zlabel('Time'); 
title(['Raw data:' file.name]); zoom on; redimscreen

