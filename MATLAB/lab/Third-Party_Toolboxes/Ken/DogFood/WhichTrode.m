% [Trode, SubClu] = WhichTrode(FileBase, CluNo)
%
% a quick script that computes which tetrode
% and which cluster within the .clu.n file
% a given cell belongs to, from its cluster no.
% in the .clu file.

function [Trode, SubClu] = WhichTrode(FileBase, CellNo)

Par = LoadPar([FileBase '.par']);

for e=1:Par.nElecGps
	[dummy out] = system(sprintf('head -q -n 1 %s.clu.%d',FileBase,e));
    nCells(e) = str2num(out)-1;
end

c = 2;
for e=1:Par.nElecGps
    if CellNo>=c & CellNo<c+nCells(e)
        MyTrode = e;
        MySubClu = CellNo-c+2;
        break
    end
    c=c+nCells(e);
end

if nargout==0
    fprintf('It''s cell %d on trode %d\n', MySubClu,MyTrode);
else
    Trode = MyTrode;
    SubClu = MySubClu;
end
       