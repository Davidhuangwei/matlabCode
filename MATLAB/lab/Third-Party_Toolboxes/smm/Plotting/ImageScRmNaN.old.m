function h = ImageScRmNaN(imageData, colorLimits, nanHSV, Gamma)
% function h = ImageScRmNaN(imageData, colorLimits, nanHSV, Gamma)
% Alternative to imagesc with the ability to specify an hsv for NaN values
% imageData can be a cell array of form {xVals yVals cVals}
% colorLimits default = min/max
% nanHSV default = [1 0 0.8] (light gray)
% h = axis handle
if iscell(imageData)
    xVals = imageData{1};
    yVals = imageData{2};
    imageData = imageData{3};
    specXYBool = 1;
else
     specXYBool = 0;
end
    
if ~exist('Gamma','var') | isempty(Gamma)
    Gamma = 1;
end
if ~exist('nanHSV','var') | isempty(nanHSV)
    nanHSV = [1 0 0.8];
end

prevWarnings = SetWarnings({'off','MATLAB:dispatcher:nameConflict'});

if ~exist('colorLimits','var') | isempty(colorLimits)
    colorLimits = [min(min(imageData(~isnan(imageData)))) max(max(imageData(~isnan(imageData))))];
end
 
Hsv(:,:,1) = (2/3) - (2/3)*clip((imageData-colorLimits(1))./(colorLimits(2)-colorLimits(1)),0,1).^Gamma;
Hsv(isnan(imageData)) = nanHSV(1);
Hsv(:,:,2) =   ~isnan(imageData) + isnan(imageData).*nanHSV(2);
Hsv(:,:,3) =   ~isnan(imageData) + isnan(imageData).*nanHSV(3);

try 
    if specXYBool
        image(xVals,yVals,hsv2rgb(Hsv));
    else
        image(hsv2rgb(Hsv));
    end
catch
    fprintf('\nimage(hsv2rgb(Hsv)) failed. Trying image(abs(hsv2rgb(Hsv)))\n')
    if specXYBool
        image(xVals,yVals,abs(hsv2rgb(Hsv)));
    else
        image(abs(hsv2rgb(Hsv)));
    end
end
set(gca, 'ydir', 'reverse')

% most annoying bit is colorbar
addpath /u16/local/matlab6.5/toolbox/matlab/graph2d/
h = gca;
h2 = SideBar;
BarHsv(:,:,1) = (2/3) - (2/3)*(0:.01:1)'.^Gamma;
BarHsv(:,:,2) = ones(101,1);
BarHsv(:,:,3) = ones(101,1);
image(0,(colorLimits(1):(colorLimits(2)-colorLimits(1))/100:colorLimits(2)), hsv2rgb(BarHsv));
set(gca, 'ydir', 'normal');
set(gca, 'xtick', []);
set(gca, 'yaxislocation', 'right');
axes(h);
rmpath /u16/local/matlab6.5/toolbox/matlab/graph2d/
if nargout == 0
    clear h;
end
SetWarnings(prevWarnings);

return
