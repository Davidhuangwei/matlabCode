function csdData = CSD1D(inData)
% function csdData = CSD1D(inData)
% inData is 2D (chanPerShank x nShank)

for j=1:size(inData,2)
    csdData(:,j) = -diff(inData(:,j),2);
end
