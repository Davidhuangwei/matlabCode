% Out = ForAllCells(db, Cmd, QualThresh, Type)
% Iterate through all cells in database db, executing command Cmd
%
% .res, .spk, .fet, .bclu, .whl, and .eeg files will be loaded if used as arguments
% to Cmd as variables Res Spk Fet Bclu Whl Eeg
% They will only be loaded off disk if they are somewhere in the string Cmd
%
% Res Spk Fet and Bclu will be only for the cell in question
% - that's why the .clu file is not passed
%
% Also available as possible arguments are
% db (database, as passed in input),
% F (file structure for this file, i.e. db(FileNo)
% CellNo (value of this cell in .clu.n file -1)
% BigCellNo (value of this cell in .clu file -1)
% ElecGpNo (i.e. which tetrode this cell was found on)
% FileNo (which file within database db this cell is in)
% Par (.par file structure pertaining to this cell)
% Par1 (.par.n file structure pertaining to this cell)
%
% Optional arguments QualThresh and Type restrict to only cells of at least that
% isolation quality (eDist) and of the specified type
%
% Output argument Out is a cell array with one entry for every
% cell for which the function was called

function Out = ForAllCells(db, Cmd, QualThresh, Type)

if nargin<3, QualThresh = 0; end
if nargin<4, Type = ''; end;

NeedRes = ~isempty(findstr('Res', Cmd));
NeedSpk = ~isempty(findstr('Spk', Cmd));
NeedFet = ~isempty(findstr('Fet', Cmd));
NeedBclu = ~isempty(findstr('Bclu', Cmd));
NeedWhl = ~isempty(findstr('Whl', Cmd));
NeedEeg = ~isempty(findstr('Eeg', Cmd));

OutCount = 1;

for FileNo = 1:length(db)
	F = db(FileNo);
	Par = F.Par;
	
	if NeedWhl
		Whl = load([F.Directory '/' F.FileBase '.whl']);
	end
	
	if NeedEeg
		Eeg = bload([F.Directory '/' F.FileBase '.eeg'], [Par.nChannels inf]);
	end
	
	if NeedBclu
		BigBclu = LoadClu([F.Directory '/' F.FileBase '.bclu']);
	end
	
	% .clu file is always loaded
	BigClu = LoadClu([F.Directory '/' F.FileBase '.clu']);

	for ElecGpNo = 1:length(F.ElecGp) % loop through electrode groups
	
%		fprintf('%s.%s tet %d\n', F.Name, F.FileBase, ElecGpNo);
		
		% get cells for this trode
		if F.ElecGp(ElecGpNo).nCells > 0
			CellNos = F.ElecGp(ElecGpNo).FirstCell + (1:F.ElecGp(ElecGpNo).nCells) - 1;
		else
			CellNos = [];
		end
		
		% get cells of requisite quality and type
		if isempty(Type)
			CellsToDo = find([F.Cell(CellNos).eDist] >= QualThresh);
		else
			CellsToDo = find([F.Cell(CellNos).eDist] >= QualThresh & ...
						strcmp({F.Cell(CellNos).Type}, Type));
		end

		if ~isempty(CellsToDo)		
			Par1 = F.ElecGp(ElecGpNo).Par1;
		
			if NeedRes
				AllRes = load([F.Directory '/' F.FileBase '.res.' num2str(ElecGpNo)]);
			end
		
			if NeedFet
				AllFet = LoadFet([F.Directory '/' F.FileBase '.fet.' num2str(ElecGpNo)]);
			end
		
			if NeedSpk
				AllSpk = LoadSpk([F.Directory '/' F.FileBase '.spk.' num2str(ElecGpNo)], Par1.nSelectedChannels, Par1.WaveSamples);
			end
		
			Clu = LoadClu([F.Directory '/' F.FileBase '.clu.' num2str(ElecGpNo)]);
	
		end
			
		for CellNo = CellsToDo % loop through cells

			% compute cell number for overall file
			BigCellNo = CellNo + F.ElecGp(ElecGpNo).FirstCell - 1;

					
			MySpikes = find(Clu==CellNo+1);
			BigMySpikes = find(BigClu==BigCellNo+1);
			nMySpikes = length(MySpikes);
			if (length(BigMySpikes) ~= nMySpikes)
				error('.clu and .clu.n files do not match!!!\n');
			end
			
			if (NeedRes), Res = AllRes(MySpikes); end
			if (NeedFet), Fet = AllFet(MySpikes, :); end;
			if (NeedSpk), Spk = AllSpk(:,:,MySpikes); end;
			if (NeedBclu), Bclu = BigBclu(BigMySpikes); end;
			
			% And here's the part you've been waiting for ....
%fprintf('%s.%s.%d\n', F.Name, F.FileBase, BigCellNo);
			
			Out{OutCount} = eval(Cmd);			
			OutCount = OutCount+1;
	
		end
	end
end
