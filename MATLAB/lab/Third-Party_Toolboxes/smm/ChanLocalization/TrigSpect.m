function TrigSpect(fileBaseCell,trigFileName,trigFs,segLen,fileExtCell,nChanCell,varargin)
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

        time = load([SC(fileBaseCell{m}) trigFileName]);
        segs = zeros([size(time,1) nChan round(segLen*Fs)]);
        for n = 1:size(time,1)
            seg = bload([SC(fileBaseCell{m}) fileBaseCell{m} fileExt],...
                [nChan round(segLen*Fs)],...
                round(time(n)*trigFs*nChan*bps));
                
            for ch=1:size(seg,1)
                [yoTemp period junk coi] = xwt(squeeze(seg(ch,:)),squeeze(seg(ch,:)));
                
                if isempty(powSpec.yo)
                    powSpec.yo = zeros([size(seg,1),size(yoTemp)]);
                end
                powSpec.yo(ch,:,:) = squeeze(powSpec.yo(ch,:,:)) + 10*log10(yoTemp)/size(time,1);
            end
        end
        if isempty(time)
            powSpec.coi = [];
            powSpec.fo = [];
        else
            powSpec.coi = coi;
            powSpec.fo = eegSamp./period;
        end
        powSpec.to = [-floor(segLen*Fs/2):ceil(segLen*Fs/2)-1]/Fs*1000; % in millisec
        powSpec.numSeg = size(time,1);
        outFile = [fileBaseCell{m} '/TrigAveSpect_' num2str(segLen) 's' fileExt ...
            '_' trigFileName '.mat'];
        fprintf('Saving: %s\n',outFile)
        save(outFile,SaveAsV6,'powSpec');
 
    end
end