function U2 = null_u(n);

U = 2*pi/n:2*pi/n:2*pi;
U = U/2/pi
U2 = 0;

for i = 1:n
    temp = (U(i) - mean(U) - ((2*i-1)/2/n) + 0.5);
    U2 = U2 + temp;
end
U2
U2 = U2 + 1/12/n;