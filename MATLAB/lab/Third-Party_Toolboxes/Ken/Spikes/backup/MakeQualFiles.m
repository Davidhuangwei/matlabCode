% MakeQualFiles(Description, db)
% goes through the files of database db, matching Description, and makes .qual files
% - these have one line for all clusters, starting from 2

function MakeQualFiles(Description, db)

if nargin<2
    db = 'extra';
end

% get all cells
if nargin<1 | isempty(Description)
    qOut = mysql(['SELECT FileBase, CellID FROM Files, ElecGps, Cells ' ...
        'WHERE Files.FileID=ElecGps.FileID AND ElecGps.ElecGpID = Cells.ElecGpID ' ...
        'ORDER BY Cells.CellID;'], db);
else       
    qOut = mysql(['SELECT FileBase, CellID FROM Files, ElecGps, Cells ' ...
        'WHERE Files.FileID=ElecGps.FileID AND ElecGps.ElecGpID = Cells.ElecGpID AND Description= ''' Description ''' ' ...
        ' ORDER BY Cells.CellID;'], db);
end
CellIDs = str2double(qOut.CellID);
FileBases = qOut.FileBase;

% do calculation
ChkFile = ['/tmp/' Description 'Chk.mat'];
Out = ForCells(CellIDs, 'MakeQualFiles2(SmallRes, SmallClu, SmallCluNo, SmallFet, Par1)', ChkFile, db);

% now make qual files
QualArray = [[Out.eDist]', [Out.bRat]', [Out.fRate]'];
uFileBases = unique(FileBases);
for i = 1:length(uFileBases)
    FileBase = uFileBases{i};
    FileCells = find(strcmp(FileBases, FileBase));
    msave([FileBase '.qual'], QualArray(FileCells,:));
end

% now update database
sql = sprintf('UPDATE Cells SET eDist = %f, bRat = %f, fRate = %f WHERE CellID = %d;\n', ...
    [QualArray, CellIDs]');

mysql(sql, db);
%keyboard

return

%OutFp = fopen('dbase.qual', 'w');

for File = DataBase
	% extract filebase
	FileBase = [File.Directory, '/', File.FileBase];
	
	Par = File.Par;
	for ElecNo = 1:(Par.nElecGps)
		Par1 = LoadPar1([FileBase, '.par.', num2str(ElecNo)])
		Fet = LoadFet([FileBase, '.fet.', num2str(ElecNo)]);
		Clu = LoadClu([FileBase, '.clu.', num2str(ElecNo)]);
		Res = load([FileBase, '.res.', num2str(ElecNo)]);
		fprintf('done loading\n');
		
		nClusters = max(Clu);
		nSpikes = length(Clu);
		nFet = Par1.nSelectedChannels * Par1.nPCs;
				
		for c=2:nClusters
			fprintf('\ndoing cluster %d...', c);
			% find spikes in this clustr and calculate mahal dist
			MySpikes = find(Clu==c);
			nMySpikes = length(MySpikes);
			[HalfDist, WorstBurstRat, WorstBurstRatAt] = ClusterQuality(Fet(:,1:nFet), MySpikes, Res, BurstTimeWin);

			CellCount = File.ElecGp(ElecNo).FirstCell+c-2; % overall cell number
			CellType = File.Cell(CellCount).Type;
%			fprintf('%s.%d cell %d type %s nSpikes %d EqDist %f Worst bRat %f at %f\n', ...
%			fprintf(OutFp, '%s.%d cell %d type %s nSpikes %d EqDist %f Worst bRat %f at %f\n', ...
%				FileBase, ElecNo, c, CellType,...
%				nMySpikes, HalfDist, WorstBurstRat, WorstBurstRatAt);
			
			% Keep track of qualities so you can write them to a file
			eDist(CellCount) = 	HalfDist;
			bRat(CellCount) = WorstBurstRat;
		end
	end
	
	% write quality file
	msave([FileBase, '.qual'], [eDist' , bRat']);
end
