function x=dfangle(x,b,a,istest)
% x=dfangle(x,b,a,istest)
% generate: filter(b,a,fangle(x));
if istest
    x=fangle(x);
else
    filter(b,a,fangle(x));
end