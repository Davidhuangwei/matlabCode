% MakeQualFiles(Description, db, Overwrite)
% goes through specified files (see RetrieveFileBases) and makes .lqual files
% - these have one line for all clusters, starting from 2
% with 4 columns: L_intra/L_extra, L_extra, L_intra, nSpikes

function MakeQualFiles(Description, db, Overwrite)

if nargin<2, db = []; end
if nargin<3, Overwrite = 0; end

FileBases = RetrieveFileBases(Description, db)

for i=1:length(FileBases)
    FileBase = FileBases{i};
    fprintf('%s ... ', FileBase);
    
    % create .thph file from .eeg.0 file, (or load it if it already exists)
    if FileExists([FileBase '.lqual']) & ~Overwrite
        warning('.lqual file already exists!');
        continue;
    end
    
    Par = LoadPar([FileBase '.par']);
    clear Qual
    CellCount = 1;
    for e=1:Par.nElecGps
        Par1 = LoadPar1(sprintf('%s.par.%d', FileBase, e));
        Fet = LoadFet(sprintf('%s.fet.%d', FileBase, e));
        Clu = LoadClu(sprintf('%s.clu.%d', FileBase, e));
        
        SubFet = Fet(:,1:Par1.nSelectedChannels*Par1.nPCs);

        % start with empty array ...
        for c=2:max(Clu)
            MySpikes = find(Clu==c);
            [Lextra, Lintra] = LClusterQuality(SubFet, MySpikes);
            Qual(CellCount,:) = [Lintra/Lextra, Lextra, Lintra, length(MySpikes)];
            fprintf('Cell %d: %d spikes, qual %f\n', c, length(MySpikes), Lintra/Lextra)
            CellCount = CellCount+1;
        end               
    end
    msave([FileBase '.lqual'], Qual);
%Qual, pause
    
end
            
