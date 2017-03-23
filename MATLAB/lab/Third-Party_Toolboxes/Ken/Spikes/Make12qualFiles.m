% Make12QualFiles(Description, db, Overwrite)
% goes through specified files (see RetrieveFileBases) and makes .qual12 files
% giving the isolation distance measured from the best 12 features
% this allows comparison between different dimensions of feature space

function MakeQualFiles(Description, db, Overwrite)

if nargin<2, db = []; end
if nargin<3, Overwrite = 0; end

FileBases = RetrieveFileBases(Description, db)

for i=1:length(FileBases)
    FileBase = FileBases{i};
    fprintf('%s ... ', FileBase);
    
    % create .thph file from .eeg.0 file, (or load it if it already exists)
    if FileExists([FileBase '.qual12']) & ~Overwrite
        warning('.qual12 file already exists!');
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
            q = ClusterQuality12(SubFet, MySpikes);
            Qual(CellCount,:) = q;
            fprintf('Cell %d: %d spikes, qual %f\n', c, length(MySpikes), q)
            CellCount = CellCount+1;
        end               
    end
    msave([FileBase '.qual12'], Qual);
%Qual, pause
    
end
            
