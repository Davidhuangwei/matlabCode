% function TrigAveCoh(fileBaseCell,trigFileName,trigFs,segLen,fileExtCell,nChanCell,varargin)
% [Fs,bps] = ...
%     DefaultArgs(varargin,{1250,2});
% 
% tag:coherence
% tag:cohereogram
% tag:triggered

function TrigAveCoh(fileBaseCell,trigFileName,trigFs,segLen,fileExtCell,nChanCell,varargin)
[Fs,bps] = ...
    DefaultArgs(varargin,{1250,2});

infoStruct.trigFileName = trigFileName;
infoStruct.trigFs = trigFs;
infoStruct.segLen = segLen;
infoStruct.Fs = Fs;
infoStruct.bps = bps;
infoStruct.date = date;

for m=1:length(fileBaseCell)
    for k=1:length(fileExtCell)
        fileExt = fileExtCell{k};
        nChan = nChanCell{k};
        infoStruct.fileBase = fileBaseCell{m};
        infoStruct.fileExt = fileExt;
        infoStruct.nChan = nChan;

        fprintf('processing: %s\n',[SC(fileBaseCell{m}) trigFileName])

        time = load([SC(fileBaseCell{m}) trigFileName]);
        time((time/trigFs-segLen/2)<0) = []; % remove times too close to beginning

        selChan = Struct2CellArray(LoadVar(['ChanInfo/SelChan' fileExt '.mat']),[],1);
        infoStruct.selChan = selChan;
        for r=1:size(selChan,1)
            cohSpec.yo = [];

            for n = 1:size(time,1)
                seg = bload([SC(fileBaseCell{m}) fileBaseCell{m} fileExt],...
                    [nChan round(segLen*Fs)],...
                    round((time(n)/trigFs-segLen/2)*Fs*nChan*bps));
                for ch=1:size(seg,1)
                    [yoTemp period junk coi] = wtc(squeeze(seg(selChan{r,2},:)),...
                        squeeze(seg(ch,:)),'MonteCarloCount',0);

                    if isempty(cohSpec.yo)
                        cohSpec.yo = zeros([size(seg,1),size(yoTemp)]);
                    end
                    cohSpec.yo(ch,:,:) = squeeze(cohSpec.yo(ch,:,:)) + ATanCoh(yoTemp)/size(time,1);
                end
            end
            if isempty(time)
                cohSpec.coi = [];
                cohSpec.fo = [];
            else
                cohSpec.coi = coi;
                cohSpec.fo = Fs./period;
            end
            cohSpec.to = [-floor(segLen*Fs/2):ceil(segLen*Fs/2)-1]/Fs*1000; % in millisec
            cohSpec.numSeg = size(time,1);
            outFile = [SC(fileBaseCell{m}) trigFileName '_TrigAveCoh' ...
                num2str(segLen) 's' fileExt ...
                '.' selChan{r,1} '.mat'];
            fprintf('Saving: %s\n',outFile)
            cohSpec.infoStruct = infoStruct;
            save(outFile,SaveAsV6,'cohSpec');
        end
    end
end