function X=shift_eye(n, k)
X=[[zeros(k,n-k); eye(n-k)], zeros(n, k)];
X=X+X';