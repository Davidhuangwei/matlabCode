function y = hajexp(beta,x)

a = beta(1);
b = beta(2);
c = beta(3);

y = a + c*exp(-b*x);

