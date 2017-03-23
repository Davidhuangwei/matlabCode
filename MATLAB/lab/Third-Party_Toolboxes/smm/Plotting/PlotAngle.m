% function PlotAngle(angleMat,varargin)
% rotAngle = pi/2;
function PlotAngle(angleMat,varargin)
%[lineLen] = DefaultArgs(varargin,{1});
rotAngle = pi/2;
if isreal(angleMat)
    angleMat = Angle2Complex(angleMat);
end

for j=1:size(angleMat,1)
    for k=1:size(angleMat,2)
        imag(angleMat(j,k));
        real(angleMat(j,k));
        rotAngle;
%angleMat(j,k) = complex(rotateCart(imag(angleMat(j,k)),real(angleMat(j,k)),rotAngle));
tempAngle = num2cell([imag(angleMat(j,k)),real(angleMat(j,k))]*[cos(rotAngle) -sin(rotAngle);sin(rotAngle) cos(rotAngle)]);
angleMat(j,k) = complex(tempAngle{:});
    end
end

for j=1:size(angleMat,1)
    for k=1:size(angleMat,2)
        
        hold on
        startPoint = [k - imag(angleMat(j,k))/2, -j - real(angleMat(j,k))/2];
        endPoint = [k + imag(angleMat(j,k))/2, -j + real(angleMat(j,k))/2];
        if ~isnan(startPoint) & ~isnan(endPoint)
            plot_arrow(startPoint(1),startPoint(2),endPoint(1),endPoint(2),'headwidth',0.15,'headheight',0.3);
        end
    end
end
set(gca,'xlim',[0 size(angleMat,1)+1],'ylim',[-size(angleMat,2)-1 0])
set(gca,'xtick',[1:size(angleMat,1)],'ytick',[-size(angleMat,1):-1])