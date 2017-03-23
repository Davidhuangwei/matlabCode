% MakeCanShapeFiles(Description, db)
%
% makes a .canshape file for every .canfet file
% this file gives the shape of all clusters in canonical 
% cluster space (including noise cluster 1)
% the .canshape file has 1 line for each cell:
% nSpikes MeanVec CovMat
% 
% with 3 PCs per channel (so for a tetrode, mean is 12d, CovMat 144d)
%

DON'T FORGET TO UPDATE THIS TO USE RetrieveFileBases

function MakeCanShapeFiles(Description, db)

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
        fprintf('%s.%d\n', FileBases{i}, e);
        Par1 = LoadPar1([FileBases{i} '.par.' num2str(e)]);
        nChannels = Par1.nSelectedChannels;
        SpkSampls = Par1.WaveSamples;
        CanFet = LoadFet([FileBases{i} '.canfet.' num2str(e)]);
        Clu = LoadClu([FileBases{i} '.clu.' num2str(e)]);
        
        OutFp = fopen([FileBases{i} '.canshape.' num2str(e)], 'w');
        
        for c=1:max(Clu);
            My = CanFet(find(Clu==c),:);
            mu = mean(My);
            sig = cov(My);
            n = size(My,1);
            fprintf(OutFp, '%d ', n);
            fprintf(OutFp, '%e ', mu);
            fprintf(OutFp, '%e ', sig);
            fprintf(OutFp, '\n');
        end
    end
end
return
