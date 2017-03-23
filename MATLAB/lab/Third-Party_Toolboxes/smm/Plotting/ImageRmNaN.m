function h = ImageRmNan(imageData, colorLimits, nanHSV, Gamma)
% Alternative to imagesc with the ability to specify an hsv for NaN values
% colorLimits default = min/max
% nanHSV default = [1 0 0.8] (light gray)

if ~exist('Gamma','var') | isempty(Gamma)
    Gamma = 1;
end
if ~exist('nanHSV','var') | isempty(nanHSV)
    nanHSV = [1 0 0.8];
end


if ~exist('colorLimits','var') | isempty(colorLimits)
    colorLimits = [min(min(imageData(~isnan(imageData)))) max(max(imageData(~isnan(imageData))))];
end
 
Hsv(:,:,1) = (2/3) - (2/3)*clip((imageData-colorLimits(1))./(colorLimits(2)-colorLimits(1)),0,1).^Gamma;
Hsv(isnan(imageData)) = nanHSV(1);
Hsv(:,:,2) =   ~isnan(imageData) + isnan(imageData).*nanHSV(2);
Hsv(:,:,3) =   ~isnan(imageData) + isnan(imageData).*nanHSV(3);

image(hsv2rgb(Hsv));
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

return
