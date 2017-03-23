% DataBase = GetJosefDataBase
%
% extracts filenames from the list in MetaFile

function DataBase = GetJosefDataBase(BaseDir)

if nargin<1
	BaseDir = '/u5/b/ken/Linkz/dbase';
end

MetaFp = fopen([BaseDir '/prfiles'], 'r');

FileNo = 0;
while(1)
	% load in next line
	Line = fgets(MetaFp)
		
	% check end of file
	if (feof(MetaFp))
		fclose(MetaFp);
		return;
	end

	Directory = [BaseDir '/' strtok(Line)]; 
	FileNo = FileNo + 1;
	DataBase(FileNo).Directory = Directory;
	FileBase = strtok(Line); 
	DataBase(FileNo).FileBase = FileBase;
	DataBase(FileNo).Name = FileBase; % for josef files, name = filebase
	DataBase(FileNo).Par = LoadPar([Directory '/' FileBase '.par']);
	
	% concatenate them for final Epochs structure
	DataBase(FileNo).Epochs = GetEpochs([Directory '/' FileBase], ...
		1e6/DataBase(FileNo).Par.SampleTime);
	
	% set up ElecGp sub-structures (1 for each tetrode)
	
	BigCellNo = 2; % this is used to count cells in the overall .clu file
	for ElecGpNo = 1:DataBase(FileNo).Par.nElecGps	
		% load .par.n file
		DataBase(FileNo).ElecGp(ElecGpNo).Par1 = ...
			LoadPar1([Directory '/' FileBase '.par.' num2str(ElecGpNo)]);
		
		% set location to '' - so it can be changed later by the .des file
		DataBase(FileNo).ElecGp(ElecGpNo).Location = '';
		
		% get n cells
		DataBase(FileNo).ElecGp(ElecGpNo).nCells = ...
			textread([Directory '/' FileBase '.clu.' num2str(ElecGpNo)] ...
			, '%d', 1) -1;
	end
	
	% construct CellMap
	pos = 1;
	for ElecGpNo = 1:DataBase(FileNo).Par.nElecGps	
		nc = DataBase(FileNo).ElecGp(ElecGpNo).nCells;
		if (nc>0) 
			DataBase(FileNo).ElecGp(ElecGpNo).FirstCell = pos;
		end
		CellMap(pos:pos+nc-1,1) = ElecGpNo; % set to this electrode group
		CellMap(pos:pos+nc-1,2) = (2:nc+1)'; % set cluster no to 2...n
		pos = pos+nc;
	end
	DataBase(FileNo).CellMap = CellMap;
	DataBase(FileNo).nCells = pos-1;
			
	% extract cell information from .des file
	Des = LoadStringList([Directory '/' FileBase '.des']);
	for CellNo = 1:(DataBase(FileNo).nCells) % this is cell number NOT counting the noise cluster
		Type = Des{CellNo}(1);
		Location = Des{CellNo}(2);
		SubType = Des{CellNo}(3:end);
		
		% check location is the same as for previous cells on this tetrode
		ElecGpNo = CellMap(CellNo,1);
		if isempty(DataBase(FileNo).ElecGp(ElecGpNo).Location) % if this is the first cell on this electrode
			DataBase(FileNo).ElecGp(ElecGpNo).Location = Location;
		elseif Location~=DataBase(FileNo).ElecGp(ElecGpNo).Location
			warning(sprintf('Elec %d location mismatch for cell %d', ElecGpNo, CellMap(CellNo,2)));
		end
	
		DataBase(FileNo).Cell(CellNo).Type = Type;
		DataBase(FileNo).Cell(CellNo).SubType = SubType;	
			
	end
	
	% load .qual file if it exists
	if FileExists([Directory '/' FileBase '.qual'])
		qFile = load([Directory '/' FileBase '.qual']);
	else
		qFile = zeros(DataBase(FileNo).nCells, 2);
	end
	
	for CellNo = 1:DataBase(FileNo).nCells	
		DataBase(FileNo).Cell(CellNo).eDist = qFile(CellNo,1);
		DataBase(FileNo).Cell(CellNo).bRat = qFile(CellNo,2);	
	end


end

% subfunction to load up epochs - argument is [Directory '/' FileBase];
% and SampleRate (in Hz)
function Epochs = GetEpochs(Base, SampleRate)

Epochs = [];
Pos = 1; % where to write in epoch file
% loop thru types
for eType = {'sw', 'nsw', 'ssw', 'rem'}
	
	% load epoch files - careful! .rem you look at different columns!
	
	fName = [Base, '.', char(eType)];
	if FileExists(fName)
		eFile = load(fName);
		for i=1:size(eFile,1);
			Epochs(Pos+i-1).Type = char(eType);
			Epochs(Pos+i-1).Start = eFile(i,1) / SampleRate;
			% watch out for REM - end is column two
			if strcmp(eType, 'rem')
				Epochs(Pos+i-1).End = eFile(i,2) / SampleRate;
			else
				Epochs(Pos+i-1).End = eFile(i,3) / SampleRate;
			end
		end
		Pos = Pos + size(eFile,1);
	end
end