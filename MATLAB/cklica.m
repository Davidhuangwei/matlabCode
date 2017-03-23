function z=cklica(s)
% Negative log profile likelihood function using Laplacian Kernel Density Estimates
% using ordkde.c
% from KDICA

z=0; m=size(s,1);
for i=1:m,
    z=z-ordkde(sort(s(i,:)));
end
end
