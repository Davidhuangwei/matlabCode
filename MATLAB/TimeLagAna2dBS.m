function TimeLagAna2dBS(LFP,chbelong,datat,varargin)
[ns,~,nch]=size(LFP);
if nargin<4
    bs_time=500;
end
% sorder=ShuffleNr(ns,ns,bs_time);
[~,sorder]=sort(rand(ns,bs_time));% permute
rlfp=sq(sum(LFP(:,:,:,(end-chbelong+1):end),4));% fangle()
timelags=-100:4:100;
timelag2s=-200:4:200;
t1=length(timelags);
t2=length(timelag2s);
pn=zeros(t1,t2,nch);
pl=zeros(size(pn));
pa=zeros(size(pn));
pac=zeros(size(pn));
plc=zeros(size(pn));
A=zeros(size(pn));
Null_dist=zeros(t1,t2,nch,bs_time,6);
for k=1:nch
    if k~=21 && k~=19
        for m=1:t1
            for h=1:t2
                timelag=timelags(m);
                timelag2=timelag2s(h);
                ms=zscore(sq(abs(LFP(:,tb+1+timelag+timelag2,k))));
                cs=zscore(sq(abs(rlfp(:,tb+1+timelag,n))));
                fms=sq(fangle(LFP(:,tb+1+timelag+timelag2,k)));
                fcs=sq(fangle(rlfp(:,tb+1+timelag,n)));
                if timelag2<0
                    pn(m,h,k)=UInd_KCItestnb(fms, fms.*conj(fcs));
                    plc(m,h,k)=UInd_KCItestnb(fms, fcs);
                    [Ress, A(m,h,k)]=BasicRegression(ms,cs);
                    pa(m,h,k)=UInd_KCItestnb(ms, Ress);
                    pac(m,h,k)=UInd_KCItestnb(ms, cs);
                else
                    pn(m,h,k)=UInd_KCItestnb(fcs, fms.*conj(fcs));
                    plc(m,h,k)=UInd_KCItestnb(fms, fcs);
                    [Ress, A(m,h,k)]=BasicRegression(cs,ms);
                    pa(m,h,k)=UInd_KCItest(cs, Ress);
                    pac(m,h,k)=UInd_KCItest(cs, ms);
                end
                pl(m,h,k)=(fms'*fcs)/ns;
                for bsn=1:bs_time
                    ms=ms(sorder,:);
                    fms=fms(sorder,:);
                    if timelag2<0
                        Null_dist(m,h,k,bsn,1)=UInd_KCItestnb(fms, fms.*conj(fcs));
                        Null_dist(m,h,k,bsn,2)=UInd_KCItestnb(fms, fcs);
                        [Ress, Null_dist(m,h,k,bsn,3)]=BasicRegression(ms,cs);
                        Null_dist(m,h,k,bsn,4)=UInd_KCItestnb(ms, Ress);
                        Null_dist(m,h,k,bsn,5)=UInd_KCItestnb(ms, cs);
                    else
                        Null_dist(m,h,k,bsn,1)=UInd_KCItestnb(fcs, fms.*conj(fcs));
                        Null_dist(m,h,k,bsn,2)=UInd_KCItestnb(fms, fcs);
                        [Ress, Null_dist(m,h,k,bsn,3)]=BasicRegression(cs,ms);
                        Null_dist(m,h,k,bsn,4)=UInd_KCItest(cs, Ress);
                        Null_dist(m,h,k,bsn,5)=UInd_KCItest(cs, ms);
                    end
                    Null_dist(m,h,k,bsn,6)=(fms'*fcs)/ns;
                end
                
            end
        end
        figure(226)
        subplot(1,nch,k)
        imagesc(sq(pa(:,:,k)))
        drawnow
    end
end
clear LFP
save([datat, 'TimeLagAna2dBS.mat'])