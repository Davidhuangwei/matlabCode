function dirmtfilt_job
%  DIRMTFILT_JOB crunches a directory of lmem data sets and prints spectra to files
evglobals
auglobals
dir=ls;
name=findstr(ls,'l');
%nstart=3;


p=4;
filt_band=mtfilter([0.5*1000,p]);

f0=[7.,17.];
jj=2;

for n=1:length(name)
%for jj=1:2
     eval(sprintf('cd %s',dir(name(n):name(n)+7)));
     eval(sprintf('load %s',dir(name(n):name(n)+7)));
     fname=dir(name(n):name(n)+7);
     auname=[fname,'.lp100.ds.au'];
     au=auload(auname);
     auf=mtfilt(au,filt_band, f0(jj)./1000.);
     re_auf=real(auf);
     im_auf=imag(auf);
     refname=sprintf('%s.lp100.%dHz.%d.re.au',fname,f0(jj),p)
     imfname=sprintf('%s.lp100.%dHz.%d.im.au',fname,f0(jj),p);

     info=['lp100 Band pass filtered using mtfilter([.5*1000,4])', ...
           ' at ',num2str(f0(jj)),'Hz'];
     ausave(re_auf,refname,info,1000,AU_ENC_LINEAR_16);
     ausave(im_auf,imfname,info,1000,AU_ENC_LINEAR_16);
     eval(sprintf('cd ..'));
end
end


