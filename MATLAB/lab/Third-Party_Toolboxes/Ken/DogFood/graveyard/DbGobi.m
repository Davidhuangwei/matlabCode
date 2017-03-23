function [xg, Labels, Type] = DbGobi(db)
%  [xg, Labels, Type] = DbGobi(db)
% takes a db structure and does an xgobi process with lots of
% summary information about the database (quality, firing rate, etc)
% 
% optional output arguments capture data to send to xgobi, without plotting it.

[Name FileBase SpecifiedCells] = FindGoodCells(db);

Cells = [db.Cell];
CellMap = vertcat(db.CellMap);

% make info ...
Info = load('/u5/b/ken/multicell/AllInfo.mat', 'Out') ;
sm = 1.5.^(2:15)*91/255;
b = {Info.Out.BitsPerSec};
for i=1:length(b)
	[SpaceInfo(i) pos] = max(mean(b{i}));
    BestSmooth(i) = sm(pos);
end

% xg is a structure array containing data to plot

xg.ElecGp = CellMap(:,1)';
xg.Clu = CellMap(:,2)';
xg.eDist = [Cells.eDist];
xg.bRat = [Cells.bRat];
xg.BitsPerSec = SpaceInfo;
xg.BestSmooth = BestSmooth;

% sort cells by file
[FileID i j] = unique(strcat(Name, '.', FileBase));
xg.FileID = j;
nPerFile = histc(j,1:max(j));
xg.nPerFile = nPerFile(j);

Out = ForSpecifiedCells(db, 'struct(''fr'', 20000*length(Res)/MaxRes, ''bf'', sum(diff(Res)<20*6)/length(Res))');
xg.fRate = [Out.fr];
xg.ShortFrac = [Out.bf];

xg.BitsPerSpike = SpaceInfo./xg.fRate;

Type = [Cells.Type];

Colors = ones(length(Cells),1);
Colors(find(Type=='p')) = 2;
Colors(find(Type=='b')) = 5;
Colors(find(Type=='u')) = 8;

Labels = strcat(Name', '.', FileBase', '.', num2str(CellMap(:,1)), '.', num2str(CellMap(:,2)));

xgobi(xg, Type, 11, Labels);

if nargout==0
    clear xg Labels Type
end