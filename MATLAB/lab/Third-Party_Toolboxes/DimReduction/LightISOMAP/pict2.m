fprintf('Left   Mouse Button : switch between nearest neighbor and interpolation\n');
fprintf('Middle Mouse Button : swap space left-right\n') 
fprintf('Right  Mouse Button : swap space up-down\n');

hs=40;vs=40;
tol=1/10;

M = Mean ;

global a butt
a=[0,0]; butt=1;
lambda=.9;

hfig=figure(1);clf;hold on;
if isempty(beta) plot2(Y);axis equal
else 
  for i=1:length(beta); 
  plot(Y(i,1),Y(i,2),'.','Color',lambda*ones(1,3)*(1-(beta(i)-min(beta))/(max(beta)-min(beta))));
  %rectangle('Curvature',[1,1],'Position',[Y(i,1)-beta(i)/2,Y(i,2)-beta(i)/2,beta(i),beta(i)]);
  end
end

hold on;axis equal;hax=gca;
tagg='SelectionType';b1='normal';b3='alt';curp='currentpoint';
set(hfig,'WindowButtonMotionFcn','tmp = get(hax,curp);a = tmp(1,1:2);');
set(hfig,'WindowButtonDownFcn','b=get(1,tagg);if strcmp(b,b1); butt=1-butt;elseif strcmp(b,b3); Y(:,2)=-Y(:,2);figure(1);clf;plot2(Y); else; Y(:,1)=-Y(:,1);figure(1);clf;plot2(Y);end;hax=gca;axis off;figure(2)');
set(1,'DoubleBuffer','on');axis off
%gplot(conn,Yn,'k');plot(Yn(:,1),Yn(:,2),'.k',Yn(:,1),Yn(:,2),'+k');

figure(2);clf;
set(2,'DoubleBuffer','on');
set(2,'ToolBar','none');
set(2,'MenuBar','none');

nh_size=5;
while 1
% figure(1);[x,y,butt]=ginput(1);a=[x y];

  if butt==0
    [b,c]=min(sqdist(Y',a'));
    pic=EC(c,:)+M;
  elseif butt==1
    dists = sqdist(Y',a');
    nh=zeros(nh_size,1);
    for i=1:nh_size;
      [b,c]= min(dists);
      nh(i) = c; 
      dists(c)=Inf;
    end
    lnh = Y(nh,:) -repmat(a,nh_size,1);
    C   = lnh*lnh'; 
    C   = C+eye(nh_size)*trace(C)*tol;
    w = C\ones(nh_size,1);
    w = w / sum(w);
   % pic = (w'*test(nh,:))*Evecs(:,1:10)';
   pic=w'*EC(nh,:)+M;
  end
  pic=reshape(pic,hs,vs);
  figure(2)

%clf; axes('Position',[0,0,1,1]); 
image(pic);
%axis off; shg;
%nm=strcat(num2str(counter),'extra.eps');
%print('-deps',nm);
%counter=counter+1;
end

