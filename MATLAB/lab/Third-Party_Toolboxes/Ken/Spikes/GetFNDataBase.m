% [DataBase Groupage]= GetFNDataBase(MetaFile)
%
% extracts filenames from the list in MetaFile
%
% DataBase is standard DataBase format.
% Groupage is a cell array telling you which DataBase entries
% are clustered together (i.e. on the same line of MetaFile
%
% DON'T USE THIS INSTEAD OF GetAwakeDataBase!!!!!1

function [DataBase, Groupage] = GetFNDataBase(MetaFile)

if nargin<1
	MetaFile = '/u14/xaj/Analysis/Database/fndatabase';
end

MetaFp = fopen(MetaFile);

%EpochMap{1} = 'Theta';
%EpochMap{2} = 'Theta';

OldDirectory = '';
OldFileBase = '';
FileNo = 0;
GroupNo = 0;
while(1)
	% load in lines until you get one starting with /
	while(1)
		Line = fgets(MetaFp);

		% check end of file
		if (length(Line)>=3)
			First3 = Line(1:3);
		else
			First3 = 'XXX';
		end
		if (feof(MetaFp) | First3 == 'END')
			fclose(MetaFp);
			return;
		end

		% check against comments - only real lines begin with /
		if (Line(1) == '/')
			break;
		end
	end
	
	% get directory and filebase (MATLAB string handling SUCKS!)
	Words = SplitString(Line);
	Directory = Words{1};
	FileBases = {Words{5:2:end}};
	%
	% is it a new directory?
	if (~strcmp(Directory, OldDirectory) | ~all(strcmp(FileBases, OldFileBases)))
		OldDirectory = Directory;
		OldFileBases = FileBases;

		GroupNo = GroupNo+1;
		Groupage{GroupNo} = FileNo+1:FileNo+length(FileBases);

		for SubFile = 1:length(FileBases)
			FileNo = FileNo + 1;
			fb = FileBases{SubFile};
			
			DataBase(FileNo).Directory = [Directory '/' fb];
			DataBase(FileNo).FileBase = fb;
			DataBase(FileNo).Par = LoadPar([Directory '/' fb '/' fb '.par']);
			DataBase(FileNo).Epochs = [];
			DataBase(FileNo).Name = Directory(max(find(Directory == '/'))+1:end);
		
			% set up ElecGp sub-structures (1 for each tetrode)
		
			for ElecGpNo = 1:DataBase(FileNo).Par.nElecGps	
				% load .par.n file
				DataBase(FileNo).ElecGp(ElecGpNo).Par1 = ...
				LoadPar1([Directory '/' fb '/' fb '.par.' num2str(ElecGpNo)]);
			
				% set location to CA1
				DataBase(FileNo).ElecGp(ElecGpNo).Location = '1';
				
				% get n cells
				DataBase(FileNo).ElecGp(ElecGpNo).nCells = ...
					textread([Directory '/' fb '/' fb '.clu.' num2str(ElecGpNo)] ...
					, '%d', 1) -1;
					
			end
			
			% construct CellMap
			pos = 1;
			CellMap = [];
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
		
			% Get Epochs - do this later
%			DataBase(FileNo).Epochs = GetEpochs(Line);
			DataBase(FileNo).Epochs = {};
		
			% Get quality from file, if it exists
			if FileExists([Directory '/' fb '/' fb '.qual'])
			qFile = load([Directory '/' fb '/' fb '.qual']);
			else
				qFile = zeros(DataBase(FileNo).nCells, 2);
			end
		
			for CellNo = 1:DataBase(FileNo).nCells	
				DataBase(FileNo).Cell(CellNo).eDist = qFile(CellNo,1);
				DataBase(FileNo).Cell(CellNo).bRat = qFile(CellNo,2);	
			end
		
		end % of stuff to do for new directory
	end
	
	% extract cell information

	CellNo = sscanf(Line, '%*s %d') - 1; % subtract one because we are losing the noise cluster
	Type = sscanf(Line, '%*s %*d %s');
	
	% change 'i' to 'b' - WHY CAN'T HAJ AND JOSEF USE THE SAME CONVENTIONS!
	if (Type == 'i')
		Type = 'b';
	end
	
	SubType = 	sscanf(Line,'%*s %*d %*s %s');

	for i=Groupage{GroupNo}
		DataBase(i).Cell(CellNo).Type = Type;
		DataBase(i).Cell(CellNo).SubType = SubType;	
	end
end


%%%%%%%%%%%%%%% GetEpochs subfunction %%%%%%%%%%%%%%%%%%%%%%%
% Takes a line from the database file and outputs an array  %
% of Epoch structures describing the sleep-run-sleep, theta %
% and sharp-wave periods. Par is the parameter file.        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Epochs = GetEpochs(Line)
Directory = sscanf(Line, '%s %*s %*s %*s %*s %*s %*s %*s %*s %*s');
SubDir1 = sscanf(Line, '%*s %*s %*s %*s %s %*s %*s %*s %*s %*s');
SubDir2 = sscanf(Line, '%*s %*s %*s %*s %*s %*s %s %*s %*s %*s');
SubDir3 = sscanf(Line, '%*s %*s %*s %*s %*s %*s %*s %*s %s %*s');

EEGLen1 = FileLength([Directory '/' SubDir1 '/' SubDir1 '.eeg']);
Par{1} = LoadPar([Directory '/' SubDir1 '/' SubDir1 '.par']);
EEGLen2 = FileLength([Directory '/' SubDir2 '/' SubDir2 '.eeg']);
Par{2} = LoadPar([Directory '/' SubDir2 '/' SubDir2 '.par']);
EEGLen3 = FileLength([Directory '/' SubDir3 '/' SubDir3 '.eeg']);
Par{3} = LoadPar([Directory '/' SubDir3 '/' SubDir3 '.par']);

% determine epoch length from eeg files - sample rate 1250 Hz, 2 bytes per sample per channel
Sleep1End = EEGLen1 / (2*1250*Par{1}.nChannels);
RunEnd = Sleep1End + EEGLen2 / (2*1250*Par{2}.nChannels);
Sleep2End = RunEnd + EEGLen3 / (2*1250*Par{3}.nChannels);

Epochs(1).Type = 'Sleep1';
Epochs(1).Start = 0;
Epochs(1).End = Sleep1End;

Epochs(2).Type = 'Run';
Epochs(2).Start = Sleep1End;
Epochs(2).End = RunEnd;

Epochs(3).Type = 'Sleep2';
Epochs(3).Start = RunEnd;
Epochs(3).End = Sleep2End;

% now loop through info files and add epochs
% there are 9 - 3 subfiles and 3 types (the nthe sw)
Pos = 4; % where to write in Epochs array
for FileNo = 0:8
	% determine the start of the file name - i.e. which directory
	SubDirNo = 1+mod(FileNo,3);
	switch(SubDirNo)
		case 1
			FileBase = [Directory '/' SubDir1 '/' SubDir1];
			Offset = 0;
		case 2
			FileBase = [Directory '/' SubDir2 '/' SubDir2];
			Offset = Sleep1End;
		case 3
			FileBase = [Directory '/' SubDir3 '/' SubDir3];
			Offset = RunEnd;
	end
	
	% now determine which type of epochs to read in
	TypeNo = 1+floor(FileNo/3);
	switch(TypeNo)
		case 1
			FileName = [FileBase '.the'];
			Type = 'Theta';
		case 2
			FileName = [FileBase '.nthe'];
			Type = 'NonTheta';
		case 3
			FileName = [FileBase '.sw'];
			Type = 'Ripple';
	end
	
	% load it in and add epochs
	if FileExists(FileName)
		File = load(FileName);
	
		for i=1:size(File, 1)
			Epochs(Pos+i-1).Type = Type;
			Epochs(Pos+i-1).Start = Offset + File(i,1)*Par{SubDirNo}.SampleTime/1e6;
			Epochs(Pos+i-1).End = Offset + File(i,end)*Par{SubDirNo}.SampleTime/1e6;
		end
	
		Pos = Pos+size(File,1);
	end
end