function SpectSignif(f,x0,varargin)
[f0,PLOT] = DefaultArgs(varargin,{8,0});
%%
%%
%%

delta = [2 4];
theta = [f0-2 f0+3];
beta = [12 20];


%% find right orientation of x
if size(x0,1)~=length(f)
  x = x0';
else
  x = x0;
end

if length(f)~=size(x,1)
  error('matrix has wrong dimentions')
end

%% find indices of f
fd = find(f>delta(1) & f<delta(2));
ft = find(f>theta(1) & f<theta(2));

if beta(2)>max(f)
  fb = find(f>beta(1));
else
  fb = find(f>beta(1) & f<beta(2));
end

%% compute means and stdv of the spacetra within the intervals
xdelta = [mean(x(fd,:))' std(x(fd,:))'];
xtheta = [mean(x(ft,:))' std(x(ft,:))' max(x(ft,:))'];
xbeta = [mean(x(fb,:))' std(x(fb,:))'];

%% seletct 'good' spectra
k1 = find(xtheta(:,1)./(xdelta(:,1)+3*xdelta(:,2))>1);
k2 = find(xtheta(:,1)./(xbeta(:,1)+3*xbeta(:,2))>1);

k3 = find(xtheta(:,3)./(xdelta(:,1)+10*xdelta(:,2))>1);
k4 = find(xtheta(:,3)./(xbeta(:,1)+10*xbeta(:,2))>1);

%% PLOT
if PLOT
  figure(473855);clf;
  %
  subplot(331)
  imagesc(f,[],unity(x)')
  axis xy
  %
  subplot(334)
  plot(xtheta(:,1),xdelta(:,1)+xdelta(:,2),'.')
  hold on;
  plot(xtheta(:,1),xbeta(:,1)+xbeta(:,2),'r.')
  plot([0 max(xtheta(:,1))],[0 max(xtheta(:,1))],'k--');
  %
  subplot(335)
  imagesc(f,[],unity(x(:,k1))')
  axis xy
  %
  subplot(336)
  imagesc(f,[],unity(x(:,k2))')
  axis xy
  %
  subplot(337)
  plot(xtheta(:,3),xdelta(:,1)+xdelta(:,2),'.')
  hold on;
  plot(xtheta(:,3),xbeta(:,1)+xbeta(:,2),'r.')
  plot([0 max(xtheta(:,3))],[0 max(xtheta(:,3))],'k--');
  %
  subplot(338)
  imagesc(f,[],unity(x(:,k3))')
  axis xy
  %
  subplot(339)
  imagesc(f,[],unity(x(:,k4))')
  axis xy
  
  %for n=1:size(x,2)
  %  figure(485734);clf
  %  subplot(121)
  %  plot(f,x(:,n))
  %  hold on
  %  
  %  
  %  WaitForButtonpress
  %end
end


return;


