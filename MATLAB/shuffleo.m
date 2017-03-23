function y=shuffleo(x,num)
nx=size(x,1);
[~,indx]=sort(rand(nx,1));
y=x(indx(1:num),:);
end