% Out = ForCells(CellIDs, Cmd, ChkFile, db, FileCmd, GpCmd)
% Iterate through specified cells in database db, executing command Cmd
%
% db is name of SQL database containing the cell info (default 'extra')
%
% .res, .spk, .spku, .fet, .whl, .theta .eeg .eeg.0 .spkph or .thph files will be loaded
% if used as arguments to Cmd as variables Res Spk Spku Fet Whl Theta Eeg Eeg0 ThPh The Gam
% ThPh (instantaneous Hilbert transform phase) will be converted to radians.
% 
% They will only be loaded off disk if they are somewhere in the string Cmd
% but Eeg and Eeg0 cannot both be loaded.
%
% Res Spk and Fet will subsetted for the cell in question
% BigClu and BigRes are non-subsetted .clu and .res file
% SmallClu and SmallRes are non-subsetted .clu.n and .res.n files
% AllFet and AllSpk are non-subsetted .fet.n and .spk.n files
%
% Also available as possible arguments are
% SmallCluNo (value of this cell in .clu.n file)
% BigCluNo (value of this cell in .clu file)
% ElecGpNo (i.e. which tetrode this cell was found on)
% Par (.par file structure pertaining to this cell)
% Par1 (.par.n file structure pertaining to this cell)
% MaxRes (maximum spike time for any cell in this file)
% FileBase (string name of the file)
% Epochs (read from database)
% nSamples (length of file, computed from size of .eeg file)
%
% The function called should return a single structure
% The output argument of this function is a structure array with one entry
% for every cell for which the function was called.
% NB it is possible for the function to return [], in which case
% the corresponding element of the output array will be empty.
%
% ChkFile (optional) specifies a name of a checkpoint file.  After doing 
% every cell, it will save to this file.  If something crashes, it will 
% read from the file and start up where it left off.
%
% Optional arguments FileCmd and GpCmd are commands which are executed after
% each File and ElecGp are loaded.  For example if FileCmd is 
% 'ThPh=ThetaPhase(Eeg0)' it will save you from recalculating the theta 
% phase for every cell (of course you could load the .thph file ...)

function Out = ForCells(CellIDs, Cmd, ChkFile, db, FileCmd, GpCmd)


% make column vector
CellIDs = CellIDs(:);

% check inputs
nCells = length(CellIDs);
if nCells==0
    warning('No Cells specified!');
    Out = [];
    return
end


% see if checkpoint file has been loaded, make sure it is .mat
if nargin<3 | isempty(ChkFile)
    ChkFile = '';
elseif isempty(findstr(ChkFile, '.mat'))
    ChkFile = [ChkFile, '.mat'];
end

if nargin<4
    db = 'extra';
end

if nargin<5
    FileCmd = '';
end

if nargin<6
    GpCmd = '';
end

% run an SQL query to find FileBases and ElecGps
% UniqueIDs gives the ID for each line returned from the query.
% it's important not to confuse this with CellIDs, which is the input
% and could contain duplicates
sql = sprintf(['SELECT Files.FileBase, Files.FileID, ElecGps.GpNo, Cells.BigCluNo, Cells.SmallCluNo, Cells.CellID, IFNULL(Cells.eDist,0) ' ...
        'FROM Files, ElecGps, Cells ' ...
        'WHERE Files.FileID=ElecGps.FileID AND ElecGps.ElecGpID=Cells.ElecGpID AND Cells.CellID IN (%s) ' ...
        'ORDER BY Cells.CellID'], CommaList(CellIDs));
[FileBases FileIDs GpNos BigCluNos SmallCluNos UniqueIDs eDists] = mysql(sql, db, '%s %d %d %d %d %d %f');

if ~isequal(UniqueIDs, unique(CellIDs))
    error('Could not retrieve all cells from db');
end
nCells = length(UniqueIDs);

