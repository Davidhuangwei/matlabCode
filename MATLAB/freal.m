function x=freal(x,b,a,istest)
if istest
    x=real(x);
else
    x=filter(b,a,real(x));
end