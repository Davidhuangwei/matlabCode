%% way to generize the data
nt=size(lfp,1);
nlfp=zeros(nt,nfr*2);
for k=1:nfr
wn = FreqBins(k,:)/(FS/2);
[z, p, kk] = butter(4,wn,'bandpass');
[b, a]=zp2sos(z,p,kk);
filtLFP_temp = filtfilt(b, a, lfp);
filtLFP_temp=hilbert(filtLFP_temp);
nlfp(:,2*k+[-1 0])=filtLFP_temp;
end
tmp=bsxfun(@plus,nRes,-200 :200);
LFP=[];
for k=1:(2*nfr)
    x=nlfp(:,k);
    LFP(:,:,k)=x(tmp);
end
save('compLFP3778','LFP','FreqBins')
clear all
%%
load compLFP3778
for timelag2=20:4:40
figure(224+timelag2)
nt=size(LFP,1);
frb=1;% frequency band
timelag=-110;% choose from -200 :200
% timelag2=-40;
ca3=squeeze(LFP(:,201+timelag,2*frb));
ca1=squeeze(LFP(:,201+timelag+timelag2,2*frb-1));%
subplot(221)
plot(1:nt,angle([ca3,ca1]),'.')
subplot(222)
hist(angle([ca3,ca1]),10)
subplot(223)
plot(angle(ca3),angle(ca1),'.')
axis([-pi pi -pi pi])
subplot(224)
[h,XBin,YBin,~]=hist2(angle(ca1),angle(ca3),10,15);
imagesc(XBin,YBin,h)
xlabel('ca3 phase')
ylabel('ca1 phase')
end
%%
meanlfp=squeeze(mean(fangle(LFP),1));
figure(223)
subplot(121)
imagesc(abs(meanlfp))
hold on
plot([1,6],[201 201],'w')
[~,kk]=max(abs(meanlfp),[],1);
plot(1:6,kk,'w*')
subplot(211)
plot(1:401,abs(meanlfp))
legend('12Hz ca1','12Hz ca3','15Hz ca1','15Hz ca3','20Hz ca1','20Hz ca3')
axis tight
subplot(212)
plot(1:401,angle(meanlfp))
legend('12Hz ca1','12Hz ca3','15Hz ca1','15Hz ca3','20Hz ca1','20Hz ca3')
axis tight
kk=unwrap(angle(meanlfp(1:201,:)));
kk=bsxfun(@minus,kk,kk(end,:));
figure
plot(-150:-30,kk(201+[-150:-30],[1 2]))
axis tight
legend('12Hz ca1','12Hz ca3','15Hz ca1','15Hz ca3','20Hz ca1','20Hz ca3')
nLFP=zeros(size(LFP));
for k=1:6
nLFP(:,:,k)=bsxfun(@times,squeeze(LFP(:,:,k)),meanlfp(:,k)');
end
%%
figure(225)
frb=1;% frequency band
for timelag=-90:2:-40
% timelag=-70;% choose from -200 :200
ca3=squeeze(nLFP(:,201,2*frb));%+timelag
ca1=squeeze(nLFP(:,201+timelag,2*frb-1));
subplot(221)
plot(1:nt,angle([ca3,ca1]),'.')
subplot(222)
hist(angle([ca3,ca1]),10)
subplot(223)
plot(angle(ca3),angle(ca1),'.')
axis([-pi pi -pi pi])
subplot(224)
[h,XBin,YBin,~]=hist2(angle(ca1),angle(ca3),10,15);
imagesc(XBin,YBin,h,[0 25])
xlabel('ca3 phase')
ylabel('ca1 phase')
title(num2str(timelag))
drawnow
pause(1)
end
figure
for timelag=45%-90:2:-30
% timelag=-70;% choose from -200 :200
ca3=squeeze(nLFP(:,201,2*frb));%+timelag
ca1=squeeze(nLFP(:,201+timelag,2*frb-1));
[h,XBin,YBin,~]=hist2(angle(ca1),angle(ca3),10,15);
imagesc(XBin,YBin,h,[0 25])
xlabel('ca3 phase')
ylabel('ca1 phase')
title(num2str(timelag))
drawnow
pause(1)
end
figure(226)
k=1;
ts=11:20:201;% here 201 is 0 lag... i'm just too lazy....
ca1=sq(angle(LFP(:,ts,2*k-1)))';
    ca3=sq(angle(LFP(:,ts-10,2*k)))';
scatter(ca3(:),ca1(:),5,repmat(ts',nt,1));
axis tight
xlabel('ca3')
ylabel('ca1')
for k=1:3
    subplot(1,3,k)
    ca1=sq(angle(LFP(:,:,2*k-1)))';
    ca3=sq(angle(LFP(:,:,2*k)))';
scatter(ca1(:),ca3(:),2,repmat([1:401]',nt,1));
end

% check phase locking 
clfp=zeros(size(LFP));
for k=1:3
    clfp(:,:,2*k-1)=repmat(sq(LFP(:,201,2*k-1)),1,401);
    clfp(:,:,2*k)=clfp(:,:,2*k-1);
end
meanlfp=squeeze(mean(fangle(LFP.*conj(clfp)),1));
figure(227)
subplot(121)
imagesc(abs(meanlfp))
hold on
plot([1,6],[201 201],'w')
[~,kk]=max(abs(meanlfp),[],1);
plot(1:6,kk,'w*')
subplot(222)
plot(1:401,abs(meanlfp))
legend('12Hz ca1','12Hz ca3','15Hz ca1','15Hz ca3','20Hz ca1','20Hz ca3')
axis tight
subplot(224)
plot(1:401,angle(meanlfp))
legend('12Hz ca1','12Hz ca3','15Hz ca1','15Hz ca3','20Hz ca1','20Hz ca3')
axis tight
figure(227)
mlfp=mean(fangle(LFP(:,16:end,1).*conj(LFP(:,1:(end-15),2))),1);
mlfp=[mlfp; mean(fangle(LFP(:,16:end,1)),1)];
mlfp=[mlfp; mean(fangle(LFP(:,1:(end-15),2)),1)];
subplot(211)
plot(-100:100,abs(mlfp(:,201+[-100:100])))
legend('diff','ca1','ca3')
axis tight
subplot(212)
plot(-100:100,angle(mlfp(:,201+[-100:100])))
axis tight
legend('diff','ca1','ca3')


legend('12Hz ca1','12Hz ca3','15Hz ca1','15Hz ca3','20Hz ca1','20Hz ca3')