function [GoodSPc GoodSPa] = GoodSpect2(SP,f,varargin)
%% function GoodCells = GoodSpect(SP,f,type,varargin)
%% [dummy] = DefaultArgs(varargin,{[]});
%% 
%% find good spectra: theta peak has to exceed background by 3*std
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
%%    GoodSPc{n} : cellaray of good spectra for each cell type
%%    GoodSPa    : 
%%   
[type,freq,cutoff,PLOT] = DefaultArgs(varargin,{[],[5 10],3,0});

if ~isempty(type)
  celltypes = unique(type);
else
  type = ones(size(SP,2));
  celltypes = 1;
end
  
gf = (f>freq(1) & f<freq(2));

%% mean and std of spectrum OUTSIDE theta band 
MSpectU = mean(SP(~gf,:));
STDSpectU = std(SP(~gf,:));

%% maximum power INSIDE theta band
[MaxSpU MI] = max(SP(gf,:));

%% Good spectra
GoodSPa = (MaxSpU > (MSpectU + cutoff*STDSpectU))';

for n=celltypes'
  ix = type==n & GoodSPa;
  GoodSPc{n} = find(ix);
end


if PLOT

  m=0;
  for n=celltypes
    m=m+1;
    subplot(length(celltypes),1,m)
    imagesc(f,[],unity(SP(:,GoodSP{n}))')
    axis xy
    %Lines(SP.feeg,[],'k','--',2)
  end
end

keyboard

return;


%%%%%% diffrent:

fin = [5 11];
fout = [1 5; 11 15];
thfin = find(WithinRanges(f,fin));
thfout = find(WithinRanges(f,fout));

thratio = log(mean(SP(thfin,:),1))-log(mean(SP(thfout,:),1));

[so si] = sort(thratio);

imagesc(SP(:,si));