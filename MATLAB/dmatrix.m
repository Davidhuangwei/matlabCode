% W=rand(50);
% DD=dmatrix(W)+dmatrix(W');
% figure;subplot(121);imagesc(W);subplot(122);imagesc(DD);
function D=dmatrix(W)
a=size(W,2);
D=zeros(a);
for k=1:(a-1)
    for n=(k+1):a
    D(k,n)=(W(:,k)-W(:,n))'.^2*ones(a,1);
    D(n,k)=D(k,n);
    end
end
end