% load checkpoint file
if FileExists(ChkFile)
    fprintf('Loading checkpoint file %s\n', ChkFile);
    Chk = load(ChkFile);
    if ~(isequal(Chk.CellIDs, CellIDs) & isequal(Chk.db, db))
        error('Saved checkpoint file does not match arguments');
    end        
    % mark those which have already been done
    Done = Chk.Done;
    Out = Chk.Out;
else
    Done = zeros(nCells,1);
end

% find out which stuff needs to be loaded
Arg = [Cmd(min(find(Cmd=='(')):max(find(Cmd==')')))];
if FileCmd
    Arg = [Arg ' ' FileCmd(min(find(FileCmd=='(')):max(find(FileCmd==')')))];
end
if GpCmd
    Arg = [Arg ' ' GpCmd(min(find(GpCmd=='(')):max(find(GpCmd==')')))];
end
NeedBigRes = ~isempty(ContainsToken('BigRes', Arg));
NeedBigClu = ~isempty(ContainsToken('BigClu', Arg));
NeedRes = ~isempty(ContainsToken('Res', Arg)) | ~isempty(ContainsToken('SmallRes', Arg));
NeedSpk = ~isempty(ContainsToken('Spk', Arg));
NeedSpku = ~isempty(ContainsToken('Spku', Arg));
NeedFet = ~isempty(ContainsToken('Fet', Arg)) | ~isempty(ContainsToken('SmallFet', Arg));
NeedWhl = ~isempty(ContainsToken('Whl', Arg));
NeedTheta = 0; %NeedTheta = ~isempty(ContainsToken('Theta', Arg));
NeedEeg0 = ~isempty(ContainsToken('Eeg0', Arg));
NeedEeg = ~isempty(ContainsToken('Eeg', Arg));
NeedEpochs = ~isempty(ContainsToken('Epochs', Arg));
NeedThPh = ~isempty(ContainsToken('ThPh', Arg));
NeedThe = ~isempty(ContainsToken('The', Arg));
NeedGam = ~isempty(ContainsToken('Gam', Arg));
NeedBigSpkPh = ~isempty(ContainsToken('BigSpkPh', Arg));
NeedSpkPh = ~isempty(ContainsToken('SpkPh', Arg));
NeednSamples = ~isempty(ContainsToken('nSamples', Arg));

[UniqueFileBases index] = unique(FileBases);
UniqueFileIDs = FileIDs(index);

