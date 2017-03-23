% make high kurt image

p=1;
n=1000;
s1=randk(1,n);
s2=randk(1,n);

s1=s1-mean(s1); s1=s1/std(s1);
s2=m2-mean(s2); s2=s2/std(s2);

a=0.4;b=(1-a);
m1 = a*s1.^p+b*s2.^p;
m2 = a*s2.^p+b*s1.^p;

m1=m1-mean(m1); m1=m1/std(m1);
m2=m2-mean(m2); m2=m2/std(m2);

jcorr(m1,m2)
jcorr_info(m1,m2)

m12 = [m1;m2]'; % ms in columns.

u12=gso2(m12);

size(m12)
size(u12)

u1 = u12(:,1);
u2 = u12(:,2);


rs=jcorr_info(s1,s2);rm=jcorr_info(m1,m2);ru=jcorr_info(u1,u2);
% rs=jcorr(s1,s2);rm=jcorr(m1,m2);ru=jcorr(u1,u2);

fprintf('Dependency between independent sources = %.3f\n',rs);
fprintf('Dependency between correlated mixtures = %.3f\n',rm);
fprintf('Dependency between decorrelated mixtures = %.3f\n',ru);
