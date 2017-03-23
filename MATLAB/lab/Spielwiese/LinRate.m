%function [EFspike EFx] = LinRate(whl,spike,neu,tdir)
function [Rate T AdaRate AdaT] = LinRate(whl,spike,neu,tdir,varargin)
[NumBin,Smoother,Win] = DefaultArgs(varargin,{100,10,2});

nn=neu;
n=tdir;

%%
%keyboard
%%

post = [1:length(whl.dir)]';

pos(:,1) = whl.lin(find(whl.dir'==n));
pos(:,2) = post(find(whl.dir'==n));

%% get transfer function
%[f,x,ind] = myecdf(pos(:,1));
[f,x,ind] = SimpleECDF(pos(:,1));
[dummy indr] = sort(ind);
%kern = gausswin(1000,5);    
%smf = Filter0(kern/sum(kern),f);

%% transformed signal
a = min(pos(:,1)); b = max(pos(:,1));
fpos = (b-a)*f(indr)+a;
%smfpos = (b-a)*smf(indr)+a;
%fpos = MakeUniformDistr(pos(:,1));
%% get fpos for each spike
Pspike = spike.lpos(find(spike.dir==n & spike.ind ==nn));
Tspike = spike.t(find(spike.dir==n & spike.ind ==nn));
[dummy, indx] = intersect(pos(:,2),round(Tspike/16));
Fspike = fpos(indx);

%% equally spaced bins
Banf = min(x);
Bend = max(x);
Bins = [Banf:(Bend-Banf)/NumBin:max(Bend)];
%plotBins = Bins(1:end-1)+(Bend-Banf)/NumBin/2;

%%%% adaptive binsize for spikes in f-space
%% get transfer function of spikes
if ~isempty(Fspike)
  [spf,spx,spind] = SimpleECDF(Fspike);
  
  %% make sure spx is stricty monotone 
  if ~min(diff(spx))
    fprintf('double points!!\n');
    keyboard;
  end
  
  spa = min(Fspike); spb = max(Fspike);
  nspf = (spb-spa)*spf+spa;
  %% get equally sized bins of nspf
  nspfbins = [min(nspf):(max(nspf)-min(nspf))/NumBin:max(nspf)];
  %% find the bins in f-space (project nspfbins onto spx
  spfbins(1) = spx(1);
  spfbins(length(nspfbins)) = spx(end);
  for m=2:length(nspfbins)-1
    [aa aainx] = sort(abs(nspf-nspfbins(m)));
    spfbins(m) = spx(aainx(1));
  end
  
  AdaBins = spfbins;
  
  %if ~isempty(Fspike)
  HFspike = histcI(Fspike,Bins)/mean(diff(Bins));
  AdaHFspike = histcI(Fspike,spfbins)./diff(spfbins');
else
  HFspike = zeros(NumBin,1);
  AdaHFspike = zeros(NumBin,1);
  AdaBins = Bins;
end

%% smooth histogram:
kern = gausswin(round(length(Bins)/Win),round(length(Bins)/Smoother));    
sHFspike = Filter0(kern/sum(kern),HFspike);

Adakern = gausswin(round(length(AdaBins)/Win),round(length(AdaBins)/Smoother/2));    
AdasHFspike = Filter0(Adakern/sum(Adakern),AdaHFspike);

%% KS-DENSITY
%[EFspike EFx] = ksdensity(Fspike);

%% Project bins back into original space:
scf = (b-a)*f+a;

[dummy2 iscf] = histcI(scf,Bins);
[dummy3 adaiscf] = histcI(scf,AdaBins);

for m=1:(length(Bins)-1)
  if ~isempty(find(iscf==m))
    newx(m) = mean(x(find(iscf==m)));
  else
    newx(m) = 0;
  end
end
for m=1:(length(AdaBins)-1)
  if ~isempty(find(adaiscf==m))
    adanewx(m) = mean(x(find(adaiscf==m)));
  else
    adanewx(m) = 0;
  end
end

%% OUTPUT
Rate = sHFspike;
AdaRate = AdasHFspike;
T = newx;
AdaT = adanewx;

return
