function TimeSequencyProcessing
% 
% <----:: Time Sequency Processing tool functions by YY ::---------------->
% 
% ******* BASIC PROCESS:
% 
% getindex: bina=getindex(a,b,If_Tell_All_Idx); 
%           get index of b in a, return 0 if element in b is not in a
% spkcount: [x, indx]=spkcount(clu)
%           count spikes
% clocalmin1: vind=clocalmin1(x,c) 1D simple localmin detection, closest to
%           c, x is sample x ch
% NearbySamples: st=NearbySamples(st,t)
%       get nearby samples when you want to increase samples around gamma
%       bursts. 
% MapTime: [btt, indtt]=MapTime(bt, tt): map burst time to time sequence.
%           btt=tt(indtt); 
% STmatrix: ny=STmatrix(y,t): ny=y([T+1:t(2):t(1)],:)
% ButterFilter: x=ButterFilter(x,wn,FS,passmode): perform butter worth
%           filter
% GetInternalActivity: [inactivity, exactivity]=GetInternalActivity(LFP):
%           get internal activity assuming all current source located
%           within recording area.  
% 
% ******* CSD related: (probably I would build a csd toolbox):
%
% lfp2CSD: csd=lfp2CSD(lfp,r) using linear operator D s.t. lfp=D*csd
% CSD2lfp: lfp=CSD2lfp(csd,r)
%
% 
% see also: functionlist(Independence test, Kernel related, Regression),
% ICArelated, 
% accumarray.m, spkcount.m, NearbySamples.m, spkcount.m, getindex.m, 
% MapTime.m, GetInternalActivity.m, STmatrix.m
% ButterFilter.m
% CSD related: lfp2CSD.m, CSD2lfp.m,
% TO DO: kCSD, gpCSD, lfps2CSDs