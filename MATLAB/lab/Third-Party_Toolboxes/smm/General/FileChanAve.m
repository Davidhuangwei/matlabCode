% function FileChanAve(fileBaseCell,oldFileExt,newFileExt,nChannels,chanAveCell)
% Loads specified file (in .dat/.eeg format), averages channels specified
% by chanAveCell and saves the result in a new file with the specified extension. 
function FileChanAve(fileBaseCell,oldFileExt,newFileExt,nChannels,chanAveCell)

for j=1:length(fileBaseCell)
    FileBase = fileBaseCell{j};
    FileIn = [FileBase oldFileExt];
    fprintf('\nReading: %s\n',FileIn);

    FileOut = [FileBase newFileExt];
    fprintf('\nWriting: %s\n',FileOut);

    BlockSize = 2^16;

    InFp = fopen(FileIn, 'r');
    OutFp = fopen(FileOut, 'w');

    while(~feof(InFp))
        Block = fread(InFp, [nChannels, BlockSize], 'short');
        
        outData = zeros([length(chanAveCell), size(Block,2)]);
        for k=1:length(chanAveCell)
            outData(k,:) = mean(Block([chanAveCell{k}],:),1);
        end
        
        fwrite(OutFp, outData, 'short');
    end
    fclose(InFp);
    fclose(OutFp);
    
    if exist([FileIn '.ch'],'file')
        oldCh = LoadVar([FileIn '.ch']);
        for k=1:length(chanAveCell)
            ch{k} = [oldCh{[chanAveCell{k}]}];
        end
        save([FileOut '.ch'],SaveAsV6,'ch')
    end
end