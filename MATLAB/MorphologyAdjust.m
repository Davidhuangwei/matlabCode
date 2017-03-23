function [nX,nY,nZ]=MorphologyAdjust(X,Y,Z,linew,tickvalues,ticklabels)
ischange=1;
aaa=figure;
xc=size(X,2);if xc>2;X=X';end
yc=size(Y,2);if yc>2;Y=Y';end
zc=size(Z,2);if zc>2;Z=Z';end
head=[X(:,1),Y(:,1),Z(:,1)];
tail=[X(:,2),Y(:,2),Z(:,2)];
fprintf('1 point position/time.')
while ischange
    updataMorphology(head,tail,aaa,linew,tickvalues,ticklabels,'b')
    datacursormode on
    changepoint=input('point:');
    [tv,tchangelabel]=min(sum(abs(bsxfun(@minus,tail,changepoint(:)')),2));
    % it must be a tail, but not necessary a head. 
    hchangelabel=find(sum(abs(bsxfun(@minus,head,changepoint(:)')),2)<(tv+10^-5));
    showstr=sprintf('\n[%d,%d,%d] new point:',tail(tchangelabel,:));
    newpoint=input(showstr);
    tail(tchangelabel,:)=newpoint;
    lhv=length(hchangelabel);
    if lhv>0
    head(hchangelabel,:)=repmat(newpoint(:)',lhv,1);
    end
    updataMorphology(head([tchangelabel;hchangelabel(:)],:),...
        tail([tchangelabel;hchangelabel(:)],:),...
        aaa,...
        linew([tchangelabel;hchangelabel(:)]),...
        tickvalues,ticklabels,'r')
    figure(aaa)
    hold off
    ischange=input('more change?');
end
nX=[head(:,1),tail(:,1)];
nY=[head(:,2),tail(:,2)];
nZ=[head(:,3),tail(:,3)];
end
function updataMorphology(head,tail,aaa,linew,tickvalues,ticklabels,cls)
for k=1:size(head,1)
figure(aaa)
    plot3([head(k,1),tail(k,1)],[head(k,2),tail(k,2)],[head(k,3),tail(k,3)],'Linewidth',linew(k),'Color',cls);
    hold on;
end
set(gca,'Ztick',tickvalues,'Zticklabel',ticklabels);
grid on
axis tight
end