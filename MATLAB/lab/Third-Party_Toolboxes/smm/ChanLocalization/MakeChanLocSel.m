% function MakeChanLocSel(fileExtCell)
% tag:channel
% tag:selected
% tag:chanloc
% tag:selchan

function MakeChanLocSel(fileExtCell)
for m=1:length(fileExtCell)
    fileExt = fileExtCell{m};

    chanMat = LoadVar(['ChanInfo/ChanMat' fileExt '.mat']);
    selChan = LoadVar(['ChanInfo/SelChan' fileExt '.mat']);
    chanFields = fieldnames(selChan);
    for j=1:length(chanFields)
        for k=1:size(chanMat,2)
            if any(chanMat(:,k) == selChan.(chanFields{j}))
                chanLoc.(chanFields{j}){k} = selChan.(chanFields{j});
            else
                chanLoc.(chanFields{j}){k} = [];
            end
%                 
%             if chanLoc.(chanFields{j}){k} ~= selChan.(chanFields{j})
%                 chanLoc.(chanFields{j}){k} = [];
%             end
        end
    end
    chanLoc
    save(['ChanInfo/ChanLoc_Sel' fileExt '.mat'],SaveAsV6,'chanLoc')
end
   
    