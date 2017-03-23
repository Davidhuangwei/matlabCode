% function [outStruct keptIndexes] = ...
%     CalcUnitRateTrialIndexes(fileBaseCell,spectAnalDir,depVar,unitRateVar,rateMin,trialDesig)

function [keptIndexes] = ...
    CalcUnitRateTrialIndexes(fileBaseCell,spectAnalDir,unitRateVar,rateMin,trialDesig)

sumTemp = {};
for k=1:length(fileBaseCell)
    try
%         temp = Struct2CellArray(LoadDesigVar(fileBaseCell(k),spectAnalDir,depVar,trialDesig),[],1);
        unitRate = Struct2CellArray(LoadDesigVar(fileBaseCell(k),spectAnalDir,unitRateVar,trialDesig),[],1);
    fieldNames = unitRate(:,1:end-1);
    for m=1:size(fieldNames,1)
        if ~isempty(unitRate{m,end})
            for n=1:size(unitRate{m,end},2)
                %             unitRate{m,end}(isnan(unitRate{m,end}(:))) = 0;
                notNaN = sum(sum(isnan(unitRate{m,end}(:,n,:,:)),4),3)==0;
                goodRate = unitRate{m,end}(:,n)>=rateMin;
                keptIndexes{k,m,n} = [goodRate & notNaN]';
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

return