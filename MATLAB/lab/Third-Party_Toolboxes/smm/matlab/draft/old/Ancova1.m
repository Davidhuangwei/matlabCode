function Ancova1(data)
% data is an (data points) x (number of covariates) x (number of
% groups) matix.

for c=1:size(data,2) % for each covariate
    grandMean = mean(mean(data(:,c,:)));
    %SSTotal(c) = sum(sum((data(:,c,:)-repmat(grandMean,size(data(:,c,:)))).^2));
    SSTotal(c) = sum(sum((data(:,c,:)-grandMean).^2));
    betweenMean(c,:) = mean(data(:,c,:),1);
    SSBetween(c) = sum(
end

SSTotal = zeros(1,size(data,2));
for c=1:size(data,2) % for each covariate
    for n=1:size(data,1) % for each data point
        for g=1:size(data,3)
            SSTotal(c) = SSTotal(c) + (data(n,c,g) - mean(mean(data(:,c,:)))).^2;
        end
    end
end