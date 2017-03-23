function SuggestClusteringFeatures(Fet,Trode)
% SuggestClusteringFeatures(Fet)
% does a K-S test for normality on each column of a feature matrix Fet
% 
% SuggestClusteringFeatures(FileBase,ElecNo)
% loads feature file FileBase.fet.ElecNo first
%
% SuggestClusteringFeatures(FileBase)
% does it for all in turn

if nargin==1 & isnumeric(Fet)
    for i=1:size(Fet,2)
	    Mine = Fet(:,i);
    	[h p(i) s(i)] = kstest((Mine-mean(Mine))/std(Mine));
    end
    subplot(1,2,1);
    bar(s);
    ylabel('Non-normality');
    xlabel('Feature');
    subplot(1,2,2);
    imagesc(corrcoef(Fet));
    colorbar
    title('Correlation Coefficient');
elseif nargin==2
    fprintf('Loading Tetrode %d...', Trode);
    SuggestClusteringFeatures(LoadFet(sprintf('%s.fet.%d',Fet,Trode)));
else
    Par = LoadPar([Fet '.par']);
    for c=1:Par.nElecGps
        SuggestClusteringFeatures(Fet,c);
        fprintf('press return\n');
        pause
    end
end