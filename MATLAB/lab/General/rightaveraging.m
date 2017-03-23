function out=rightaveraging(in)

x=in(:,1);
e=in(:,2);
t=in(:,3);
n=length(t);

maxout=(x+e)/(sum(abs(x))-sum(abs(e)));
minout=(x-e)/(sum(abs(x))+sum(abs(e)));
xout=x/sum(abs(x));
meanout=mean([maxout minout],2);
eout=mean([(maxout-meanout), (meanout-minout)],2);
out=[xout eout t];