% %% way to generize the data
% nt=size(lfp,1);
% nlfp=zeros(nt,nfr*2);
% for k=1:nfr
% wn = FreqBins(k,:)/(FS/2);
% [z, p, kk] = butter(4,wn,'bandpass');
% [b, a]=zp2sos(z,p,kk);
% filtLFP_temp = filtfilt(b, a, lfp);
% filtLFP_temp=hilbert(filtLFP_temp);
% nlfp(:,2*k+[-1 0])=filtLFP_temp;
% end
% tmp=bsxfun(@plus,nRes,-200 :200);
% LFP=[];
% for k=1:(2*nfr)
%     x=nlfp(:,k);
%     LFP(:,:,k)=x(tmp);
% end
% save('compLFP3778','LFP','FreqBins')
% clear all
%%
clear all
close all
load compLFP3778
figure(225)
nt=size(LFP,1);
frb=1;% frequency band
timelag=-18;% choose from -200 :200 % or -45 ?
timelag2 = -20;
ca3=squeeze(LFP(:,201+timelag + timelag2,2*frb));
% ca1=squeeze(LFP(:,201+timelag,2*frb-1));
ca1=squeeze(LFP(:,201+timelag,2*frb-1));
 
subplot(221)
plot(1:nt,angle([ca3,ca1]),'.')
subplot(222)
hist(angle([ca3,ca1]),10)
subplot(223)
plot(angle(ca3),angle(ca1),'.')
axis([-pi pi -pi pi])
subplot(224)
[h,XBin,YBin,cww]=hist2(angle(ca1),angle(ca3),10,15);
imagesc(XBin,YBin,h)
xlabel('ca3 phase')
ylabel('ca1 phase')
 
%% convert to real number
real_ca3 = angle(ca3);
real_ca1 = angle(ca1);
 
%% get rid of the effect of taking Modulus
% under hypothesis ca3 -> ca1
Ind_ca3_to_ca1 = find((real_ca1-real_ca3)<0);
real_ca1_new = real_ca1;
real_ca1_new(Ind_ca3_to_ca1) = real_ca1_new(Ind_ca3_to_ca1)+ 2 * pi;
Error_ca3_to_ca1 = real_ca1_new - real_ca3;
disp('Ind test for ca3 -> ca1:')
pva1 = UInd_KCItest(real_ca3, Error_ca3_to_ca1)
 
% under hypothesis ca3 -> ca1
Ind_ca1_to_ca3 = find((real_ca3-real_ca1)<0);
real_ca3_new = real_ca3;
real_ca3_new(Ind_ca1_to_ca3) = real_ca3_new(Ind_ca1_to_ca3)+ 2 * pi;
 
Error_ca1_to_ca3 = real_ca3_new - real_ca1;
disp('Ind test for ca1 -> ca3:')
pval2 = UInd_KCItest(real_ca1, Error_ca1_to_ca3)
 
figure(226), subplot(2,2,1), plot(real_ca3, real_ca1_new, '.'); xlabel('angle of ca3'); ylabel('transf. of angle of ca1')
subplot(2,2,2), plot(real_ca1, real_ca3_new, '.'); xlabel('angle of ca1'); ylabel('transf. of angle of ca3')
subplot(2,2,3), plot(real_ca3, Error_ca3_to_ca1, '.'); xlabel('angle of ca3'); ylabel('Error in transf. of angle of ca1')
subplot(2,2,4), plot(real_ca1, Error_ca1_to_ca3, '.'); xlabel('angle of ca1'); ylabel('Error in transf. of angle of ca3')
