function numEpochs = CountIndCCGEpochs(keptIndexes)
numEpochs = cell(size(keptIndexes,2),1);

for j=1:size(keptIndexes,1) % files
    for k=1:size(keptIndexes,2) % fieldNames
        for n=1:size(keptIndexes,3) % cells
            for p=1:size(keptIndexes,3) % cells
                if isempty(numEpochs{k}) | n>size(numEpochs{k},1) | p>size(numEpochs{k},2)
                    numEpochs{k}(n,p) = sum(keptIndexes{j,k,n} & keptIndexes{j,k,p});
                else
                    numEpochs{k}(n,p) = sum([numEpochs{k}(n,p) sum(keptIndexes{j,k,n} & keptIndexes{j,k,p})]);
                end
            end
        end
    end
end
