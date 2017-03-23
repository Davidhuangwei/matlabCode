% function h = ImageScRmNaN(imageData,varargin)
%     [colorLimits, nanColor] = DefaultArgs(varargin,{[],[0.75 0.75 0.75]});
% Alternative to imagesc with the ability to specify a color for NaN values
function varargout = ImageScRmNaN(imageData,varargin)
[colorLimits, nanColor] = DefaultArgs(varargin,{[],[0.85 0.85 0.85]});

if iscell(imageData)
    xVals = imageData{1};
    yVals = imageData{2};
    imageData = imageData{3};
    specXYBool = 1;
else
    specXYBool = 0;
end

% try
if specXYBool
    h = imagesc(xVals,yVals,imageData);
else
    h = imagesc(imageData);
end
% catch
%     fprintf('\nimage(hsv2rgb(Hsv)) failed. Trying image(abs(hsv2rgb(Hsv)))\n')
%     if specXYBool
%         h = imagesc(xVals,yVals,imageData);
%     else
%         h = imagesc(abs(imageData));
%     end
% end

%     h = imagesc(imageData);
if ~isempty(colorLimits)
    set(gca,'clim',colorLimits);
end
[y x] = find(isnan(imageData));
for j=1:length(x)
     patch([x(j)-0.5 x(j)+0.5 x(j)+0.5 x(j)-0.5],[y(j)-0.5 y(j)-0.5 y(j)+0.5 y(j)+0.5],nanColor,'edgecolor',nanColor);
end
varargout = {h};
varargout = varargout(1:nargout);
return

% 
% if iscell(imageData)
%     xVals = imageData{1};
%     yVals = imageData{2};
%     imageData = imageData{3};
%     specXYBool = 1;
% else
%      specXYBool = 0;
% end
%     
% if ~exist('Gamma','var') | isempty(Gamma)
%     Gamma = 1;
% end
% if ~exist('nanHSV','var') | isempty(nanHSV)
%     nanHSV = [1 0 0.8];
% end
% 
% prevWarnings = SetWarnings({'off','MATLAB:dispatcher:nameConflict'});
% 
% if ~exist('colorLimits','var') | isempty(colorLimits)
%     colorLimits = [min(min(imageData(~isnan(imageData)))) max(max(imageData(~isnan(imageData))))];
% end
%  
% Hsv(:,:,1) = (2/3) - (2/3)*clip((imageData-colorLimits(1))./(colorLimits(2)-colorLimits(1)),0,1).^Gamma;
% Hsv(isnan(imageData)) = nanHSV(1);
% Hsv(:,:,2) =   ~isnan(imageData) + isnan(imageData).*nanHSV(2);
% Hsv(:,:,3) =   ~isnan(imageData) + isnan(imageData).*nanHSV(3);
% 
% try 
%     if specXYBool
%         image(xVals,yVals,hsv2rgb(Hsv));
%     else
%         image(hsv2rgb(Hsv));
%     end
% catch
%     fprintf('\nimage(hsv2rgb(Hsv)) failed. Trying image(abs(hsv2rgb(Hsv)))\n')
%     if specXYBool
%         image(xVals,yVals,abs(hsv2rgb(Hsv)));
%     else
%         image(abs(hsv2rgb(Hsv)));
%     end
% end
% set(gca, 'ydir', 'reverse')
% 
% % most annoying bit is colorbar
% addpath /u16/local/matlab6.5/toolbox/matlab/graph2d/
% h = gca;
% h2 = SideBar;
% BarHsv(:,:,1) = (2/3) - (2/3)*(0:.01:1)'.^Gamma;
% BarHsv(:,:,2) = ones(101,1);
% BarHsv(:,:,3) = ones(101,1);
% image(0,(colorLimits(1):(colorLimits(2)-colorLimits(1))/100:colorLimits(2)), hsv2rgb(BarHsv));
% set(gca, 'ydir', 'normal');
% set(gca, 'xtick', []);
% set(gca, 'yaxislocation', 'right');
% axes(h);
% rmpath /u16/local/matlab6.5/toolbox/matlab/graph2d/
% if nargout == 0
%     clear h;
% end
% SetWarnings(prevWarnings);
% 
% return
