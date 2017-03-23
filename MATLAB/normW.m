function W=normW(W)
W=bsxfun(@rdivide,W,sqrt(sum(W.^2,2)));
end