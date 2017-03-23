% MakeCanFetFiles(Description, db)
%
% makes a .canfet file for every .spk file
%
% this is like a .fet file but uses the SAME principle
% components across files, allowing you to compare clusters
% from different sessions.
%
% requires a file /home/ken/bitz/CanonPCs.txt which gives
% 3 32-sample waveforms

function MakeCanFetFiles(Description, db)

PCs = load('/home/ken/bitz/CanonPCs.txt');
nPCA = 3;

if nargin<1 | isempty(Description)
    [FileBases FileIDs] = mysql('SELECT FileBase, FileID FROM Files ', db, '%s %d');
else
    [FileBases FileIDs] = mysql(['SELECT FileBase, FileID FROM Files ' ...
        'WHERE Description LIKE ''' Description ''''], db, '%s %d');
end

for i=1:length(FileBases)
    if findstr(FileBases{i}, 'l19'); continue; end
    Par = LoadPar([FileBases{i} '.par']);
    for e=1:Par.nElecGps
        Par1 = LoadPar1([FileBases{i} '.par.' num2str(e)]);
        nChannels = Par1.nSelectedChannels;
        SpkSampls = Par1.WaveSamples;
        Spk = LoadSpk([FileBases{i} '.spk.' num2str(e)], nChannels);
        nSpikes = size(Spk,3);
       
        AllSpikes = reshape(permute(Spk,[3 1 2]), nSpikes*nChannels, SpkSampls);

        Fets = AllSpikes * PCs;
		Fets = reshape(Fets, [nSpikes,nChannels, nPCA]);
		Fets = permute(Fets, [1 3 2]);
		Fets = reshape(Fets, [nSpikes, nPCA*nChannels]);
        SaveFet([FileBases{i} '.canfet.' num2str(e)], Fets);
    end
end
return

% here's where you make the cannonical PCs.
Spk1 = LoadSpk('/u15/xaj/Awake/l21-02/f1.spk.4');
Spk2 = LoadSpk('/u15/xaj/Awake/l21-02/n1.spk.4');
Spk3 = LoadSpk('/u15/xaj/Awake/l21-02/f2.spk.4');
Spk = cat(3, Spk1, Spk2, Spk3);

[nChannels, SpkSampls, nSpikes] = size(Spk);


% combine all channels
AllSpikes = reshape(permute(Spk,[3 1 2]), nSpikes*nChannels, SpkSampls);


CovMat  = cov(AllSpikes);
[PCs d] = eigs(CovMat, eye(size(CovMat)), 3);

plot(PCs);

msave('/home/ken/bitz/CanonPCs.txt', PCs);