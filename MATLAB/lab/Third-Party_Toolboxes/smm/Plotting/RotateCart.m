% function [outputX, outputY] = RotateCart(xData,yData,angle,varargin)
% origin = DefaultArgs(varargin,{[mean([max(data(:,1)),min(data(:,1))]) mean([max(data(:,2)),min(data(:,2))])]});
function output = RotateCart(data,angle,varargin)
origin = DefaultArgs(varargin,{[mean([max(data(:,1)),min(data(:,1))]) mean([max(data(:,2)),min(data(:,2))])]});

data(:,2) = data(:,2)-origin(2);
data(:,1) = data(:,1)-origin(1);
output = data*[cos(angle) -sin(angle);sin(angle) cos(angle)];

output(:,2) = output(:,2)+origin(2);
output(:,1) = output(:,1)+origin(1);

return
