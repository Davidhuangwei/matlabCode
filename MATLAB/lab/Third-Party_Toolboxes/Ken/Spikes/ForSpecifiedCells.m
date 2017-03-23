% Out = ForSpecifiedCells(db, Cmd, Name, FileBase, CellNo, ChkFile)
% Iterate through specified cells in database db, executing command Cmd
%
% Name is a cell array of session names e.g. {'l23-01', 'l23-01', 'l21-02'}
% FileBase is a cell array of file bases e.g. {'n4', 's1s2', 'l21-02-031'}
% CellNo is an array of cell numbers for each file STARTING FROM 1
% (unlike .clu file which starts from 2) - e.g. [1 10 12]
%
% .res, .spk, .fet, .bclu, .whl, .theta and .eeg files will be loaded if used as arguments
% to Cmd as variables Res Spk Fet Bclu Whl Theta Eeg
% They will only be loaded off disk if they are somewhere in the string Cmd
%
% Res Spk Fet and Bclu will subsetted for the cell in question
% - that's why the .clu file is not passed.  BigClu and BigRes are non-subsetted
%
% Also available as possible arguments are
% db (database, as passed in input),
% F (file structure for this file, i.e. db(FileNo)
% CluNo (value of this cell in .clu.n file)
% BigCluNo (value of this cell in .clu file)
% ElecGpNo (i.e. which tetrode this cell was found on)
% FileNo (which file within database db this cell is in)
% Par (.par file structure pertaining to this cell)
% Par1 (.par.n file structure pertaining to this cell)
% Cell (= F.Cell(BigCluNo-1), but saves time)
% MaxRes (maximum spike time for any cell in this file)
%
% The function called should return a single structure
% The output argument of this function  is a structure array with one entry
% for every cell for which the function was called
%
% ChkFile (optional) specifies a name of a checkpoint file.  After doing every cell, it will 
% save to this file.  If something crashes, it will read from the file and start up where it left off.
%
% if only 2 arguments are passed, the command will be run for all cells in the db

function Out = ForSpecifiedCells(db, Cmd, Name, FileBase, CellNo, ChkFile)

% check inputs
if nargin==2
    % make Name, FileBase, and CellNo everything
    Name = {};
    FileBase = {};
    CellNo = [];
    for F = db 
        n = length(F.Cell); % number of cells in this file
        Name = horzcat(Name, cellstr(repmat(F.Name,n,1))');
        FileBase = horzcat(FileBase, cellstr(repmat(F.FileBase,n,1))');
        CellNo = [CellNo, 1:n];
    end
elseif nargin<5
	error('Usage: Out = ForSpecifiedCells(db, Cmd, Name, FileBase, CellNo)');
end

nCells = length(CellNo);

% see if checkpoint file has been loaded, make sure it is .mat
if nargin<6
    ChkFile = '';
else
    if isempty(findstr(ChkFile, '.mat'))
        ChkFile = [ChkFile, '.mat'];
    end
end

% load checkpoint file
if FileExists(ChkFile)
    fprintf('Loading checkpoint file %s\n', ChkFile);
    Chk = load(ChkFile);
    if ~(isequal(Chk.Name, Name) & isequal(Chk.FileBase, FileBase) & ...
            isequal(Chk.CellNo, CellNo) & isequal(Chk.db, db))
        error('Saved checkpoint file does not match arguments');
    end        
    % mark those which have already been done
    Done = Chk.Done;
    Out = Chk.Out;
else
    Done = zeros(1, nCells);
end

% if they just supplied one name, replicate it for each cell
if (isstr(Name))
	Name = cellstr(repmat(Name, nCells, 1));
elseif length(Name)~=nCells
	error('Name should be a cell array of same length as CellNo');
end

% if they just supplied one FileBase, replicate it for each cell
if (isstr(FileBase))
	FileBase = cellstr(repmat(FileBase, nCells, 1));
elseif length(FileBase)~=nCells
	error('FileBase should be a cell array of same length as CellNo');
end

% find out which stuff needs to be loaded
Arg = Cmd(min(find(Cmd=='(')):max(find(Cmd==')')));
NeedRes = ~isempty(findstr('Res', Arg));
NeedSpk = ~isempty(findstr('Spk', Arg));
NeedFet = ~isempty(findstr('Fet', Arg));
NeedBclu = ~isempty(findstr('Bclu', Arg));
NeedWhl = ~isempty(findstr('Whl', Arg));
NeedTheta = ~isempty(findstr('Theta', Arg));
NeedEeg = ~isempty(findstr('Eeg', Arg));

for FileNo = 1:length(db)
	F = db(FileNo);
	Par = F.Par;
	
	% which cells do we need this file?
    FileCells = find(strcmp(Name, F.Name) & strcmp(FileBase, F.FileBase) &~Done);
    
	if ~isempty(FileCells)		
        
        % load what needs to be loaded

		if NeedWhl
			Whl = load([F.Directory '/' F.FileBase '.whl']);
		end
		
		if NeedTheta
			Theta = load([F.Directory '/' F.FileBase '.theta']);
		end
		
		if NeedEeg
			Eeg = bload([F.Directory '/' F.FileBase '.eeg'], [Par.nChannels inf]);
		end
		
		if NeedBclu
			BigBclu = LoadClu([F.Directory '/' F.FileBase '.bclu']);
		end
		
		% .clu and .res file is always loaded
		BigClu = LoadClu([F.Directory '/' F.FileBase '.clu']);
	    BigRes = load([F.Directory '/' F.FileBase '.res']);
        
		for ElecGpNo = 1:length(F.ElecGp) % loop through electrode groups
		
			% find cells of this electrode group
            RightGroup = (F.CellMap(CellNo(FileCells), 1) == ElecGpNo);
            GroupCells = FileCells(find(RightGroup)); % position in output array to write to
            
			if ~isempty(GroupCells)		
				fprintf('Loading %s.%s tet %d...\n', F.Name, F.FileBase, ElecGpNo);
			
				Par1 = F.ElecGp(ElecGpNo).Par1;
			
				if NeedRes
					AllRes = load([F.Directory '/' F.FileBase '.res.' num2str(ElecGpNo)]);
                    MaxRes = max(AllRes);
				end

				if NeedFet
					AllFet = LoadFet([F.Directory '/' F.FileBase '.fet.' num2str(ElecGpNo)]);
				end

				if NeedSpk
					AllSpk = LoadSpk([F.Directory '/' F.FileBase '.spk.' num2str(ElecGpNo)], Par1.nSelectedChannels, Par1.WaveSamples);
				end
			
				Clu = LoadClu([F.Directory '/' F.FileBase '.clu.' num2str(ElecGpNo)]);
				
				for SpecifiedCell = GroupCells % loop through cells
	
					% get cluster number
					CluNo = F.CellMap(CellNo(SpecifiedCell),2);
					BigCluNo = CellNo(SpecifiedCell)+1;
					Cell = F.Cell(BigCluNo-1); % for passing to cmd, if they want it

fprintf('%s.%s.%d is gp %d clu %d, qual %f\n', F.Name, F.FileBase,CellNo(SpecifiedCell), ElecGpNo, CluNo, Cell.eDist);
					MySpikes = find(Clu==CluNo);
					BigMySpikes = find(BigClu==BigCluNo);
					nMySpikes = length(MySpikes);
					% sanity check - it gets a bit confusing with all the .clu's and .clu.n's
					if (length(BigMySpikes) ~= nMySpikes)
						error('.clu and .clu.n files do not match!!!\n');
					end
				
					if (NeedRes), Res = AllRes(MySpikes); end
					if (NeedFet), Fet = AllFet(MySpikes, :); end;
					if (NeedSpk), Spk = AllSpk(:,:,MySpikes); end;
					if (NeedBclu), Bclu = BigBclu(BigMySpikes); end;
			
					% And here's the part you've been waiting for ....

                    RetVal = eval(Cmd);
                    if ~isempty(RetVal)
    					Out(SpecifiedCell) = RetVal;
                    end
                                        
                    % mark it as done, and save checkpoint file if required
                    Done(SpecifiedCell) = 1;
                    if ChkFile
                        save(ChkFile, 'Out', 'Done', 'db', 'Name', 'FileBase', 'CellNo');
                    end
                      

                    
		
				end
			end
		end
	end
end