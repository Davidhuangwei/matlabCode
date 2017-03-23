function nx=Zscore(x,dim)
if dim>1
    x=x';
end
cx=mean(x,1);
x=bsxfun(@minus,x,cx);
nx=bsxfun(@rdivide,x,sqrt(mean(x.^2)));
if dim>1
    nx=nx';
end