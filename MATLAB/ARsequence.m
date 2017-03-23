function [x, y]=ARsequence(nt)
r=.9;
x=randn(nt+10,1);
y=randn(nt+10,1);
e=randn(1);
v=.1*randn(1);
for k=3:(nt+10)  
    x(k)=2*r*cos(2*pi*40/1250)*x(k-1)-r^2*x(k-2)-e;%;
    if k<7
        y(k)=2*r*cos(2*pi*40/1250)*y(k-1)-r^2*y(k-2)-.3*v;
    else
    y(k)=2*r*cos(2*pi*40/1250)*y(k-1)-r^2*y(k-2)-.3*v+.1*x(k-6);
    end
    e=randn(1);
    v=.1*randn(1);
%     x(k)=x(k)+e;y(k)=y(k)+v;
end
x=hilbert(x(10:end));
y=hilbert(y(10:end));