function vind=clocalmin1(x,c)
% 1D simple localmin detection, closest to c
% x is sample x ch
[ns,nt]=size(x);
ct=cos(angle(x))<-.7;
troughs=sign(-sin(angle(x)));
troughs(troughs>0)=0;
troughs=troughs-[zeros(ns,1),troughs(:,1:(end-1))];
troughs=troughs>0 & ct;
troughs=bsxfun(@times,troughs,1:nt);
troughs(troughs==0)=2*nt;
troughs=troughs-c;
[~,vind]=min(abs(troughs),[],2);

% %%
% vx=min(x,[],2);
% [y,iy]=findpeaks(-vx);
% iy(y<0)=[];
% y(y<0)=[];
% [~, im]=min(abs(mod(iy-1,2*c+1)-c));
% v=-y(im);
% vind=iy(im)-1-c;
% if isempty(y)
%     [v vind]=min(vx);
%     vind=vind-1-c;
% end