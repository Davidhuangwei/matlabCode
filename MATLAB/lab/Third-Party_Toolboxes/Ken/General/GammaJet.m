function J = GammaJet(m, gamma)
% GammaJet(m, gamma)
%
% Gamma-correct a colormap (provides more color resolution at low values, 
% like a TV.  m is number of entries in colormap, gamma is correction factor.

LargeNumber = m*100;

BigJet = jet(LargeNumber);

Range = (0:(m-1))/(m-1);

g = 1+floor((LargeNumber-1)*Range.^gamma);

J = BigJet(g,:);