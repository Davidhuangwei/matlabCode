% function outStruct = MeanDesigUnitPhaseThresh(fileBaseCell,spectAnalDir,depVar,unitRateVar,rateMin,trialDesig)
% saves memory by summing then dividing

function outStruct = MeanDesigUnitPhaseThresh(fileBaseCell,spectAnalDir,depVar,unitRateVar,rateMin,trialDesig)

sumTemp = {};
for k=1:length(fileBaseCell)
    try
        temp = Struct2CellArray(LoadDesigVar(fileBaseCell(k),spectAnalDir,depVar,trialDesig),[],1);
        unitRate = Struct2CellArray(LoadDesigVar(fileBaseCell(k),spectAnalDir,unitRateVar,trialDesig),[],1);
    fieldNames = temp(:,1:end-1);
    for m=1:size(fieldNames,1)
        if ~isempty(temp{m,end})
            for n=1:size(unitRate{m,end},2)
                %             temp{m,end}(isnan(temp{m,end}(:))) = 0;
                if length(sumTemp)>=m & ~isempty(sumTemp{m}) & size(sumTemp{m},1)>=n
                    sumTemp{m}(n,:,:) = sumTemp{m}(n,:,:) + ...
                        shiftdim(sum(Angle2Complex(temp{m,end}(unitRate{m,end}(:,n)>=rateMin,n,:,:)),1),1);
                    num(m,n) = num(m,n) + size(temp{m,end}(unitRate{m,end}(:,n)>=rateMin,n,:,:),1);
                else
                    sumTemp{m}(n,:,:) = shiftdim(sum(Angle2Complex(temp{m,end}(unitRate{m,end}(:,n)>=rateMin,n,:,:)),1),1);
                    num(m,n) = size(temp{m,end}(unitRate{m,end}(:,n)>=rateMin,n,:,:),1);
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
for m=1:size(fieldNames,1)
    for n=1:size(unitRate{m,end},2)
        outCell{m,end}(1,n,:,:) = sumTemp{m}(n,:,:) / num(m,n);
    end
end
outStruct = CellArray2Struct(outCell);
return