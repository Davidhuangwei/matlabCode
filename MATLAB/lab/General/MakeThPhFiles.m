%function MakeThPhFiles(FileBase, Overwrite, ThetaRange,ThetaLabel)
%
% makes .thph files from .eeg0 files by running ThetaPhase.
% NB the .thph file is stored as int16 (to save space)
% with -pi to pi running -32767...32767
%
% also makes a .spkph file which gives a total phase (unwrapped)
function MakeThPhFiles(FileBase,varargin)
[Overwrite, ThetaRange, ThetaLabel] = DefaultArgs(varargin,{1,[6 9],{'REM','RUN'}});

Par = LoadPar([FileBase '.par']);    
%IMPORTANT %%%%%%%%%%%%%%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! NB!!
EegFs = GetEegFs(FileBase);

% create .thph file from .eeg.0 file, (or load it if it already exists)
if FileExists([FileBase '.thph']) & ~Overwrite
    	warning('.thph file already exists!');
    	ThPh = bload([FileBase '.thph'], [1 inf])*pi/32767;
else
	%if FileExists([FileBase '.eeg.0'])
    %		Eeg0 = bload([FileBase '.eeg.0'], [1 inf]);
	%else    
		%make eeg.0 file
		fprintf('.eeg.0 file does not exist, creating');
		hCh = GetChannels(FileBase,'h1','eegseg.par');
		Eeg0 = readsinglech([FileBase '.eeg'],Par.nChannels,hCh);
		bsave([FileBase '.eeg.0'],Eeg0);
	%end		
    	fprintf('loaded ... ');
    	ThPh = ThetaPhase(Eeg0, ThetaRange, 4, 20, EegFs);
    	bsave([FileBase '.thph'], round(ThPh*32767/pi), 'int16');
    	fprintf('done\n');
end

% first load theta epochs - could be .the or .rem 
if FileExists([FileBase '.states.clu'])
    The = SelectStates(FileBase, ThetaLabel, 10*EegFs);
elseif FileLength([FileBase '.rem'])>0
    The = load([FileBase '.rem']);
elseif FileLength([FileBase '.the'])>0
    The = load([FileBase '.the']);
else 
    fprintf('.the (or .rem) file does not exist!\n');
    The = [];
end
%  if isempty(The)
%      error('there is no theta here!!');
%  end
% now compute spike phase for all spikes
Par = LoadPar([FileBase '.par']);

% loop through electrodes - 0 is all
for ElecGp = 1:Par.nElecGps
    if ElecGp ==0
        Suffix = '';
    else
        Suffix = sprintf('.%d', ElecGp);
    end
    
    if FileExists([FileBase '.spkph' Suffix]) & ~Overwrite
        warning([FileBase '.spkph' Suffix ' already exists!']);
    end
    Res = load([FileBase '.res' Suffix]);
    ThPhU = unwrap(ThPh);
    SpkEegSamp = 1+floor(Res*Par.SampleTime*EegFs/1e6);
    if max(SpkEegSamp)>length(ThPhU)
        warning('NOT ENOUGH EEG SAMPLES IN .EEG0 FILE!');
        ThPhU(1+length(ThPhU):max(SpkEegSamp)) = NaN;
    end
    SpkPh = ThPhU(SpkEegSamp);
    
    % overwrite those outside of theta epoochs        
    
    if 0        
        sql = sprintf('SELECT Type, Start, End FROM Epochs WHERE FileID = %d', FileIDs(i));
        Epochs = mysql(sql, db);
        Epochs.Start = str2double(Epochs.Start);
        Epochs.End = str2double(Epochs.End);
        NoGood = find(WithinEpochs(Res, Epochs, {}, {'Theta'}));
    else
        %        NoGood = ~find(WithinRanges(Res, The));
    end        
    %	SpkPh(NoGood) = NaN;
    
    
    fp = fopen([FileBase '.spkph' Suffix],'w');
    fprintf(fp, '%f\n', SpkPh);
    fclose(fp);
end


