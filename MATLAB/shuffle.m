function y=shuffle(x,isal)
[nx, vx]=size(x);
if isal
    [~,indx]=sort(rand(nx*vx,1));
    y=reshape(x(indx),nx,vx);
else
    [~,indx]=sort(rand(nx,1));
    y=x(indx,:);
end