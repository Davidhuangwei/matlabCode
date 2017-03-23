% KlustaSistData(Fet,Clu)
%
% evaluates the fit of the CEM algorithm by computing the probability
% of missclassification

function KlustaSistData(Fet,Clu)

fprintf('--- Missclassification Error Estimates ---\n\n');

nDims = size(Fet,2)-1;
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
    if length(MyPoints)>1
        ErrorMat(c,:) = mean(Pp(MyPoints,:)); % mean prob 
    end
end

ErrorMat = ErrorMat - diag(diag(ErrorMat));

imagesc(ErrorMat);
ylabel('From'); xlabel('To');
caxis([0 .1]);
colorbar
title('Log Error Probability');
[sorted index] = sort(ErrorMat(:));

fprintf('\n------------ Worst 10 -------------\n');
for i=nClusters^2-min(10,nClusters^2-1):nClusters^2
    [y x] = ind2sub([nClusters nClusters], index(i));
    fprintf('From %2d to %2d.  Error prob %f\n', y, x, sorted(i));
end

ErrorMat(1,:) = 0;
ErrorMat(:,1) = 0;
[sorted index] = sort(ErrorMat(:));

fprintf('\n---- Worst 10 without cluster 1 ----\n');
for i=nClusters^2-min(10,nClusters^2-1):nClusters^2
    [y x] = ind2sub([nClusters nClusters], index(i));
    fprintf('From %2d to %2d.  Error prob %f\n', y, x, sorted(i));
end

% response = input('Return to go again, q to quit ', 's');
% if (~isempty(response) & response == 'q')
%     break;
% end
