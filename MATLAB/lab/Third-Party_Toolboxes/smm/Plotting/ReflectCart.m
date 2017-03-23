% function output = ReflectCart(data,reflectionAngle,varargin)
% origin = DefaultArgs(varargin,{[mean([max(data(:,1)),min(data(:,1))]) mean([max(data(:,2)),min(data(:,2))])]});
function output = ReflectCart(data,reflectionAngle,varargin)
origin = DefaultArgs(varargin,{[mean([max(data(:,1)),min(data(:,1))]) mean([max(data(:,2)),min(data(:,2))])]});

data(:,2) = data(:,2)-origin(2);
data(:,1) = data(:,1)-origin(1);


refMat = [2*(cos(reflectionAngle))^2-1 2*cos(reflectionAngle)*sin(reflectionAngle);...
    2*cos(reflectionAngle)*sin(reflectionAngle) 2*(sin(reflectionAngle))^2-1];

output = data*refMat;

output(:,2) = output(:,2)+origin(2);
output(:,1) = output(:,1)+origin(1);

return