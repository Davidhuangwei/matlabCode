function [GoodSPc GoodSPa] = GoodSpect(SP,f,varargin)
%% function GoodCells = GoodSpect(SP,f,type,varargin)
%% [dummy] = DefaultArgs(varargin,{[]});
%% 
%% find good spectra: theta peak has to exceed background by cutoff*std
%%
%%
%% IN:
%%   SP   : spectra matrix f x cells
%%   f    : frequecy vector
%%   type : vector or numpers according to cell type
%% 
%% optional:
%%   freq   : frequency range to detect max power (default [5 10])
%%   cutoff : mean power must be larger than cutoff x std + mean (default 3)
%%
%% OUT:
%%    GoodSPc{n} : cellarray of good spectra for each cell type
%%    GoodSPa    : actual numbers of the theta ration
%%   
[frin,frout,cutoff,PLOT,type] = DefaultArgs(varargin,{[5 11],[1 5; 11 15],1,0,[]});

if ~isempty(type)
  celltypes = unique(type);
else
  type = ones(size(SP,2));
  celltypes = 1;
end
  
thfin = find(WithinRanges(f,frin));
thfout = find(WithinRanges(f,frout));

spin = log(mean(SP(thfin,:),1));
spout = log(mean(SP(thfout,:),1));
spoutstd = log(mean(SP(thfout,:),1)+cutoff*std(SP(thfout,:),1));

%% theta ration - convert back with exp!
thratio = spin-spoutstd;
GoodSPa = exp(thratio);

%% Good spect: exp(thratio)>1!
for n=celltypes'
  ix = type==n & GoodSPa'>1;
  GoodSPc{n} = find(ix);
end

%if PLOT
%
%  m=0;
%  for n=celltypes
%    m=m+1;
%    subplot(length(celltypes),1,m)
%    imagesc(f,[],unity(SP(:,GoodSP{n}))')
%    axis xy
%    %Lines(SP.feeg,[],'k','--',2)
%  end
%end


return;
