% function TrigAveSpect(fileBaseCell,trigFileName,trigFs,segLen,fileExtCell,nChanCell,varargin)
% [Fs,bps] = ...
%     DefaultArgs(varargin,{1250,2});
function TrigAveSpect(fileBaseCell,trigFileName,trigFs,segLen,fileExtCell,nChanCell,varargin)
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
        powSpec.yo = [];
        
        temp = dir([SC(fileBaseCell{m}) fileBaseCell{m} fileExt]);
        fileLen = temp.bytes/nChan/bps/Fs;
        trigStart = load([SC(fileBaseCell{m}) trigFileName])/trigFs-segLen/2;
        trigStart(trigStart<0 | (trigStart+segLen)>fileLen) = [];
        for n = 1:size(trigStart,1)
            seg = bload([SC(fileBaseCell{m}) fileBaseCell{m} fileExt],...
                [nChan round(segLen*Fs)],...
                round(trigStart(n)*Fs*nChan*bps));
            for ch=1:size(seg,1)
                [yoTemp period junk coi] = xwt(squeeze(seg(ch,:)),squeeze(seg(ch,:)));
                
                if isempty(powSpec.yo)
                    powSpec.yo = zeros([size(seg,1),size(yoTemp)]);
                end
                powSpec.yo(ch,:,:) = squeeze(powSpec.yo(ch,:,:)) + 10*log10(yoTemp)/size(trigStart,1);
            end
        end
        if isempty(trigStart)
            powSpec.coi = [];
            powSpec.fo = [];
        else
            powSpec.coi = coi;
            powSpec.fo = Fs./period;
        end
        powSpec.to = [-floor(segLen*Fs/2):ceil(segLen*Fs/2)-1]/Fs*1000; % in millisec
        powSpec.numSeg = size(trigStart,1);
        outFile = [SC(fileBaseCell{m}) trigFileName '_TrigAveSpect' ...
            num2str(segLen) 's' fileExt ...
            '.mat'];
        fprintf('Saving: %s\n',outFile)
        save(outFile,SaveAsV6,'powSpec');
 
    end
end