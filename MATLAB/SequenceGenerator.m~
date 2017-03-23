t=1:25000;
snr=.1*2*3^.5;
P=[7 8 6 2]/1250;
trigger=SequenceGenerator(t,P);
trigger1=filter(exp(-[0:.001:.06]-([0:60]-20).^2/900),1,trigger1);
trigger2=filter(exp(-[0:.001:.06]-([0:60]-20).^2/2500),1,trigger2);
trigger3=filter(exp(-[0:.001:.3]-([0:300]-50).^2/2500),1,trigger3);
trigger4=filter(exp(-[0:.001:.3]-([0:300]-50).^2/2500),1,trigger4);
s1=(sin((t.^.5+t.^2)*2*pi/1250*17)+sin(t*2*pi/1250*62)+snr*rand(size(t))+1).*trigger1;%exp(-(t-1000).^2/300^2).*(max((-abs(t-1000)/500+1),0))
s2=(sin((t-log(t))*2*pi/1250*45)+sin(t*2*pi/1250*47)+snr*rand(size(t))+1).*trigger2+rand(size(t))-.5;%(exp(-(t-1050).^2/120^2)+exp(-(t-700).^2/200^2))
% s1=filter(randn(1,15),1,s1);
% s2=filter(randn(1,15),1,s2);
% s3=filter([zeros(1,20), 1:3 1],1,s1)+rand(size(s1));
% s4=filter([zeros(1,30), [1:7]/5 1],1,s2)+rand(size(s2));
s3=filter([zeros(1,20), (1:3)/2 1],1,(sin((t.^.5+t.^2)*2*pi/1250*17)+sin(t*2*pi/1250*62)+snr*rand(size(t))+1).*trigger3)+rand(size(s1))+filter(exp(-[0:.1:3]-([0:30]-10).^2/100),1,rand(size(t))<.03).*sin(t*2*pi/1250*50);
%%
s4=filter([zeros(1,30), -[1:7]/5 1],1,(sin((t-log(t))*2*pi/1250*45)+sin(t*2*pi/1250*47)+snr*rand(size(t))+1).*trigger4)+rand(size(s2))+filter(exp(-[0:.1:3]-([0:30]-10).^2/100),1,rand(size(t))<.03).*sin((t.^.5+t.^2)*2*pi/1250*10);
S=[s1;s2;s3;s4]';
HP=1:16;
oA=zeros(16,4);
X=S*oA'+2*rand(length(t),9)*diag(randn(9,1));%2500
figure(1)
subplot(211)
plot(t,S)
% legend('s1','s2')
subplot(212)
plot(t,X)


function Seq=SequenceGenerator(t,P)
P=P(:);
t=t(:);
Seq=bsxfun(@le,rand(size(t),length(P)),P');
end
function [B,W,rW,vMI,covS,Perr,rMI,R]=CompareMethods(X,nc,oA,S,t)
Perr=nan(3,1);
vMI=cell(3,1);
R=cell(3,1);
rMI=cell(3,1);
oA=normW(oA')';
k=400;
[B, ~]=SSpecJAJD(X,1250,400,k,[10 20 30 40 50 60],200,nc,0);
noA=size(oA,2);
A=pinv(normW(B));
Perr(1)=amariIdx(A(:,1:noA),oA);
[vMI{1}, R{1}, rMI{1}]=UniqICtest(B,X);

[icasig,wA,W,m]=wKDICA(X',nc,0,0,0);
Perr(2)=amariIdx(wA(:,1:noA),oA);
[vMI{2}, R{2}, rMI{2}]=UniqICtest(W,X);
wA=normW(wA')';

[~,~,rW, ~]=RefinICsRot(W,X,[],50);
[vMI{3}, R{3}, rMI{3}]=UniqICtest(rW,X);
rA=pinv(normW(rW));


clim=max([max(abs(vMI{1}(:))), max(abs(vMI{2}(:))), max(abs(vMI{3}(:)))]);
tit=sprintf('SAJD: %d, KDICA: %d, ROT: %d',Perr);
figure;imagesc([triu(vMI{1}),triu(vMI{2}),triu(vMI{3})],[0 clim]);title(tit)
figure;imagesc([A,wA,rA,oA;oA'*[A,wA,rA,oA]])


vS=Zscore([S,(X*B'),icasig'],1);
covS=vS'*vS/length(t);
figure;imagesc(abs(covS))
end
function W=normW(W)
W=bsxfun(@rdivide,W,sqrt(sum(W.^2,2)));
end