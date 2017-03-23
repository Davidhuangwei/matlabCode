%function [csd, newtrange, newchrange] = CurSrcDns(eeg,trange,type,chnum,chanrange,samplerate)
function [csd, newtrange, newchrange] = CurSrcDnsFile(filename,trange,type,chnum,chanrange,samplerate)
global CSDSTEP;
method =2;

if nargin<6 | isempty(samplerate)
    esr=1250;
else
    esr=samplerate;
end

if esr==1250
    ending='.eeg';
else
    ending='.dat';
end
if nargin<2 | isempty(trange)
    %trange=[-100:500]*esr/1000;
    trange=[1:size(eeg,1)]/(esr/1000);
end

if nargin<3 |isempty(type) type = 'c'; end
    
if isstr(eeg)
    fn=[filename ending];
    eeg=readmulti(fn,chnum,chanrange);
else
    chanrange=[1:size(eeg,2)];
    chnum=size(eeg,2);
end


%m=MeanSmoothMany(trange,eeg,5);
%csd=interp2(eeg,'cubic');
%csd=interp2(eeg,'nearest');
csd=eeg;
if (method == 1)
    csd=-diff(csd,2,2);
else
    step = CSDSTEP;
    ch=[step+1:chnum-step];
    csd = csd(:,ch+step) - 2*csd(:,ch) + csd(:,ch-step);
    csd = -csd/(step^2);
end

csd=interp2(csd,'linear');
%csd =csd(:,1:2:end);
%csd=interp2(csd,'cubic');
%csd=interp2(csd,'nearest');
newtrange=linspace(trange(1),trange(end),size(csd,1));
newchrange=[1:size(csd,2)];
if nargout==0
    if (type=='c')
        pcolor(newtrange,newchrange,flipdim(csd,2)');
        shading interp
%         colorbar
        cx =caxis;
        cxmax = max(abs(cx));
        caxis([-cxmax cxmax]);
    elseif (type=='l')
        spacing= mean(max(csd,[],1)-min(csd,[],1)) ;
        plot(newtrange,csd'-repmat(newchrange*spacing,length(newtrange),1)','k'); 
    end
end
