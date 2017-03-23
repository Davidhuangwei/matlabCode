%function PlotWithErr(x,y,e,col)
%plots function with error lines above and below
function PlotWithErr(x,y,e,col)

if min(size(x))>1 | min(size(y))>1 | max(size(x))~=max(size(y))
    error('x or y is wrong')
    exit;
end
x=x(:)'; y=y(:)';
if (size(e,1)>2) e=e'; end
if (nargin<4) col ='b'; end
plot(x,y,col);
hold on
col=[col ':'];
if (min(size(e))==1)
    ydown = y-e;
    yup = y+e;
else
    ydown = y -e(2,:);
    yup = y + e(1,:);
end
plot(x,ydown,col);
plot(x,yup,col);
hold off