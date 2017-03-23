% [mu, k, muerr] = VonMisesFit(th)
% fits a Von Mises distribution by maximum likelihood
%
% muerr WILL BE STANDARD ERROR AS SOON AS I DO IT

function [mu, k, muerr] = VonMisesFit(th)

[mu r] = circmean(th);

kml = BesselRatInv(r);

n = length(th(:));
if n<=15
    if kml<2
        k = max(kml -2/(n*kml),0);
    else
        k = (n-1)^3*kml/(n^3+n);
    end
else
    k = kml;
end