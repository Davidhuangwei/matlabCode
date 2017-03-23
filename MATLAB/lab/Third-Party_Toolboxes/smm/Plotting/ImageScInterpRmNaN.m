% function h = ImageScInterpRmNaN(data,varargin)
% [nTimes interpMethod] = DefaultArgs(varargin,{5,'linear'});
% uses interp2 and imagesc to replace pcolor 
% (because pcolor sucks in so many ways)
% note: y-axis orientation is similar to imagessc, not pcolor
% imageData can be a cell array of form {xVals yVals cVals}
function h = ImageScInterpRmNaN(data,varargin)
[nTimes interpMethod, colorLimits, nanHSV, Gamma] = DefaultArgs(varargin,{5,'linear',[],[1 0 1],[]});
if iscell(data)
    oldXVals = data{1};
    oldYVals = data{2};
   data = data{3};
   
    xVals = interp2(squeeze(cat(3,oldXVals,oldXVals)),nTimes); 
    xVals = xVals(:,1);
     yVals = interp2(squeeze(cat(3,oldYVals,oldYVals)),nTimes);
     yVals = yVals(:,1);
else
    yVals = 1:1/nTimes:size(data,1);
    xVals = 1:1/nTimes:size(data,2);
end

interpData = interp2(data,nTimes,interpMethod);

h = ImageScRmNaN({xVals,yVals,interpData}, colorLimits, nanHSV, Gamma);
return
