function [ Freqb,Rb ] = Blanchit(Freq,R)

Lm = 20;
Rb = zeros(1,max(size(R)));
for (iR=(Lm+1):(length(R)-(Lm+1)))
    m = mean(R(iR-Lm:iR+Lm));
    Rb(iR) = R(iR)/m;     
end
%Freqb = Freq((Lm+1):(length(R)-(Lm+1)));
Freqb = Freq;