function I=MutualInformation(x,y,xbins,ybins)
% I=MutualInformation(x,y,xbins,ybins)
% xbins,ybins:numbers
if ~isreal(x)
    x=angle(x*conj(sum(x)));
end
if ~isreal(y)
    y=angle(y*conj(sum(y)));
end
    
xbins=prctile(x,0:(100/xbins):100);
ybins=prctile(y,0:(100/ybins):100);
n=length(x);
[px,~]=histc(x,xbins);
[py,~]=histc(y,ybins);
[pxy,~,~,~]=hist2(x,y,xbins,ybins);
px=px(px>0)/n;py=py(py>0)/n;pxy=pxy(pxy>0)/n;
I=sum(sum(pxy.*log2(pxy)))-sum(px.*log2(px))-sum(py.*log2(py));