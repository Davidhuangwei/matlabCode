% LinkClusters(FileBase1, FileBase2)
%
% compares two sets of clustered data to see if the clusters
% correspond to the same cells. 
%
% It does this by looking at the waveforms (not the .fet files
% as these may be wrt a different pc basis), doing a pca (all
% electrodes at once) and then comparing with MANOVA.

function LinkClusters(FileBase1, FileBase2)

Par1 = LoadPar([FileBase1 '.par']);
Par2 = LoadPar([FileBase2 '.par']);

if Par1.nElecGps~=Par2.nElecGps
    warning('different numbers of tetrodes on the 2 files')
end

for i=1:min(Par1.nElecGps, Par2.nElecGps)

    fprintf('\nElec %d', i);
    Par11 = LoadPar1([FileBase1 '.par.' num2str(i)]);
    Par12 = LoadPar1([FileBase2 '.par.' num2str(i)]);

    Clu1 = LoadClu([FileBase1 '.clu.' num2str(i)]);
    Clu2 = LoadClu([FileBase2 '.clu.' num2str(i)]);
    nClu1 = max(Clu1);
    nClu2 = max(Clu2);

    if min(nClu1, nClu2)==1
        fprintf(' No clusters!');
        continue
    end
    
    if ~isequal(rmfield(Par11, 'FileName'), rmfield(Par12, 'FileName'))
        warning('different .par. files');
    end
    
    fprintf(' Loading Spikes ');
    
    Spk1 = LoadSpk([FileBase1 '.spk.' num2str(i)], ...
        Par11.nSelectedChannels, Par11.WaveSamples);
    
    Spk2 = LoadSpk([FileBase2 '.spk.' num2str(i)], ...
        Par12.nSelectedChannels, Par12.WaveSamples);
    
    
    
    Size1 = size(Spk1);
    Size2 = size(Spk2);
 
    AllSpk = cat(3, Spk1, Spk2);
    Fet = Feature(AllSpk);
    
    fprintf('Processing ');
    clear d p stats
    for c1=2:nClu1
        for c2=2:nClu2
            m1 = find(Clu1==c1);
            m2 = find(Clu2==c2);
            ind = [m1; Size1(3)+m2];
            gp = [zeros(size(m1)) ; ones(size(m2))];
    
            [d(c1,c2), p(c1,c2) stats(c1, c2)] = manova1(Fet(ind,:), gp);
            fprintf('.');
        end
    end
     
    imagesc(2:nClu1, 2:nClu2, reshape([stats.lambda], [nClu1-1 nClu2-1]), [0 1]);
    colorbar;
    pause
        
    %keyboard
    
%    AllSpk = 
    
end