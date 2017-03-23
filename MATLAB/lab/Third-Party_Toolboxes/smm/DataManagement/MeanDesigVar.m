% function outStruct = MeanDesigVar(meanDim,fileBaseCell,spectAnalDir,depVar,trialDesig)
% saves memory by summing then dividing

function outStruct = MeanDesigVar(meanDim,fileBaseCell,spectAnalDir,depVar,trialDesig)

sumTemp = {};
for k=1:length(fileBaseCell)
     try 
        temp = Struct2CellArray(LoadDesigVar(fileBaseCell(k),spectAnalDir,depVar,trialDesig),[],1);
    fieldNames = temp(:,1:end-1);
    for m=1:size(fieldNames,1)
        if ~isempty(temp{m,end})
            temp{m,end}(isnan(temp{m,end}(:))) = 0;
            if length(sumTemp)>=m & ~isempty(sumTemp{m})
                sumTemp{m} = sumTemp{m} + sum(temp{m,end},meanDim);
                num(m) = num(m) + size(temp{m,end},meanDim);
            else
                sumTemp{m} = sum(temp{m,end},meanDim);
                num(m) = size(temp{m,end},meanDim);
            end
%         else
%             if length(sumTemp)>=m & ~isempty(sumTemp{m})
%             else
%                  sumTemp{m} = 0;
%                  num(m) = 0;
%             end
        end
    end
     catch
         junk=lasterror
         junk.message
         junk.stack(1)
         keyboard
     end
%         fprintf(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n'...
%         'SKIPPING %s\n'...
%         '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'],fileBaseCell{k});
%     end
end
     try 

outCell = cell(size(fieldNames)+[0 1]);
outCell(:,1:end-1) = fieldNames(:,1:end);
for m=1:size(fieldNames,1)
        outCell{m,end} = sumTemp{m} / num(m);
end
outStruct = CellArray2Struct(outCell);
return

     catch
         junk=lasterror
         junk.message
         junk.stack(1)
         keyboard
     end
