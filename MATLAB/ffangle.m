function y=ffangle(x,b,a,istest)
% y=ffangle(x,b,a,istest)
% y=exp(sqrt(-1)*filter(b,a,angle(x)));
if istest
    y=fangle(x);
else
    y=exp(sqrt(-1)*filter(b,a,angle(x)));
end