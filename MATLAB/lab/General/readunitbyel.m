% function spike_timing = readunitbyel(fname,ellist)
% 
% reads spike timings of set of cells 'neurons' from fname.res and fname.clu
% writes a result as a cell array 
function spiket= readunitbyel(fname,ellist)

elnum=length(ellist);
resdata=cell(elnum,1);
cludata=cell(elnum,1);
clunum=zeros(elnum,1);

for i=1:elnum
    k=ellist(i);
    resfile = sprintf('%s.res.',fname);
    clufile = sprintf('%s.clu.',fname);
    resdata{i} = load(strcat(resfile,num2str(k)));
    cludatatmp = load(strcat(clufile,num2str(k)));
    clunum(i) = cludatatmp(1);
    cludata{i} = cludatatmp(2:end);
end
eltimedata = cell(elnum,max(clunum));
    
for i=1:elnum
    for j=2:clunum(i)
       eltimedata{i,j}  = resdata{i}(find(eq(cludata{i},j)));
   end
end

spiket = eltimedata;
numclus=clunum;
clear eltimedata;



