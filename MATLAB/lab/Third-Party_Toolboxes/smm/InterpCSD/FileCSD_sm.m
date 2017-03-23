%function FileCSD_sm(FileBaseCell, fileExt, nChannels, Channels2Use, SpatialSmoother)
% does a CSD on a file, smoother with [1 2 1] by default
% function FileCSD_sm(FileBaseCell, fileExt, varargin)
%     [nChannels, Channels2Use, SpatialSmoother] = DefaultArgs(varargin, ...
%         {   parnChannels, [1:parnChannels], [1 2 1]   });
function FileCSD_sm(FileBaseCell, fileExt, varargin)
for j=1:length(FileBaseCell)
    FileBase = FileBaseCell{j};
    FileIn = [FileBase '/' FileBase fileExt];
    fprintf('\nReading: %s\n',FileIn);

    if FileExists([FileBase '/' FileBase '.par'])
        Par = LoadPar([FileBase '/' FileBase '.par']);
        parnChannels = Par.nChannels;
    else
        parnChannels = 1;
    end
    [nChannels, Channels2Use, SpatialSmoother] = DefaultArgs(varargin, ...
        {   parnChannels, [1:parnChannels], [1 2 1]   });

    smootherFileExt = [];
    for i = 1:length(SpatialSmoother)
        smootherFileExt = [smootherFileExt num2str(SpatialSmoother(i))];
    end
    FileOut = [FileBase '/' FileBase '.csd' smootherFileExt];
    fprintf('\nWriting: %s\n',FileOut);

    BlockSize = 2^16;

    InFp = fopen(FileIn, 'r');
    OutFp = fopen(FileOut, 'w');
    if iscell(Channels2Use)
        nShanks = length(Channels2Use);
    else
        nShanks =1;
        Channels2Use = {Channels2Use};
    end
    while(~feof(InFp))
        Block = fread(InFp, [nChannels, BlockSize], 'short');
        CSDBlock = [];
        for s=1:nShanks
            SmoothLoss =(length(SpatialSmoother)-1);
            nCsdChannels = length(Channels2Use{s}) -2 - SmoothLoss ;
            CsdChannels{s}  = Channels2Use{s}(2+SmoothLoss/2:end-1-SmoothLoss/2);
            if length(SpatialSmoother) > 1
                CSDBlock(end+1:end+nCsdChannels,:) = -conv2(SpatialSmoother, 1 , diff(Block(Channels2Use{s},:), 2), 'valid');
            else
                CSDBlock(end+1:end+nCsdChannels,:) = -diff(Block(Channels2Use{s},:),2);
            end
        end
        fwrite(OutFp, CSDBlock, 'short');
    end
    save([FileBase '/' FileBase '.csd' smootherFileExt '.ch'], 'CsdChannels');
    fclose(InFp);
    fclose(OutFp);
end