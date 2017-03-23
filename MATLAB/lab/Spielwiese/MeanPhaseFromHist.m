function [Phi MaxHH] = MeanPhaseFromHist(HH)
%% HH = [phase x cells];

bin = repmat([1:size(HH,1)]'*2*pi/size(HH,1),1,size(HH,2));

X = sum(HH.*cos(bin),1);
Y = sum(HH.*sin(bin),1);

Phi = (atan(Y./X));

Phi(X<0&Y<0) = Phi(X<0&Y<0) - pi;
Phi(X<0&Y>0) = Phi(X<0&Y>0) + pi;

Phi = mod(Phi,2*pi);

[ma mi] = max(HH);

MaxHH = bin(mi);