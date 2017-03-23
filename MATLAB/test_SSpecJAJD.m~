% test SSpecJAJD
t=1:50000;
snr=.1*2*3^.5;
trigger1=rand(size(t))<.03;
trigger3=(rand(size(t))<.7).*trigger1;
trigger2=rand(size(t))<.03;
trigger4=(rand(size(t))<.7).*trigger2;
trigger1=filter(exp(-[0:.001:.3]-([0:300]-50).^2/2500),1,trigger1);
trigger2=filter(exp(-[0:.001:.3]-([0:300]-50).^2/2500),1,trigger2);
trigger3=filter(exp(-[0:.001:.3]-([0:300]-50).^2/2500),1,trigger3);
trigger4=filter(exp(-[0:.001:.3]-([0:300]-50).^2/2500),1,trigger4);
s1=(sin((t.^.5+t.^2)*2*pi/1250*17)+sin(t*2*pi/1250*62)+snr*rand(size(t))+1).*trigger1;%exp(-(t-1000).^2/300^2).*(max((-abs(t-1000)/500+1),0))
s2=(sin((t-log(t))*2*pi/1250*45)+sin(t*2*pi/1250*47)+snr*rand(size(t))+1).*trigger2+rand(size(t))-.5;%(exp(-(t-1050).^2/120^2)+exp(-(t-700).^2/200^2))
% s1=filter(randn(1,15),1,s1);
% s2=filter(randn(1,15),1,s2);
% s3=filter([zeros(1,20), 1:3 1],1,s1)+rand(size(s1));
% s4=filter([zeros(1,30), [1:7]/5 1],1,s2)+rand(size(s2));
s3=0*filter([zeros(1,20), (1:3)/2 1],1,(sin((t.^.5+t.^2)*2*pi/1250*17)+sin(t*2*pi/1250*62)+snr*rand(size(t))+1).*trigger3)+rand(size(s1))+filter(exp(-[0:.1:3]-([0:30]-5).^2/100),1,rand(size(t))<.03).*sin(t*2*pi/1250*50);
%
s4=0*filter([zeros(1,30), -[1:7]/5 1],1,(sin((t-log(t))*2*pi/1250*45)+sin(t*2*pi/1250*47)+snr*rand(size(t))+1).*trigger4)+rand(size(s2))+filter(exp(-[0:.1:3]-([0:30]-5).^2/100),1,rand(size(t))<.03).*sin((t.^.5+t.^2)*2*pi/1250*10);
S=[s1;s2;s3;s4]';
oA=[-4,  3  5 1;...
    -200,20 14 6;...
    -30  8  50 9;...
    50, -3  20 15;...
    40, -40 -10 20;...
    30, -7  -50 30;...
    10, 20  -24 45;...
    5,  30  -16 30;...
    1,  20   5   5];
X=S*oA'+2*rand(length(t),9)*diag(randn(9,1));%2500
figure(1)
subplot(211)
plot(t,S)
% legend('s1','s2')
subplot(212)
plot(t,X)
% legend('channel 1','channel 2','CHANNEL3')
%% compare different methods. the 
% for k=133:2:193
% result is vary sensitive to parameter. frequency method are better at
% sparse case.  
k=100;
[B, Spec]=SSpecJAJD(X,1250,100,k,[10 20 30 40 50 60],50,7,0,[]);
Sep=ReliabilityICtest(B,X,[],[],2)
%
A=pinv(B);
figure(29)
vS=Zscore([S,(X*B')],1);
plot(t,vS)%zscore
covS=vS'*vS/length(t)
Perr=amariIdx(A(:,1:4),oA)
[vMI, R, rMI]=UniqICtest(B,X);
% [vSep, mSep]=ReliabilityICtest(B,X,[],[],2);
figure;imagesc(vMI);title(num2str(Perr))
figure;imagesc(abs(covS))
% fprintf(' %d=%d;',k,A(2))
% title(num2str(k))
% pause(1.5)
% end
%% zscore
[icasig,wA,W,m]=wKDICA(X',4,0,0,0);
[Sep,malpha,n]=ReliabilityICtest(W,X)
Perr=amariIdx(wA(:,[1:4]),oA)
[vMI, R, rMI]=UniqICtest(W,X);
for k=1:4;
    for n=1:4;
        figure(256);
        subplot(7,7,(k-1)*7+n);plot(1:240,sq(rMI(k,n,:)));
        set(gca,'XTick',0:80:240,'XTicklabel',[0:30:90]-45);axis tight;
    end;
end
figure(33)
vS=Zscore([S,-icasig(:,:)'],1);
% plot(t,vS)
covS=vS'*vS/length(t);
figure;imagesc(abs(covS))
figure;imagesc(vMI);title(num2str(Perr))
% %%
% [icasig,A,W]=wKDICA(X',m,[],0);
% figure(34)
% plot(t,zscore([S,icasig'*[-1 0; 0 1]]))
%%
[icasigf, Af, Wf] = fastica(X','numOfIC',4);
Perr=amariIdx(Af(:,1:4),oA)
figure(4)
% subplot(211)zscore
plot(t,Zscore([S,icasigf'],1))
subplot(212)
plot(t,zscore([S,icasigf']))