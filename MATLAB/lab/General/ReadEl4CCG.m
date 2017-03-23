% function [spiketime, spikeind, numclus, spikeph, ClustByEl,cID] = ReadEl4CCGLoc(fname,ellist)
% old function and not the most efficient .. wrote it when I knew little
% :)) ..so don't use it. Use LoadCluRes (written by Pascale with my small
% touches)
% reads spike timings of set of cells 'neurons' from fname.res and fname.clu
% writes a result as a cell array
% ClustByEl - contains electrode number and actual cluster index in the
% original nomenclature (i.e. as in clu file ..used by klusters)
function [spiket, spikeind, numclus, spikeph, ClustByEl, cID] = ReadEl4CCG(fname,ellist)

if nargin<2 | isempty(ellist)
    par=LoadPar([fname '.xml']);
    ellist=[1:par.nElecGps];
end

elnum=length(ellist);
resdata=cell(elnum,1);
cludata=cell(elnum,1);
clunum=zeros(elnum,1);

resfile = sprintf('%s.res.',fname);
clufile = sprintf('%s.clu.',fname);

for i=1:elnum
    k=ellist(i);
    if FileExists(strcat(resfile,num2str(k))) & FileExists(strcat(clufile,num2str(k)))
        resdata{i} = load(strcat(resfile,num2str(k)));
        cludatatmp = load(strcat(clufile,num2str(k)));
        cludata{i} = cludatatmp(2:end);
        uclu{i} = setdiff(unique(cludata{i}),[0 1]);
        clunum(i) = length(uclu{i});
    else
        clunum(i)=0;
    end
    if nargout>3 & FileExists([fname '.spkph.' num2str(k)])
        spkphdata{i}=load([fname '.spkph.' num2str(k)]);
    end
end
%eltimedata = cell(elnum,max(clunum));
spiket=[];
spikeind=[];
spikeph=[];
cnt=1;

ClustByEl =[];cID = [];
for i=1:elnum
    %    loc = load([fname '.uloc']);

    for j=1:clunum(i)
        realclui = uclu{i}(j);
        whichclu=find(eq(cludata{i},realclui));
        numspk=length(whichclu);
        eltimedata  = resdata{i}(whichclu);
        spiket=[spiket; eltimedata];
        spikeind=[spikeind;ones(numspk,1)*cnt];
        if nargout>3 & FileExists([fname '.spkph.' num2str(k)])
            spikeph = [spikeph; spkphdata{i}(whichclu)];
        end
        ClustByEl = cat(1,ClustByEl,[ellist(i) realclui]);
        if nargout>5
            cID(end+1) = CellID(fname, ellist(i), realclui); %generate unique cell ID based on file name, el num, and cluster number
        end
        cnt=cnt+1;
    end
end

numclus=cnt-1;
[spiket sortind] =sort(spiket);
spikeind = spikeind(sortind);
