% cable model.
% here I have one sealed cable, input given at [x1, x2]<[0 100]
% which have shapes of gaussian N(x,W);
% input is given in Poisson. 
% I have 100 compartments.
% Maybe I can specify recording sites...
% shape: input:[x1,w1;x2,w2;...]
function [V,inputseq,inputx,lt]=CableICAmodel(inputx,inputseq)
% initiate the voltage
nx=size(inputx,1);
if isempty(inputseq)
    inputseq=rand(1250*2000,nx)<.00001;
end
lt=length(inputseq)+500;
ncomp=100;
V=zeros(ncomp,lt/10);
inputspace=exp(-bsxfun(@rdivide,bsxfun(@minus,1:ncomp,inputx(:,1)).^2,inputx(:,2).^2)/2)';
inputspace=bsxfun(@rdivide,inputspace,sum(inputspace,1));
st=1000/1250/10;
C_m=1.0;
R_m= 15000;
R_a = 150;
vV=V(:,1);
for k=2:lt
    if k>(lt-50)
        It=0;
    else
        It=inputspace*inputseq(k,:)';
    end
    dV=-vV/R_m+([0;vV(1:(end-1))]+[vV(2:end);0]-2*vV)/R_a+It;
    vV=vV+st*dV/C_m;
    if ~mod(k-1,10)
    V(:,(k-1)/10+1)=vV;
    end
end
figure;
imagesc(V);
colorbar

hold on
plot(1:(lt-50),bsxfun(@times,inputseq,inputx(:,1)')','k+');
[icasig, A, W, ~]=wKDICA(V,2,0,0,0);
mamari(pinv(inputspace),W)
figure;plot(1:100,bsxfun(@plus,inputspace*3,1:2));
hold on;plot(1:100,bsxfun(@plus,bsxfun(@rdivide,A,sum(A,1))*3,1:2),':')
