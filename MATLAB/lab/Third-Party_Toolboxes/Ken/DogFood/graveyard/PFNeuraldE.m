function dE = PFNeuraldE(wmat,Pos,SpkCnt,nHidden);
% derivative function for PFNeural
% wmat is weight matrix 3xnHidden then (nHidden+1)x1

% extract weights from matrix
v = reshape(wmat(1:3*nHidden), [3 nHidden]);
w = wmat(3*nHidden+1:end);

y = Pos*w;
yy = 1./(1+exp(-y));
z = yy*w;

dEdz = (SpkCnt - exp(z))

dw = dEdz' * yy;
dv = dEdz' * (repmat(w