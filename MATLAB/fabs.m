function x=fabs(x,b,a,istest)
% x=fabs(x,b,a,istest)
% x=filter(b,a,abs(x));
if istest
    x=abs(x);
else
    x=filter(b,a,abs(x));
end