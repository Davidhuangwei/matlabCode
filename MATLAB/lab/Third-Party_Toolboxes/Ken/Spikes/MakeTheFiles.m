% MakeTheFiles(Description, db, Overwrite, mode)
%
% goes through a database making .the and .nthe files 
% also makes .sw files (for sharp waves).
% will not overwrite existing files.
%
% call's haj's functions: see TRD, trdetect, etc.
% mode =0 -> datamax 16bit awake theta periods
% mode =1 -> datamax 16bit sleep REM periods
% mode =2 -> RC 12bit awake theta periods
% mode =3 -> RC 12bit sleep REM periods
%
% needs a .eeg.0 file: see MakeEEG0Files
% also see MakeThPhFiles, while you're at it.
%
% first arg is a description, or a list of FileBases.

function MakeTheFiles(Description, db, Overwrite, mode)

% get all files
FileBases = RetrieveFileBases(Description, db);

% if no mode, argument, automatically make it
if 0 % nargin<4
    fprintf('Automatically choosing modes ...\n');
    for f=1:length(FileBases)
        mode(f) = 2*(nBits(f)==12) + (~isempty(findstr(Desc{f}, 'Sleep')) ...
            | ~isempty(findstr(Desc{f}, 'sleep')));
        fprintf('FileBase %s, %d Bits, Description %s --> mode %d\n', ...
            FileBases{f}, nBits(f), Desc{f}, mode(f));
    end
    OK = input('Is this OK? ', 's');
    if OK(1)~='y'
        error('Not OK!!');
    end
end        

% if you have a single mode argument, repeat it
if length(mode)==1
    mode = repmat(mode, length(FileBases), 1);
end

min_REM_period = 10; % (second)
sr = 1250; % sampling rate (Hz)

% now do it!
for i=1:length(FileBases)
    FileBase = FileBases{i};
    eegfilename=[FileBase '.eeg.0'];
    if ~FileExists(eegfilename)
        warning('No eeg file!');       
        continue;
    end
    if FileExists([FileBase '.the']) & ~(Overwrite==1)
        warning([FileBase '.the already exists!']);
    else
        switch mode(i)
        case 0
            [t, nt] = trdetect(eegfilename, 1,1);
        case 1
            [t, nt] = trdetectr(eegfilename, 1,1);
        case 2
            [t, nt] = trdetect2(eegfilename, 1,1);
        case 3
            [t, nt] = trdetectr2(eegfilename, 1,1);
        end

        % chop small chunks out of rem
        if mode(i)==1 | mode(i)==3
            dt = diff(t,1,2);
            t = t(find(dt/sr >= min_REM_period),:);
        end

        % save
        msave([FileBase '.the'], t*16);
        msave([FileBase '.nthe'], nt*16);    
    end
    
    % now sharpwave files
    if FileExists([FileBase '.sw']) & ~(Overwrite==1)
        warning([FileBase '.sw already exists!']);
    else
        s = sdetect(eegfilename,1,1);
        msave([FileBase '.sw'],s*16);
    end

end