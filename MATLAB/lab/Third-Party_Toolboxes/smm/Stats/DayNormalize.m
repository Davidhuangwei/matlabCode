function outStruct = DayNormalize(inStruct,dayDesigStruct,zScoreBool)
%function outStruct = DayNormalize(inStruct,dayDesigStruct,zScoreBool)

if ~exist('zScoreBool','var') | isempty(zScoreBool)
    zScoreBool = 1;
end

inCell = Struct2CellArray(inStruct,[],1);
dayDesigCell = Struct2CellArray(dayDesigStruct,[],1);
CheckCellArraySim(inCell(:,1:end-1),dayDesigCell(:,1:end-1));

dayCat{length(unique(cat(1,dayDesigCell{:,end})))} = [];
for i=1:size(inCell,1)
    days = unique(dayDesigCell{i,end});
    for j=1:length(days)
        trialDesig{i,j} = find(strcmp(dayDesigCell{i,end},days{j}));
        dayCat{j} = cat(1,dayCat{j},inCell{i,end}(trialDesig{i,j}));
    end
end
for j=1:length(dayCat)   
    temp = dayCat{j};
    dayMed{j} = median(temp(isfinite(temp)));
    dayStd{j} = std(temp(isfinite(temp)));
end

%%% to preserve original values %%%%
allDataMed = median(cat(1,inCell{:,end}));

outCell = inCell;
for i=1:size(inCell,1)
    for j=1:length(dayCat)
        if zScoreBool
            outCell{i,end}(trialDesig{i,j}) = (outCell{i,end}(trialDesig{i,j})-dayMed{j})./dayStd{j};
        else
            outCell{i,end}(trialDesig{i,j}) = outCell{i,end}(trialDesig{i,j})...
                -dayMed{j}+allDataMed;
        end
    end
end
outStruct = CellArray2Struct(outCell);
return
    