%function [csd, newtrange, newchrange] = CurSrcDns(eeg,trange,type,chnum,chanrange,samplerate, step, ColorRange)
function [csd, newtrange, newchrange] = CurSrcDns(eeg,varargin)
method =2;
if size(eeg,1)<size(eeg,2)
    eeg  = eeg';
end
[trange,type,chnum,chanrange,samplerate, step,ColorRange] = ...
    DefaultArgs(varargin, {[], 'c',size(eeg,2), [1:size(eeg,2)], 1250, 2, []}); 
% if isempty(trange)

if isempty(trange)
 trange=[1:size(eeg,1)]/(samplerate/1000);
end
% end
csd=eeg;

csd = csd - repmat(mean(csd),size(csd,1),1);
if (method == 1)
    csd=-diff(csd,2,2);
else
    ch=[step+1:chnum-step];
    csd = csd(:,ch+step) - 2*csd(:,ch) + csd(:,ch-step);
    csd = -csd/(step^2);
end

%m=MeanSmoothMany(trange,eeg,5);
%csd=interp2(eeg,'cubic');
%csd=interp2(eeg,'nearest');

% [nt, nch] = meshgrid(newtrange, newchrange); 
% csd=interp2(ch, trange, csd', nt, nch, 'linear');

if nargout==0
    
%    newtrange=linspace(trange(1),trange(end),3*size(csd,1));
%    newchrange=linspace(ch(1)-0.5, ch(end)+0.5, 3*size(csd,2));
%    [ti chi] = meshgrid(newtrange, newchrange);
%    icsd=interp2(csd, trange, ch, ti, chi, 'linear');

    csd=interp2(csd, 3, 'linear');
    newtrange=linspace(trange(1),trange(end),size(csd,1))';
    newchrange=linspace(ch(1)-0.5, ch(end)+0.5, size(csd,2))';


    if (type=='c')
%        pcolor(newtrange,newchrange,csd');
  %      set(gca,'YTick', newchrange(1:2:end));
 %       shading interp
         imagesc(newtrange,newchrange,csd');
        set(gca,'YTick', ch);
        axis tight
        set(gca,'ydir','rev');

        if (isempty(ColorRange))
            cx =caxis;
            cxmax = max(abs(cx));
            caxis([-cxmax cxmax]);
        else
            caxis(ColorRange);
        end
    elseif (type=='l')
        spacing= mean(max(csd,[],1)-min(csd,[],1)) ;
        plot(newtrange,csd'-repmat(newchrange*spacing,length(newtrange),1)','k'); 
    end
else
    csd=interp2(csd, 3, 'linear');
    newtrange=linspace(trange(1),trange(end),size(csd,1))';
    newchrange=linspace(ch(1)-0.5, ch(end)+0.5, size(csd,2))';
end
