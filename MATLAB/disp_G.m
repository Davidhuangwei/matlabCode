pl=zeros(size(pn));
for k=1:nch
    if k~=21 && k~=19
        for n=1:nfr
            for m=1:t1
                for h=1:t2
                    timelag=timelags(m);
                    timelag2=timelag2s(h);
                    
                    if timelag2<0
                        pl(m,h,n,k)=mean(sq(fangle(lfp(:,201+timelag+timelag2,n,k))).*sq(conj(rlfp(:,201+timelag,n))));
                    else
                        pl(m,h,n,k)=mean(sq(fangle(lfp(:,201+timelag+timelag2,n,k))).*sq(conj(rlfp(:,201+timelag,n))));
                    end
                    
                end
            end
            figure(225)
            subplot(2,nch,k+(n-1)*nch)
            imagesc(timelag2s,timelags,sq(abs(pl(:,:,n,k))))
            title(['Channel', num2str(Channels(k))])
            subplot(2,nch,k+nch)
            imagesc(timelag2s,timelags,sq(pa(:,:,n,k)))
            title('NoiIndTest')
            drawnow
        end
    end
end