function outStruct = DayZscoreTemp(inStruct,dayDesigStruct,zScoreBool)
%function outStruct = DayZscoreTemp(inStruct,dayDesigStruct,zScoreBool)

if ~exist('zScoreBool','var') | isempty(zScoreBool)
    zScoreBool = 1;
end

inCell = Struct2CellArray(inStruct,[],1);
dayDesigCell = Struct2CellArray(dayDesigStruct,[],1);

dayCat{length(dayDesigCell)} = [];
for i=1:size(inCell,1)
    days = unique(dayDesigCell{i,end});
    for j=1:length(days)
        trialDesig{j} = find(strcmp(dayDesigCell{i,end},days{j}));
        dayCat{j} = cat(1,dayCat{j},inCell{i,end}(trialDesig{j}));
    end
end
for j=1:length(days)   
    dayMean{j} = mean(dayCat{j});
    dayStd{j} = std(dayCat{j});
end
outCell = inCell;
for i=1:size(inCell,1)
    for j=1:length(days)
        if zScoreBool
            outCell{i,end}(trialDesig{j}) = (outCell{i,end}(trialDesig{j})-dayMean{j})./dayStd{j};
        else
            outCell{i,end}(trialDesig{j}) = outCell{i,end}(trialDesig{j})-dayMean{j};
        end
    end
end
outStruct = CellArray2Struct(outCell);
return
    