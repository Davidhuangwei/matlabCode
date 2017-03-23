% CombineSessions(InFiles, Result)
%
% combines .eeg, .whl, , .res.n and .spk.n files
% but won't combine .clu or .fet files
% so you do this then run sfeatureb
%
% InFiles should be a cell array of filebases
% result should be the filebase for the result.

%function CombineSessions(InFiles, Result)

InFiles = { '/u10/ken/64trode/j360801/j360801', ...
            '/u10/ken/64trode/j360802/j360802', ...
            '/u10/ken/64trode/j360803/j360803', ...
            '/u10/ken/64trode/j360804/j360804', ...
            '/u10/ken/64trode/j360806/j360806'};
Result = '/u10/ken/64trode/Combined/j3608';    

% check number of channels trode assignments match
nFiles = length(InFiles);
for i=1:nFiles
    FileBase = InFiles{i};
    Par(i) = LoadPar([FileBase '.par']);
    
    if ~isequal(Par(i).ElecGp, Par(1).ElecGp) | Par(i).nChannels~=Par(1).nChannels
        error('Trode assignments do not match in .par files');
    end
end

% wipe output files
delete([Result '.*']);

% loop through files, appending
Offset = 0;
for i=1:nFiles
    FileBase = InFiles{i};
    fprintf('Doing %s\n', FileBase);
    EegLen = FileLength([FileBase '.eeg']);
    WhlLen = FileLines([FileBase '.whl']);
    
    WhlSamps = min(WhlLen, floor(EegLen/2/Par(i).nChannels/32));
    % how many .whl samples to include
    % we want to be sure that .whl length and .eeg length are the same
    
    % append whl file
    Cmd = sprintf('!head -n %d %s.whl >> %s.whl', WhlSamps, FileBase, Result);
    eval(Cmd);
    
    % append eeg file
    Cmd = sprintf('!head -c %d %s.eeg >> %s.eeg', ...
        WhlSamps*32*Par(i).nChannels*2, FileBase, Result);
    eval(Cmd);

    % append .res.n files and .spk.n files
    MaxRes = WhlSamps*25600/Par(i).SampleTime;
    for j=1:Par(i).nElecGps
        
        % load .res file and determine which spikes aren't too late
        Res = load([FileBase '.res.' num2str(j)]);        
        nSpk = max(find(Res<MaxRes));
        
        % do .res.n file
        ResFp = fopen([Result '.res.' num2str(j)], 'a');
        fprintf(ResFp, '%d\n', Offset+Res(1:nSpk));
        fclose(ResFp);
        
        % do .spk.n file
        Par1 = LoadPar1([FileBase '.par.' num2str(j)]);
        Cmd = sprintf('!head -c %d %s.spk.%d >> %s.spk.%d', ...
            nSpk*Par1.nSelectedChannels*Par1.WaveSamples*2, FileBase, j, Result, j);
        eval(Cmd);
        
    end
    
    % add to Offset
    Offset = Offset+MaxRes;
end

% copy Par files and .mm.n and .m1m2.n files (whatever they are ...)
Cmd = sprintf('!cp %s.par %s.par', FileBase, Result);
eval(Cmd);
for j=1:Par(1).nElecGps
    Cmd = sprintf('!cp %s.par.%d %s.par.%d', FileBase, j, Result, j);
    eval(Cmd);
    Cmd = sprintf('!cp %s.mm.%d %s.mm.%d', FileBase, j, Result, j);
    eval(Cmd);
    Cmd = sprintf('!cp %s.m1m2.%d %s.m1m2.%d', FileBase, j, Result, j);
    eval(Cmd);
end

return