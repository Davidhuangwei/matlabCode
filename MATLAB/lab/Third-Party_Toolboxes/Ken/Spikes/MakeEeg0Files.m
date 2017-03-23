% MakeEeg0Files(Description, db, Overwrite, Chans)
%
% makes .eeg.0 files from .eeg files by averaging channels.  
%
% Description and db specify what files to operate on (see RetrieveFileBases)
% Overwrite - if 1, then overwrite existing .eeg.0 files
% Chans - which channels to average (starting from 1).  If empty or missing, 
% it will use any in CA1 that belong to any active tetrode.  So it should be alright,
% as long as no dodgy channels were included the .par file.

function MakeEeg0Files(Description, db, Overwrite, Chans0)

if nargin<2, db = []; end;
if nargin<3, Overwrite = 0; end
if nargin<4, Chans0 = []; end

FileBases = RetrieveFileBases(Description, db);

for i=1:length(FileBases)
    FileBase = FileBases{i};
    Par = LoadPar([FileBase '.par']);
    
    
    if FileExists([FileBase '.eeg.0']) & Overwrite~=1
        warning([FileBase '.eeg.0 already exists!']);
    elseif FileExists([FileBase '.eegh'])
        % Josef's dat with a .eegh file
        % find CA1 channels
        if isempty(Chans0)
            Sql = sprintf('SELECT GpNo FROM ElecGps WHERE FileBase=%s AND Location = ''1''', FileBase);
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
%             Sql = sprintf('SELECT GpNo FROM ElecGps WHERE FileBase=%s AND Location = ''1''', FileBase);
% 
%             CA1Tets = mysql(Sql, db, '%d'); % these will count from 1

            Chans = 1+vertcat(Par.ElecGp{:}); % these will count from 0 
        else
            Chans = Chans0;
        end
        Eeg0 = mean(Eeg(Chans,:));
        %keyboard
        bsave([FileBase '.eeg.0'], Eeg0-mean(Eeg0), 'int16');
    end
end



return

