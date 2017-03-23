cd ~/data/sm/4_16_05_merged/
load KCIm.mat
% smaller width
sci=zeros(40,7);
sici=zeros(40,7);
t=1:size(XZ,1);
par.width=.5;
for k=1:39
sci(k,:)=KCIcausal_new(fangle(XZ(:,40)-XZ(:,k)),fangle(YZ(:,k)-XZ(:,k)),fangle(XZ(:,k)),par,t,0);
sici(k,:)=KCIcausal_new(fangle(YZ(:,40)-YZ(:,k)),fangle(XZ(:,k)-YZ(:,k)),fangle(YZ(:,k)),par,t,0);
end
figure
plot(1:40,[sci(:,[1,5]),sici(:,[1,5])])
hold on
plot([1 40],[.05 .05],'r.-')
legend('p','cp','ip','icp')
title('width 0.5')

kk=1000;
e=zeros(40,1);
ee=zeros(40,kk);
%% shuffle
XZ=exp(sqrt(-1)*filter([0.001,exp(-[0:1:5])],1,angle(YZ)')');
% XZ=filter([0.001,exp(-[0:1:5])],1,YZ')';
% the more lag involved, the more the noise, the more uncertain it will be,
% s.t. the smaller the TE.
dr=linspace(-pi,pi,11);
for isr=1:2
for k=1:40
    if isr==1
    X=XZ(:,40);
    Y=YZ(:,k);
    Z=XZ(:,k);
    else
        X=YZ(:,40);% XZ(:,40);
    Y=XZ(:,k);% YZ(:,k);
    Z=YZ(:,k);% XZ(:,k);
    end
    [h,xb,yb,zb,p]=histc3(angle([Z,Y,X]),dr,dr,dr);
    e(k)=centrop(h,[3,2,1]);
    for n=1:kk
[hh,xxb,yyb,zzb,pp]=histc3(angle([Z,shf(Y),X]),dr,dr,dr);
ee(k,n)=centrop(hh,[3,2,1]);
    end
end
figure(225)
subplot(1,2,isr)
plot(-39 :0,mean(ee,2),'r')
hold on
plot(-39 :0,mean(ee,2)+std(ee,[],2),'g--')
plot(-39 :0,mean(ee,2)-std(ee,[],2),'g--')
plot(-39 :0,e,'b+-')
axis([-39 0 0 1.8])
legend('mean','std','std','TE')
if isr==1
    title('CA3 TO CA1')
else 
    title('CA1 TO CA3')
end
end
%% boot
for isr=1:2
for k=1:40
    if isr==1
    X=XZ(:,40);
    Y=YZ(:,k);
    Z=XZ(:,k);
    else
        X=YZ(:,40);% XZ(:,40);
    Y=XZ(:,k);% YZ(:,k);
    Z=YZ(:,k);% XZ(:,k);
    end
    [h,xb,yb,zb,p]=histc3(angle([Z,Y,X]),pi*[0:10]/10,pi*[0:10]/10,pi*[0:10]/10);
    e(k)=centrop(h,[3,2,1]);
    for n=1:kk
[hh,xxb,yyb,zzb,pp]=histc3(angle([Z,boot(Y),X]),pi*[0:10]/10,pi*[0:10]/10,pi*[0:10]/10);
ee(k,n)=centrop(hh,[3,2,1]);
    end
end
figure(225)
subplot(1,2,isr)
plot(-39 :0,mean(ee,2),'r')
hold on
plot(-39 :0,mean(ee,2)+std(ee,[],2),'g--')
plot(-39 :0,mean(ee,2)-std(ee,[],2),'g--')
plot(-39 :0,e,'b+-')
axis([-39 0 0 1.8])
legend('mean','std','std','TE')
if isr==1
    title('CA3 TO CA1')
else 
    title('CA1 TO CA3')
end
end

%% analog signal
sjn=dir('4_16_05_merged.phase.ch51*');
load(sjn.name);
theta=1:5;
lgamma=11:15;
hgamma=19:23;
lname={'theta','lgamma','hgamma','hf'};
% so
fb=[1,5;11,15;19,23;23,28];
pr=[1,2;2,2;3,2;1,3;1,4;2,3;2,4];%
% inverse
% pr=pr(:,[2,1]);
lpr=size(pr,1);
ifunif=true;
for xz=1:lpr
    for lc=1:2
hXZ=sum(out.LFPsig(:,fb(pr(xz,2),1):fb(pr(xz,2),2),1),2);%effect
hYZ=sum(out.LFPsig(:,fb(pr(xz,1),1):fb(pr(xz,1),2),lc),2);%lgamma
tp=5000:10000;
XZ=hXZ(tp);
YZ=hYZ(tp);
kk=1000;
e=zeros(40,1);
ee=zeros(40,kk);
dr=linspace(-pi,pi,11);
%% shuffle
for isr=1:2
    for k=1:40
        if isr==1
            X=XZ((k+1):end);
            Y=YZ(1:(end-k));
            Z=XZ(1:(end-k));
        else
            X=YZ((k+1):end);% XZ(:,40);2*2*
            Y=XZ(1:(end-k));% YZ(:,k);2*2*
            Z=YZ(1:(end-k));% XZ(:,k);2*2*
        end
        [h,xb,yb,zb,p]=histc3([angle(Z),angle(Y),abs(X)],dr,dr,10,ifunif);%./abs(Y)-Z./abs(Z)angle(Y-Z)-Y
        e(k)=centrop(h,[3,2,1]);
        for n=1:kk
            [hh,xxb,yyb,zzb,pp]=histc3([angle(Z),shf(angle(Y)),abs(X)],dr,dr,10,ifunif);%./abs(Y)-Z./abs(Z)angle(Y-Z)-Y
            ee(k,n)=centrop(hh,[3,2,1]);
        end
    end
figure(224)
subplot(4,size(pr,1),(lc-1)*2*lpr+(isr-1)*lpr+xz)
plot(1:40,mean(ee,2),'r')
hold on
plot(1:40,mean(ee,2)+std(ee,[],2),'g--')
plot(1:40,mean(ee,2)-std(ee,[],2),'g--')
plot(1:40,e,'b+-')
axis([1 40 0 .2])
legend('mean','std','std','TE')
if isr==1
    if lc==1
    title(['CA1', lname{pr(xz,1)}, ' TO CA1 ', lname{pr(xz,2)}])
    else
    title(['CA3', lname{pr(xz,1)}, ' TO CA1 ', lname{pr(xz,2)}])
    end
else 
    if lc==1
    title(['CA1', lname{pr(xz,2)}, ' TO CA1 ', lname{pr(xz,1)}])
    else
    title(['CA1', lname{pr(xz,2)}, ' TO CA3 ', lname{pr(xz,1)}])
    end
end
end
    end
end
%% phase phase phase 
ifunif=false;
for xz=1:lpr
    for lc=1:2
hXZ=sum(out.LFPsig(:,fb(pr(xz,2),1):fb(pr(xz,2),2),1),2);%effect
hYZ=sum(out.LFPsig(:,fb(pr(xz,1),1):fb(pr(xz,1),2),lc),2);%lgamma
tp=5000:10000;
XZ=hXZ(tp);
YZ=hYZ(tp);
kk=1000;
e=zeros(40,1);
ee=zeros(40,kk);
dr=linspace(-pi,pi,11);
%% shuffle
for isr=1:2
    for k=1:40
        if isr==1
            X=XZ((k+1):end);
            Y=YZ(1:(end-k));
            Z=XZ(1:(end-k));
        else
            X=YZ((k+1):end);% XZ(:,40);2*2*
            Y=XZ(1:(end-k));% YZ(:,k);2*2*
            Z=YZ(1:(end-k));% XZ(:,k);2*2*
        end
        [h,xb,yb,zb,p]=histc3([angle(Z),angle(Y),angle(X)],dr,dr,10,ifunif);%./abs(Y)-Z./abs(Z)angle(Y-Z)-Y
        e(k)=centrop(h,[3,2,1]);
        for n=1:kk
            [hh,xxb,yyb,zzb,pp]=histc3([angle(Z),shf(angle(Y)),angle(X)],dr,dr,10,ifunif);%./abs(Y)-Z./abs(Z)angle(Y-Z)-Y
            ee(k,n)=centrop(hh,[3,2,1]);
        end
    end
figure(225)
subplot(4,size(pr,1),(lc-1)*2*lpr+(isr-1)*lpr+xz)
plot(1:40,mean(ee,2),'r')
hold on
plot(1:40,mean(ee,2)+std(ee,[],2),'g--')
plot(1:40,mean(ee,2)-std(ee,[],2),'g--')
plot(1:40,e,'b+-')
axis([1 40 0 .2])
legend('mean','std','std','TE')
if isr==1
    if lc==1
    title(['CA1', lname{pr(xz,1)}, ' TO CA1 ', lname{pr(xz,2)}])
    else
    title(['CA3', lname{pr(xz,1)}, ' TO CA1 ', lname{pr(xz,2)}])
    end
else 
    if lc==1
    title(['CA1', lname{pr(xz,2)}, ' TO CA1 ', lname{pr(xz,1)}])
    else
    title(['CA1', lname{pr(xz,2)}, ' TO CA3 ', lname{pr(xz,1)}])
    end
end
end
    end
end