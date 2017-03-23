
% comodug(filename,chnum,spndchind,ripchind,freqrange)
function comodug(filename,chnum,spndchind,ripchind,freqrange)
%figure;
%freqrange=[1 200];
%for i=1:length(ripchind)

%subplotfit(i, length(ripchind));
esr=1250;
fn=[filename '.eeg'];
eegcx=readsinglech(fn,chnum,spndchind);
eeghipp=readsinglech(fn,chnum,ripchind);

aComodugram([eegcx(1:esr*300),eeghipp(1:esr*300)],2^11,1250,freqrange,2^11);
%ylabel('CA1');
%xlabel('cortex');
tit=filename;
title(tit);
%end
%pictname = [ 'comod-'filename ]; 
%letterlayoutl
%print ('-f','-depsc',pictname); 
%close
