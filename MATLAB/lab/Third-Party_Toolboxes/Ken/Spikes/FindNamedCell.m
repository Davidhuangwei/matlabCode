% CellIDs = FindNamedCells(FileBase, Clu, db);
%
% finds Cell ID's corresponding to cells specified by name.
% FileBase can be a single string or a cell array of strings
% NB it is used as an argument to a sql LIKE command so "%"
% is a wildcard - you can give things like %l21-02%
%
% Clu can be a single number or a column vector, specifying
% a cluster number in the overall .clu file.
% in the case that Clu has 2 columns, the first one gives a tetrode
% number and the second gives the clusted number in the .clu.n file.

function CellIDs = FindNamedCells(FileBase, Clu, db);

if nargin<3
	db = 'extra';
end

if iscell(FileBase)
	nCells = length(FileBase);
	if size(Clu,1)==1
		Clu = repmat(Clu, nCells, 1);
	elseif size(Clu, 1)~=nCells
		error('length of FileBase and Clu does not match!');
   end
else
	nCells = size(Clu,1);
	FileBase = cellstr(repmat(FileBase, nCells, 1));
end

for i=1:nCells
	if size(Clu,2)==1
		sql = sprintf(['SELECT CellID FROM View WHERE FileBase LIKE ''%s'' '...
			' AND BigCluNo = %d'], FileBase{i}, Clu(i));
    else
		sql = sprintf(['SELECT CellID FROM View WHERE FileBase LIKE ''%s'' '...
			' AND GpNo = %d AND SmallCluNo = %d'], ...
			FileBase{i}, Clu(i,1), Clu(i,2));
	end

    Out = mysql(sql, db, '%d');

    if isempty(Out)
        fprintf('%d %s.%d not in db\n', i, FileBase{i}, Clu(i));
        CellIDs(i) = -1;
    elseif length(Out)~=1
        fprintf('%s.%d: ', FileBase{i}, Clu(i));
		error(sprintf('Query returned %d arguments', length(Out)));
	else
		CellIDs(i) = Out;
	end
end