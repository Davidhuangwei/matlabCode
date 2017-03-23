% function [spiket, spiekind, numclus] = ReadEl4CCGLoc(fname,ellist)
% reads spike timings of set of cells 'neurons' from fname.res and fname.clu
% writes a result as a cell array 
function [spiket, spikeind, numclus, ClustByEl] = ReadEl4CCG(fname,ellist)

if nargin<2 | isempty(ellist)
    par=LoadPar([fname '.par']);
    ellist=[1:par.nElecGps];
end

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
%eltimedata = cell(elnum,max(clunum));
spiket=[];
spikeind=[];
cnt=1;

ClustByEl =[];
for i=1:elnum
    loc = load([fname '.uloc']);

    for j=2:clunum(i)
        whichclu=find(eq(cludata{i},j));
        numspk=length(whichclu);
       eltimedata  = resdata{i}(whichclu);
       spiket=[spiket; eltimedata];
       spikeind=[spikeind;ones(numspk,1)*loc(j)];
       ClustByEl(end+1) = ellist(i);
       cnt=cnt+1;
    end
end

numclus=cnt-1;