for FileNo = 1:length(UniqueFileBases)
    FileID = UniqueFileIDs(FileNo);
	FileBase = UniqueFileBases{FileNo};
	Par = LoadPar([FileBase '.par']);

	% which cells do we need this file?
    FileCells = find(strcmp(FileBases, FileBase) &~Done);

	if ~isempty(FileCells)

        % load what needs to be loaded

        try

			if NeedWhl
				Whl = load([FileBase '.whl']);
			end

  			if NeedTheta
  				Theta = load([FileBase '.theta']);
            end

			if NeedEeg0
				Eeg0 = bload([FileBase '.eeg.0'], [1 inf]);
			end

			if NeedEeg
				Eeg = bload([FileBase '.eeg'], [Par.nChannels inf]);
			end

            if NeedThPh
                ThPh = bload([FileBase '.thph'], [1 inf])'*pi/32767;
            end

            if NeedEpochs
                sql = sprintf('SELECT Type, Start, End FROM Epochs WHERE FileID = %d;', ...
                    UniqueFileIDs(FileNo));
                [Epochs.Type, Epochs.Start, Epochs.End] = mysql(sql, 'extra', '%s %d %d');
            end

            % .clu and .res file is not anymore always loaded
            if NeedBigClu 
                BigClu = LoadClu([FileBase '.clu']);
            end
            if NeedBigRes
                BigRes = load([FileBase '.res']);
            end

			if NeedBigSpkPh 
				BigSpkPh = load([FileBase '.spkph']);
            end
            
            if NeednSamples
                nSamples = FileLength([FileBase '.eeg'])/Par.nChannels/2 ... % n eeg samps
                                *1e6/1250/Par.SampleTime;
            end

            eval(FileCmd);

        catch
            warning(lasterr)
            continue;
        end

		for ElecGpNo = unique(GpNos(FileCells))' % loop through electrode groups
		
			% find cells of this electrode group
            GroupCells = find(GpNos == ElecGpNo & strcmp(FileBases, FileBase));
            
			if ~isempty(GroupCells)		
				fprintf('Loading %s tet %d...\n', FileBase, ElecGpNo);
			
				Par1 = LoadPar1([FileBase '.par.' num2str(ElecGpNo)]);
			
                try
                    
                    GpStr = num2str(ElecGpNo);
                    
					if NeedRes
						SmallRes = load([FileBase '.res.' GpStr]);
                        MaxRes = max(SmallRes);
					end
	
					if NeedFet
						SmallFet = LoadFet([FileBase '.fet.' GpStr]);
					end
	
					if NeedSpk
						AllSpk = LoadSpk([FileBase '.spk.' GpStr], Par1.nSelectedChannels, Par1.WaveSamples);
					end
					
					if NeedSpku
						AllSpku = LoadSpk([FileBase '.spku.' GpStr], Par1.nSelectedChannels, Par1.WaveSamples);
					end
                    
                    if NeedThe
                        The = load([FileBase '.the.' GpStr]);
                    end
                    
                    if NeedGam
                        Gam = load([FileBase '.gam.' GpStr]);
                    end
                    
                    if NeedSpkPh
                        SmallSpkPh = load([FileBase '.spkph.' GpStr]);
                    end
				
					SmallClu = LoadClu([FileBase '.clu.' GpStr]);
					
                    eval(GpCmd);
                    
                catch
                    warning(lasterr)
                    continue;
                end

                for CellNo = GroupCells(:)' % loop through cells
	
					% get cluster number
					SmallCluNo = SmallCluNos(CellNo);
					BigCluNo = BigCluNos(CellNo);

                    eDist = eDists(CellNo);
                    CellID = UniqueIDs(CellNo);
                    fprintf('ID %d is %s gp %d clu %d Qual %f\n', CellID, FileBase, ElecGpNo, SmallCluNo, eDist);                    
					MySpikes = find(SmallClu==SmallCluNo);
% 					BigMySpikes = find(BigClu==BigCluNo);
					nMySpikes = length(MySpikes);
					% sanity check - it gets a bit confusing with all the .clu's and .clu.n's
% 					if (length(BigMySpikes) ~= nMySpikes)
% 						warning('.clu and .clu.n files do not match!!!\n');
%                         keyboard
% 					end
				
					if (NeedRes), Res = SmallRes(MySpikes); end
					if (NeedFet), Fet = SmallFet(MySpikes, :); end;
					if (NeedSpk), Spk = AllSpk(:,:,MySpikes); end;
					if (NeedSpku), Spku = AllSpku(:,:,MySpikes); end;
                    if (NeedSpkPh), SpkPh = SmallSpkPh(MySpikes); end
			
					% And here's the part you've been waiting for ....
			
					if nargout>0
                        Result = eval(Cmd);		
                        if ~isempty(Result)
                            Out(find(CellIDs==UniqueIDs(CellNo))) = Result;
                        end
                    else
                        eval(Cmd);
                    end
                    
                                        
                    % mark it as done, and save checkpoint file if required
                    Done(CellNo) = 1;
                    if ChkFile & exist('Out')
                        save(ChkFile, 'Out', 'Done', 'db', 'CellIDs');
                    end
                      
		
				end
			end
		end
	end
end

% now we have to deal with the case that the output array is
% not of the full size
if ~exist('Out')
    Out = [];
elseif length(Out)<prod(size(CellIDs))
    % make it full size by setting the last element to []
    % there must be a better way to do this
    Names = fieldnames(Out);
    Out = setfield(Out, {prod(size(CellIDs(:)))}, Names{1}, []);
    % and reshape it
    Out = reshape(Out, size(CellIDs));
end

