% function [outStruct keptIndexes] = ...
%     MeanDesigUnitThresh(fileBaseCell,spectAnalDir,depVar,unitRateVar,rateMin,trialDesig)

function [outStruct] = ...
    SumDesigUnitCCGIndexes(fileBaseCell,spectAnalDir,depVar,keptIndexes,trialDesig)

sumTemp = {};
for k=1:length(fileBaseCell)
    try
        temp = Struct2CellArray(LoadDesigVar(fileBaseCell(k),spectAnalDir,depVar,trialDesig),[],1);
        %         unitRate = Struct2CellArray(LoadDesigVar(fileBaseCell(k),spectAnalDir,unitRateVar,trialDesig),[],1);
        fieldNames = temp(:,1:end-1);
        for m=1:size(fieldNames,1)
            if ~isempty(temp{m,end})
                for n=1:size(temp{m,end},2)
                    for p=1:size(temp{m,end},3)
                        goodIndexes = keptIndexes{k,m,n} & keptIndexes{k,m,p};
                        if length(sumTemp)>=m & ~isempty(sumTemp{m}) & size(sumTemp{m},1)>=n & size(sumTemp{m},2)>=p
                            sumTemp{m}(n,p,:) = sumTemp{m}(n,p,:) + permute(sum(temp{m,end}(goodIndexes,n,p,:),1),[2,3,4,1]);
                            %                         num(m,n) = num(m,n) + size(temp{m,end}(keptIndexes{k,m,n},n,:,:),1);
                        else
                            %                         if ndims(permute(sum(temp{m,end}(keptIndexes{k,m,n},n,:,:),1),[2,3,4,1])) < 3
                            %                             sumTemp{m}(n,:) = permute(sum(temp{m,end}(keptIndexes{k,m,n},n,:,:),1),[2,3,4,1]);
                            %                         end
                            sumTemp{m}(n,p,:) = permute(sum(temp{m,end}(goodIndexes,n,p,:),1),[2,3,4,1]);
                            %                         num(m,n) = size(temp{m,end}(keptIndexes{k,m,n},n,:,:),1);
                        end
                    end
                end
            end
        end
    catch
        junk = lasterror
        keyboard
        %         fprintf(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n'...
        %         'SKIPPING %s\n'...
        %         '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'],fileBaseCell{k});
    end
end
outCell = cell(size(fieldNames)+[0 1]);
outCell(:,1:end-1) = fieldNames(:,1:end);
% numEpochs = cell(size(fieldNames)+[0 1]);
% numEpochs(:,1:end-1) = fieldNames(:,1:end);
for m=1:size(fieldNames,1)
    %     for n=1:size(temp{m,end},2)
    outCell{m,end}(1,:,:,:) = sumTemp{m}(:,:,:);
    %         numEpochs{m,end}(n) = num(m,n);
    %     end
end
% numEpochs = CellArray2Struct(numEpochs);
outStruct = CellArray2Struct(outCell);
return