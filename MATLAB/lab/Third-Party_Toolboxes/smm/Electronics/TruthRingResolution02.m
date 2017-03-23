%function TruthRingResolution02(vLimits,r2,r3)
% using wheatstone bridge
function TruthRingResolution02(vLimits,r2,r3)
% function TruthRingResolution01(vLimits,r2)
% function TruthRingResolution01(vLimits,r2)

% vLimits = [-0.5 1.5]
% vLimits = [1 2.5]

clf
rTest = [0.5 1 3 10]*1000000;
rTest = [ 100 1000]*10000;
for k=1:length(rTest)
    r1 = rTest(k);
rTestRes = 100;
rS = 10000:rTestRes:10000000;
Vdd = 3;

% Vs = Vdd.*(1-(r1./(r1 + rS)));
% Vs = Vdd.*(1-(r1./(r1 + rS)));
% r2 = 1000000;
% r2 = 0;
%Vs = Vdd.*(1-(r1./(r1 + rS+r2)));

Vs = Vdd.*(rS./(r1+rS) - r2./(r3+r2));

Vs8bit = round(Vs*256)/256;
Vs10bit = round(Vs*1080)/1080;
Vs12bit = round(Vs*4096)/4096;

subplot(1,length(rTest),k)
semilogx(rS,Vs8bit,'.k')
hold on
semilogx(rS,Vs10bit,'.r')
semilogx(rS,Vs12bit,'.g')
semilogx(get(gca,'xlim'),[vLimits(1) vLimits(1)],':r')
semilogx(get(gca,'xlim'),[vLimits(2) vLimits(2)],':r')
[yCross xCross] = FindNearest(vLimits(1),Vs);
text(rS(xCross),yCross,[num2str(rS(xCross)/1000,'%2.1f') 'K'],'color','r')
[yCross xCross] = FindNearest(vLimits(2),Vs);
text(rS(xCross),yCross,[num2str(rS(xCross)/1000,'%2.1f') 'K'],'color','r')

xMax = Vdd*1.2;
set(gca,'ylim',[0 xMax])
title([num2str(r1/1000000,'%2.2f') 'M'])

resPoints = [0.1 1 3 9]*1000000;
resAdd = 1000000;
res12bitVals = [];
res10bitVals = [];
res8bitVals = [];
for j=1:length(resPoints)
    res12bitVals(j) = max(diff(find(diff(Vs12bit(rS>resPoints(j) & rS<resPoints(j)+resAdd))~=0)))*rTestRes;
    text(resPoints(j),1.15*Vdd,[num2str(res12bitVals(j)/1000,'%2.1f') 'K'],'color','g');
    res10bitVals(j) = max(diff(find(diff(Vs10bit(rS>resPoints(j) & rS<resPoints(j)+resAdd))~=0)))*rTestRes;
    text(resPoints(j),1.1*Vdd,[num2str(res10bitVals(j)/1000,'%2.1f') 'K'],'color','r');
    res8bitVals(j) = max(diff(find(diff(Vs8bit(rS>resPoints(j) & rS<resPoints(j)+resAdd))~=0)))*rTestRes;
    text(resPoints(j),1.05*Vdd,[num2str(res8bitVals(j)/1000,'%2.1f') 'K'],'color','k');
end
end

