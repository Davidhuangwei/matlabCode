function MergeChanLocLayers(newChanLocName,mergeStruct)

oldChan = LoadVar(['ChanInfo/' oldChanLocName]);
newFields = fieldnames(mergeStruct);
chanLoc = cell(length(newFields),2);
maxLen = 0;
for j=1:length(newFields)
    maxLen = max([maxLen length(mergeStruct.(newFields{j}))]);
end
for j=1:length(newFields)
    chanLoc{j,1} = newFields{j};
    for k=1:maxLen
%         if isempty(chanLoc{j,2})
%             chanLoc{j,2} = oldChan.(mergeStruct.(newFields{j}){k});
%         else
          if k <= length(mergeStruct.(newFields{j}))
            chanLoc{j,2} = cat(2,chanLoc{j,2},oldChan.(mergeStruct.(newFields{j}){k}));
          else
              temp = cell(size(oldChan.(mergeStruct.(newFields{j}){1})));
              chanLoc{j,2} = cat(2,chanLoc{j,2},temp);
          end
%         end
    end
end

chanLoc = CellArray2Struct(chanLoc)
save(['ChanInfo/' newChanLocName],SaveAsV6,'chanLoc')
