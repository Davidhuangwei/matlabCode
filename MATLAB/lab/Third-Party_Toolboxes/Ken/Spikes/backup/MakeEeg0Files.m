% MakeEeg0Files(Description, db)
% MakeEeg0Files(Description, Chans)
% or MakeEeg0Files(FileBases, Chans)
%
% makes .eeg.0 files from .eeg files by averaging channels.  If you use
% the first form, channels will be used which
% belong to any active tetrode.  So it should be alright, as long as
% no dodgy channels were included the .par file.
%
% if you use the second form (i.e. if arg2 is numeric), it will 
% use the specified channels.  Note that these start from 1!!!

function MakeEeg0Files(arg1, arg2)

if iscell(arg1)
    % we are in format 2
    % rename input variables
    FileBases = arg1;
    Chans = arg2;
    for i=1:length(FileBases)
        FileBase = FileBases{i};
        Par = LoadPar([FileBase '.par']);
        Eeg = bload([FileBase '.eeg'], [Par.nChannels inf], 0, '*int16');
        Eeg0 = mean(Eeg(Chans,:));
        %keyboard
        bsave([FileBase '.eeg.0'], Eeg0, 'int16');
    end
    return
else
    Description=arg1;
    if nargin<2
		db = 'extra';
        Chans0 = []; % means use channels from .par file
    elseif isnumeric(arg2)
        Chans0 = arg2;
        db = 'extra';
    else
        db = arg2;
        Chans0 = []; % means use channels from .par file
    end
end


% get all files
if nargin<1 | isempty(Description)
    [FileBases FileIDs] = mysql('SELECT FileBase, FileID FROM Files ', db, '%s %d');
else
    [FileBases FileIDs] = mysql(['SELECT FileBase, FileID FROM Files ' ...
        'WHERE Description LIKE ''' Description ''''], db, '%s %d');
end

for i=1:length(FileBases)
    FileBase = FileBases{i};
    Par = LoadPar([FileBase '.par']);
    
    
    if FileExists([FileBase '.eeg.0'])
        warning([FileBase '.eeg.0 already exists!']);
    elseif FileExists([FileBase '.eegh'])
        % Josef's dat with a .eegh file
        % find CA1 channels
        Sql = sprintf('SELECT GpNo FROM ElecGps WHERE FileID=%d AND Location = ''1''', ...
            FileIDs(i));
        if isempty(Chans0)
            Chans = mysql(Sql, db, '%d'); % these will count from 1
        else
            Chans = Chans0;
        end
        
        % sum the .eegh file ...        
        % load it in by chunks (these files can be big)
        ChunkSize = 1e6;
        fprintf('summing %s ... ', [FileBase '.eegh']);

        if length(Chans)==0
            warning('No channels in CA1!');
            continue;
        end
        
        InFp = fopen([FileBase '.eegh'], 'r');
        OutFp = fopen([FileBase '.eegh.0'], 'w');
        while(~feof(InFp))
            Chunk = fread(InFp, [Par.nElecGps, ChunkSize], '*int16');
            Chunk0 = mean(Chunk(Chans,:),1);
            fwrite(OutFp, Chunk0, 'int16');
        end
        fclose(InFp);
        fclose(OutFp);
        
        % now decimate the .eegh.0 file
        fprintf('Decimating ... ');
        deciall([FileBase '.eegh.0'], [FileBase '.eeg.0'], 1, 4);
        fprintf('\n');
    elseif ~FileExists([FileBase '.eeg'])
        % is there an .eeg file?
        warning('No Eeg file!');
    else
        Eeg = bload([FileBase '.eeg'], [Par.nChannels inf], 0, '*int16');
        if isempty(Chans0)
            Chans = 1+vertcat(Par.ElecGp{:}); % these will count from 0 - assume they are all in Ca1
        else
            Chans = Chans0;
        end
        Eeg0 = mean(Eeg(Chans,:));
        %keyboard
        bsave([FileBase '.eeg.0'], Eeg0, 'int16');
    end
end

