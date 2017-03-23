function [xx, nbin] = Binning(x,b,bin)
%% 
%% function Binning(x,b)
%%
%% data x is binned in bins with width b


%% pad x with zeroes
nx = zeros(b*ceil(length(x)/b),1);
nx(1:length(x)) = x;
rnx = reshape(nx,b,length(nx)/b)';

xx = sum(rnx,2);

%nbin = [min(bin):mean(diff(bin))*b:max(bin)+(length(nx)-length(x))]+mean(diff(bin))*b/2;
%nbin = [min(bin) : mean(diff(bin))*b : max(bin)+(length(nx)-length(x))]+mean(diff(bin))*b/2;
nbin = [1:length(xx)];

return;





%% find good number of bins

%% -- 2n+1 bins IF odd
%% -- 2n bins IF even
%% -> 2n difference between old and new bin 

%nb = length(x);
%nbin = 



%% defind new bins

%% pad orig. data with zeroes

%% sum

