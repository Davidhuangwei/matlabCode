%function plotmanych(manych,ifscale,trange,ypostion,yrange,color)
function plotmanych(manych,ifscale,trange,yposition,yrange,color,sr)
if nargin<1
    disp('plotmanych(manych,trange,yposition,yrange,color)');
end
if nargin<7
    sr=1250;
end
if nargin<2
    ifscale=1;
end
chnum=size(manych,2);
manych=manych-repmat(mean(manych),size(manych,1),1);
spacing= mean(max(manych,[],1)-min(manych,[],1)) ;
if nargin<6
    color='k';
end
ax=axis;
if (nargin<5 | isempty(yrange))
    if ifscale==1
        yrange=ax(3:4);
    else
        yrange=[1 (chnum+1)*spacing];
    end
end

if ifscale==1
    scale=(yrange(2)-yrange(1))/(0.5*chnum*spacing);
    manych=manych*scale;
    spacing=spacing*scale;
end
 if (nargin<4 | isempty(yposition))
    yposition=linspace((yrange(end)-spacing/2),(yrange(1)+spacing/2),chnum);
end
   
if (nargin<3 | isempty(trange))
    trange=[1 size(manych,2)]/sr;
end
yposition=yposition(:);
yrange=yrange(:);

if chnum~=size(yposition,1)
    error('manych second dimmension should be same as yposition');
end

if ifscale==0
    error('non finished option');
 %   manych=manych-repmat(newchrange*spacing,length(trange),1
 %not finished
else
    manych=manych+repmat(yposition',size(manych,1),1);
end
trange=linspace(trange(1),trange(end),size(manych,1));
plot(trange,manych',color);
if ifscale==1
    axis(ax);
end

