function h = ImageScPvalDots(imageData,pVals,varargin)
[colorLimits,pValLim,minSize] = DefaultArgs(varargin,{[min(min(imageData)) max(max(imageData))],-3,0.5});

if ~exist('colorLimits','var') | isempty(colorLimits)
%     if isnan(maskHSV(1))
        colorLimits = [min(min(imageData)) max(max(imageData))];
%     else
%         colorLimits = [min(min(imageData(mask))) max(max(imageData(mask)))];
%     end
end
    Gamma = 1;

temp = zeros(size(imageData));
temp = (2/3) - (2/3)*clip((imageData -colorLimits(1))./(colorLimits(2)-colorLimits(1)),0,1).^Gamma;
% if isnan(maskHSV(1)) % if maskHSV(1) = NaN scale the hue as the rest of imageData
%     temp(~mask) = (2/3) - (2/3)*clip((imageData(~mask) -colorLimits(1))./(colorLimits(2)-colorLimits(1)),0,1).^Gamma;
% else
%     temp(~mask) = maskHSV(1);
% end
Hsv(:,:,1) = temp;
Hsv(:,:,2) =   1;%mask + ~mask.*maskHSV(3);
Hsv(:,:,3) =   1;%mask + ~mask.*maskHSV(3);
rgbData = hsv2rgb(Hsv);



% hold on
% % imageData = flipud(imageData)
% % pVals = flipud(pVals)
% for m=1:size(imageData,1)
%     for n=1:size(imageData,2)
%             if ~isnan(pVals(m,n))
%                 if length(pValLim) == 1
%                 radius = 0.250/pValLim*floor(log10(pVals(m,n))) + 0.05;
%                 else
%                 end
%                 xData = radius*[-1 1 1 -1]+n;
%                 yData = radius*[1 1 -1 -1]+m;
%                 rgbData(m,n,:)
%                 fill(xData,yData,squeeze(rgbData(m,n,:))','edgecolor',squeeze(rgbData(m,n,:))');
%             end
%     end
% end
% 
% maxPval = 3;
% pVals = log10(pVals);
holdStatus = get(gca,'NextPlot');
if length(pValLim) ==1
    pValLim = pValLim:-1;
end
keyboard
colorSlope = (0.49 - minSize) / (pValLim(end) - pValLim(1));
if any(pValLim) < 0
    pVals = FurcateData(pValLim,pVals,@floor);
else
    pVals = FurcateData(pValLim,pVals,@ceil);
end

% imageData = flipud(imageData)
% pVals = flipud(pVals)
angleData = -pi:0.1:pi;
for m=1:size(imageData,1)
    for n=1:size(imageData,2)
        if ~isnan(pVals(m,n))
            %                 radius = 0.49/pValLim*clip(ceil(log10(pVals(m,n))),pValLim,-0.5);
            %                 radius = (0.49-minSize)/pValLim*(clip(ceil(pVals(m,n)),pValLim,0));
            radius = pVals(m,n)*colorSlope;
            xData = radius*cos(angleData)+n;
            yData = radius*sin(angleData)+m;
            if all(isfinite(rgbData(m,n,:)))
                fill(xData,yData,squeeze(rgbData(m,n,:))','edgecolor',squeeze(rgbData(m,n,:))');
            end
        end
    end
end
set(gca,'NextPlot',holdStatus)

%%%%%%%%%% most annoying bit is colorbar %%%%%%%%%%%%
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
