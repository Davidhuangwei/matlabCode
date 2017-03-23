%Smoothed = MeanSmoothMany(x,y,smpl2av)
function Smoothed = MeanSmoothMany(x,y,smpl2av)
Smoothed=[];
for i=1:size(y,2)
    Smoothed(:,i)=MeanSmooth(x,y(:,i),[x(1):smpl2av:x(end)]);
end