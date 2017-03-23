%function [csd, newtrange, newchrange] = CurSrcDns(eeg,trange,type,chnum,chanrange)
% plots or outputs the smoothed by cubic interpolation CSD of the eeg signal
% could be either file (need to be outside the directory) or matrix(trange,chanrange)
function [csd, newtrange, newchrange] = CurSrcDns(eeg,trange,type,chnum,chanrange,samplerate)
if nargin<6 | isempty(samplerate)
    esr=1250;
else
    esr=samplerate;
end

if esr==1250
    ending='.eeg';
else
    ending='dat';
end
if nargin<2
    %trange=[-100:500]*esr/1000;
    trange=[1:size(eeg,1)/1.25];
end
if isstr(eeg)
    fn=[filename ending];
    eeg=readmulti(fn,chnum,chanrange);
else
    chanrange=[1:size(eeg,2)];
    chnum=size(eeg,2);
end

%m=MeanSmoothMany(trange,eeg,5);
csd=interp2(eeg,'cubic');
%csd=interp2(eeg,'nearest');
%csd=eeg;
csd=diff(csd,2,2);
newtrange=linspace(trange(1),trange(2),size(csd,1));
newchrange=[1:size(csd,2)];
if nargout==0
    if (type=='c')
        pcolor(newtrange,newchrange,flipdim(csd,2)');
        shading interp
    elseif (type=='l')
        spacing= mean(max(csd,[],1)-min(csd,[],1)) ;
        plot(newtrange,csd'-repmat(newchrange*spacing,length(newtrange),1)','k'); 
    end
end
    



 


    
