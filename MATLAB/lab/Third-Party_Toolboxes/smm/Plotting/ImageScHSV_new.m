function h = ImageScHSV(imageData, satMask, valMask, colorLimits, Gamma)
% Alternative to imagesc with the ability to specify an hsv for masked
%   values
% mask is a boolean matrix the size of imageData with zeros for to be masked
%   entries
% colorLimits default = min/max
% maskHSV default = [1 0 0.8] (light gray) 
%   if maskHue = NaN the hue will be determined by imageData

if ~exist('maskHSV','var') | isempty(maskHSV)
    maskHSV = [1 0 0.8];
end
if ~exist('mask','var') | isempty(mask)
    mask = logical(ones(size(imageData)));
end
if ~exist('colorLimits','var') | isempty(colorLimits)
    if isnan(maskHSV(1))
        colorLimits = [min(min(imageData)) max(max(imageData))];
    else
        colorLimits = [min(min(imageData(mask))) max(max(imageData(mask)))];
    end
end
if ~exist('valMask','var') | isempty(valMask)
    valMask = logical(ones(size(imageData)));
end
if ~exist('satMask','var') | isempty(satMask)
    satMask = logical(ones(size(imageData)));
end

if ~exist('Gamma','var') | isempty(Gamma)
    Gamma = 1;
end
temp = zeros(size(imageData));
temp(mask) = (2/3) - (2/3)*clip((imageData(mask) -colorLimits(1))./(colorLimits(2)-colorLimits(1)),0,1).^Gamma;
if isnan(maskHSV(1)) % if maskHSV(1) = NaN scale the hue as the rest of imageData
    temp(~mask) = (2/3) - (2/3)*clip((imageData(~mask) -colorLimits(1))./(colorLimits(2)-colorLimits(1)),0,1).^Gamma;
else
    temp(~mask) = maskHSV(1);
end
Hsv(:,:,1) = temp;
%Hsv(:,:,2) =   HSVmask;%mask + ~mask.*maskHSV(2);

%Hsv(:,:,2) =   mask + ~mask.*maskHSV(2);
%Hsv(:,:,2) =   ones(size(HSVmask));%mask + ~mask.*maskHSV(3);
Hsv(:,:,2) =   satMask;%mask + ~mask.*maskHSV(3);
%Hsv(:,:,3) =   ones(size(HSVmask));%mask + ~mask.*maskHSV(3);
Hsv(:,:,3) =   valMask;%mask + ~mask.*maskHSV(3);

%Hsv(:,:,3) =   mask + ~mask.*maskHSV(3);

image(hsv2rgb(Hsv));
%shading interp;
set(gca, 'ydir', 'reverse')

% most annoying bit is colorbar
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
return
