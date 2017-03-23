function [categPvalStruct contPvalStruct] = CalcDurbinWatson(residuals,categData,contData,contNames)
% function [categPvalStruct contPvalStruct] = CalcDurbinWatson(residuals,categData,contData,contNames)
% caculates the empirical probability that the residuals have first order
% autocorrelation using the Durbin-Watson method
nRandSamp = 500;

residStruct = CellArray2Struct(cat(2,categData,mat2cell(residuals,repmat(1,size(residuals,1),1),1)));


dataCell = Struct2CellArray(residStruct,[],1);
nGroups = size(dataCell,1);
categPvalCell = dataCell;
for j=1:nGroups
    data = dataCell{j,end};
    shuffVar = [];
    for k=1:nRandSamp
        shuffData = randsample(data,length(data));
        sigu = shuffData'*shuffData;
        ediff = shuffData(2:end) - shuffData(1:end-1);
        shuffDW(k) = (ediff'*ediff)/sigu; % durbin-watson
    end
    sigu = data'*data;
    ediff = data(2:end) - data(1:end-1);
    categDW = (ediff'*ediff)/sigu; % durbin-watson
    categPvalCell{j,end} = (1+length(find(shuffDW>=categDW)))/length(shuffDW);
    %categPvalCell{j,end} =
    %length(find(abs(shuffDW-2)>=abs(categDW-2)))/length(shuffDW); %tests
    %for negative autocorrelation
end
categPvalStruct = CellArray2Struct(categPvalCell);

if isempty(contData)
    contPvalStruct = NaN;
else
    [sortedCategData sortIndexes] = sort(contData);
    for j=1:length(contNames)
        data = residuals(sortIndexes(:,j));
        sigu = data'*data;
        ediff = data(2:end) - data(1:end-1);
        contDWStruct.(GenFieldName(contNames{j})) = (ediff'*ediff)/sigu; % durbin-watson
    end
    shuffDW = [];
    for k=1:nRandSamp
        shuffData = randsample(residuals,length(residuals));
        sigu = shuffData'*shuffData;
        ediff = shuffData(2:end) - shuffData(1:end-1);
        shuffDW(k) = (ediff'*ediff)/sigu; % durbin-watson
    end
    for j=1:length(contNames)
        contPvalStruct.(GenFieldName(contNames{j})) = ...
            (1+length(find(shuffDW>=contDWStruct.(GenFieldName(contNames{j})))))/length(shuffDW);
    end
end
return

