% Klustassist(FileBase, ElecNo)
%
% evaluates the fit of the CEM algorithm by computing the probability
% of missclassification

function KlustaSist(FileBase, ElecNo)

fprintf('--- Missclassification Error Estimates ---\n\n');

[Fet nFeatures] = LoadFet([FileBase '.fet.' num2str(ElecNo)]);
if FileExists([FileBase '.par.' num2str(ElecNo)])
    %old way to get number of channels in a group and number of pca's in
    %each
    Par1 = LoadPar1([FileBase '.par.' num2str(ElecNo)]);
    nDims = Par1.nSelectedChannels * Par1.nPCs;
else
    Par = LoadPar([FileBase '.xml']);
    nDims = length(Par.SpkGrps(ElecNo).Channels)*Par.SpkGrps(ElecNo).nFeatures;
end
if nDims > size(Fet,2)
    nDims = nFeatures-1;
end
while 1

	Clu = LoadClu([FileBase '.clu.' num2str(ElecNo)]);

	x = Fet(:, [1:nDims]);
	nPoints = size(x,1);
	nClusters = max(Clu);
    Pp = MGProbs(x, x, Clu);
    
    % compute "Error matrix" = mean prob that point of cluster c1 actually belongs to c2.
	ErrorMat = zeros(nClusters);

% 	fprintf('    ');
% 	for c=1:nClusters
% 		fprintf(' To %2d  ', c);
% 	end
% 	fprintf('\n');

	for c=1:nClusters
		MyPoints = find(Clu==c);
	
%		fprintf('%2d: ', c);
%		fprintf('%.1e ', mean(Pp(MyPoints,:)));
%		fprintf('\n');

		if length(MyPoints)>1
            ErrorMat(c,:) = mean(Pp(MyPoints,:)); % mean prob 
        end
	end
	
	
% keyboard
	
	ErrorMat = ErrorMat - diag(diag(ErrorMat));
	
	imagesc(ErrorMat);
    ylabel('From'); xlabel('To');
	caxis([0 .1]);
	colorbar
	title('Log Error Probability');
	[sorted index] = sort(ErrorMat(:));

	fprintf('\n------------ Worst 10 -------------\n');
	for i=nClusters^2-10:nClusters^2
		[y x] = ind2sub([nClusters nClusters], index(i));
		fprintf('From %2d to %2d.  Error prob %f\n', y, x, sorted(i));
	end

	ErrorMat(1,:) = 0;
	ErrorMat(:,1) = 0;
	[sorted index] = sort(ErrorMat(:));

	fprintf('\n---- Worst 10 without cluster 1 ----\n');
	for i=nClusters^2-10:nClusters^2
		[y x] = ind2sub([nClusters nClusters], index(i));
		fprintf('From %2d to %2d.  Error prob %f\n', y, x, sorted(i));
	end

	response = input('Return to go again, q to quit ', 's');
	if (~isempty(response) & response == 'q')
		break;
	end
end