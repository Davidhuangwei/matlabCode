% [CellIDs, CellNames, Info] = FindCells(db, QualThresh, Type, Description, InfoFields)
%
% finds cells in database db (e.g. 'extra')
% of quality at least QualThresh
% of type Type, from files with description Description.
%
% optional 2nd output CellNames gives a string describing the cell
% e.g. 'l23-01/n4.1.3' - last part of directory, filebase, tet no, clu no
%
% if you specify optional argument InfoFields (eg 'eDist, fRate') it will do an 
% SQL query to find these out for the cells, and return a struct containing
% cell arrays of strings (see mysql).

function [CellIDs, CellNames, Info] = FindCells(db, QualThresh, Type, Description, InfoFields)

Query = 'SELECT CellID';

if nargout>=2
    Query = [Query ', FileBase, GpNo, SmallCluNo' ];
end

Query = [Query ' FROM Cells, ElecGps, Files ' ...
	' WHERE Cells.ElecGpID=ElecGps.ElecGpID AND ElecGps.FileID = Files.FileID '];

if nargin>=2 & ~isempty(QualThresh)
	Query = sprintf('%s AND	Cells.eDist >= %f ', Query, QualThresh);
end

if nargin>=3 & ~isempty(Type)
	if iscell(Type)
		TypeList = ['''' Type{1} ''''];
		for i=2:length(Type)
			TypeList = sprintf('%s, ''%s''', TypeList, Type{i});
		end
	else
		TypeList = ['''' Type ''''];
	end

	Query = sprintf('%s AND Cells.Type IN (%s)', Query, TypeList);
end

if nargin>=4 & ~isempty(Description)
	if iscell(Description)
		DescriptionList = ['''' Description{1} ''''];
		for i=2:length(Description)
			DescriptionList = sprintf('%s, ''%s''', DescriptionList, Description{i});
		end
	else
		DescriptionList = ['''' Description ''''];
	end

	Query = sprintf('%s AND Files.Description IN (%s)', Query, DescriptionList);
end

Query = [Query ' ORDER BY CellID'];
qOut = mysql(Query, db);

if isempty(qOut)
	CellIDs = []; CellNames = {};
else
	CellIDs = str2double(qOut.CellID);
    if nargout>=2
        for i=1:length(CellIDs)
            FileBase = qOut.FileBase{i};
            Slashes = find(FileBase=='/');
            FileEnd = FileBase(Slashes(length(Slashes)-1)+1:end);
            CellNames{i} = [FileEnd '.' qOut.GpNo{i} '.' qOut.SmallCluNo{i}];
        end
    end
end

if nargin>=5
    CellIDStr = sprintf('%d,', CellIDs);
    CellIDStr = ['(' CellIDStr(1:length(CellIDStr)-1) ')'];
    InfoQuery = ['SELECT ' InfoFields ' FROM View WHERE CellID IN ' CellIDStr ...
            ' ORDER BY CellID'];
    Info = mysql(InfoQuery, 'extra');
end