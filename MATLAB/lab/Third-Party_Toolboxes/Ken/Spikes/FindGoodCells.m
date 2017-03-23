% [Name, FileBase, CellNo] = FindGoodCells(db, QualThresh, Type);
%
% Finds cells from a database that have a good enough quality (isolation
% distance), and are of the specified type.  The last 2 inputs are optional.
% if not specified it will return all cells
%
% The first 3 output variables are in the format required by ForSpecifiedCells.
% The Index output gives the overall cell number within db for the specified cells

function [Name, FileBase, CellNo, Index] = FindGoodCells(db, QualThresh, Type);

if nargin<2, QualThresh = 0; end;
if nargin<3, Type = ''; end;

nCells = 0;
OverallNo = 0;

for FileNo = 1:length(db)
	F = db(FileNo);
	
	% find good cells
	if isempty(Type)
		GoodCells = find([F.Cell.eDist] >= QualThresh);
	else
		GoodCells = find([F.Cell.eDist] >= QualThresh & strcmp({F.Cell.Type}, Type));
	end
	
	% add to output
	nGood = length(GoodCells);
	if nGood>0
		[Name{nCells + (1:nGood)}] = deal(F.Name);
		[FileBase{nCells + (1:nGood)}] = deal(F.FileBase);
		CellNo(nCells + (1:nGood)) = GoodCells;
        Index(nCells + (1:nGood)) = OverallNo+GoodCells;
		nCells = nCells + nGood;
	end
    
    OverallNo = OverallNo + F.nCells;
end