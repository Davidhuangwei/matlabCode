function CheckLFP(lfp,varargin)
[nt, nch]=size(lfp);
if nargin<2 || isempty(varargin{1})
    Period=1:1250:(nt-1250);
    Period=[Period;Period+1250]';
% Period=[1 nt];
else
    
    Period=varargin{1};
    if isempty(Period)
        Period=1:1250:(nt-1250);
    Period=[Period;Period+1250]';
    end
end
if nargin<3|| isempty(varargin{2}); HP=1:nch;else HP=varargin{2};end
nPeriod=size(Period,1);
rscales=median(median(abs(lfp)));
lfp=lfp/rscales/100;%centersig(lfp,1)
figure
if nargin>3
    bt=varargin{3};
    bt=bt(:);
    ist=true;
else 
    ist=false;
end
for k=1:nPeriod
    t=Period(k,1):Period(k,2);
clim=max(prctile(abs(lfp),98));%1;%
%     imagesc(t,HP,lfp(t,:)',clim*[-1 1]);*2
    plot(t,bsxfun(@plus,lfp(t,:)/clim,1:nch))
    hold on
    if ist
        btt=(bt<=Period(k,2))&(bt>=Period(k,1));
        plot(repmat(bt(btt),1,2)',bsxfun(@times,[0;nch],ones(2,sum(btt))),'k:')
    end
    set(gca,'YTick',1:nch,'YTicklabel',repmat(1:(nch/2),1,2))
    hold off
    axis tight
    grid on
    pause%(.5)
end
