%function sx=avgsmooth(x,swin)
%average smoothing funciton : input vector x is smoothed by sliding the window of size swin and 
%writing the average result in corresponding bin of output vecor sx 
% if x is a matrix, averaging will be doen across rows for each column

function sx=avgsmooth(x,swin)

sx=[];
halfwin=floor(swin/2);
tempav=sum(x(1:2*halfwin+1));
lx=length(x);

for i=1:halfwin
    sx(i,:)=mean(x(1:i+halfwin,:));
end

for i=lx-halfwin:lx
    sx(i,:)=mean(x(i-halfwin:lx,:));
end
 
for i=halfwin+1:lx-halfwin-1
   sx(i,:)=(tempav)/(2*halfwin+1);
   tempav=tempav-x(i-halfwin,:)+x(i+halfwin+1,:);
end
 
   