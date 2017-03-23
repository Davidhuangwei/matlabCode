clear all
close all
FileBase='g09-20120330';
load([FileBase,'.HPGB30-60Hz.fHighGamma.mat'],'FreqBins','Channels','chbelong','tb','lfp')
LFP=sq(lfp);
clear lfp
datat=[FileBase,'.HPGB30-60Hz.fHighGamma'];
chbelong=chbelong(end);
[ns,~,nch]=size(LFP);
bs_time=500;
% sorder=ShuffleNr(ns,ns,bs_time);
[~,sorder]=sort(rand(ns,bs_time));% permute
rlfp=sq(sum(LFP(:,:,(end-chbelong+1):end),3));% fangle()
timelags=-60:4:60;
timelag2s=-60:4:60;
t1=length(timelags);
t2=length(timelag2s);
pl=zeros(t1,t2,nch);
te=zeros(t1,t2,nch);
ate=zeros(t1,t2,nch);
Null_dist=zeros(t1,t2,nch,bs_time,3);
for k=1:nch
    if k~=21 && k~=19
        for m=1:t1
            for h=1:t2
                timelag=timelags(m);
                timelag2=timelag2s(h);
                ms=zscore(sq(abs(LFP(:,tb+1+timelag+timelag2,k))));
                cs=zscore(sq(abs(rlfp(:,tb+1+timelag))));
                cst=zscore(sq(abs(rlfp(:,tb+1+timelag+timelag2))));
                mst=zscore(sq(abs(LFP(:,tb+1+timelag,k))));
                fms=sq(fangle(LFP(:,tb+1+timelag+timelag2,k)));
                fcs=sq(fangle(rlfp(:,tb+1+timelag)));
                fcst=sq(fangle(rlfp(:,tb+1+timelag+timelag2)));
                fmst=sq(fangle(LFP(:,tb+1+timelag,k)));
                if timelag2<0
                    ate(m,h,k)=nTEp(cs,ms,cst);
                    te(m,h,k)=nTEp(fcs,fms,fcst);
                else
                    ate(m,h,k)=nTEp(ms,cs,mst);
                    te(m,h,k)=nTEp(fms,fcs,fmst);
                end
                pl(m,h,k)=(fms'*fcs)/ns;
                for bsn=1:bs_time
                    ms=ms(sorder(:,bsn),:);
                    mst=mst(sorder(:,bsn),:);
                    fms=fms(sorder(:,bsn),:);
                    fmst=fmst(sorder(:,bsn),:);
                    if timelag2<0
                        Null_dist(m,h,k,bsn,1)=nTEp(cs,ms,cst);
                        Null_dist(m,h,k,bsn,2)=nTEp(fcs,fms,fcst);
                    else
                        Null_dist(m,h,k,bsn,1)=nTEp(ms,cs,mst);
                        Null_dist(m,h,k,bsn,2)=nTEp(fms,fcs,fmst);
                    end
                    Null_dist(m,h,k,bsn,3)=(fms'*fcs)/ns;
                end
                
            end
        end
        figure(226)
        subplot(1,nch,k)
        imagesc(sq(abs(pl(:,:,k))))
        drawnow
    end
    disp(['done for channel', num2str(k),' in ', num2str(nch)])
end
clear LFP
save([datat, 'TimeLagAna2dBSfast.mat'])