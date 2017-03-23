directions={[datat, '3 to 1'],[datat, '1 to 3']};
methodsname={'condition on past','condition on future'};
figure(226);
kk=cst;
for k=1:2
    for n=1:2
subplot(4,2,n+k*2-2)
imagesc(timelag2s, timelags,sq(kk(:,:,k,n)))
if n==1
    ylabel(directions{k});
end
if k==1
    title(methodsname{n});
end
    end
end
subplot(4,2,5)
imagesc(timelag2s, timelags,sign(sq(kk(:,:,2,1)-kk(:,:,1,1))))
ylabel('compare p-val of 2 sides')
subplot(4,2,6)
imagesc(timelag2s, timelags,sign(sq(kk(:,:,2,2)-kk(:,:,1,2))))
subplot(4,2,7)
imagesc(timelag2s, timelags,sq(abs(plv(:,:,1))))
ylabel('phase locking for directions')
subplot(4,2,8)
imagesc(timelag2s, timelags,sq(abs(plv(:,:,2))))
zlag=find(timelags==0);
for d=1:2
for k=1:length(timelag2s)
    nulld=Null_dist{zlag,k,d,1};
    figure(337+d)
    subplot(5,5,k)
    hist(nulld,20);
    hold on
    plot(cst(zlag,k,1,1),1,'r.','Linewidth',5)
end
end