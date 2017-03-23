% function spike_timing = readNunit(fname,neurons)
% 
% reads spike timings of set of cells 'neurons' from fname.res and fname.clu
% writes a result as a cell array 

function [spiket] = readNunit(fname,neurons)

resfile = sprintf('%s.res',fname);
clufile = sprintf('%s.clu',fname);
resdata = load(resfile);
cludata = load(clufile);
nnum=length(neurons);
timedata = cell(1,nnum);

for i=1:nnum,
   timedata{i}  = resdata(find(eq(cludata(2:length(cludata)),neurons(i))));
end
spiket = timedata;
clear timedata;



