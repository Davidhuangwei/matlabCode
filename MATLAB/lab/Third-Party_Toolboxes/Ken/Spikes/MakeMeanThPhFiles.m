% MakeMeanThPhFiles(Description, db, Overwrite)
%
% for each cell (including mua cell 1), computes the following for all
% spikes in theta:
%
% MeanThPh (mean phase in radians)
% R (radius parameter of circular distribution)
% NThSpikes (number of spikes of this cluster in theta
% k (Von Mises concentration parameter by maximum likelihood) 
% p (p-val for non-uniformity, Rayleigh test)
%
% these are saved as a .meanthph file, with one line per clu (inc clu 1)

function MakeMeanThFiles(Description, db, Overwrite)

if nargin<2, db = []; end;
if nargin<3, Overwrite = 0; end

% get appropriate files
FileBases = RetrieveFileBases(Description, db)

for f=1:length(FileBases)
    
    FileBase = FileBases{f};
    
    if FileExists([FileBase '.meanthph']) & Overwrite~=1
        warning([FileBase '.meanthph already exists!']);
        continue;
    end

    fprintf('Doing %s\n', FileBase);
    BigSpkPh = load([FileBase '.spkph']);
    BigClu = LoadClu([FileBase '.clu']);

    clear Out
	for c=1:max(BigClu)
        MySpikes = find(BigClu==c & isfinite(BigSpkPh));
        MyPh = BigSpkPh(MySpikes);
        
        [Out(c,1), Out(c,2)] = circmean(MyPh);
        Out(c,3) = length(MyPh);
        [dummy, Out(c,4)] = VonMisesFit(MyPh);
        Out(c,5) = RayleighTest(MyPh);
	end
	
% 	Out
    FileName = [FileBase '.meanthph'];
% 	FileName
    msave(FileName, Out);
% 	pause
end