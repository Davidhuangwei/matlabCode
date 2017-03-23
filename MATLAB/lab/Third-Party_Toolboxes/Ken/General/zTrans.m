% helper function zTrans computes Fisher's z-transform
function z = zTrans(x)
z = 0.5 * log((1+x) ./ (1-x));
