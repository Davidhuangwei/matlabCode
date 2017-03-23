% MakeThPhFiles(Description, db)
%
% makes .thph files from .eeg0 files by running ThetaPhase.
% NB the .thph file is stored as int16 (to save space)
% with -pi to pi running -32767...32767
%
% also makes a .spkph file which gives a total phase (unwrapped)

function MakeThPhFiles(Description, db)

if nargin<2
	db = 'extra';
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
    fprintf('%s ... ', FileBase);
    if FileExists([FileBase '.thph'])
        warning('.thph file already exists!');
        ThPh = bload([FileBase '.thph'], [1 inf])*pi/32767;
    elseif FileExists([FileBase '.eeg.0'])
        Eeg0 = bload([FileBase '.eeg.0'], [1 inf]);
        fprintf('loaded ... ');
        ThPh = ThetaPhase(Eeg0);
        bsave([FileBase '.thph'], round(ThPh*32767/pi), 'int16');
        fprintf('done\n');
    else
        warning('.eeg.0 file does not exist!');
    end


    % now compute spike phase for all spikes
	Par = LoadPar([FileBase '.par']);
    
    % loop through electrodes - 0 is all
    for ElecGp = 0:Par.nElecGps
        if ElecGp ==0
            Suffix = '';
        else
            Suffix = sprintf('.%d', ElecGp);
        end
        
        if FileExists([FileBase '.spkph' Suffix])
            warning([FileBase '.spkph' Suffix ' already exists!']);
            continue;
        end
		Res = load([FileBase '.res' Suffix]);
		ThPhU = unwrap(ThPh);
        SpkEegSamp = 1+floor(Res*Par.SampleTime/800);
        if max(SpkEegSamp)>length(ThPhU)
            warning('NOT ENOUGH EEG SAMPLES IN .EEG0 FILE!');
            ThPhU(1+length(ThPhU):max(SpkEegSamp)) = NaN;
        end
		SpkPh = ThPhU(SpkEegSamp);
	
		% overwrite those outside of theta epoochs
        sql = sprintf('SELECT Type, Start, End FROM Epochs WHERE FileID = %d', FileIDs(i));
        Epochs = mysql(sql, db);
		Epochs.Start = str2double(Epochs.Start);
		Epochs.End = str2double(Epochs.End);
		NoGood = find(WithinEpochs(Res, Epochs, {}, {'Theta'}));
		SpkPh(NoGood) = NaN;
	
		fp = fopen([FileBase '.spkph' Suffix],'w');
		fprintf(fp, '%f\n', SpkPh);
		fclose(fp);
    end

end

