function imagesclogy(x,y,c,varargin)
base = 2.5;
yTickLabel = DefaultArgs(varargin,{base*2.^[0:2:log2(max(y)/base)]});

imagesc(x,1:size(c,1),c);

for j=1:length(yTickLabel)
    yTick(j) = find(abs(y-yTickLabel(j))==min(abs(y-yTickLabel(j))));
end
yTickLabel = str2num(num2str(y(yTick),2));

if diff(yTick) < 0
    yTick = fliplr(yTick);
    yTickLabel = fliplr(yTickLabel);
end
set(gca,'ytick',yTick,'yticklabel',yTickLabel)

